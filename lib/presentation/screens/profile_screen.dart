import 'package:chrono_point/business/profile/profile_bloc.dart';
import 'package:chrono_point/data/models/employee.dart';
import 'package:chrono_point/data/repositories/profile_repository.dart';
import 'package:chrono_point/presentation/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Widget ini bertindak sebagai "Entry Point" untuk halaman profil.
/// Tugas utamanya adalah menyediakan ProfileRepository dan ProfileBloc
/// ke dalam widget tree, sehingga ProfileView dan halaman selanjutnya (EditProfileScreen)
/// dapat mengaksesnya.
class ProfileScreen extends StatelessWidget {
  final Employee employee;
  const ProfileScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    // Menyediakan ProfileRepository dan ProfileBloc ke dalam widget tree
    return RepositoryProvider(
      create: (context) => ProfileRepository(),
      child: BlocProvider(
        create: (context) =>
            ProfileBloc(profileRepository: context.read<ProfileRepository>()),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil berhasil diperbarui!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is ProfileUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal memperbarui profil: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          // ProfileView adalah widget yang berisi UI sebenarnya
          child: ProfileView(employee: employee),
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  final Employee employee;
  const ProfileView({super.key, required this.employee});

  String _formatDate(DateTime? date) {
    if (date == null) return "Belum diatur";
    return DateFormat('d MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    // UBAH WARNA DI SINI
    final Color baseColor = Colors.green.shade600;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: baseColor, // Terapkan warna
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            profileBloc: context.read<ProfileBloc>(),
                            currentEmployee: employee,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(context, baseColor),
                ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  tabs: const [
                    Tab(text: 'PRIBADI'),
                    Tab(text: 'PEKERJAAN'),
                    // Tab(text: 'PENGATURAN'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildPersonalInfo(context),
              _buildWorkInfo(context),
              // const Center(child: Text("Halaman Pengaturan")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Color themeColor) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              backgroundImage:
                  employee.fotoProfil != null && employee.fotoProfil!.isNotEmpty
                  ? NetworkImage(employee.fotoProfil!)
                  : null,
              child:
                  (employee.fotoProfil == null || employee.fotoProfil!.isEmpty)
                  ? Icon(Icons.person, size: 45, color: themeColor)
                  : null,
            ),
            const SizedBox(height: 10),
            Text(
              employee.namaLengkap,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Chip(
              avatar: Icon(Icons.work, color: themeColor, size: 16),
              label: Text(
                employee.jabatan?.namaJabatan ?? "Jabatan Kosong",
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Text(
                "Informasi Pribadi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildInfoRow(
              icon: Icons.badge_outlined,
              label: "ID Pegawai",
              // Menampilkan ID dengan lebih aman
              value: employee.employeeId.length > 20
                  ? "${employee.employeeId.substring(0, 20)}..."
                  : employee.employeeId,
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.email_outlined,
              label: "Email",
              value: employee.email,
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: "Phone Number",
              value: employee.noHp ?? "Belum diatur",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Address",
              value: employee.alamat ?? "Belum diatur",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.cake_outlined,
              label: "Date of Birth",
              value: _formatDate(employee.tanggalLahir), // Menggunakan helper
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.person_outline,
              label: "Gender",
              value: employee.jenisKelamin ?? "Belum diatur",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkInfo(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Text(
                "Informasi Pekerjaan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildInfoRow(
              icon: Icons.work_outline,
              label: "Position",
              value: employee.jabatan?.namaJabatan ?? "Jabatan Kosong",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.business_outlined,
              label: "Department",
              value: employee.departemen?.namaDepartemen ?? "Departemen Kosong",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: "Hire Date",
              value: _formatDate(employee.tanggalMasuk),
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.toggle_on_outlined,
              label: "Employee Status",
              value: employee.statusKaryawan ?? "Belum diatur",
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk menampilkan baris informasi, sudah disederhanakan.
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
