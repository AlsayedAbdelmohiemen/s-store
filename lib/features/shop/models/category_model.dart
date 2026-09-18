class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId = '',
  });

  /// Empty Helper Function
  static CategoryModel empty() => CategoryModel(
        id: '',
        name: '',
        image: '',
        isFeatured: false,
      );

  /// Convert model to JSON structure
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'Image': image,
      'ParentId': parentId,
      'IsFeatured': isFeatured,
    };
  }

  /// Map JSON from Supabase / Firebase to CategoryModel
  factory CategoryModel.fromJson(Map<String, dynamic> document) {
    return CategoryModel(
      id: (document['id'] ?? document['Id'] ?? '').toString(),
      name: (document['Name'] ?? document['name'] ?? '').toString(),
      image: (document['Image'] ?? document['image'] ?? '').toString(),
      parentId: (document['ParentId'] ?? document['parentId'] ?? '').toString(),
      isFeatured: document['IsFeatured'] == true ||
          document['isFeatured'] == true ||
          document['IsFeatured'] == 1 ||
          document['isFeatured'] == 1,
    );
  }
}
