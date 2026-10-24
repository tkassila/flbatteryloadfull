import 'dart:ui';

class AppStrings {
  final String appTitle;
  final String alarmBannerTitle;
  final String alarmBannerSubtitle;
  final String stopAlarm;
  final String chargerConnected;
  final String chargerDisconnected;
  final String settingsTitle;
  final String notify22Title;
  final String notify22Subtitle;
  final String volume80Title;
  final String volume80Subtitle;
  final String testSectionTitle;
  final String testSectionSubtitle;
  final String test22Button;
  final String test22Snackbar;
  final String test80Button;
  final String test80StopButton;
  final String test80Snackbar;
  final String notification22Title;
  final String notification22Body;
  final String notification80Title;
  final String notification80Body;
  final String foregroundNotificationTitle;
  final String foregroundNotificationCharging;
  final String foregroundNotificationDischarging;
  final String instructionsSectionTitle;
  final String instructionsTitle;
  final String instructionsIntro;
  final String instructionsSamsungTitle;
  final String instructionsSamsungBody;
  final String instructionsXiaomiTitle;
  final String instructionsXiaomiBody;
  final String instructionsOnePlusTitle;
  final String instructionsOnePlusBody;
  final String instructionsAndroid13Title;
  final String instructionsAndroid13Body;
  final String beforeUseButton;

  const AppStrings({
    required this.appTitle,
    required this.alarmBannerTitle,
    required this.alarmBannerSubtitle,
    required this.stopAlarm,
    required this.chargerConnected,
    required this.chargerDisconnected,
    required this.settingsTitle,
    required this.notify22Title,
    required this.notify22Subtitle,
    required this.volume80Title,
    required this.volume80Subtitle,
    required this.testSectionTitle,
    required this.testSectionSubtitle,
    required this.test22Button,
    required this.test22Snackbar,
    required this.test80Button,
    required this.test80StopButton,
    required this.test80Snackbar,
    required this.notification22Title,
    required this.notification22Body,
    required this.notification80Title,
    required this.notification80Body,
    required this.foregroundNotificationTitle,
    required this.foregroundNotificationCharging,
    required this.foregroundNotificationDischarging,
    required this.instructionsSectionTitle,
    required this.instructionsTitle,
    required this.instructionsIntro,
    required this.instructionsSamsungTitle,
    required this.instructionsSamsungBody,
    required this.instructionsXiaomiTitle,
    required this.instructionsXiaomiBody,
    required this.instructionsOnePlusTitle,
    required this.instructionsOnePlusBody,
    required this.instructionsAndroid13Title,
    required this.instructionsAndroid13Body,
    required this.beforeUseButton,
  });

  // English (Default)
  static const AppStrings en = AppStrings(
    appTitle: 'Battery Guard',
    alarmBannerTitle: '80% ALARM RINGING!',
    alarmBannerSubtitle: 'Unplug the charger or stop the alarm below.',
    stopAlarm: 'Stop alarm',
    chargerConnected: 'Charger connected (Charging)',
    chargerDisconnected: 'Charger disconnected (In use)',
    settingsTitle: 'Settings and Operating Modes',
    notify22Title: '1) 22% Alert Notification',
    notify22Subtitle: 'When unplugged and battery reaches 22%, send a brief alert with a distinct sound.',
    volume80Title: '2) 80% Alarm Volume',
    volume80Subtitle: 'When charging and battery reaches 80%, continuously play sound at selected volume.',
    testSectionTitle: 'Test Buttons',
    testSectionSubtitle: 'Test alert notification and alarm immediately without waiting for battery level:',
    test22Button: 'Test 22% notification',
    test22Snackbar: 'Test notification (22%) sent!',
    test80Button: 'Test 80% alarm',
    test80StopButton: 'Cut off sound',
    test80Snackbar: 'Test sound (80%) playing once.',
    notification22Title: '⚠️ Battery level 22%',
    notification22Body: 'Battery has dropped to 22%. Remember to plug in charger if needed.',
    notification80Title: '🔋 Battery 80% reached!',
    notification80Body: 'Unplug phone from charger to preserve battery lifespan.',
    foregroundNotificationTitle: 'Battery Guard active',
    foregroundNotificationCharging: 'Charging',
    foregroundNotificationDischarging: 'Unplugged',
    instructionsSectionTitle: 'Instructions Before Use',
    instructionsTitle: 'Device manufacturer specific settings (Important!):',
    instructionsIntro: 'Different Android manufacturers have their own aggressive battery optimizers that may terminate background services when the phone is in sleep mode for a prolonged time. Check these depending on your phone model:',
    instructionsSamsungTitle: 'Samsung (One UI):',
    instructionsSamsungBody: 'Settings -> Battery -> Background usage limits -> Never sleeping apps -> Add Battery Guard (or fsavenotifications).',
    instructionsXiaomiTitle: 'Xiaomi / Redmi / POCO (MIUI / HyperOS):',
    instructionsXiaomiBody: 'App info -> Autostart -> Turn ON.\nApp info -> Battery saver -> Select No restrictions.',
    instructionsOnePlusTitle: 'OnePlus / Oppo / Realme (OxygenOS / ColorOS):',
    instructionsOnePlusBody: 'App info -> Battery usage -> Allow background activity.',
    instructionsAndroid13Title: 'Android 13 and 14+ (all brands):',
    instructionsAndroid13Body: 'If app is installed from an APK file: App info -> three dots in top-right corner (⋮) -> Allow restricted settings, before enabling notification permissions.',
    beforeUseButton: 'Before use',
  );

  // Finnish
  static const AppStrings fi = AppStrings(
    appTitle: 'Akkuvahti',
    alarmBannerTitle: '80 % HÄLYTYS SOI!',
    alarmBannerSubtitle: 'Ota laturi irti puhelimesta tai sammuta hälytys alta.',
    stopAlarm: 'Sammuta hälytys',
    chargerConnected: 'Laturi kytketty (Ladataan)',
    chargerDisconnected: 'Laturi irti (Akku vähenee käytössä)',
    settingsTitle: 'Asetukset ja toimintatilat',
    notify22Title: '1) 22 % Huomautusilmoitus',
    notify22Subtitle: 'Kun laturi on irti ja akku laskee tasan 22 % kohdalle, annetaan lyhyt ilmoitus eri äänellä.',
    volume80Title: '2) 80 % Hälytyksen voimakkuus',
    volume80Subtitle: 'Kun laturi on kiinni ja akku saavuttaa tasan 80 %, soitetaan jatkuva musiikki/hälytys.',
    testSectionTitle: 'Testipainikkeet',
    testSectionSubtitle: 'Voit kokeilla ilmoituksen ja hälytyksen toimivuutta heti ilman akun odottelua:',
    test22Button: 'Testaa 22% ilmoitus',
    test22Snackbar: 'Testi-ilmoitus (22 %) lähetetty!',
    test80Button: 'Testaa 80% hälytys',
    test80StopButton: 'Katkaise ääni',
    test80Snackbar: 'Testiääni (80 %) soitetaan kerran.',
    notification22Title: '⚠️ Akun varaus 22 %',
    notification22Body: 'Akun varaus on laskenut 22 % tasolle. Muista kytkeä laite lataukseen tarvittaessa.',
    notification80Title: '🔋 Akku 80 % saavutettu!',
    notification80Body: 'Ota puhelin pois laturista akun eliniän säästämiseksi.',
    foregroundNotificationTitle: 'Akkuvahti aktiivinen',
    foregroundNotificationCharging: 'Ladataan',
    foregroundNotificationDischarging: 'Laturi irti',
    instructionsSectionTitle: 'Ohjeet ennen käyttöä',
    instructionsTitle: 'Laitevalmistajakohtaiset asetukset puhelimessa (Tärkeää!):',
    instructionsIntro: 'Eri Android-valmistajilla on omat "tehovalvojat", jotka saattavat sammuttaa taustapalveluita, jos puhelin on pitkään lepotilassa. Tarkista nämä puhelinmallistasi riippuen:',
    instructionsSamsungTitle: 'Samsung (One UI):',
    instructionsSamsungBody: 'Asetukset -> Akku -> Taustakäytön rajat -> Älä koskaan aseta lepotilaan -> Lisää Akkuvahti (tai fsavenotifications).',
    instructionsXiaomiTitle: 'Xiaomi / Redmi / POCO (MIUI / HyperOS):',
    instructionsXiaomiBody: 'Sovelluksen tiedot -> Automaattikäynnistys (Autostart) -> Laita päälle.\nSovelluksen tiedot -> Akunsäästäjä -> Valitse Ei rajoituksia.',
    instructionsOnePlusTitle: 'OnePlus / Oppo / Realme (OxygenOS / ColorOS):',
    instructionsOnePlusBody: 'Sovelluksen tiedot -> Akun käyttö -> Salli taustatoiminta.',
    instructionsAndroid13Title: 'Android 13 ja 14+ (kaikki merkit):',
    instructionsAndroid13Body: 'Jos sovellus asennetaan APK-tiedostosta: Sovelluksen tiedot -> oikeasta yläkulmasta kolme pistettä (⋮) -> Salli rajoitetut asetukset, ennen kuin ilmoitusten käyttöoikeus kytketään päälle.',
    beforeUseButton: 'Ennen käyttöä',
  );

  // Swedish
  static const AppStrings sv = AppStrings(
    appTitle: 'Batterivakt',
    alarmBannerTitle: '80 % LARMET RINGER!',
    alarmBannerSubtitle: 'Koppla ur laddaren eller stäng av larmet nedan.',
    stopAlarm: 'Stäng av larm',
    chargerConnected: 'Laddare ansluten (Laddar)',
    chargerDisconnected: 'Laddare urkopplad (Används)',
    settingsTitle: 'Inställningar och driftlägen',
    notify22Title: '1) 22 % Varningsnotis',
    notify22Subtitle: 'När laddaren är ur och batteriet når 22 %, skickas en kort notis med särskilt ljud.',
    volume80Title: '2) 80 % Larmvolym',
    volume80Subtitle: 'När laddaren är ansluten och batteriet når 80 %, spelas larm kontinuerligt med vald volym.',
    testSectionTitle: 'Testknappar',
    testSectionSubtitle: 'Testa notis och larm direkt utan att vänta på batterinivån:',
    test22Button: 'Testa 22 % notis',
    test22Snackbar: 'Testnotis (22 %) skickad!',
    test80Button: 'Testa 80 % larm',
    test80StopButton: 'Stäng av ljud',
    test80Snackbar: 'Testljud (80 %) spelas en gång.',
    notification22Title: '⚠️ Batterinivå 22 %',
    notification22Body: 'Batteriet har sjunkit till 22 %. Kom ihåg att ansluta laddaren vid behov.',
    notification80Title: '🔋 Batteri 80 % uppnått!',
    notification80Body: 'Koppla ur telefonen från laddaren för att spara batteriets livslängd.',
    foregroundNotificationTitle: 'Batterivakt aktiv',
    foregroundNotificationCharging: 'Laddar',
    foregroundNotificationDischarging: 'Laddare urkopplad',
    instructionsSectionTitle: 'Instruktioner före användning',
    instructionsTitle: 'Enhetstillverkarens specifika inställningar (Viktigt!):',
    instructionsIntro: 'Olika Android-tillverkare har egna batterioptimerare som kan stänga av bakgrundstjänster när telefonen är i viloläge under en längre tid. Kontrollera dessa beroende på din telefonmodell:',
    instructionsSamsungTitle: 'Samsung (One UI):',
    instructionsSamsungBody: 'Inställningar -> Batteri -> Gränser för bakgrundsanvändning -> Appar som aldrig försätts i viloläge -> Lägg till Batterivakt (eller fsavenotifications).',
    instructionsXiaomiTitle: 'Xiaomi / Redmi / POCO (MIUI / HyperOS):',
    instructionsXiaomiBody: 'Appinformation -> Autostart -> Slå PÅ.\nAppinformation -> Batterisparare -> Välj Inga begränsningar.',
    instructionsOnePlusTitle: 'OnePlus / Oppo / Realme (OxygenOS / ColorOS):',
    instructionsOnePlusBody: 'Appinformation -> Batterianvändning -> Tillåt bakgrundsaktivitet.',
    instructionsAndroid13Title: 'Android 13 och 14+ (alla märken):',
    instructionsAndroid13Body: 'Om appen installeras från en APK-fil: Appinformation -> tre punkter i övre högra hörnet (⋮) -> Tillåt begränsade inställningar, innan behörighet för aviseringar aktiveras.',
    beforeUseButton: 'Före användning',
  );

  // German
  static const AppStrings de = AppStrings(
    appTitle: 'Batteriewächter',
    alarmBannerTitle: '80 % ALARM ERKLINGT!',
    alarmBannerSubtitle: 'Trennen Sie das Ladegerät oder stoppen Sie den Alarm unten.',
    stopAlarm: 'Alarm stoppen',
    chargerConnected: 'Ladegerät angeschlossen (Wird geladen)',
    chargerDisconnected: 'Ladegerät getrennt (In Benutzung)',
    settingsTitle: 'Einstellungen und Betriebsmodi',
    notify22Title: '1) 22 % Hinweis-Benachrichtigung',
    notify22Subtitle: 'Wenn nicht geladen und Akku auf 22 % sinkt, kurzen Hinweis mit individuellem Ton senden.',
    volume80Title: '2) 80 % Alarmlautstärke',
    volume80Subtitle: 'Beim Laden bei 80 % kontinuierlich Alarm mit ausgewählter Lautstärke abspielen.',
    testSectionTitle: 'Testschaltflächen',
    testSectionSubtitle: 'Benachrichtigung und Alarm sofort testen, ohne auf Akkustand zu warten:',
    test22Button: '22 % Benachrichtigung testen',
    test22Snackbar: 'Test-Benachrichtigung (22 %) gesendet!',
    test80Button: '80 % Alarm testen',
    test80StopButton: 'Ton stoppen',
    test80Snackbar: 'Testton (80 %) wird einmal abgespielt.',
    notification22Title: '⚠️ Akkustand 22 %',
    notification22Body: 'Akkustand ist auf 22 % gesunken. Bei Bedarf Ladegerät anschließen.',
    notification80Title: '🔋 Akku 80 % erreicht!',
    notification80Body: 'Telefon vom Ladegerät trennen, um die Akkulebensdauer zu schonen.',
    foregroundNotificationTitle: 'Batteriewächter aktiv',
    foregroundNotificationCharging: 'Wird geladen',
    foregroundNotificationDischarging: 'Nicht geladen',
    instructionsSectionTitle: 'Hinweise vor der Verwendung',
    instructionsTitle: 'Herstellerspezifische Einstellungen am Telefon (Wichtig!):',
    instructionsIntro: 'Verschiedene Android-Hersteller haben eigene Akku-Manager, die Hintergrunddienste beenden können, wenn das Telefon längere Zeit im Ruhezustand ist. Bitte prüfen Sie folgende Einstellungen je nach Modell:',
    instructionsSamsungTitle: 'Samsung (One UI):',
    instructionsSamsungBody: 'Einstellungen -> Akku -> Grenzen der Hintergrundnutzung -> Apps, die nie in Standby versetzt werden -> Batteriewächter (oder fsavenotifications) hinzufügen.',
    instructionsXiaomiTitle: 'Xiaomi / Redmi / POCO (MIUI / HyperOS):',
    instructionsXiaomiBody: 'App-Info -> Autostart -> Einschalten.\nApp-Info -> Energiesparmodus -> Keine Beschränkungen wählen.',
    instructionsOnePlusTitle: 'OnePlus / Oppo / Realme (OxygenOS / ColorOS):',
    instructionsOnePlusBody: 'App-Info -> Akkunutzung -> Hintergrundaktivität zulassen.',
    instructionsAndroid13Title: 'Android 13 und 14+ (alle Marken):',
    instructionsAndroid13Body: 'Wenn die App über eine APK-Datei installiert wird: App-Info -> drei Punkte oben rechts (⋮) -> Eingeschränkte Einstellungen zulassen, bevor die Benachrichtigungsberechtigung aktiviert wird.',
    beforeUseButton: 'Vor der Nutzung',
  );

  /// Resolve strings based on locale code ('fi', 'sv', 'de', or default 'en')
  static AppStrings of([Locale? locale]) {
    final languageCode = (locale?.languageCode ?? PlatformDispatcher.instance.locale.languageCode).toLowerCase();
    switch (languageCode) {
      case 'fi':
        return fi;
      case 'sv':
        return sv;
      case 'de':
        return de;
      default:
        return en;
    }
  }
}
