import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/bottom_nav.dart';
import '../../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final carwashProvider = Provider.of<CarwashProvider>(context);
    final UserModel? user = carwashProvider.currentUser;
    final favoriteCount = carwashProvider.favorites.length;
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (user == null) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
      return const SizedBox.shrink();
    }

    Widget buildProfileItem(String title, String value, {bool isPassword = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isPassword ? '********' : value,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const Divider(),
          ],
        ),
      );
    }

    // Widget untuk Tombol Logout
    Widget buildLogoutButton() {
      return InkWell(
        onTap: () {
          carwashProvider.logout();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anda berhasil Log Out.')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red[700], size: 28),
              const SizedBox(width: 12),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Stack(
              clipBehavior: Clip.none, alignment: Alignment.topCenter,
              children: [
                // Background Image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: primaryColor,

                    image: DecorationImage(
                      image: const NetworkImage(
                        'https://placehold.co/600x400/add8e6/0D47A1?text=PROFILE+BACKGROUND',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    ),
                  ),
                ),
                // Teks Profile
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 24),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'PROFILE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 100,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        user.profileAssetPath, // Menggunakan path aset dari user model
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        // Fallback jika gambar aset tidak ditemukan
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey[400],
                          child: const Icon(Icons.person, size: 80, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Detail Informasi Pengguna ---
                  buildProfileItem('Nama', user.username),
                  buildProfileItem('Email', user.email),
                  buildProfileItem('Password', '', isPassword: true),

                  const SizedBox(height: 16),

                  // --- Jumlah Favorite ---
                  Text(
                    'Gerai Favorit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$favoriteCount Gerai',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Divider(),

                  const SizedBox(height: 32),

                  // --- Tombol Log Out ---
                  buildLogoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
      // --- Bottom Navigation Bar ---
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 2),
    );
  }
}