import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/purple_background.dart';
import '../theme/context_extensions.dart';

class DashboardShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardShell({
    super.key,
    required this.navigationShell,
  });

  void _onTabChange(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PurpleBackground(
        child: Column(
          children: [
            Expanded(
              child: navigationShell,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                16,
              ),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: GNav(
                  selectedIndex:
                  navigationShell.currentIndex,
                  onTabChange: _onTabChange,
                  gap: 6,
                  color: context.mutedText,

                  activeColor: context.accent,

                  tabBackgroundColor: context.accent.withValues(
                    alpha: 0.15,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  tabs: const [
                    GButton(
                      icon: Icons.home_rounded,

                    ),
                    GButton(
                      icon: Icons.swap_horiz_rounded,
                    ),
                    GButton(
                      icon: Icons.pie_chart_rounded,
                    ),
                    GButton(
                      icon: Icons.more_horiz_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}