import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/poses_screen.dart';
import 'screens/videos_screen.dart';
import 'screens/benefits_screen.dart';

void main() {
  runApp(const GSheYogApp());
}

class GSheYogApp extends StatelessWidget {
  const GSheYogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GSheYog',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
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
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Benefits'),
        ],
      ),
    );
  }
}
