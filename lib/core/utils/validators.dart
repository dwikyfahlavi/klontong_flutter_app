class Validators {
  /// Checks if the input is not empty
  static String? validateRequired(String? value, {String fieldName = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required.";
    }
    return null;
  }

  /// Validates a product name (min 3, max 50 characters)
  static String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Product name is required.";
    } else if (value.length < 3 || value.length > 50) {
      return "Product name must be between 3 and 50 characters.";
    }
    return null;
  }

  /// Validates a price (must be a positive number)
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Price is required.";
    }
    final num? price = num.tryParse(value);
    if (price == null || price <= 0) {
      return "Price must be a positive number.";
    }
    return null;
  }

  /// Validates SKU (Alphanumeric, length 5-10)
  static String? validateSKU(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "SKU is required.";
    }
    final RegExp skuPattern = RegExp(r'^[a-zA-Z0-9]{5,10}$');
    if (!skuPattern.hasMatch(value)) {
      return "SKU must be 5-10 alphanumeric characters.";
    }
    return null;
  }

  /// Validates dimensions (must be positive numbers)
  static String? validateDimension(String? value,
      {String fieldName = "Dimension"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required.";
    }
    final double? dimension = double.tryParse(value);
    if (dimension == null || dimension <= 0) {
      return "$fieldName must be a positive number.";
    }
    return null;
  }
}
