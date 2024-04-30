import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  BottomBar({required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey,
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      elevation: 8.0,
      selectedItemColor: Colors.purple.withOpacity(0.7),

      unselectedItemColor: Colors.grey[600],
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Anasayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.announcement),
          label: 'İlan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign),
          label: 'Duyuru',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Etkinlik',
        ),
      ],
    );
  }
}
