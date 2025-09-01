import 'package:chrono_point/business/auth/auth_bloc.dart';
import 'package:chrono_point/data/models/employee.dart';
import 'package:chrono_point/data/repositories/auth_repository.dart';
import 'package:chrono_point/presentation/screens/home_screen.dart';
import 'package:chrono_point/presentation/screens/notification_screen.dart';
import 'package:chrono_point/presentation/screens/profile_tab.dart';
import 'package:chrono_point/presentation/screens/schedule_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Index 2 adalah untuk FAB, jangan ubah halaman
    if (index == 2) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ambil AuthRepository dari context
    final authRepository = context.read<AuthRepository>();

    // Ambil user dari state BLoC dengan aman
    final state = context.watch<AuthBloc>().state;
    User? user;
    if (state is AuthAuthenticated) user = state.user;
    if (state is AuthLoginSuccess) user = state.user;

    // Tampilkan loading jika user belum tersedia
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Gunakan StreamBuilder untuk mendapatkan data Employee secara real-time
    return StreamBuilder<Employee>(
      stream: authRepository.getEmployeeStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Data karyawan tidak ditemukan.")),
          );
        }

        final employee = snapshot.data!;
        // Daftar halaman yang akan ditampilkan
        final List<Widget> pages = [
          HomeScreen(employee: employee),
          const NotificationScreen(),
          const SizedBox.shrink(),
          const ScheduleScreen(),
          ProfileScreen(employee: employee),
        ];

        final Color baseColor = Colors.green.shade600;

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: pages),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Tambahkan logika untuk Absen
              print("Tombol Absen ditekan!");
            },
            backgroundColor: baseColor,
            shape: const CircleBorder(),
            elevation: 2.0,
            child: const Icon(Icons.fingerprint, color: Colors.white, size: 30),
            tooltip: 'Absen',
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomAppBar(baseColor),
        );
      },
    );
  }

  BottomAppBar _buildBottomAppBar(Color baseColor) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      elevation: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(Icons.home_filled, 'Beranda', 0, baseColor),
          _buildNavItem(Icons.notifications, 'Notifikasi', 1, baseColor),
          const SizedBox(width: 48), // Spasi untuk FloatingActionButton
          _buildNavItem(Icons.calendar_today, 'Jadwal', 3, baseColor),
          _buildNavItem(Icons.person, 'Profil', 4, baseColor),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    Color baseColor,
  ) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? baseColor : Colors.grey.shade500,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? baseColor : Colors.grey.shade500,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
