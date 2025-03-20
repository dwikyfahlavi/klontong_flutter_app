import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/core/utils/error_handler.dart';
import 'package:klontong_flutter_app/core/utils/logger.dart';
import 'package:klontong_flutter_app/data/models/product/product_model.dart';

import '../../../core/network/api_service.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ApiService apiService;

  ProductCubit(this.apiService) : super(ProductInitial());

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    Logger.logMessage("Fetching products...");
    emit(ProductLoading());
    try {
      final products =
          await apiService.fetchProducts(forceRefresh: forceRefresh);
      Logger.logMessage("Fetched ${products.length} products successfully.");
      emit(ProductLoaded(products));
    } catch (e) {
      final errorMessage = ErrorHandler.handleApiError(e);
      Logger.logMessage("Error fetching products: $errorMessage",
          level: LogLevel.error);
      emit(ProductError(errorMessage));
    }
  }

  Future<void> addProduct(Product product) async {
    Logger.logMessage("Adding product: ${product.name}");
    emit(ProductLoading());
    try {
      await apiService.addProduct(product);
      Logger.logMessage("Product added successfully: ${product.name}");
      fetchProducts(forceRefresh: true);
    } catch (e) {
      final errorMessage = ErrorHandler.handleApiError(e);
      Logger.logMessage("Error adding product: $errorMessage",
          level: LogLevel.error);
      emit(ProductError(errorMessage));
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    Logger.logMessage("Updating product ID: $id - ${product.name}");
    emit(ProductLoading());
    try {
      await apiService.updateProduct(id, product);
      Logger.logMessage("Product updated successfully: ${product.name}");
      fetchProducts(forceRefresh: true);
    } catch (e) {
      final errorMessage = ErrorHandler.handleApiError(e);
      Logger.logMessage("Error updating product: $errorMessage",
          level: LogLevel.error);
      emit(ProductError(errorMessage));
    }
  }

  Future<void> deleteProduct(String id) async {
    Logger.logMessage("Deleting product ID: $id");
    emit(ProductLoading());
    try {
      await apiService.deleteProduct(id);
      Logger.logMessage("Product deleted successfully: ID $id");
      fetchProducts(forceRefresh: true);
    } catch (e) {
      final errorMessage = ErrorHandler.handleApiError(e);
      Logger.logMessage("Error deleting product: $errorMessage",
          level: LogLevel.error);
      emit(ProductError(errorMessage));
    }
  }
}
