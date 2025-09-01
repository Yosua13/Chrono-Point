import 'package:chrono_point/business/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk mengambil teks dari input field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Login Karyawan'), centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Header atau Logo bisa ditambahkan di sini
                SizedBox(height: 40),
                Text(
                  'Selamat Datang Kembali',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Silakan login untuk melanjutkan',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 48),

                // Input Field untuk Email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),

                // Input Field untuk Password
                TextFormField(
                  controller: passwordController,
                  obscureText: true, // Menyembunyikan teks password
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Tombol Login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthSignInRequested(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      ),
                    );
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CircularProgressIndicator(color: Colors.white);
                      }
                      return Text('Login', style: TextStyle(fontSize: 16));
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Link ke Halaman Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun?'),
                    TextButton(
                      onPressed: () {
                        // Navigasi ke halaman Register
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text('Daftar di sini'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
