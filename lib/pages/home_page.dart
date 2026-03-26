import 'package:flutter/material.dart';
import '../models/food.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<Food, int> cart = {};
  String selectedLocation = "Pilih Lokasi";

  final List<Food> foodList = [
    Food(
      name: "Geprek Sambal Ijo",
      price: 15000,
      image: "assets/images/sambelijo.png",
    ),
    Food(
      name: "Geprek Sambal Merah",
      price: 17000,
      image: "assets/images/sambelmerah.png",
    ),
    Food(
      name: "Geprek Sambal Matah",
      price: 18000,
      image: "assets/images/sambelmatah.png",
    ),
    Food(
      name: "Es Teh Manis",
      price: 5000,
      image: "assets/images/estehmanis.png",
    ),
  ];

  void add(Food food) {
    setState(() {
      cart[food] = (cart[food] ?? 0) + 1;
    });
  }

  void remove(Food food) {
    setState(() {
      if (!cart.containsKey(food)) return;

      if (cart[food]! > 1) {
        cart[food] = cart[food]! - 1;
      } else {
        cart.remove(food);
      }
    });
  }

  int get totalItem => cart.values.fold(0, (sum, item) => sum + item);

  int get ongkir {
    if (selectedLocation == "Rumah") return 5000;
    if (selectedLocation == "Sekolah") return 8000;
    return 0;
  }

  void pilihLokasi() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          children: [
            ListTile(
              title: const Text("Rumah"),
              onTap: () {
                setState(() => selectedLocation = "Rumah");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Sekolah"),
              onTap: () {
                setState(() => selectedLocation = "Sekolah");
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Geprek Caca 🍗"),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: pilihLokasi,
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(
                        cart: cart,
                        location: selectedLocation,
                        ongkir: ongkir,
                      ),
                    ),
                  );
                },
              ),
              if (totalItem > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      totalItem.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.fastfood, color: Colors.white, size: 40),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Selamat datang di Geprek Caca 🔥\nPilih menu favoritmu!",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),

          // LIST MENU
          Expanded(
            child: ListView.builder(
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final food = foodList[index];
                int qty = cart[food] ?? 0;

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(food.image, width: 70),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(food.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text("Rp ${food.price}"),
                          ],
                        ),
                      ),

                      // 🔥 BUTTON + -
                      Row(
                        children: [
                          // 🔴 TOMBOL KURANG
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (qty > 0) {
                                  remove(food);
                                }
                              },
                              icon:
                                  const Icon(Icons.remove, color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // 🔢 JUMLAH
                          Text(
                            qty.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 8),

                          // 🟢 TOMBOL TAMBAH
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () => add(food),
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
