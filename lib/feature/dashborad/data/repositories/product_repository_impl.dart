import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/return_failure.dart';
import '../../../../core/network/return_response.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;
    final StorageService storageService;  // Inject StorageService


  ProductRepositoryImpl({required this.apiClient, required this.storageService});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      // Retrieve the token from SessionManager
      String? token = await storageService.getToken();

      if (token == null) {
       // context('/login');
        throw ApiException(error: 'No token found');
      }
        if (kDebugMode) {
          print("Token retrieved: $token");
        }
      final response = await apiClient.dio.get(
        '/products/getProduts',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final products = ReturnResponse<List<ProductModel>>().call(
        response,
        (data) => (data['products'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList(),
      );

      return Right(products);
    } catch (e) {
      return ReturnFailure<List<Product>>().call(Exception(e.toString()));
    }
  }
}
