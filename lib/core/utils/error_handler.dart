import 'package:dio/dio.dart';

class ErrorHandler {
  static String handleApiError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is FormatException) {
      return "Invalid response format.";
    } else {
      return "An unexpected error occurred.";
    }
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please try again.";
      case DioExceptionType.sendTimeout:
        return "Request timeout. Please try again.";
      case DioExceptionType.receiveTimeout:
        return "Server response timeout.";
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      case DioExceptionType.unknown:
      default:
        return "Something went wrong. Please check your internet connection.";
    }
  }

  static String _handleBadResponse(Response<dynamic>? response) {
    if (response == null) {
      return "No response from the server.";
    }

    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    if (statusCode >= 400 && statusCode < 500) {
      return responseData?['message'] ?? "Client error occurred.";
    } else if (statusCode >= 500) {
      return "Server error. Please try again later.";
    } else {
      return "Unexpected response from server.";
    }
  }
}
