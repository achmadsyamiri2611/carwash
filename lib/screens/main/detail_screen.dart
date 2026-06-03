import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/carwash_model.dart';
import '../../widgets/bottom_nav.dart';
import '../../helpers/list_extension.dart';

class DetailScreen extends StatefulWidget {
  final String carwashId;

  const DetailScreen({
    super.key,
    required this.carwashId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  final TextEditingController _commentController =
  TextEditingController();

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSlotIndicator(
      BuildContext context,
      String statusText,
      String helperText,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time_filled,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  helperText,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceModel service) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: primaryColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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

            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                service.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.local_car_wash, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                        Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.priceRange,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CarwashProvider>(
        context,
        listen: false,
      ).fetchComments(widget.carwashId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarwashProvider>(
      builder: (context, carwashProvider, child) {
        final primaryColor = Theme.of(context).colorScheme.primary;

        final CarwashModel? carwash = carwashProvider.carwashes.firstWhereOrNull((c) => c.id == widget.carwashId);

        if (carwash == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Gerai tidak ditemukan')),
            body: const Center(child: Text('Gerai tidak ditemukan!')),
          );
        }

        final bool isAvailable = carwash.availableSlots > 0;
        final Color slotColor = isAvailable ? Colors.green.shade700 : Colors.red.shade700;
        final String slotStatusText = isAvailable
            ? 'Tersedia ${carwash.availableSlots} Slot'
            : 'Penuh. Coba Lain Waktu.';
        final String slotHelperText = isAvailable
            ? 'Estimasi tunggu saat ini: 0-15 menit.'
            : 'Antrian saat ini mungkin panjang.';

        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 4,


            title: Text(carwash.name),
            centerTitle: true,


            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: primaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Tombol Favorite
            actions: [
              IconButton(
                icon: Icon(
                  carwash.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  carwashProvider.toggleFavorite(carwash.id);
                },
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                        carwash.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250, width: double.infinity, color: Colors.blueGrey,
                          child: const Center(child: Icon(Icons.car_crash_rounded, color: Colors.white, size: 50)),
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              carwash.name,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                          ),
                          Row(
                            children: [
                              _buildRatingStars(carwash.rating),
                              const SizedBox(width: 4),
                              Text(
                                carwash.rating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(carwash.address, style: TextStyle(color: Colors.grey[600])),
                      const Divider(height: 24),

                      _buildSlotIndicator(
                        context,
                        slotStatusText,
                        slotHelperText,
                        slotColor,
                      ),
                      const Divider(height: 24),

                      _buildSectionTitle('Daftar Layanan'),
                      const SizedBox(height: 16),

                      ...carwash.services.map((service) {
                        return _buildServiceCard(context, service);
                      }).toList(),

                      const SizedBox(height: 40),

                      _buildSectionTitle('Komentar'),
                      const SizedBox(height: 16),
                      Consumer<CarwashProvider>(
                        builder: (context, provider, child) {
                          if (provider.comments.isEmpty) {
                            return const Text('Belum ada komentar');
                          }
                          return Column(
                            children: provider.comments.map((comment) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(comment.username),
                                subtitle: Text(comment.comment),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Tulis komentar...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(

                          onPressed: () async {

                            if (_commentController.text.isEmpty) return;

                            final provider =
                                Provider.of<CarwashProvider>(
                              context,
                              listen: false,
                            );

                            await provider.addComment(

                              carwashId: carwash.id,

                              username: 'User',

                              comment: _commentController.text,

                            );

                            _commentController.clear();
                          },

                          child: const Text('Kirim Komentar'),
                        ),
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isAvailable
                              ? () {
                            carwashProvider.decrementSlot(carwash.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Pemesanan slot berhasil! Slot ${carwash.name} berkurang 1.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                              : null,
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            isAvailable ? 'Pesan Slot Sekarang' : 'Tidak Tersedia',
                            style: const TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: isAvailable ? primaryColor : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Bottom Navigation Bar ---
          bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 0),
        );
      },
    );
  }
}