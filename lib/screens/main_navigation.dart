import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'crop_health/crop_health_screen.dart';
import 'weather/weather_screen.dart';
import 'market/market_screen.dart';
import 'activities/activities_screen.dart';
import 'community/community_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CropHealthScreen(),
    const WeatherScreen(),
    const MarketScreen(),
    const ActivitiesScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    NavigationItem(
      icon: Icons.camera_alt_outlined,
      activeIcon: Icons.camera_alt,
      label: 'Crop Health',
    ),
    NavigationItem(
      icon: Icons.wb_sunny_outlined,
      activeIcon: Icons.wb_sunny,
      label: 'Weather',
    ),
    NavigationItem(
      icon: Icons.trending_up_outlined,
      activeIcon: Icons.trending_up,
      label: 'Market',
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Activities',
    ),
    NavigationItem(
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      label: 'Community',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: _navigationItems.map((item) {
            final isSelected = _navigationItems.indexOf(item) == _currentIndex;
            return BottomNavigationBarItem(
              icon: Icon(
                isSelected ? item.activeIcon : item.icon,
                size: 24,
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

