import 'package:dio/dio.dart';
import 'package:klontong_flutter_app/core/storage/database.service.dart';
import 'package:klontong_flutter_app/core/utils/app_constants.dart';
import 'package:klontong_flutter_app/core/utils/error_handler.dart';
import 'package:klontong_flutter_app/core/utils/logger.dart';
import 'package:klontong_flutter_app/data/models/product/product_model.dart';

class ApiService {
  final Dio _dio;
  final DatabaseService _dbService;

  ApiService(this._dio, this._dbService);

  /// Fetch products from cache first, then API if needed
  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cachedProducts = await _dbService.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          Logger.logMessage("✅ Loaded products from cache");
          return cachedProducts;
        }
      }

      Logger.logMessage("🌐 Fetching products from API...");
      final response = await _dio.get("${AppConstants.baseUrl}/products");
      final products = (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();

      // Cache new data
      await _dbService.clearCache();
      await _dbService.insertProducts(products);
      Logger.logMessage("📝 API response cached successfully");

      return products;
    } catch (e) {
      Logger.logMessage("❌ Error fetching products: $e", level: LogLevel.error);
      throw Exception(ErrorHandler.handleApiError(e));
    }
  }

  /// Fetch single product by ID
  Future<Product> getProduct(String id) async {
    try {
      Logger.logMessage("📌 Fetching product ID: $id");
      final response = await _dio.get("${AppConstants.baseUrl}/products/$id");
      Logger.logMessage("🔍 Product fetched: ${response.data}");
      return Product.fromJson(response.data);
    } catch (e) {
      Logger.logMessage("❌ Error fetching product: $e", level: LogLevel.error);
      throw Exception(ErrorHandler.handleApiError(e));
    }
  }

  /// Add new product to API and cache
  Future<void> addProduct(Product product) async {
    try {
      Logger.logMessage("➕ Adding product: ${product.name}");
      final response = await _dio.post("${AppConstants.baseUrl}/products",
          data: product.toJson());

      await _dbService.insertProducts([Product.fromJson(response.data)]);
      Logger.logMessage("✅ Product added successfully");
    } catch (e) {
      Logger.logMessage("❌ Error adding product: $e", level: LogLevel.error);
      throw Exception(ErrorHandler.handleApiError(e));
    }
  }

  /// Update existing product
  Future<void> updateProduct(String id, Product product) async {
    try {
      Logger.logMessage("🔄 Updating product ID: $id");
      await _dio.put("${AppConstants.baseUrl}/products/$id",
          data: product.toJson());

      await _dbService.updateProduct(product);
      Logger.logMessage("✅ Product updated successfully");
    } catch (e) {
      Logger.logMessage("❌ Error updating product: $e", level: LogLevel.error);
      throw Exception(ErrorHandler.handleApiError(e));
    }
  }

  /// Delete product from API and cache
  Future<void> deleteProduct(String id) async {
    try {
      Logger.logMessage("🗑️ Deleting product ID: $id");
      await _dio.delete("${AppConstants.baseUrl}/products/$id");

      await _dbService.deleteProduct(id);
      Logger.logMessage("✅ Product deleted successfully");
    } catch (e) {
      Logger.logMessage("❌ Error deleting product: $e", level: LogLevel.error);
      throw Exception(ErrorHandler.handleApiError(e));
    }
  }
}
