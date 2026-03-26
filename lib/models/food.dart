class Food {
  final String name;
  final int price;
  final String image;

  Food({
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Food && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
