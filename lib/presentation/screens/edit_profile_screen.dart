import 'dart:io';
import 'package:chrono_point/business/profile/profile_bloc.dart';
import 'package:chrono_point/data/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final Employee currentEmployee;
  final ProfileBloc profileBloc;

  const EditProfileScreen({
    super.key,
    required this.currentEmployee,
    required this.profileBloc,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Kunci untuk form, berguna untuk validasi di masa depan
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field teks
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  // State untuk field non-teks
  DateTime? _selectedDate;
  String? _selectedGender;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.currentEmployee.namaLengkap,
    );
    _phoneController = TextEditingController(text: widget.currentEmployee.noHp);
    _addressController = TextEditingController(
      text: widget.currentEmployee.alamat,
    );
    _selectedDate = widget.currentEmployee.tanggalLahir;
    _selectedGender = widget.currentEmployee.jenisKelamin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveProfile() {
    // Opsional: tambahkan validasi form
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    // ===== PERBAIKAN UTAMA DI SINI =====
    final updatedData = {
      'nama_lengkap': _nameController.text.trim(),
      'no_hp': _phoneController.text.trim(),
      'alamat': _addressController.text.trim(),
      // Format tanggal ke 'yyyy-MM-dd' sebelum mengirim, atau kirim null jika kosong
      'tanggal_lahir': _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : null,
      'jenis_kelamin': _selectedGender,
    };
    // ===================================

    widget.profileBloc.add(
      ProfileUpdateRequested(
        updatedData: updatedData,
        imageFile: _selectedImage,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.profileBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ubah Profil'),
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: state is ProfileUpdateInProgress
                      ? null
                      : _saveProfile,
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileUpdateInProgress) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Menyimpan perubahan..."),
                  ],
                ),
              );
            }
            return _buildEditForm();
          },
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    // Bungkus dengan Form untuk best practice
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (widget.currentEmployee.fotoProfil != null &&
                                      widget
                                          .currentEmployee
                                          .fotoProfil!
                                          .isNotEmpty
                                  ? NetworkImage(
                                      widget.currentEmployee.fotoProfil!,
                                    )
                                  : null)
                              as ImageProvider?,
                    child:
                        (_selectedImage == null &&
                            (widget.currentEmployee.fotoProfil == null ||
                                widget.currentEmployee.fotoProfil!.isEmpty))
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => _showPicker(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields...
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _selectedDate != null
                      ? DateFormat('d MMMM yyyy').format(_selectedDate!)
                      : 'Pilih Tanggal',
                  style: TextStyle(
                    color: _selectedDate != null
                        ? Colors.black
                        : Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Jenis Kelamin',
                border: OutlineInputBorder(),
              ),
              items: _genderOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
