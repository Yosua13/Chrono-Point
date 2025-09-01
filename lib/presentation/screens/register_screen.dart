import 'package:chrono_point/business/auth/auth_bloc.dart';
import 'package:chrono_point/presentation/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk setiap input field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpSuccess) {
          AppDialogs.showInfoDialog(
            context: context,
            title: "Registrasi Berhasil",
            duration: Duration(seconds: 1),
            message:
                "Akun Anda telah dibuat. Anda akan dialihkan ke halaman login",
            onDismissed: () {
              Navigator.of(context).pop();
            },
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Buat Akun Baru'), centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Satu Langkah Lagi',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Isi data diri Anda untuk membuat akun',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 32),

                // Input Field Nama Lengkap
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Input Field Email
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

                // Input Field Password
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Input Field Konfirmasi Password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    prefixIcon: Icon(Icons.lock_person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Tombol Daftar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Password tidak cocok!'),
                        ),
                      );
                      return;
                    }

                    context.read<AuthBloc>().add(
                      AuthSignUpRequested(
                        nameController.text.trim(),
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

                      return Text('Daftar', style: TextStyle(fontSize: 16));
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Link kembali ke Halaman Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah punya akun?'),
                    TextButton(
                      onPressed: () {
                        // Kembali ke halaman sebelumnya (Login)
                        Navigator.pop(context);
                      },
                      child: Text('Login di sini'),
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
