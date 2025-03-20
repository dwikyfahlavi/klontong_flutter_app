import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klontong_flutter_app/core/network/api_service.dart';
import 'package:klontong_flutter_app/core/storage/database.service.dart';
import 'package:klontong_flutter_app/core/utils/app_constants.dart';
import 'package:klontong_flutter_app/data/models/product/product_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([Dio, DatabaseService])
void main() {
  late ApiService apiService;
  late MockDio mockDio;
  late MockDatabaseService mockDbService;

  setUp(() {
    mockDio = MockDio();
    mockDbService = MockDatabaseService();
    apiService = ApiService(mockDio, mockDbService);
  });

  group('ApiService Tests', () {
    test('fetchProducts should return cached products if available', () async {
      final cachedProducts = [
        Product(
          id: '1',
          categoryId: 1,
          categoryName: 'Category 1',
          sku: 'SKU1',
          name: 'Product 1',
          description: 'Description 1',
          weight: 100,
          width: 10,
          length: 20,
          height: 5,
          image: 'image1.png',
          harga: 100,
        ),
        Product(
          id: '2',
          categoryId: 2,
          categoryName: 'Category 2',
          sku: 'SKU2',
          name: 'Product 2',
          description: 'Description 2',
          weight: 200,
          width: 15,
          length: 25,
          height: 10,
          image: 'image2.png',
          harga: 200,
        ),
      ];

      when(mockDbService.getCachedProducts())
          .thenAnswer((_) async => cachedProducts);

      final result = await apiService.fetchProducts();

      expect(result, cachedProducts);
      verify(mockDbService.getCachedProducts()).called(1);
      verifyNever(mockDio.get(any));
    });

    test('fetchProducts should fetch from API if cache is empty', () async {
      final apiResponse = [
        {
          'id': '1',
          'categoryId': 1,
          'categoryName': 'Category 1',
          'sku': 'SKU1',
          'name': 'Product 1',
          'description': 'Description 1',
          'weight': 100,
          'width': 10,
          'length': 20,
          'height': 5,
          'image': 'image1.png',
          'harga': 100,
        },
        {
          'id': '2',
          'categoryId': 2,
          'categoryName': 'Category 2',
          'sku': 'SKU2',
          'name': 'Product 2',
          'description': 'Description 2',
          'weight': 200,
          'width': 15,
          'length': 25,
          'height': 10,
          'image': 'image2.png',
          'harga': 200,
        },
      ];

      when(mockDbService.getCachedProducts()).thenAnswer((_) async => []);
      when(mockDio.get('${AppConstants.baseUrl}/products'))
          .thenAnswer((_) async => Response(
                data: apiResponse,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await apiService.fetchProducts();

      expect(result.length, 2);
      expect(result[0].name, 'Product 1');
      verify(mockDbService.getCachedProducts()).called(1);
      verify(mockDio.get('${AppConstants.baseUrl}/products')).called(1);
    });

    test('getProduct should fetch a single product by ID', () async {
      final productJson = {
        'id': '1',
        'categoryId': 1,
        'categoryName': 'Category 1',
        'sku': 'SKU1',
        'name': 'Product 1',
        'description': 'Description 1',
        'weight': 100,
        'width': 10,
        'length': 20,
        'height': 5,
        'image': 'image1.png',
        'harga': 100,
      };

      when(mockDio.get('${AppConstants.baseUrl}/products/1'))
          .thenAnswer((_) async => Response(
                data: productJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await apiService.getProduct('1');

      expect(result.name, 'Product 1');
      verify(mockDio.get('${AppConstants.baseUrl}/products/1')).called(1);
    });

    test('addProduct should send product data to API and cache it', () async {
      final product = Product(
        categoryId: 1,
        categoryName: 'Category 1',
        sku: 'SKU1',
        name: 'Product 1',
        description: 'Description 1',
        weight: 100,
        width: 10,
        length: 20,
        height: 5,
        image: 'image1.png',
        harga: 100,
      );
      final apiResponse = {
        'CategoryId': 1,
        'categoryName': 'Category 1',
        'sku': 'SKU1',
        'name': 'Product 1',
        'description': 'Description 1',
        'weight': 100,
        'width': 10,
        'length': 20,
        'height': 5,
        'image': 'image1.png',
        'harga': 100,
      };

      when(mockDio.post('${AppConstants.baseUrl}/products',
              data: product.toJson()))
          .thenAnswer((_) async => Response(
                data: apiResponse,
                statusCode: 201,
                requestOptions: RequestOptions(path: ''),
              ));

      await apiService.addProduct(product);

      verify(mockDio.post('${AppConstants.baseUrl}/products',
              data: product.toJson()))
          .called(1);
      verify(mockDbService.insertProducts([product])).called(1);
    });

    test('updateProduct should update product data in API and cache', () async {
      final product = Product(
        id: '1',
        categoryId: 1,
        categoryName: 'Category 1',
        sku: 'SKU1',
        name: 'Updated Product',
        description: 'Updated Description',
        weight: 150,
        width: 12,
        length: 22,
        height: 6,
        image: 'updated_image.png',
        harga: 150,
      );

      when(mockDio.put('${AppConstants.baseUrl}/products/1',
              data: product.toJson()))
          .thenAnswer((_) async => Response(
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      await apiService.updateProduct('1', product);

      verify(mockDio.put('${AppConstants.baseUrl}/products/1',
              data: product.toJson()))
          .called(1);
      verify(mockDbService.updateProduct(product)).called(1);
    });

    test('deleteProduct should remove product from API and cache', () async {
      when(mockDio.delete('${AppConstants.baseUrl}/products/1'))
          .thenAnswer((_) async => Response(
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      await apiService.deleteProduct('1');

      verify(mockDio.delete('${AppConstants.baseUrl}/products/1')).called(1);
      verify(mockDbService.deleteProduct('1')).called(1);
    });
  });
}
