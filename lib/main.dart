import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:battery_plus/battery_plus.dart';
import 'battery_monitor_service.dart';
import 'app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  try {
    final service = BatteryMonitorService();
    await service.init();
  } catch (e, stack) {
    debugPrint('Service init error: $e\n$stack');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Guard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.dark,
        ),
      ),
      home: const BatteryMonitorScreen(),
    );
  }
}

class BatteryMonitorScreen extends StatefulWidget {
  const BatteryMonitorScreen({super.key});

  @override
  State<BatteryMonitorScreen> createState() => _BatteryMonitorScreenState();
}

class _BatteryMonitorScreenState extends State<BatteryMonitorScreen> {
  final BatteryMonitorService _service = BatteryMonitorService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _scrollController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Color _getBatteryColor(int level, bool isCharging) {
    if (isCharging) return Colors.greenAccent;
    if (level <= 22) return Colors.orangeAccent;
    if (level <= 15) return Colors.redAccent;
    return Colors.lightBlueAccent;
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of();
    final isCharging = _service.batteryState == BatteryState.charging ||
        _service.batteryState == BatteryState.full;
    final batteryColor = _getBatteryColor(_service.batteryLevel, isCharging);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 130,
        leading: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 8.0, bottom: 8.0),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.amberAccent,
              side: const BorderSide(color: Colors.amberAccent, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              visualDensity: VisualDensity.compact,
            ),
            icon: const Icon(Icons.arrow_downward, size: 14),
            label: Text(
              strings.beforeUseButton,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: _scrollToBottom,
          ),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(strings.appTitle),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // Alarm banner if currently playing
                if (_service.isPlayingAlarm) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      border: Border.all(color: Colors.redAccent, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              strings.alarmBannerTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.alarmBannerSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          icon: const Icon(Icons.stop_circle_outlined),
                          label: Text(
                            strings.stopAlarm,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _service.stopAlarm(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Battery Status Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                          Theme.of(context).colorScheme.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: CircularProgressIndicator(
                                value: _service.batteryLevel / 100.0,
                                strokeWidth: 12,
                                backgroundColor: Colors.white10,
                                valueColor: AlwaysStoppedAnimation<Color>(batteryColor),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isCharging ? Icons.bolt : Icons.battery_std,
                                  size: 32,
                                  color: batteryColor,
                                ),
                                Text(
                                  '${_service.batteryLevel}%',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isCharging ? Icons.power : Icons.power_off,
                              color: isCharging ? Colors.greenAccent : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                isCharging
                                    ? strings.chargerConnected
                                    : strings.chargerDisconnected,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isCharging ? Colors.greenAccent : Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Settings Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.settingsTitle,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        // 1) 22% notification toggle
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(strings.notify22Title),
                          subtitle: Text(
                            strings.notify22Subtitle,
                            style: const TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                          value: _service.enable22Notification,
                          onChanged: (bool value) {
                            _service.setEnable22Notification(value);
                          },
                        ),

                        const Divider(height: 24),

                        // 2) 80% Alarm volume
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              strings.volume80Title,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${(_service.alarmVolume * 100).round()} %',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strings.volume80Subtitle,
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                        Slider(
                          value: _service.alarmVolume,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          label: '${(_service.alarmVolume * 100).round()}%',
                          onChanged: (double val) {
                            _service.setAlarmVolume(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Test buttons
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.science_outlined, color: Colors.orangeAccent),
                            const SizedBox(width: 8),
                            Text(
                              strings.testSectionTitle,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.testSectionSubtitle,
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: const Icon(Icons.notifications_active_outlined),
                                label: Text(strings.test22Button),
                                onPressed: () {
                                  _service.trigger22Notification();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(strings.test22Snackbar),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _service.isPlayingTestSound
                                      ? Colors.redAccent
                                      : Colors.amber.shade800,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: Icon(_service.isPlayingTestSound
                                    ? Icons.stop_circle_outlined
                                    : Icons.alarm),
                                label: Text(_service.isPlayingTestSound
                                    ? strings.test80StopButton
                                    : strings.test80Button),
                                onPressed: () {
                                  _service.toggleTest80Sound();
                                  if (!_service.isPlayingTestSound) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(strings.test80Snackbar),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Instructions Section (Ohjeet ennen käyttöä)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      leading: const Icon(Icons.info_outline, color: Colors.amberAccent, size: 28),
                      title: Text(
                        strings.instructionsSectionTitle,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        strings.instructionsTitle,
                        style: const TextStyle(fontSize: 13, color: Colors.amberAccent),
                      ),
                      children: [
                        Text(
                          strings.instructionsIntro,
                          style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        _buildInstructionItem(
                          context: context,
                          icon: Icons.phone_android,
                          iconColor: Colors.lightBlueAccent,
                          title: strings.instructionsSamsungTitle,
                          body: strings.instructionsSamsungBody,
                        ),
                        _buildInstructionItem(
                          context: context,
                          icon: Icons.speed,
                          iconColor: Colors.orangeAccent,
                          title: strings.instructionsXiaomiTitle,
                          body: strings.instructionsXiaomiBody,
                        ),
                        _buildInstructionItem(
                          context: context,
                          icon: Icons.battery_charging_full,
                          iconColor: Colors.redAccent,
                          title: strings.instructionsOnePlusTitle,
                          body: strings.instructionsOnePlusBody,
                        ),
                        _buildInstructionItem(
                          context: context,
                          icon: Icons.security,
                          iconColor: Colors.greenAccent,
                          title: strings.instructionsAndroid13Title,
                          body: strings.instructionsAndroid13Body,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
