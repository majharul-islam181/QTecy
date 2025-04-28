class Product {
  final String id;
  final String name;
  final double currentPrice;
  final double offerPrice;
  final double offerPercentage;
  final double rating;
  final int numberOfRatings;
  final String image;

  const Product({
    required this.id,
    required this.name,
    required this.currentPrice,
    required this.offerPrice,
    required this.offerPercentage,
    required this.rating,
    required this.numberOfRatings,
    required this.image,
  });
}
