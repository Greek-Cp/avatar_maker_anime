import 'package:avatar_maker/page/PageBase.dart';
import 'package:avatar_maker/page/intro/PageIntroGame.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:avatar_maker/page/reward_system/achievment_system.dart';
import 'package:avatar_maker/page/reward_system/daily_reward_system.dart';
import 'package:avatar_maker/page/reward_system/model/shop_item.dart';
import 'package:avatar_maker/page/reward_system/shop_page.dart';
import 'package:avatar_maker/page/viewcharacter/PageViewCharacter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/AvatarController.dart';
import 'page/maker/PageMakerCharacter.dart';

// Import new monetization features

void main() async {
  // Ensure Flutter is initialized before accessing native code
  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions
  await requestPermissions();

  // Initialize AppSettings
  final settings = AppSettings();
  await settings.loadSettings();

  // Run the app
  runApp(const MainApp());
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.manageExternalStorage,
  ].request();

  if (statuses[Permission.storage]!.isGranted &&
      statuses[Permission.manageExternalStorage]!.isGranted) {
    // Permissions granted, you can now access external storage
  } else {
    // Permissions not granted, handle accordingly
    print(
        "Storage permissions not granted. Some features may not work properly.");
  }
}

// Settings class for app-wide configuration
class AppSettings {
  // Singleton instance
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  // Shared Preferences keys
  static const String PREFS_FIRST_RUN = 'first_run';
  static const String PREFS_SOUND_ENABLED = 'sound_enabled';
  static const String PREFS_MUSIC_ENABLED = 'music_enabled';
  static const String PREFS_NOTIFICATION_ENABLED = 'notification_enabled';

  // Observable settings
  final RxBool soundEnabled = true.obs;
  final RxBool musicEnabled = true.obs;
  final RxBool notificationEnabled = true.obs;

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      soundEnabled.value = prefs.getBool(PREFS_SOUND_ENABLED) ?? true;
      musicEnabled.value = prefs.getBool(PREFS_MUSIC_ENABLED) ?? true;
      notificationEnabled.value =
          prefs.getBool(PREFS_NOTIFICATION_ENABLED) ?? true;
    } catch (e) {
      print("Error loading settings: $e");
    }
  }

  // Save settings to SharedPreferences
  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(PREFS_SOUND_ENABLED, soundEnabled.value);
      await prefs.setBool(PREFS_MUSIC_ENABLED, musicEnabled.value);
      await prefs.setBool(
          PREFS_NOTIFICATION_ENABLED, notificationEnabled.value);
    } catch (e) {
      print("Error saving settings: $e");
    }
  }

  // Check if this is the first run of the app
  Future<bool> isFirstRun() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final firstRun = prefs.getBool(PREFS_FIRST_RUN) ?? true;

      if (firstRun) {
        // Mark as no longer first run
        await prefs.setBool(PREFS_FIRST_RUN, false);
      }

      return firstRun;
    } catch (e) {
      print("Error checking first run: $e");
      return true;
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());

    // Initialize all controllers
    final repoController = Get.put(AssetRepo());
    final saveAvatarController = Get.put(SaveAvatarController());
    final avatarController = Get.put(AvatarController());

    // Initialize new feature controllers
    final rewardsController = Get.put(RewardsController());
    final shopController = Get.put(ShopController());
    final achievementController = Get.put(AchievementController());

    return GetMaterialApp(
      title: 'Anime Avatar Maker',
      theme: ThemeData(
        primaryColor: Color(0xFFFA9ECC),
        fontFamily: 'Nunito', // Use a rounded font for kid-friendly UI
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      getPages: [
        GetPage(name: SplashScreen.routeName, page: () => SplashScreen()),
        GetPage(name: IntroScreen.routeName, page: () => IntroScreen()),
        GetPage(name: PageBase.routeName, page: () => PageBase()),
        GetPage(
            name: PageMakerCharacter.routeName,
            page: () => PageMakerCharacter()),
        GetPage(
            name: AvatarHistoryPage.routeName, page: () => AvatarHistoryPage()),

        // Add routes for new features
        GetPage(
            name: DailyRewardsPage.routeName, page: () => DailyRewardsPage()),
        GetPage(name: ShopPage.routeName, page: () => ShopPage()),
        GetPage(
            name: AchievementsPage.routeName, page: () => AchievementsPage()),
      ],
    );
  }
}

// Define route names for new pages
extension Routes on DailyRewardsPage {
  static String get routeName => '/daily-rewards';
}

extension ShopRoutes on ShopPage {
  static String get routeName => '/shop';
}

extension AchievementRoutes on AchievementsPage {
  static String get routeName => '/achievements';
}
