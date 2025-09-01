import 'package:chrono_point/data/models/employee.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Employee employee;
  const ProfileScreen({super.key, required this.employee});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Warna tema untuk halaman profil
    final Color profileThemeColor = Colors.blue.shade800;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: profileThemeColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(context, profileThemeColor),
                ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  tabs: const [
                    Tab(text: 'PRIBADI'),
                    Tab(text: 'PEKERJAAN'),
                    Tab(text: 'PENGATURAN'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildPersonalInfo(context),
              _buildWorkInfo(context),
              const Center(child: Text("Halaman Pengaturan")),
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
            Stack(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.employee.profilePictureUrl != null
                      ? NetworkImage(widget.employee.profilePictureUrl!)
                      : null,
                  child: widget.employee.profilePictureUrl == null
                      ? Icon(Icons.person, size: 45, color: themeColor)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: themeColor, width: 2),
                    ),
                    child: Icon(Icons.camera_alt, size: 18, color: themeColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.employee.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.edit, color: Colors.white, size: 18),
              ],
            ),
            const SizedBox(height: 5),
            Chip(
              avatar: Icon(Icons.work, color: themeColor, size: 16),
              label: Text(
                widget.employee.position ?? 'Posisi Belum Diatur',
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
              value: "${widget.employee.employeeId.substring(0, 20)}...",
              showEdit: false,
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.email_outlined,
              label: "Email",
              value: widget.employee.email,
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: "Phone Number",
              value: widget.employee.phoneNumber ?? "Belum diatur",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Address",
              value: widget.employee.address ?? "Belum diatur",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Date of Birth",
              value: widget.employee.department ?? "Belum diatur",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Gender",
              value: widget.employee.gender ?? "Belum diatur",
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
              icon: Icons.location_on_outlined,
              label: "Position",
              value: widget.employee.position ?? "Belum diatur",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Department",
              value: widget.employee.department ?? "Belum diatur",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Hire Date",
              value: widget.employee.department ?? "Belum diatur",
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Employee Status",
              value: widget.employee.employeeStatus ?? "Belum diatur",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool showEdit = true,
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
          if (showEdit)
            InkWell(
              onTap: () {},
              child: Icon(Icons.edit, size: 20, color: Colors.grey[400]),
            ),
        ],
      ),
    );
  }
}
