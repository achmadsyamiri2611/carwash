import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {

  final int? selectedIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {

    final actualIndex = selectedIndex != null && selectedIndex! >= 0 && selectedIndex! < 3
        ? selectedIndex!
        : 0;
    return BottomNavigationBar(

      currentIndex: actualIndex,
      onTap: (index) {
        String routeName = '';
        if (index == 0) {
          routeName = '/home';
        } else if (index == 1) {
          routeName = '/favorite';
        } else if (index == 2) {
          routeName = '/profile';
        }

        if (ModalRoute.of(context)!.settings.name != routeName) {

          Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
        }
      },
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey[400],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorit',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}