import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  CustomBottomBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist),
          label: '채소',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.circle),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: '레시피',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => onTap(index),
    );
  }
}