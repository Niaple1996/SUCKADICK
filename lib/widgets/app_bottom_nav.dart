import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Hauptnavigation',
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: AppColorTokens.primary,
        unselectedItemColor: AppColorTokens.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Start'),
          BottomNavigationBarItem(icon: Icon(Icons.group_rounded), label: 'Kontakte'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Einstellungen'),
        ],
      ),
    );
  }
}
