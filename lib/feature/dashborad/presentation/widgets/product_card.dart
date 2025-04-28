import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          _buildDetailsSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            product.image,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              height: 150,
              child: const Icon(Icons.broken_image, size: 50),
            ),
          ),
        ),
        if (product.offerPrice == 0) _buildOutOfStockBadge(),
      ],
    );
  }

  Widget _buildOutOfStockBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: const Text(
          'Out Of Stock',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          _buildPriceSection(),
          if (product.offerPrice < product.currentPrice) _buildDiscount(),
          _buildRating(),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Text(
          "\$${product.currentPrice.toStringAsFixed(0)}", // New price
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 6),
        Text(
          "\$${product.offerPrice.toStringAsFixed(0)}", // Old price
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        "${_calculateDiscount(product.offerPrice, product.currentPrice)}% OFF",
        style: const TextStyle(fontSize: 12, color: Colors.red),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.orange, size: 16),
        const SizedBox(width: 4),
        Text(
          product.rating.toStringAsFixed(1), // Rating
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 4),
        Text(
          "(${product.numberOfRatings})", // Number of ratings
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  int _calculateDiscount(double offerPrice, double currentPrice) {
    if (currentPrice == 0) return 0;
    final discount = ((1 - (offerPrice / currentPrice)) * 100).round();
    return discount;
  }
}
