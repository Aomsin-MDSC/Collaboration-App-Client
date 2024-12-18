
class Product {
  final int userId;
  final String name;
  // final double price;
  // final String description;
  // final String category;
  // final String image;
  // final double rating;

  Product({
    required this.userId,
    required this.name,
    // required this.price,
    // required this.description,
    // required this.category,
    // required this.image,
    // required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      userId: json['userId'],
      name: json['name'],
      // price: json['price'].toDouble(),
      // description: json['description'],
      // category: json['category'],
      // image: json['image'],
      // rating: json['rating']['rate'].toDouble(),
    );
  }
}

