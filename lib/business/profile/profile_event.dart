part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

class ProfileUpdateRequested extends ProfileEvent {
  final Map<String, dynamic> updatedData;
  final File? imageFile;

  const ProfileUpdateRequested({required this.updatedData, this.imageFile});

  @override
  List<Object> get props => [updatedData];
}
