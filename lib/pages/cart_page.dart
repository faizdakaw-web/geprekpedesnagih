import 'package:flutter/material.dart';
import '../models/food.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  final Map<Food, int> cart;
  final String location;
  final int ongkir;

  const CartPage({
    super.key,
    required this.cart,
    required this.location,
    required this.ongkir,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void add(Food food) {
    setState(() {
      widget.cart[food] = widget.cart[food]! + 1;
    });
  }

  void remove(Food food) {
    setState(() {
      if (widget.cart[food]! > 1) {
        widget.cart[food] = widget.cart[food]! - 1;
      } else {
        widget.cart.remove(food);
      }
    });
  }

  int get subtotal {
    int total = 0;
    widget.cart.forEach((food, qty) {
      total += food.price * qty;
    });
    return total;
  }

  int get total => subtotal + widget.ongkir;

  void kirimWA() async {
    String pesan = "Halo, saya pesan:\n\n";

    widget.cart.forEach((food, qty) {
      pesan += "- ${food.name} x$qty (Rp ${food.price * qty})\n";
    });

    pesan += "\nLokasi: ${widget.location}";
    pesan += "\nOngkir: Rp ${widget.ongkir}";
    pesan += "\nTotal: Rp $total";

    final url = Uri.parse(
      "https://wa.me/62895600790104?text=${Uri.encodeComponent(pesan)}",
    );

    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang 🛒")),
      body: widget.cart.isEmpty
          ? const Center(child: Text("Keranjang kosong 😢"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final food = widget.cart.keys.elementAt(index);
                      final qty = widget.cart[food]!;

                      return ListTile(
                        leading: Image.asset(food.image, width: 50),
                        title: Text(food.name),
                        subtitle: Text("Rp ${food.price} x $qty"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => remove(food),
                              icon: const Icon(Icons.remove),
                            ),
                            Text(qty.toString()),
                            IconButton(
                              onPressed: () => add(food),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Text("Subtotal: Rp $subtotal"),
                Text("Ongkir: Rp ${widget.ongkir}"),
                Text("Total: Rp $total"),
                ElevatedButton(
                  onPressed: kirimWA,
                  child: const Text("Pesan via WhatsApp"),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
