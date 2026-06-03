import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/carwash_model.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main/home_screen.dart';
import 'screens/main/favorite_screen.dart';
import 'screens/main/profile_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/main/detail_screen.dart';
import 'helpers/list_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/comment_model.dart';
import 'screens/admin/admin_screen.dart';

class UserModel {
  final String username;
  final String email;
  final String password;
  final String role;
  final String profileAssetPath;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.profileAssetPath = 'assets/images/user/satria_mahatir.jpg',
  });
}

class CarwashProvider extends ChangeNotifier {
  List<CarwashModel> _carwashes = dummyCarwashes;
  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;
  UserModel? _currentUser;

  List<CarwashModel> get carwashes => _carwashes;
  List<CarwashModel> get favorites => _carwashes.where((c) => c.isFavorite).toList();
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // CarwashProvider() {
  //   _carwashes = dummyCarwashes;
  //   _registeredUsers.add(
  //       UserModel(
  //         username: 'Satria Mahatir',
  //         email: 'contact@academy.ac.id',
  //         password: 'password123',
  //       )
  //   );
  // }

  CarwashProvider() {
    fetchCarwashes();
  }

  // Simulasi Registrasi
  Future<bool> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // simpan user ke firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username.trim(),
        'email': email.trim(),
        'role': 'user',
        'createdAt': Timestamp.now(),
      });
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print("FIREBASE AUTH ERROR:");
      print(e.code);
      print(e.message);
      return false;
    } catch (e) {
      print("GENERAL ERROR:");
      print(e);
      return false;
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid =
          userCredential.user!.uid;

      final userDoc = await _firestore
        .collection('users')
        .doc(uid)
        .get();
      final data = userDoc.data();
      _currentUser = UserModel(
        username: data?['username'] ?? '',
        email: data?['email'] ?? '',
        password: '',
        role: data?['role'] ?? 'user',
      );
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  void toggleFavorite(String carwashId) {
    _carwashes = _carwashes.map((carwash) {
      if (carwash.id == carwashId) {
        return carwash.copyWith(isFavorite: !carwash.isFavorite);
      }
      return carwash;
    }).toList();
    notifyListeners();
  }

  void decrementSlot(String carwashId) {
    _carwashes = _carwashes.map((carwash) {
      if (carwash.id == carwashId && carwash.availableSlots > 0) {
        return carwash.copyWith(availableSlots: carwash.availableSlots - 1);
      }
      return carwash;
    }).toList();
    notifyListeners();
  }

  List<CarwashModel> searchCarwashes(String query) {
    if (query.isEmpty) return _carwashes;
    return _carwashes.where((carwash) {
      return carwash.name.toLowerCase().contains(query.toLowerCase()) ||
          carwash.address.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> fetchCarwashes() async {
    try {
      final snapshot = await _firestore.collection('carwashes').get();
      if (snapshot.docs.isNotEmpty) {
        _carwashes = snapshot.docs.map((doc) {
          return CarwashModel.fromFirestore(doc.id, doc.data());
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      print("FETCH ERROR:");
      print(e);
    }
  }

  Future<void> fetchComments(
    String carwashId,
  ) async {
    try {
      final snapshot = await _firestore
        .collection('comments')
        .get();
      _comments = snapshot.docs
        .map((doc) {
          return CommentModel.fromFirestore(
            doc.data(),
          );
        })
        .where((comment) {
          return comment.carwashId == carwashId;
        })
        .toList();
      print(_comments.length);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addComment({
    required String carwashId,
    required String username,
    required String comment,
  }) async {
    try {
      await _firestore.collection('comments').add({
        'carwashId': carwashId,
        'username': username,
        'comment': comment,
        'createdAt': Timestamp.now(),
      });
      await fetchComments(carwashId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCarwash({
    required String name,
    required String address,
    required double rating,
    required String imageUrl,
    required int availableSlots,
  }) async {
    try {
      await _firestore.collection('carwashes').add({
        'name': name,
        'address': address,
        'rating': rating,
        'imageUrl': imageUrl,
        'availableSlots': availableSlots,
        'isFavorite': false,
        'services': [],
      });
      await fetchCarwashes();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateCarwash({
    required String id,
    required String name,
    required String address,
    required double rating,
    required String imageUrl,
    required int availableSlots,
  }) async {
    try {
      await _firestore
        .collection('carwashes')
        .doc(id)
        .update({
          'name': name,
          'address': address,
          'rating': rating,
          'imageUrl': imageUrl,
          'availableSlots': availableSlots,
        });
      await fetchCarwashes();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCarwash(
    String id,
  ) async {
    try {
      await _firestore
          .collection('carwashes')
          .doc(id)
          .delete();
      await fetchCarwashes();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addService({
    required String carwashId,
    required String name,
    required String description,
    required String priceRange,
    required String imageUrl,
  }) async {
    try {
      final doc =
          await _firestore
              .collection('carwashes')
              .doc(carwashId)
              .get();
      final data = doc.data();
      List services = data?['services'] ?? [];
      services.add({
        'name': name,
        'description': description,
        'priceRange': priceRange,
        'imageUrl': imageUrl,
      });
      await _firestore
          .collection('carwashes')
          .doc(carwashId)
          .update({'services': services,
      });
      await fetchCarwashes();
    } catch (e) {
      print(e);
    }
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CarwashProvider(),
        ),
      ],
      child: const GoCarwashApp(),
    ),
  );
}


class GoCarwashApp extends StatelessWidget {
  const GoCarwashApp({super.key});

  @override
  Widget build(BuildContext context) {

    const primaryColor = Color(0xFF0D47A1);
    const accentColor = Color(0xFF1E88E5);

    return Consumer<CarwashProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'GoCarwash',
          debugShowCheckedModeBanner: false,
          themeMode: provider.isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,
            theme: ThemeData(
            brightness: Brightness.light,
            cardColor: Colors.white,
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              secondary: accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Roboto',
            useMaterial3: true,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            cardColor: const Color(0xFF1E1E1E),
            colorScheme: ColorScheme.dark(
              primary: primaryColor,
              secondary: accentColor,
            ),
            useMaterial3: true,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/home': (context) => const HomeScreen(),
            '/favorite': (context) => const FavoriteScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/admin': (context) => const AdminScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final carwashId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (context) {
                  if (carwashId == null) {
                    return const HomeScreen();
                  }
                  return DetailScreen(
                    carwashId: carwashId,
                  );
                },
              );
            }
            return null;
          },
        );
      },
    );
  }
}