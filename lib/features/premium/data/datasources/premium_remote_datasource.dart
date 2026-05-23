import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/network/dio_client.dart';

abstract class PremiumRemoteDataSource {
  Future<Map<String, dynamic>> getPremiumStatus();
  Future<List<Map<String, dynamic>>> getPremiumPlans();
}

class PremiumRemoteDataSourceImpl implements PremiumRemoteDataSource {
  final DioClient _dioClient;

  PremiumRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> getPremiumStatus() async {
    final response = await _dioClient.dio.get(ApiConstants.premiumStatus);
    return response.data['data'];
  }

  @override
  Future<List<Map<String, dynamic>>> getPremiumPlans() async {
    final response = await _dioClient.dio.get(ApiConstants.premiumPlans);
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
}
