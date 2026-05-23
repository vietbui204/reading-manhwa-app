import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/network/dio_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getUserProfile(String userId, String currentUserId);
  Future<ProfileModel> updateProfile(String currentUserId, {String? username, String? avatarUrl});
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
  // Thêm mới
  Future<List<Map<String, dynamic>>> getUserMangas(String userId);
  Future<void> deleteManga(String mangaId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ProfileModel> getUserProfile(String userId, String currentUserId) async {
    final response = await _dioClient.dio.get(
      '${ApiConstants.baseUrl}/users/$userId',
    );
    return ProfileModel.fromJson(response.data['data'], currentUserId);
  }

  @override
  Future<ProfileModel> updateProfile(
      String currentUserId, {
        String? username,
        String? avatarUrl,
      }) async {
    final response = await _dioClient.dio.put(
      '${ApiConstants.baseUrl}/users/me',
      data: {
        if (username  != null) 'username'  : username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      },
    );
    return ProfileModel.fromJson(response.data['data'], currentUserId);
  }

  @override
  Future<void> followUser(String userId) async {
    await _dioClient.dio.post(
      '${ApiConstants.baseUrl}/users/$userId/follow',
    );
  }

  @override
  Future<void> unfollowUser(String userId) async {
    await _dioClient.dio.delete(
      '${ApiConstants.baseUrl}/users/$userId/follow',
    );
  }

  // ── Thêm mới ──────────────────────────────────────
  @override
  Future<List<Map<String, dynamic>>> getUserMangas(String userId) async {
    final response = await _dioClient.dio.get(
      '${ApiConstants.baseUrl}/users/$userId/manga',
    );
    return List<Map<String, dynamic>>.from(
      response.data['data'] ?? [],
    );
  }

  @override
  Future<void> deleteManga(String mangaId) async {
    await _dioClient.dio.delete(
      '${ApiConstants.baseUrl}/manga/$mangaId',
    );
  }
}