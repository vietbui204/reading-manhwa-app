import 'dart:io';
import 'package:dio/dio.dart';
import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/network/dio_client.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadCover(File file);
  Future<List<String>> uploadPages(List<File> files);
  Future<String> uploadAvatar(File file);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final DioClient _dioClient;
  UploadRemoteDataSourceImpl(this._dioClient);

  @override
  Future<String> uploadCover(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await _dioClient.dio.post('/upload/cover', data: formData);
    return response.data['data']['url'];
  }

  @override
  Future<List<String>> uploadPages(List<File> files) async {
    final formData = FormData();
    for (var file in files) {
      formData.files.add(MapEntry(
        'files', // Key phải khớp với uploadMultiple ở Backend
        await MultipartFile.fromFile(file.path),
      ));
    }
    final response = await _dioClient.dio.post('/upload/pages', data: formData);
    return List<String>.from(response.data['data']['urls']);
  }

  @override
  Future<String> uploadAvatar(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await _dioClient.dio.post('/upload/avatar', data: formData);
    return response.data['data']['url'];
  }
}
