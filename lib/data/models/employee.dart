import 'package:chrono_point/data/models/departemen.dart';
import 'package:chrono_point/data/models/jabatan.dart';
import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String employeeId;
  final String namaLengkap;
  final String email;
  final String? noHp;
  final String? alamat;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final Jabatan? jabatan;
  final Departemen? departemen;
  final DateTime? tanggalMasuk;
  final String? statusKaryawan;
  final String? fotoProfil;

  const Employee({
    required this.employeeId,
    required this.namaLengkap,
    required this.email,
    this.noHp,
    this.alamat,
    this.tanggalLahir,
    this.jenisKelamin,
    this.jabatan,
    this.departemen,
    this.tanggalMasuk,
    this.statusKaryawan,
    this.fotoProfil,
  });

  Map<String, dynamic> toJson() => {
    'nama_lengkap': namaLengkap,
    'email': email,
    'no_hp': noHp,
    'alamat': alamat,
    'tanggal_lahir': tanggalLahir,
    'jenis_kelamin': jenisKelamin,
    'jabatan_id': jabatan,
    'departemen_id': departemen,
    'tanggal_masuk': tanggalMasuk,
    'status_karyawan': statusKaryawan,
    'foto_profil': fotoProfil,
  };

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      employeeId: map['employee_id'] as String,
      namaLengkap: map['nama_lengkap'] as String,
      email: map['email'] as String,
      noHp: map['no_hp'] as String?,
      alamat: map['alamat'] as String?,
      tanggalLahir: map['tanggal_lahir'] != null
          ? DateTime.parse(map['tanggal_lahir'] as String)
          : null,
      jenisKelamin: map['jenis_kelamin'] as String?,
      jabatan: map['jabatan'] != null
          ? Jabatan.fromMap(map['jabatan'] as Map<String, dynamic>)
          : null,
      departemen: map['departemen'] != null
          ? Departemen.fromMap(map['departemen'] as Map<String, dynamic>)
          : null,
      tanggalMasuk: map['tanggal_masuk'] != null
          ? DateTime.parse(map['tanggal_masuk'] as String)
          : null,
      statusKaryawan: map['status_karyawan'] as String?,
      fotoProfil: map['foto_profil'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    employeeId,
    namaLengkap,
    email,
    noHp,
    alamat,
    tanggalLahir,
    jenisKelamin,
    jabatan,
    departemen,
    tanggalMasuk,
    statusKaryawan,
    fotoProfil,
  ];
}
