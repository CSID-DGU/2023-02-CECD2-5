import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'vegetablepage.dart';

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
      selectedItemColor: Colors.green[700],
      elevation: 10,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist, size: 35),
          label: '채소',
          
        ),
BottomNavigationBarItem(
  icon: Stack(
    alignment: Alignment.center, // 중앙 정렬을 기본으로 설정
    clipBehavior: Clip.none, // 자식이 경계를 넘어 표시되도록 허용
    children: [
      Positioned(
        top: -35, // 원의 위치를 적절히 조정
        child: Container(
          height: 80, // 원의 크기
          width: 80, // 원의 너비
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
      ),
      Transform.translate(
        offset: Offset(0, -15), // 아이콘의 상단 패딩을 적용해 위치를 위로 조정
        child: Icon(Icons.home, size: 40, color: Colors.white),
      ),
    ],
  ),
  label: '',
),

        BottomNavigationBarItem(
          icon: Icon(Icons.book, size: 35),
          label: '레시피',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == selectedIndex) {
          return;
        }
        switch (index) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => VegetablePage()));
            break;
          case 1:
            Navigator.pop(context);
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage()));
            break;
        }
      }
    );
  }
}
