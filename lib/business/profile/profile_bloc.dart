import 'dart:io';
import 'package:chrono_point/data/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(ProfileInitial()) {
    on<ProfileUpdateRequested>((event, emit) async {
      emit(ProfileUpdateInProgress());
      try {
        Map<String, dynamic> dataToUpdate = Map.from(event.updatedData);

        // Jika ada file gambar baru, upload dulu
        if (event.imageFile != null) {
          final imageUrl = await _profileRepository.uploadProfilePicture(
            event.imageFile!,
          );
          // Tambahkan URL gambar baru ke data yang akan di-update
          dataToUpdate['foto_profil'] = imageUrl;
        }

        // Update data di tabel karyawan
        await _profileRepository.updateProfile(dataToUpdate);

        emit(ProfileUpdateSuccess());
      } catch (e) {
        emit(ProfileUpdateFailure(e.toString()));
      }
    });
  }
}
