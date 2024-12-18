class Product {
  final int userId;
  final String name;
  // Uncomment the below fields as needed
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
      userId: json['userId'] ?? 0, // Provide a default value if null
      name: json['name'] ?? 'Unknown', // Default for missing name
      // price: (json['price'] ?? 0).toDouble(),
      // description: json['description'] ?? 'No description available',
      // category: json['category'] ?? 'General',
      // image: json['image'] ?? '',
      // rating: (json['rating']?['rate'] ?? 0).toDouble(),
    );
  }
}
