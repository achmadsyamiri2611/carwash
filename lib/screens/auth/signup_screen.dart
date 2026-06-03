import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _submitSignUp() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<CarwashProvider>(context, listen: false);

      final bool registerSuccess = await provider.register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (registerSuccess) {

        await provider.login(_emailController.text, _passwordController.text);

        Navigator.pushReplacementNamed(context, '/home');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil! Anda sudah login.'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Gagal. Email sudah terdaftar.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildInputField(
      {required IconData icon,
        required String hintText,
        required TextEditingController controller,
        String? Function(String?)? validator,
        bool isPassword = false,
        bool isConfirmPassword = false}) {

    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextFormField(
                    controller: controller,
                    validator: validator,
                    obscureText: isPassword
                        ? !_isPasswordVisible
                        : (isConfirmPassword ? !_isConfirmPasswordVisible : false),

                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      isDense: true,

                      suffixIcon: (isPassword || isConfirmPassword)
                          ? IconButton(
                        icon: Icon(
                          (isPassword ? _isPasswordVisible : _isConfirmPasswordVisible)
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color:
                            Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isPassword) {
                              _isPasswordVisible = !_isPasswordVisible;
                            } else if (isConfirmPassword) {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            }
                          });
                        },
                      )
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Image.asset('assets/images/logo.png', height: 250),
                const SizedBox(height: 32),

                Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                const SizedBox(height: 32),

                _buildInputField(
                  icon: Icons.person_outline,
                  hintText: 'Username',
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama pengguna wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  icon: Icons.email_outlined,
                  hintText: 'Email address',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  icon: Icons.lock_outline,
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  icon: Icons.lock_outline,
                  hintText: 'Confirm password',
                  controller: _confirmPasswordController,
                  isConfirmPassword: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Konfirmasi sandi tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitSignUp,
                    child: const Text('Login Now'),
                  ),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already an have account?', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text('Login', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}