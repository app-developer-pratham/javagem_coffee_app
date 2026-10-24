enum CoffeeSize { s, m, l }

class CoffeeItem {
  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final List<CoffeeSize> availableSizes;
  final List<String> iconBadges;
  final bool isFavorite;

  const CoffeeItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.availableSizes = const [CoffeeSize.s, CoffeeSize.m, CoffeeSize.l],
    this.iconBadges = const [],
    this.isFavorite = false,
  });

  CoffeeItem copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? imageUrl,
    double? price,
    double? rating,
    int? reviewCount,
    String? description,
    List<CoffeeSize>? availableSizes,
    List<String>? iconBadges,
    bool? isFavorite,
  }) {
    return CoffeeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      availableSizes: availableSizes ?? this.availableSizes,
      iconBadges: iconBadges ?? this.iconBadges,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final List<CoffeeItem> dummyCoffeeList = [
  const CoffeeItem(
    id: 'coffee_1',
    name: 'Caffe Mocha',
    subtitle: 'Deep Foam',
    imageUrl: 'assets/images/caffe_mocha.png',
    price: 4.53,
    rating: 4.8,
    reviewCount: 230,
    description: 'A cappuccino is an approximately 150 ml (5 oz) beverage, with 25 ml of espresso coffee and 85ml of fresh milk the fo..',
    availableSizes: [CoffeeSize.s, CoffeeSize.m, CoffeeSize.l],
    iconBadges: ['delivery', 'coffee_bean', 'milk'],
    isFavorite: false,
  ),
  const CoffeeItem(
    id: 'coffee_2',
    name: 'Flat White',
    subtitle: 'Espresso',
    imageUrl: 'assets/images/flat_white.png',
    price: 3.53,
    rating: 4.8,
    reviewCount: 195,
    description: 'A flat white is an espresso-based drink that contains a blend of microfoam poured over a single or double shot of espresso.',
    availableSizes: [CoffeeSize.s, CoffeeSize.m, CoffeeSize.l],
    iconBadges: ['delivery', 'coffee_bean', 'milk'],
    isFavorite: true,
  ),
  const CoffeeItem(
    id: 'coffee_3',
    name: 'Mocha Fusi',
    subtitle: 'Ice/Hot',
    imageUrl: 'assets/images/mocha_fusi.png',
    price: 7.53,
    rating: 4.8,
    reviewCount: 310,
    description: 'A rich fusion of chocolate and espresso crafted with velvety steamed milk, served perfectly hot or iced over fresh cubes.',
    availableSizes: [CoffeeSize.s, CoffeeSize.m, CoffeeSize.l],
    iconBadges: ['delivery', 'coffee_bean', 'milk'],
    isFavorite: false,
  ),
  const CoffeeItem(
    id: 'coffee_4',
    name: 'Caffe Panna',
    subtitle: 'Ice/Hot',
    imageUrl: 'assets/images/caffe_panna.png',
    price: 5.53,
    rating: 4.8,
    reviewCount: 160,
    description: 'Espresso con panna, meaning espresso with cream in Italian, is a single or double shot of espresso topped with whipped cream.',
    availableSizes: [CoffeeSize.s, CoffeeSize.m, CoffeeSize.l],
    iconBadges: ['delivery', 'coffee_bean', 'milk'],
    isFavorite: false,
  ),
];
