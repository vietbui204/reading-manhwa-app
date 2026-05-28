import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appmanga/core/network/dio_client.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadCover(XFile file);
  Future<List<String>> uploadPages(List<XFile> files);
  Future<String> uploadAvatar(XFile file);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final DioClient _dioClient;
  UploadRemoteDataSourceImpl(this._dioClient);

  @override
  Future<String> uploadCover(XFile file) async {
    final bytes = await file.readAsBytes();
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: file.name,
      ),
    });
    final response = await _dioClient.dio.post('/upload/cover', data: formData);
    return response.data['data']['url'];
  }

  @override
  Future<List<String>> uploadPages(List<XFile> files) async {
    final formData = FormData();
    for (var file in files) {
      final bytes = await file.readAsBytes();
      formData.files.add(MapEntry(
        'files',
        MultipartFile.fromBytes(
          bytes,
          filename: file.name,
        ),
      ));
    }
    final response = await _dioClient.dio.post('/upload/pages', data: formData);
    return List<String>.from(response.data['data']['urls']);
  }

  @override
  Future<String> uploadAvatar(XFile file) async {
    final bytes = await file.readAsBytes();
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: file.name,
      ),
    });
    final response = await _dioClient.dio.post('/upload/avatar', data: formData);
    return response.data['data']['url'];
  }
}
