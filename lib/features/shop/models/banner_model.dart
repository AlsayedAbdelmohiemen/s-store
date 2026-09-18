class BannerModel {
  String id;
  String imageUrl;
  final String targetScreen;
  final bool active;

  BannerModel({
    this.id = '',
    required this.imageUrl,
    required this.targetScreen,
    required this.active,
  });

  /// Map model to JSON format for Supabase / Firebase
  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'ImageUrl': imageUrl,
      'TargetScreen': targetScreen,
      'Active': active,
    };
  }

  /// Factory constructor to create BannerModel from JSON
  factory BannerModel.fromJson(Map<String, dynamic> data) {
    return BannerModel(
      id: data['id']?.toString() ?? '',
      imageUrl: data['ImageUrl'] ?? data['imageUrl'] ?? '',
      targetScreen: data['TargetScreen'] ?? data['targetScreen'] ?? '',
      active: data['Active'] ?? data['active'] ?? false,
    );
  }
}
