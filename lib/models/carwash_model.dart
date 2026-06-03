class ServiceModel {
  final String name;
  final String description;
  final String priceRange;
  final String imageUrl;

  ServiceModel({
    required this.name,
    required this.description,
    required this.priceRange,
    required this.imageUrl,
  });
}

class CarwashModel {
  final String id;
  final String name;
  final String address;
  final double rating;
  final String imageUrl;
  final List<ServiceModel> services;
  final int availableSlots;
  final bool isFavorite;

  CarwashModel({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.imageUrl,
    required this.services,
    this.availableSlots = 0,
    this.isFavorite = false,
  });

  CarwashModel copyWith({
    bool? isFavorite,
    int? availableSlots,
  }) {
    return CarwashModel(
      id: id,
      name: name,
      address: address,
      rating: rating,
      imageUrl: imageUrl,
      services: services,
      availableSlots: availableSlots ?? this.availableSlots,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory CarwashModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    List<ServiceModel> firestoreServices = [];
    if (data['services'] != null) {
      firestoreServices =
        (data['services'] as List).map((service) {
          return ServiceModel(
            name: service['name'] ?? '',
            description: service['description'] ?? '',
            priceRange: service['priceRange'] ?? '',
            imageUrl: service['imageUrl'] ?? '',
          );
        }).toList();
    }
    return CarwashModel(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      availableSlots: data['availableSlots'] ?? 0,
      isFavorite: data['isFavorite'] ?? false,
      services: (data['services'] as List<dynamic>? ?? [])
        .map(
          (service) => ServiceModel(
            name: service['name'] ?? '',
            description: service['description'] ?? '',
            priceRange: service['priceRange'] ?? '',
            imageUrl: service['imageUrl'] ?? '',
          ),
        )
        .toList(),
    );
  }
}

final List<ServiceModel> rajawaliServices = [
  ServiceModel(
    name: 'Cuci Salju Premium',
    description: 'Cuci Eksterior, Vakum, dan Semir Ban Khusus.',
    priceRange: 'Rp 65.000 - Rp 110.000',
    imageUrl: 'images/service/cuci_reguler.png',
  ),
  ServiceModel(
    name: 'Interior Express',
    description: 'Pembersihan interior cepat, fokus pada jok dan dashboard.',
    priceRange: 'Rp 80.000 - Rp 150.000',
    imageUrl: 'images/service/poles_waxing.png',
  ),
  ServiceModel(
    name: 'Keramik Coating',
    description: 'Perlindungan cat jangka panjang (Layanan Penuh).',
    priceRange: 'Rp 2.500.000 - Rp 5.000.000',
    imageUrl: 'images/service/full_detailing.png',
  ),
];

final List<ServiceModel> kgetServices = [
  ServiceModel(
    name: 'Cuci Kilat',
    description: 'Hanya Eksterior Cepat dan Kering Angin.',
    priceRange: 'Rp 30.000 - Rp 50.000',
    imageUrl: 'images/service/cuci_reguler2.png',
  ),
  ServiceModel(
    name: 'Cuci Reguler + Vakum',
    description: 'Cuci Eksterior dengan Vakum Interior Dasar.',
    priceRange: 'Rp 45.000 - Rp 75.000',
    imageUrl: 'images/service/poles_waxing2.png',
  ),
  ServiceModel(
    name: 'Ozon Treatment',
    description: 'Penghilang bau tidak sedap di kabin mobil.',
    priceRange: 'Rp 150.000 - Rp 250.000',
    imageUrl: 'images/service/full_detailing2.png',
  ),
];

final List<ServiceModel> m2Services = [
  ServiceModel(
    name: 'Cuci Busa Salju',
    description: 'Pembersihan menyeluruh dengan busa tebal.',
    priceRange: 'Rp 55.000 - Rp 90.000',
    imageUrl: 'images/service/cuci_reguler3.png',
  ),
  ServiceModel(
    name: 'Engine Bay Detailing',
    description: 'Pembersihan ruang mesin secara profesional.',
    priceRange: 'Rp 350.000 - Rp 500.000',
    imageUrl: 'images/service/poles_waxing3.png',
  ),
  ServiceModel(
    name: 'Kaca Film Pemasangan',
    description: 'Jasa pemasangan kaca film premium (harga tergantung jenis).',
    priceRange: 'Rp 800.000 - Rp 3.000.000',
    imageUrl: 'images/service/full_detailing3.png',
  ),
];

final List<ServiceModel> service3d = [
  ServiceModel(
    name: 'Cuci Reguler (Cepat)',
    description: 'Layanan standar, cepat, dan efisien.',
    priceRange: 'Rp 40.000 - Rp 70.000',
    imageUrl: 'images/service/cuci_reguler4.png',
  ),
  ServiceModel(
    name: 'Pembersihan Jamur Kaca',
    description: 'Menghilangkan noda air dan jamur pada seluruh kaca.',
    priceRange: 'Rp 120.000 - Rp 200.000',
    imageUrl: 'images/service/poles_waxing4.png',
  ),
  ServiceModel(
    name: 'Poles Body Maksimal',
    description: 'Mengembalikan kilap cat dan menghilangkan baret halus.',
    priceRange: 'Rp 400.000 - Rp 800.000',
    imageUrl: 'images/service/full_detailing4.png',
  ),
];


final List<CarwashModel> dummyCarwashes = [
  CarwashModel(
    id: '1',
    name: 'Rajawali Carwash',
    address: 'Jl. Rajawali III No.56, RT/RW.17/05 30113 Ilir Timur II Sumatera Selatan',
    rating: 5.0,
    imageUrl: 'images/gerai/rajawali.png',
    services: rajawaliServices,
    availableSlots: 3,
    isFavorite: true,
  ),
  CarwashModel(
    id: '2',
    name: 'K-GET Carwash',
    address: 'Jl. Brigjen Hasan Kasim No.8, Bukit Sangkal, Kec. Kalidoni, Kota Palembang, Sumatera Selatan 30114',
    rating: 4.9,
    imageUrl: 'images/gerai/kget.png',
    services: kgetServices,
    availableSlots: 0,
    isFavorite: false,
  ),
  CarwashModel(
    id: '3',
    name: 'M2 Carwash',
    address: 'Jl. Prajurit Nazaruddin No.10, Kalidoni, Kec. Kalidoni, Kota Palembang, Sumatera Selatan 30163',
    rating: 3.5,
    imageUrl: 'images/gerai/m2.png',
    services: m2Services,
    availableSlots: 5,
    isFavorite: true,
  ),
  CarwashModel(
    id: '4',
    name: '3D Carwash',
    address: 'Jl. Lintas Sumatera, Kemang Agung, Kec. Kertapati, Kota Palembang, Sumatera Selatan 30259',
    rating: 3.0,
    imageUrl: 'images/gerai/3d.png',
    services: service3d,
    availableSlots: 1,
    isFavorite: false,
  ),
];