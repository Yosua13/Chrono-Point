import 'package:equatable/equatable.dart';

class Departemen extends Equatable {
  final int departemenId;
  final String namaDepartemen;

  const Departemen({required this.departemenId, required this.namaDepartemen});

  factory Departemen.fromMap(Map<String, dynamic> map) {
    return Departemen(
      departemenId: map['departemen_id'] as int,
      namaDepartemen: map['nama_departemen'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'departemen_id': departemenId, 'nama_departemen': namaDepartemen};
  }

  @override
  List<Object> get props => [departemenId, namaDepartemen];
}
