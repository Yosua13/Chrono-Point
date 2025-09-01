import 'package:flutter/material.dart';

// Class ini akan menjadi kumpulan dialog yang bisa digunakan di seluruh aplikasi.
class AppDialogs {
  static void showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3), // Durasi dialog tampil
    VoidCallback? onDismissed, // Aksi setelah dialog ditutup
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // Pengguna tidak bisa menutup dialog ini
      builder: (BuildContext dialogContext) {
        // Timer untuk menutup dialog secara otomatis
        Future.delayed(duration, () {
          Navigator.of(dialogContext).pop(); // Tutup dialog
          onDismissed?.call(); // Jalankan aksi setelah ditutup
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          icon: Icon(
            Icons.check_circle_outline_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          // TIDAK ADA TOMBOL AKSI
        );
      },
    );
  }

  // Method static agar bisa dipanggil langsung: AppDialogs.showSuccessDialog(...)
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Lanjutkan',
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Pengguna harus menekan tombol untuk menutup
      builder: (BuildContext context) {
        return AlertDialog(
          // M3-STYLE: Bentuk dialog yang lebih membulat
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),

          // M3-STYLE: Ikon besar di atas judul
          icon: Icon(
            Icons.check_circle_outline_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),

          // M3-STYLE: Tipografi yang sesuai
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            // M3-STYLE: Gunakan FilledButton untuk aksi utama yang positif
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: Text(confirmText, style: const TextStyle(fontSize: 16)),
              onPressed: () {
                // Tutup dialog terlebih dahulu
                Navigator.of(context).pop();
                // Jalankan callback jika ada (misalnya untuk navigasi)
                onDismiss?.call();
              },
            ),
          ],
        );
      },
    );
  }
}
