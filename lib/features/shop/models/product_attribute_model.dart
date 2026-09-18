class ProductAttributeModel {
  String? name;
  final List<String>? values;

  ProductAttributeModel({this.name, this.values});

  /// Convert model to JSON structure
  Map<String, dynamic> toJson() {
    return {'Name': name, 'Values': values};
  }

  /// Map JSON from Supabase / Firebase to ProductAttributeModel
  factory ProductAttributeModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductAttributeModel();
    return ProductAttributeModel(
      name: data.containsKey('Name') ? data['Name'] : data['name'] ?? '',
      values: data.containsKey('Values')
          ? List<String>.from(data['Values'])
          : data.containsKey('values')
              ? List<String>.from(data['values'])
              : [],
    );
  }
}
