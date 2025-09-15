import 'package:chrono_point/data/models/employee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepository({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  // Mendapatkan stream status autentikasi pengguna
  Stream<User?> get user => _supabaseClient.auth.onAuthStateChange.map((data) {
    return data.session?.user;
  });

  // Fungsi untuk Sign Up
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fungsi untuk Sign In
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  // Fungsi untuk Sign Out
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  Stream<Employee> getEmployeeStream(String employeeId) {
    // 1. Buat stream yang hanya MENDENGARKAN perubahan pada baris data karyawan tertentu.
    // Urutan ini benar: .from().stream().eq()
    final realTimeStream = _supabaseClient
        .from('karyawan')
        .stream(primaryKey: ['employee_id'])
        .eq('employee_id', employeeId);

    // 2. Gunakan 'asyncMap' untuk mengubah stream.
    // Setiap kali 'realTimeStream' mendeteksi perubahan dan mengirim data mentah...
    return realTimeStream.asyncMap((listOfMaps) async {
      if (listOfMaps.isEmpty) {
        // Ini bisa terjadi jika pengguna dihapus.
        throw Exception("Data karyawan tidak ditemukan untuk ID: $employeeId");
      }

      // 3. ...Kita lakukan FETCH data yang LENGKAP dengan relasinya.
      // Ini adalah query satu kali (Future), bukan stream.
      final fullData = await _supabaseClient
          .from('karyawan')
          .select('*, departemen(*), jabatan(*)')
          .eq('employee_id', employeeId)
          .single(); // .single() lebih efisien karena kita tahu hanya ada 1 hasil

      // 4. Konversi data lengkap tersebut menjadi objek Employee dan kirimkan ke UI.
      return Employee.fromMap(fullData);
    });
  }
}
