import 'package:divipay/provider/storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


class PruebaSupabase extends ConsumerWidget {
  const PruebaSupabase({super.key});

  Future<void> _pickAndUploadImage(WidgetRef ref, BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final bytes = await picked.readAsBytes();

      // Llamamos al método del servicio
      final storageService = ref.read(storageServiceProvider);
      final url = await storageService.uploadProfilePicture(bytes);

      // Mostramos feedback al usuario
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Imagen subida correctamente\n$url'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al subir imagen: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba Supabase Storage')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _pickAndUploadImage(ref, context),
          icon: const Icon(Icons.cloud_upload_outlined),
          label: const Text('Subir imagen'),
        ),
      ),
    );
  }
}

