import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cart;

  CartScreen({required this.cart});

  @override
  State<CartScreen> createState() =>
      _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double getTotal() {
    double total = 0;
    for (var item in widget.cart) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: widget.cart.isEmpty
          ? Center(child: Text("Cart is empty"))
          : Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                var item = widget.cart[index];

                return ListTile(
                  leading: Image.network(
                    item.image,
                    width: 50,
                  ),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                      "${item.price} \$  x${item.quantity}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.cart
                            .removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  "Total: ${getTotal()} \$",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Checkout"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}