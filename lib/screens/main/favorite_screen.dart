import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/bottom_nav.dart';
import '../../widgets/carwash_card.dart';
import '../../models/carwash_model.dart';
import '../../main.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCarwashes = Provider.of<CarwashProvider>(context).favorites;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      // --- PERBAIKAN HEADER ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),

              onPressed: () {

                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                        (Route<dynamic> route) => false
                );
              },
            ),
          ),
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
                'assets/images/logo.png',
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100, height: 100, color: Colors.blueGrey,
                  child: const Icon(Icons.local_car_wash, color: Colors.white),
                )
            ),
          ],
        ),
      ),


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: const [
                  Icon(Icons.favorite, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Favorite',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Daftar Gerai Favorit ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: favoriteCarwashes.isEmpty
                  ? const Center(
                child: Text('Anda belum menambahkan gerai ke favorit.'),
              )
                  : ListView.builder(
                itemCount: favoriteCarwashes.length,
                itemBuilder: (context, index) {
                  return CarwashCard(carwash: favoriteCarwashes[index]);
                },
              ),
            ),
          ),
        ],
      ),
      // --- Bottom Navigation Bar ---
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
}