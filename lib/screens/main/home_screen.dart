import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/bottom_nav.dart';
import '../../widgets/carwash_card.dart';
import '../../models/carwash_model.dart';
import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final carwashProvider = Provider.of<CarwashProvider>(context);

    final List<CarwashModel> displayedCarwashes =
    _searchQuery.isEmpty
        ? carwashProvider.carwashes
        : carwashProvider.searchCarwashes(_searchQuery);

    final primaryColor = Theme.of(context).colorScheme.primary;

    final String userName = carwashProvider.currentUser?.username ?? 'Pengguna';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- HEADER SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, $userName',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Mau cuci mobil di mana hari ini?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CENTER LOGO
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: primaryColor,
                            child: const Icon(
                              Icons.local_car_wash,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // RIGHT BUTTON
                  IconButton(
                    onPressed: () {
                      carwashProvider.toggleTheme();
                    },
                    icon: Icon(
                      carwashProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- SEARCH BAR SECTION ---
              Container(

                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(

                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    hintText: 'Cari sekarang...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: InputBorder.none,

                    contentPadding: const EdgeInsets.symmetric(vertical: 14),

                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () => _searchController.clear(),
                    )
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              if (displayedCarwashes.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada gerai yang ditemukan.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              else
                ...displayedCarwashes.map((carwash) {
                  return CarwashCard(carwash: carwash);
                }).toList(),
            ],
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 0),
    );
  }
}