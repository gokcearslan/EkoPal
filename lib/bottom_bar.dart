import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  BottomBar({required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey, // Background color of the BottomNavigationBar
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      elevation: 8.0,
      // Color of the icon and text when they are selected
      selectedItemColor: Colors.purple.withOpacity(0.7),
      // Color of the icon and text when they are not selected
      unselectedItemColor: Colors.grey[600], // Adjust this for your preferred shade of grey
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
