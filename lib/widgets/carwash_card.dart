import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/carwash_model.dart';
import '../main.dart';

class CarwashCard extends StatelessWidget {
  final CarwashModel carwash;

  const CarwashCard({
    super.key,
    required this.carwash,
  });

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).colorScheme.primary;

    final bool isAvailable = carwash.availableSlots > 0;
    final Color slotColor = isAvailable ? Colors.green : Colors.red;
    final String slotText = isAvailable
        ? '${carwash.availableSlots} Slot Tersedia'
        : 'Sedang Penuh / Antrian';


    void toggleFavoriteStatus() {
      Provider.of<CarwashProvider>(context, listen: false).toggleFavorite(carwash.id);
    }

    void navigateToDetail() {
      Navigator.pushNamed(
        context,
        '/detail',
        arguments: carwash.id,
      );
    }

    return GestureDetector(
      onTap: navigateToDetail,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),

          border: Border.all(color: primaryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Gambar Gerai ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  carwash.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.car_crash_rounded, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // --- Detail Teks ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carwash.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      carwash.address,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                          Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // ---SLOT STATUS ---
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: slotColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          slotText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: slotColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // --- Rating & Favorite Icon ---
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < carwash.rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          carwash.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),

                        // --- Tombol Favorite ---
                        IconButton(
                          icon: Icon(
                            carwash.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: carwash.isFavorite
                                ? primaryColor
                                : Colors.grey,
                            size: 24,
                          ),
                          onPressed: toggleFavoriteStatus,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}