import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> products;
  List<Product> cart = [];

  @override
  void initState() {
    super.initState();
    products = ApiService.getProducts();
  }

  void addToCart(Product product) {
    setState(() {
      int index =
      cart.indexWhere((item) => item.id == product.id);

      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(Product(
          id: product.id,
          title: product.title,
          price: product.price,
          image: product.image,
        ));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mini Shop"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CartScreen(cart: cart),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 10,
                  child: Text(
                    cart.length.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }

          var productList = snapshot.data!;

          return GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: productList.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              var product = productList[index];

              return Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [

                      Expanded(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Text(
                        product.title,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                      ),

                      Text(
                        "${product.price} \$",
                        style: TextStyle(
                            color: Colors.green),
                      ),

                      ElevatedButton(
                        onPressed: () =>
                            addToCart(product),
                        child: Text("Add"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}