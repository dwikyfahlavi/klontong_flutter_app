class Product {
  String? id;
  int? categoryId;
  String? categoryName;
  String? sku;
  String? name;
  String? description;
  int? weight;
  int? width;
  int? length;
  int? height;
  String? image;
  int? harga;

  Product({
    this.id,
    required this.categoryId,
    required this.categoryName,
    required this.sku,
    required this.name,
    required this.description,
    required this.weight,
    required this.width,
    required this.length,
    required this.height,
    required this.image,
    required this.harga,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    categoryId = json['CategoryId'];
    categoryName = json['categoryName'];
    sku = json['sku'];
    name = json['name'];
    description = json['description'];
    weight = json['weight'];
    width = json['width'];
    length = json['length'];
    height = json['height'];
    image = json['image'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    data['CategoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['sku'] = sku;
    data['name'] = name;
    data['description'] = description;
    data['weight'] = weight;
    data['width'] = width;
    data['length'] = length;
    data['height'] = height;
    data['image'] = image;
    data['harga'] = harga;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.sku == sku &&
        other.name == name &&
        other.description == description &&
        other.weight == weight &&
        other.width == width &&
        other.length == length &&
        other.height == height &&
        other.image == image &&
        other.harga == harga;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        categoryId.hashCode ^
        categoryName.hashCode ^
        sku.hashCode ^
        name.hashCode ^
        description.hashCode ^
        weight.hashCode ^
        width.hashCode ^
        length.hashCode ^
        height.hashCode ^
        image.hashCode ^
        harga.hashCode;
  }
}
