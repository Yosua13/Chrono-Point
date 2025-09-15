import 'package:chrono_point/business/auth/auth_bloc.dart';
import 'package:chrono_point/data/repositories/auth_repository.dart';
import 'package:chrono_point/presentation/screens/main_screen.dart';
import 'package:chrono_point/presentation/screens/login_screen.dart';
import 'package:chrono_point/presentation/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await supabase.Supabase.initialize(
    url: dotenv.env['URL'] ?? '',
    anonKey: dotenv.env['ANONKEY'] ?? '',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menyediakan AuthRepository ke seluruh aplikasi
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      // Menyediakan AuthBloc ke seluruh aplikasi
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: MaterialApp(
          title: 'Aplikasi Absensi',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            ),
          ),
          // Wrapper untuk menentukan halaman berdasarkan AuthState
          home: AuthWrapper(),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder akan rebuild UI berdasarkan perubahan AuthState
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous is AuthLoading && current is AuthLoginSuccess,
      listener: (context, state) {
        AppDialogs.showInfoDialog(
          context: context,
          title: 'Login Berhasil!',
          message: 'Selamat datang kembali',
          duration: const Duration(seconds: 1),
          onDismissed: () {
            context.read<AuthBloc>().add(AuthLoginAcknowledged());
          },
        );
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return MainScreen();
        }
        return LoginScreen();
      },
    );
  }
}
