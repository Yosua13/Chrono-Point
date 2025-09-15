import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient _supabaseClient;

  ProfileRepository({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  // Method untuk update data teks karyawan
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final userId = _supabaseClient.auth.currentUser!.id;
      await _supabaseClient
          .from('karyawan')
          .update(data)
          .eq('employee_id', userId);
    } catch (e) {
      throw Exception('Gagal memperbarui profil: $e');
    }
  }

  // Method untuk upload gambar profil
  Future<String> uploadProfilePicture(File imageFile) async {
    try {
      final userId = _supabaseClient.auth.currentUser!.id;
      final fileExtension = imageFile.path.split('.').last;
      final fileName =
          '$userId.${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final filePath = 'photoProfile/$fileName';

      // Upload gambar ke Supabase Storage
      await _supabaseClient.storage
          .from('profiles')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Dapatkan URL publik dari gambar yang di-upload
      final imageUrl = _supabaseClient.storage
          .from('profiles')
          .getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      // Error 403 yang Anda sebutkan biasanya karena RLS Policy di Supabase Storage belum diatur.
      // Pastikan Anda sudah mengikuti langkah-langkah RLS dari jawaban sebelumnya.
      throw Exception('Gagal mengunggah gambar: $e');
    }
  }
}
