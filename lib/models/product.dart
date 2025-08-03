import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<String> additionalImages;
  final bool inStock;
  final int stockQuantity;
  final String unit; // kg, piece, liter, etc.
  final double? discount;
  final List<String> tags;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.additionalImages = const [],
    this.inStock = true,
    this.stockQuantity = 0,
    this.unit = 'piece',
    this.discount,
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  double get discountedPrice {
    if (discount != null && discount! > 0) {
      return price * (1 - discount! / 100);
    }
    return price;
  }

  bool get hasDiscount => discount != null && discount! > 0;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    List<String>? additionalImages,
    bool? inStock,
    int? stockQuantity,
    String? unit,
    double? discount,
    List<String>? tags,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      inStock: inStock ?? this.inStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      discount: discount ?? this.discount,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}