class ProductVariationModel {
  final String id;
  String sku;
  String image;
  String? description;
  double price;
  double salePrice;
  int stock;
  Map<String, String> attributeValues;

  ProductVariationModel({
    required this.id,
    this.sku = '',
    this.image = '',
    this.description = '',
    this.price = 0.0,
    this.salePrice = 0.0,
    this.stock = 0,
    required this.attributeValues,
  });

  /// Empty Helper Function
  static ProductVariationModel empty() =>
      ProductVariationModel(id: '', attributeValues: {});

  /// Convert model to JSON structure
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Image': image,
      'Description': description,
      'Price': price,
      'SalePrice': salePrice,
      'SKU': sku,
      'Stock': stock,
      'AttributeValues': attributeValues,
    };
  }

  /// Map JSON from Supabase / Firebase to ProductVariationModel
  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductVariationModel.empty();
    return ProductVariationModel(
      id: data['Id'] ?? data['id'] ?? '',
      image: data['Image'] ?? data['image'] ?? '',
      description: data['Description'] ?? data['description'] ?? '',
      price: double.tryParse(data['Price']?.toString() ?? '0.0') ?? 0.0,
      salePrice: double.tryParse(data['SalePrice']?.toString() ?? '0.0') ?? 0.0,
      sku: data['SKU'] ?? data['sku'] ?? '',
      stock: int.tryParse(data['Stock']?.toString() ?? '0') ?? 0,
      attributeValues: Map<String, String>.from(
        data['AttributeValues'] ?? data['attributeValues'] ?? {},
      ),
    );
  }
}
