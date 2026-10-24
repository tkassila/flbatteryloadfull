import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_strings.dart';

const String notificationChannelId = 'battery_monitor_foreground';
const int notificationId = 888;

/// Top-level callback invoked when a notification action (e.g. "Sammuta hälytys") is clicked in background
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (notificationResponse.actionId == 'stop_alarm' ||
      notificationResponse.payload == 'stop_alarm') {
    final service = FlutterBackgroundService();
    service.invoke('stopAlarm');
    try {
      final notifications = FlutterLocalNotificationsPlugin();
      await notifications.cancel(80);
    } catch (_) {}
  }
}

/// Entry point for Android Foreground Background Service
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final battery = Battery();
  final audioPlayer = AudioPlayer();
  await audioPlayer.setReleaseMode(ReleaseMode.loop);

  final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
  bool isPlayingAlarm = false;
  int? lastAlarm80Level;
  int? lastNotified22Level;
  int lastLevel = 100;
  BatteryState lastState = BatteryState.discharging;

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await notifications.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) async {
      if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
        isPlayingAlarm = false;
        await audioPlayer.stop();
        await notifications.cancel(80);
        service.invoke('update', {'isPlayingAlarm': false, 'isServiceRunning': true});
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Listen to UI commands
  service.on('stopAlarm').listen((event) async {
    isPlayingAlarm = false;
    await audioPlayer.stop();
    await notifications.cancel(80);
    service.invoke('update', {'isPlayingAlarm': false, 'isServiceRunning': true});
  });

  service.on('triggerTest22').listen((event) async {
    await _showNotification22(notifications);
  });

  service.on('setVolume').listen((event) async {
    final volume = (event?['volume'] as num?)?.toDouble() ?? 1.0;
    if (isPlayingAlarm) {
      await audioPlayer.setVolume(volume);
    }
  });

  // Listen to ping from UI to confirm service is alive and return current state
  service.on('ping').listen((event) {
    service.invoke('update', {
      'level': lastLevel,
      'state': lastState.index,
      'isPlayingAlarm': isPlayingAlarm,
      'isServiceRunning': true,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  });

  // Periodic check function (executes once every 60s + upon battery state changes)
  Future<void> checkBattery() async {
    try {
      final strings = AppStrings.of();
      final level = await battery.batteryLevel;
      final state = await battery.batteryState;
      final isCharging = state == BatteryState.charging || state == BatteryState.full;

      lastLevel = level;
      lastState = state;

      final prefs = await SharedPreferences.getInstance();
      final enable22 = prefs.getBool('enable22Notification') ?? true;
      final volume = prefs.getDouble('alarmVolume') ?? 1.0;

      // Update background foreground notification text
      if (service is AndroidServiceInstance) {
        final stateText = isCharging
            ? strings.foregroundNotificationCharging
            : strings.foregroundNotificationDischarging;
        service.setForegroundNotificationInfo(
          title: strings.foregroundNotificationTitle,
          content: '${strings.appTitle}: $level% • $stateText',
        );
      }

      // Notify UI
      service.invoke('update', {
        'level': level,
        'state': state.index,
        'isPlayingAlarm': isPlayingAlarm,
        'isServiceRunning': true,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      if (!isCharging) {
        // --- 1. LATURI IRTI: Akku vähenee käytössä ---
        lastAlarm80Level = null;
        if (isPlayingAlarm) {
          // Kun laturi irrotetaan, hälytys sammuu automaattisesti!
          isPlayingAlarm = false;
          await audioPlayer.stop();
          await notifications.cancel(80);
          service.invoke('update', {'isPlayingAlarm': false, 'isServiceRunning': true});
        }

        // 22 % lyhyt ilmoitus
        if (level == 22) {
          if (lastNotified22Level != 22) {
            lastNotified22Level = 22;
            if (enable22) {
              await _showNotification22(notifications);
            }
          }
        } else {
          lastNotified22Level = null;
        }
      } else {
        // --- 2. LATURI KIINNI: Akkua ladataan ---
        lastNotified22Level = null;

        // Kun akku saavuttaa >= 79%, aloitetaan jatkuva soitto
        if (level >= 79) {
          if (lastAlarm80Level != 80 && !isPlayingAlarm) {
            lastAlarm80Level = 80;
            isPlayingAlarm = true;
            await audioPlayer.setVolume(volume);
            await audioPlayer.play(AssetSource('sounds/alarm_80.mp3'));
            await _showAlarm80Notification(notifications);
            service.invoke('update', {'isPlayingAlarm': true, 'isServiceRunning': true});
          }
        } else {
          lastAlarm80Level = null;
        }
      }
    } catch (e) {
      debugPrint('Background battery check error: $e');
    }
  }

  // Listen to immediate charging cable connect/disconnect events
  battery.onBatteryStateChanged.listen((_) => checkBattery());

  // Run immediately
  await checkBattery();

  // Run every 1 minute (60 seconds)
  Timer.periodic(const Duration(minutes: 1), (_) => checkBattery());
}

Future<void> _showNotification22(FlutterLocalNotificationsPlugin notifications) async {
  final strings = AppStrings.of();
  const androidDetails = AndroidNotificationDetails(
    'battery_22_channel',
    'Battery 22% Alert',
    channelDescription: 'Alert when battery level reaches 22%',
    importance: Importance.high,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('notify_22'),
    playSound: true,
    enableVibration: true,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);
  await notifications.show(
    22,
    strings.notification22Title,
    strings.notification22Body,
    notificationDetails,
  );
}

Future<void> _showAlarm80Notification(FlutterLocalNotificationsPlugin notifications) async {
  final strings = AppStrings.of();
  final androidDetails = AndroidNotificationDetails(
    'battery_80_channel',
    'Battery 80% Alarm',
    channelDescription: 'Continuous alarm when battery reaches 80%',
    importance: Importance.max,
    priority: Priority.max,
    ongoing: true,
    autoCancel: false,
    actions: [
      AndroidNotificationAction(
        'stop_alarm',
        strings.stopAlarm,
        cancelNotification: true,
      ),
    ],
  );

  final notificationDetails = NotificationDetails(android: androidDetails);
  await notifications.show(
    80,
    strings.notification80Title,
    strings.notification80Body,
    notificationDetails,
    payload: 'stop_alarm',
  );
}

/// Service controller used by Flutter UI
class BatteryMonitorService {
  static final BatteryMonitorService _instance = BatteryMonitorService._internal();
  factory BatteryMonitorService() => _instance;
  BatteryMonitorService._internal();

  static const MethodChannel _platformChannel =
      MethodChannel('com.metait.flbatteryloadfull/service_control');

  final FlutterBackgroundService _backgroundService = FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final Battery _battery = Battery();

  bool _enable22Notification = true;
  double _alarmVolume = 1.0;

  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.discharging;
  bool _isPlayingAlarm = false;

  bool _isRunning = false;
  bool _isCheckingService = false;
  DateTime? _lastHeartbeat;
  bool _isIgnoringBatteryOptimizations = false;

  final List<void Function()> _listeners = [];

  final AudioPlayer _testAudioPlayer = AudioPlayer();
  Timer? _testStopTimer;
  bool _isPlayingTestSound = false;

  bool get isRunning => _isRunning;
  bool get isCheckingService => _isCheckingService;
  DateTime? get lastHeartbeat => _lastHeartbeat;
  bool get isIgnoringBatteryOptimizations => _isIgnoringBatteryOptimizations;
  bool get isPlayingAlarm => _isPlayingAlarm;
  bool get isPlayingTestSound => _isPlayingTestSound;
  int get batteryLevel => _batteryLevel;
  BatteryState get batteryState => _batteryState;
  bool get enable22Notification => _enable22Notification;
  double get alarmVolume => _alarmVolume;

  void addListener(void Function() listener) => _listeners.add(listener);
  void removeListener(void Function() listener) => _listeners.remove(listener);

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _enable22Notification = prefs.getBool('enable22Notification') ?? true;
    _alarmVolume = prefs.getDouble('alarmVolume') ?? 1.0;

    try {
      _batteryLevel = await _battery.batteryLevel;
      _batteryState = await _battery.batteryState;
    } catch (_) {}

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId == 'stop_alarm' || response.payload == 'stop_alarm') {
          stopAlarm();
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final strings = AppStrings.of();

    // Notification channel for Android 8+ foreground service
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId,
      'Battery Guard Service',
      description: 'Monitors battery state and alerts at 80% and 22%',
      importance: Importance.low,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Initialize the actual independent background service
    await _backgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        autoStartOnBoot: true,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: strings.foregroundNotificationTitle,
        initialNotificationContent: '${strings.appTitle}...',
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(),
    );

    _backgroundService.on('update').listen((event) {
      if (event != null) {
        _isRunning = true;
        _lastHeartbeat = DateTime.now();
        if (event.containsKey('level')) {
          _batteryLevel = event['level'] as int;
        }
        if (event.containsKey('state')) {
          final stateIdx = event['state'] as int;
          if (stateIdx >= 0 && stateIdx < BatteryState.values.length) {
            _batteryState = BatteryState.values[stateIdx];
          }
        }
        if (event.containsKey('isPlayingAlarm')) {
          _isPlayingAlarm = event['isPlayingAlarm'] as bool;
        }
        _notifyListeners();
      }
    });

    // Check battery optimization status
    await checkBatteryOptimizationStatus();

    // Verify service status and ensure it is running
    await checkAndEnsureRunning(restartIfStopped: true);

    _notifyListeners();
  }

  /// Checks if background service is running. If not and [restartIfStopped] is true,
  /// restarts/wakes up the service immediately.
  Future<bool> checkAndEnsureRunning({bool restartIfStopped = true}) async {
    _isCheckingService = true;
    _notifyListeners();

    bool running = false;
    try {
      running = await _backgroundService.isRunning();

      // If flutter_background_service says false, double-check native side
      if (!running) {
        try {
          final nativeRunning = await _platformChannel.invokeMethod<bool>('isServiceRunning');
          if (nativeRunning == true) {
            running = true;
          }
        } catch (_) {}
      }

      if (!running && restartIfStopped) {
        debugPrint('BatteryMonitorService: Palvelu ei ollut käynnissä, käynnistetään...');
        final started = await _backgroundService.startService();
        if (!started) {
          try {
            await _platformChannel.invokeMethod('wakeUpService');
          } catch (_) {}
        }
        // Give the service a moment to initialize
        await Future.delayed(const Duration(milliseconds: 600));
        running = await _backgroundService.isRunning();
      }

      if (running) {
        _backgroundService.invoke('ping');
      }
    } catch (e) {
      debugPrint('BatteryMonitorService: Virhe taustapalvelun tarkistuksessa: $e');
    } finally {
      _isRunning = running;
      _isCheckingService = false;
      _notifyListeners();
    }

    return running;
  }

  /// Query native Android PowerManager to check whether battery optimizations are disabled
  Future<bool> checkBatteryOptimizationStatus() async {
    try {
      final isIgnoring = await _platformChannel.invokeMethod<bool>('isIgnoringBatteryOptimizations');
      _isIgnoringBatteryOptimizations = isIgnoring ?? false;
    } catch (_) {
      try {
        _isIgnoringBatteryOptimizations = await Permission.ignoreBatteryOptimizations.isGranted;
      } catch (_) {}
    }
    _notifyListeners();
    return _isIgnoringBatteryOptimizations;
  }

  /// Request exemption from Android battery optimizations (opens system dialog directly)
  Future<bool> requestIgnoreBatteryOptimization() async {
    try {
      await _platformChannel.invokeMethod('requestIgnoreBatteryOptimizations');
      await Future.delayed(const Duration(milliseconds: 800));
      return await checkBatteryOptimizationStatus();
    } catch (_) {
      final status = await Permission.ignoreBatteryOptimizations.request();
      _isIgnoringBatteryOptimizations = status.isGranted;
      _notifyListeners();
      return status.isGranted;
    }
  }

  /// Manual restart helper
  Future<bool> restartService() async {
    return await checkAndEnsureRunning(restartIfStopped: true);
  }

  Future<void> setEnable22Notification(bool value) async {
    _enable22Notification = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable22Notification', value);
    _notifyListeners();
  }

  Future<void> setAlarmVolume(double volume) async {
    _alarmVolume = volume.clamp(0.0, 1.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('alarmVolume', _alarmVolume);
    _backgroundService.invoke('setVolume', {'volume': _alarmVolume});
    _notifyListeners();
  }

  void stopAlarm() {
    _isPlayingAlarm = false;
    _backgroundService.invoke('stopAlarm');
    _notifyListeners();
  }

  void trigger22Notification() {
    _backgroundService.invoke('triggerTest22');
  }

  Future<void> toggleTest80Sound() async {
    if (_isPlayingTestSound) {
      await stopTest80Sound();
    } else {
      await playTest80Sound();
    }
  }

  Future<void> playTest80Sound() async {
    _testStopTimer?.cancel();
    _isPlayingTestSound = true;
    _notifyListeners();

    try {
      await _testAudioPlayer.stop();
      await _testAudioPlayer.setReleaseMode(ReleaseMode.stop);
      await _testAudioPlayer.setVolume(_alarmVolume);
      await _testAudioPlayer.play(AssetSource('sounds/alarm_80.mp3'));

      // Pysäytä ääni automaattisesti tasan 2 sekunnin kuluttua
      _testStopTimer = Timer(const Duration(seconds: 2), () async {
        await stopTest80Sound();
      });

      _testAudioPlayer.onPlayerComplete.listen((_) {
        stopTest80Sound();
      });
    } catch (e) {
      debugPrint('Error playing test sound: $e');
      _isPlayingTestSound = false;
      _notifyListeners();
    }
  }

  Future<void> stopTest80Sound() async {
    _testStopTimer?.cancel();
    _isPlayingTestSound = false;
    try {
      await _testAudioPlayer.stop();
    } catch (_) {}
    _notifyListeners();
  }

  void trigger80Alarm() {
    toggleTest80Sound();
  }
}
