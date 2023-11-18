import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'vegetablepage.dart';
import 'recipepage.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  CustomBottomBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black ,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3), // 그림자의 위치 (수직으로 3만큼 아래로)
          ),
        ],
      ),
      child: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 118, 191, 126),
        elevation: 10, // 하단바의 그림자 높이 조절
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.eco, size: 35),
            label: '채소',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -30,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 118, 191, 126),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -14),
                  child: Image.asset(
                    'assets/images/home.png',
                    height: 50,
                    width: 50,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant, size: 35),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage()));
              break;
          }
        },
      ),
    );
  }
}
