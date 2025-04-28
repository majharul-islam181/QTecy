import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.currentPrice,
    required super.offerPrice,
    required super.offerPercentage,
    required super.rating,
    required super.numberOfRatings,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
      offerPercentage: (json['offerPercentage'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      numberOfRatings: json['numberOfRatings'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}
