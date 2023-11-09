import 'package:flutter/material.dart';
import 'favorites_page.dart'; // 찜한 목록 페이지
import 'my_page.dart'; // 마이페이지

PopupMenuButton<int> buildPopupMenuButton(BuildContext context) {
  return PopupMenuButton<int>(
    onSelected: (item) {
      _selectedMenuItem(context, item);
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
      const PopupMenuItem<int>(
        value: 1,
        child: Text('찜한 목록'),
      ),
      const PopupMenuItem<int>(
        value: 2,
        child: Text('마이페이지'),
      ),
    ],
    icon: const Icon(Icons.menu, color: Colors.black),
  );
}

void _selectedMenuItem(BuildContext context, int item) {
  switch (item) {
    case 1:
      // 찜한 목록 페이지로 이동
      //Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
      break;
    case 2:
      // 마이페이지로 이동
      //Navigator.push(context, MaterialPageRoute(builder: (context) => MyPage()));
      break;
    default:
      print('Unknown menu item');
  }
}
