import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import 'crop_health/crop_health_screen.dart';
import 'weather/weather_screen.dart';
import 'market/market_screen.dart';
import 'activities/activities_screen.dart';
import 'community/community_screen.dart';
import 'profile/profile_screen.dart';
import '../chatbot.dart';

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

  List<NavigationItem> _buildNavigationItems(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return [
    NavigationItem(
      icon: Icons.home,
      activeIcon: Icons.home,
        label: t.navHome,
    ),
    NavigationItem(
      icon: Icons.camera_alt_outlined,
      activeIcon: Icons.camera_alt,
        label: t.navCropHealth,
    ),
    NavigationItem(
      icon: Icons.wb_sunny_outlined,
      activeIcon: Icons.wb_sunny,
        label: t.navWeather,
    ),
    NavigationItem(
      icon: Icons.trending_up_outlined,
      activeIcon: Icons.trending_up,
        label: t.navMarket,
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
        label: t.navActivities,
    ),
    NavigationItem(
      icon: Icons.people_outline,
      activeIcon: Icons.people,
        label: t.navCommunity,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
        label: t.navProfile,
    ),
  ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildNavigationItems(context);
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
          items: items.map((item) {
            final isSelected = items.indexOf(item) == _currentIndex;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                final t = AppLocalizations.of(context)!;
                return AIChatbot(
                  title: t.chatbotTitle,
                  backgroundColor: const Color(0xFFF8F9FA),
                  appBarColor: const Color(0xFF36946F),
                  inputContainerColor: const Color(0xFF2D3648),
                  sendButtonColor: const Color(0xFF36946F),
                  hintText: t.chatbotHint,
                );
              },
            ),
          );
        },
        backgroundColor: const Color(0xFF36946F),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

