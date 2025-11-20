import 'package:flutter/material.dart';
import 'cart_controller.dart';
import 'cart_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resto Catalog - UTS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const RestoHomePage(),
    );
  }
}

class RestoHomePage extends StatefulWidget {
  const RestoHomePage({super.key});

  @override
  State<RestoHomePage> createState() => _RestoHomePageState();
}

class _RestoHomePageState extends State<RestoHomePage>
    with SingleTickerProviderStateMixin {
  final List<String> categories = const [
    'All',
    'Burger',
    'Pizza',
    'Sushi',
    'Ramen',
    'Dessert',
    'Drinks',
  ];

  final List<Map<String, dynamic>> items = const [
    {
      'id': 1,
      'name': 'Classic Burger',
      'category': 'Burger',
      'price': 25000,
      'image': 'assets/Classic Burger.jpg'
    },
    {
      'id': 2,
      'name': 'Double Cheese Burger',
      'category': 'Burger',
      'price': 35000,
      'image': 'assets/Double Cheese Burger.jpg'
    },
    {
      'id': 3,
      'name': 'Spicy Hotdog Burger',
      'category': 'Burger',
      'price': 28000,
      'image': 'assets/Spicy Hotdog Burger.jpg'
    },
    {
      'id': 4,
      'name': 'Margherita Pizza',
      'category': 'Pizza',
      'price': 55000,
      'image': 'assets/Margherita Pizza.jpg'
    },
    {
      'id': 5,
      'name': 'Pepperoni Slice',
      'category': 'Pizza',
      'price': 60000,
      'image': 'assets/Pepperoni Slice.jpg'
    },
    {
      'id': 6,
      'name': 'Salmon Sushi',
      'category': 'Sushi',
      'price': 70000,
      'image': 'assets/Salmon Sushi.jpg'
    },
    {
      'id': 7,
      'name': 'Sushi Platter',
      'category': 'Sushi',
      'price': 85000,
      'image': 'assets/Sushi Platter.jpg'
    },
    {
      'id': 8,
      'name': 'Ramen Spicy',
      'category': 'Ramen',
      'price': 42000,
      'image': 'assets/Ramen Spicy.jpg'
    },
    {
      'id': 9,
      'name': 'Chicken Ramen',
      'category': 'Ramen',
      'price': 40000,
      'image': 'assets/Chicken Ramen.jpg'
    },
    {
      'id': 10,
      'name': 'Chocolate Cake',
      'category': 'Dessert',
      'price': 30000,
      'image': 'assets/Chocolate Cake.jpg'
    },
    {
      'id': 11,
      'name': 'Ice Cream Bowl',
      'category': 'Dessert',
      'price': 18000,
      'image': 'assets/Ice Cream Bowl.jpg'
    },
    {
      'id': 12,
      'name': 'Fresh Lemonade',
      'category': 'Drinks',
      'price': 12000,
      'image': 'assets/Fresh Lemonade.jpg'
    },
    {
      'id': 13,
      'name': 'Iced Coffee',
      'category': 'Drinks',
      'price': 15000,
      'image': 'assets/Iced Coffee.jpg'
    },
    {
      'id': 14,
      'name': 'Fruit Smoothie',
      'category': 'Drinks',
      'price': 20000,
      'image': 'assets/Fruit Smoothie.jpg'
    },
  ];

  String selectedCategory = 'All';
  String query = '';
  final Set<int> favorites = {};
  final CartController cartController = CartController();
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredItems {
    final List<Map<String, dynamic>> base = items.where((it) {
      if (selectedCategory == 'All') {
        return true;
      } else {
        return it['category'] == selectedCategory;
      }
    }).toList();
    if (query.trim().isEmpty) {
      return base;
    }
    return base
        .where((it) =>
            it['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void toggleFavorite(int id) {
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
    });
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          const Expanded(
            child: Text('Welcome to Hilda Resto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CartPage(cartController: cartController))),
            child: const Text('Order Now'),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryChips() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = cat == selectedCategory;
          return ChoiceChip(
            label: Text(cat),
            selected: selected,
            onSelected: (_) {
              setState(() {
                selectedCategory = cat;
              });
            },
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerLowest,
            labelStyle: TextStyle(
                color: selected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: TextField(
        onChanged: (v) {
          setState(() {
            query = v;
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          prefixIcon: const Icon(Icons.search),
          hintText: 'Cari makanan, contoh: burger, ramen...',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget buildGrid() {
    final list = filteredItems;
    return FadeTransition(
      opacity: _fadeController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GridView.builder(
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final it = list[index];
            final isFav = favorites.contains(it['id']);
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 4,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => showDetail(it),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(it['image'], fit: BoxFit.cover),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withAlpha(220),
                                  borderRadius: BorderRadius.circular(8)),
                              child: IconButton(
                                icon: Icon(isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border),
                                color: isFav ? Colors.red : Colors.grey[800],
                                onPressed: () {
                                  toggleFavorite(it['id']);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(it['name'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text('Rp ${it['price']}',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showDetail(Map<String, dynamic> it) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(it['image'],
                    height: 240, width: double.infinity, fit: BoxFit.cover),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(it['name'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Harga: Rp ${it['price']}'),
                    const SizedBox(height: 12),
                    const Text(
                        'Deskripsi: Makanan lezat dan cocok untuk UTS demo.'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: () {
                              cartController.addToCart(it);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Ditambahkan ke keranjang')));
                            },
                            child: const Text('Tambah Keranjang'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildReviews() {
    return const Column(
      children: [
        SizedBox(height: 12),
        Text('Review Pelanggan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Andi'),
            subtitle: Text('Burger nya mantap, rasanya juara!'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Siti'),
            subtitle: Text('Ramen nya pedas pas, recommended banget.'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Budi'),
            subtitle: Text('Pizza slice nya enak, porsinya pas.'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Katalog Makanan - UTS'),
          centerTitle: true,
          elevation: 1),
      body: Column(
        children: [
          buildHeader(),
          buildCategoryChips(),
          buildSearchBar(),
          Expanded(
            child: isWide
                ? Row(
                    children: [
                      Expanded(flex: 2, child: buildGrid()),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: const Icon(Icons.star),
                                  title: const Text('Favorite Count'),
                                  trailing: Text('${favorites.length}'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: const ListTile(
                                  leading: Icon(Icons.info_outline),
                                  title: Text('Info UTS'),
                                  subtitle: Text(
                                      'Satu halaman, GridView, Custom widget, Animasi'),
                                ),
                              ),
                              buildReviews(), // <--- Ditambahkan di bawah info UTS
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : buildGrid(),
          ),
        ],
      ),
    );
  }
}
