import 'package:dio/dio.dart';
import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/network/dio_client.dart';
import 'package:appmanga/features/auth/data/models/auth_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login(String email, String password);
  Future<AuthTokenModel> register({
    required String email,
    required String password,
    required String username,
    String? avatarUrl,
  });
  Future<AuthTokenModel> loginWithGoogle(String idToken);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthTokenModel> login(String email, String password) async {
    final response = await _dioClient.dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return AuthTokenModel.fromJson(response.data['data']);
  }

  @override
  Future<AuthTokenModel> register({
    required String email,
    required String password,
    required String username,
    String? avatarUrl,
  }) async {
    final response = await _dioClient.dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'username': username,
        'avatar_url': avatarUrl,
      },
    );
    return AuthTokenModel.fromJson(response.data['data']);
  }

  @override
  Future<AuthTokenModel> loginWithGoogle(String idToken) async {
    final response = await _dioClient.dio.post(
      ApiConstants.loginGoogle,
      data: {'id_token': idToken},
    );
    return AuthTokenModel.fromJson(response.data['data']);
  }

  @override
  Future<void> logout() async {
    await _dioClient.dio.post(ApiConstants.logout);
  }
}
