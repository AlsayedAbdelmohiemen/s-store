import 'brand_model.dart';
import 'product_attribute_model.dart';
import 'product_variation_model.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  String? description;
  String? categoryId;
  List<String>? images;
  String productType;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice = 0.0,
    this.isFeatured,
    this.categoryId,
    this.description,
    this.productAttributes,
    this.productVariations,
  });

  /// Empty Helper Function
  static ProductModel empty() => ProductModel(
        id: '',
        title: '',
        stock: 0,
        price: 0,
        thumbnail: '',
        productType: '',
      );

  /// Convert model to JSON structure
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Date': date?.toIso8601String(),
      'Brand': brand?.toJson(),
      'Description': description,
      'ProductType': productType,
      'ProductAttributes': productAttributes != null
          ? productAttributes!.map((e) => e.toJson()).toList()
          : [],
      'ProductVariations': productVariations != null
          ? productVariations!.map((e) => e.toJson()).toList()
          : [],
    };
  }

  /// Map JSON from Supabase / Firebase to ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductModel.empty();
    return ProductModel(
      id: (data['id'] ?? data['Id'] ?? '').toString(),
      sku: data['SKU'] ?? data['sku'],
      title: data['Title'] ?? data['title'] ?? '',
      stock: int.tryParse(data['Stock']?.toString() ?? '0') ?? 0,
      isFeatured: data['IsFeatured'] ?? data['isFeatured'] ?? false,
      price: double.tryParse(data['Price']?.toString() ?? '0.0') ?? 0.0,
      salePrice: double.tryParse(data['SalePrice']?.toString() ?? '0.0') ?? 0.0,
      thumbnail: data['Thumbnail'] ?? data['thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? data['categoryId'] ?? '',
      description: data['Description'] ?? data['description'] ?? '',
      productType: data['ProductType'] ?? data['productType'] ?? '',
      date: data['Date'] != null ? DateTime.tryParse(data['Date'].toString()) : null,
      brand: data['Brand'] != null
          ? BrandModel.fromJson(Map<String, dynamic>.from(data['Brand']))
          : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productAttributes: (data['ProductAttributes'] as List<dynamic>?)
          ?.map((e) => ProductAttributeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      productVariations: (data['ProductVariations'] as List<dynamic>?)
          ?.map((e) => ProductVariationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
