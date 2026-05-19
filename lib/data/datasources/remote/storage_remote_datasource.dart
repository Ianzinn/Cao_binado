import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../shared/statics/endpoints.dart';

class StorageRemoteDatasource {
  Future<String> uploadPetImage(
      File file, String petId, String fileName) async {
    return _upload(file, 'caobinado/pets/$petId', fileName);
  }

  Future<void> deletePetImage(String imageUrl) async {
    // Deleção no Cloudinary free requer API assinada (backend).
  }

  Future<String> uploadProfileImage(File file, String userId) async {
    return _upload(file, 'caobinado/profiles/$userId', 'profile.jpg');
  }

  Future<String> _upload(File file, String folder, String fileName) async {
    debugPrint(
        '☁️  Cloudinary upload start: folder=$folder file=$fileName size=${await file.length()}b');
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${Endpoints.cloudinaryCloudName}/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = Endpoints.cloudinaryUploadPreset
      ..fields['folder'] = folder
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
      ));

    final streamedResponse = await request.send();
    final body = await streamedResponse.stream.bytesToString();
    debugPrint(
        '☁️  Cloudinary response status=${streamedResponse.statusCode} body=$body');
    final json = jsonDecode(body) as Map<String, dynamic>;

    if (streamedResponse.statusCode != 200) {
      final error = json['error']?['message'] ?? 'Upload falhou';
      throw Exception('Cloudinary: $error');
    }

    final url = json['secure_url'] as String;
    debugPrint('☁️  Cloudinary upload OK → $url');
    return url;
  }
}
