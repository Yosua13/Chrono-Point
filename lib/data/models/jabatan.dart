import 'package:equatable/equatable.dart';

class Jabatan extends Equatable {
  final int jabatanId;
  final String namaJabatan;

  const Jabatan({required this.jabatanId, required this.namaJabatan});

  factory Jabatan.fromMap(Map<String, dynamic> map) {
    return Jabatan(
      jabatanId: map['jabatan_id'] as int,
      namaJabatan: map['nama_jabatan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'jabatan_id': jabatanId, 'nama_jabatan': namaJabatan};
  }

  @override
  List<Object> get props => [jabatanId, namaJabatan];
}
