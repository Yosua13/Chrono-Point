import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String employeeId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? address;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? position;
  final String? department;
  final DateTime? hireDate;
  final String? employeeStatus;
  final String? profilePictureUrl;

  const Employee({
    required this.employeeId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.position,
    this.department,
    this.hireDate,
    this.employeeStatus,
    this.profilePictureUrl,
  });

  // Convert from Firebase DocumentSnapshot to Employee
  factory Employee.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return Employee(
      employeeId: snap.id,
      fullName: data['fullName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate(),
      gender: data['gender'],
      position: data['position'],
      department: data['department'],
      hireDate: (data['hireDate'] as Timestamp?)?.toDate(),
      employeeStatus: data['employeeStatus'],
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  // Convert from Employee to Map to store in Firebase
  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'position': position,
    'department': department,
    'hireDate': hireDate,
    'employeeStatus': employeeStatus,
    'profilePictureUrl': profilePictureUrl,
  };

  @override
  List<Object?> get props => [
    employeeId,
    fullName,
    email,
    phoneNumber,
    address,
    dateOfBirth,
    gender,
    position,
    department,
    hireDate,
    employeeStatus,
    profilePictureUrl,
  ];
}
