class FoodItem {
  final String name, category, desc, image;
  final int price;
  const FoodItem(this.name, this.category, this.desc, this.image, this.price);
}

final List<FoodItem> menuItems = [
  FoodItem('Nasi Pecel Spesial', 'Makanan', 'Sayur segar, bumbu kacang, rempeyek gurih', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?fm=webp&fit=crop&w=700&q=70', 18000),
  FoodItem('Ayam Goreng Kremes', 'Makanan', 'Ayam empuk dengan kremesan renyah', 'https://images.unsplash.com/photo-1544025162-d76694265947?fm=webp&fit=crop&w=700&q=70', 25000),
  FoodItem('Sate Ayam Madura', 'Makanan', 'Sate ayam bakar dengan bumbu kacang khas', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?fm=webp&fit=crop&w=700&q=70', 28000),
  FoodItem('Bakso Urat Jumbo', 'Makanan', 'Kuah kaldu sapi asli dengan bakso urat', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?fm=webp&fit=crop&w=700&q=70', 22000),
  FoodItem('Kerupuk Udang', 'Snack', 'Renyah dan gurih sebagai teman makan', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?fm=webp&fit=crop&w=700&q=70', 5000),
  FoodItem('Kentang Goreng', 'Snack', 'Kentang goreng hangat dengan saus sambal', 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?fm=webp&fit=crop&w=700&q=70', 15000),
  FoodItem('Es Teh Manis', 'Minuman', 'Teh melati dingin segar', 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?fm=webp&fit=crop&w=700&q=70', 5000),
  FoodItem('Es Jeruk Peras', 'Minuman', 'Jeruk peras asli segar vitamin C', 'https://images.unsplash.com/photo-1613478223719-2ab802602423?fm=webp&fit=crop&w=700&q=70', 8000),
];
