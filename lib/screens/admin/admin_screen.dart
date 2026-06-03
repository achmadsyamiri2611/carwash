import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageController = TextEditingController();
  final _slotController = TextEditingController();
  final _serviceNameController = TextEditingController();
  final _serviceDescriptionController = TextEditingController();
  final _servicePriceController = TextEditingController();
  final _serviceImageController = TextEditingController();
  final _ratingController = TextEditingController();

  String? _selectedCarwashId;

  Future<void> _addCarwash() async {
    final provider =
      Provider.of<CarwashProvider>(
        context,
        listen: false,
      );
    await provider.addCarwash(
      name: _nameController.text,
      address: _addressController.text,
      rating: double.parse(
        _ratingController.text,
      ),
      imageUrl: _imageController.text,
      availableSlots: int.parse(
        _slotController.text,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Gerai berhasil ditambahkan',
        ),
      ),
    );
    _nameController.clear();
    _addressController.clear();
    _imageController.clear();
    _slotController.clear();
    _ratingController.clear();
  }

  Future<void> _addService() async {
    if (_selectedCarwashId == null) {
      return;
    }
    final provider =
        Provider.of<CarwashProvider>(
      context,
      listen: false,
    );
    await provider.addService(
      carwashId: _selectedCarwashId!,
      name: _serviceNameController.text,
      description: _serviceDescriptionController.text,
      priceRange: _servicePriceController.text,
      imageUrl: _serviceImageController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Layanan berhasil ditambahkan',
        ),
      ),
    );
    _serviceNameController.clear();
    _serviceDescriptionController.clear();
    _servicePriceController.clear();
    _serviceImageController.clear();
  }

  Widget _buildField(
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    dynamic carwash,
  ) {
    final nameController =
      TextEditingController(
        text: carwash.name,
      );
    final addressController =
      TextEditingController(
        text: carwash.address,
      );
    final imageController =
      TextEditingController(
        text: carwash.imageUrl,
      );
    final slotController =
      TextEditingController(
        text: carwash.availableSlots.toString(),
      );
    final ratingController =
      TextEditingController(
        text: carwash.rating.toString(),
      );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit Gerai',
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildField(
                  'Nama',
                  nameController,
                ),
                _buildField(
                  'Alamat',
                  addressController,
                ),
                _buildField(
                  'Image URL',
                  imageController,
                ),
                _buildField(
                  'Slot',
                  slotController,
                ),
                _buildField(
                  'Rating',
                  ratingController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider =
                  Provider.of<CarwashProvider>(
                    context,
                    listen: false,
                  );
                await provider.updateCarwash(
                  id: carwash.id,
                  name: nameController.text,
                  address: addressController.text,
                  imageUrl: imageController.text,
                  availableSlots: int.parse(
                    slotController.text,
                  ),
                  rating: double.parse(
                    ratingController.text,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Simpan',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final provider = Provider.of<CarwashProvider>(
                context,
                listen: false,
              );

              await provider.logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                  child: Consumer<CarwashProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        itemCount: provider.carwashes.length,
                        itemBuilder: (context, index) {
                          final carwash =
                            provider.carwashes[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                carwash.name,
                              ),
                              subtitle: Text(
                                carwash.address,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                    onPressed: () {
                                      _showEditDialog(
                                        context,
                                        carwash,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      final provider = Provider.of<CarwashProvider>(context, listen: false);
                                      await provider.deleteCarwash(
                                        carwash.id,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Gerai berhasil dihapus',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              _buildField(
                'Nama Gerai',
                _nameController,
              ),
              _buildField(
                'Alamat',
                _addressController,
              ),
              _buildField(
                'Image URL',
                _imageController,
              ),
              _buildField(
                'Slot Tersedia',
                _slotController,
              ),
              _buildField(
                'Rating',
                _ratingController,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addCarwash,
                  child: const Text(
                    'Tambah Gerai',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Tambah Layanan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Consumer<CarwashProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<String>(
                    value: _selectedCarwashId,
                    hint: const Text(
                      'Pilih Gerai',
                    ),
                    items: provider.carwashes.map((carwash) {
                      return DropdownMenuItem(
                        value: carwash.id,
                        child: Text(
                          carwash.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCarwashId = value;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
                _buildField(
                  'Nama Layanan',
                  _serviceNameController,
                ),
                _buildField(
                  'Deskripsi',
                  _serviceDescriptionController,
                ),
                _buildField(
                  'Harga',
                  _servicePriceController,
                ),
                _buildField(
                  'Image Service',
                  _serviceImageController,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addService,
                    child: const Text(
                      'Tambah Layanan',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}