import 'package:flutter/material.dart';
import 'theme.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/poses_screen.dart';
import 'screens/videos_screen.dart';
import 'screens/benefits_screen.dart';
import 'screens/progress_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.init();
  runApp(const GSheYogApp());
}

class GSheYogApp extends StatefulWidget {
  const GSheYogApp({super.key});

  @override
  State<GSheYogApp> createState() => _GSheYogAppState();
}

class _GSheYogAppState extends State<GSheYogApp> {
  bool _onboarded = StorageService.onboardingDone;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga By Gargi',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: _onboarded
          ? const MainNavigation()
          : OnboardingScreen(onComplete: () => setState(() => _onboarded = true)),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    PosesScreen(),
    VideosScreen(),
    ProgressScreen(),
    BenefitsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Poses'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: 'Videos'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Benefits'),
        ],
      ),
    );
  }
}
