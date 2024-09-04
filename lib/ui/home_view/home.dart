import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoping_app_admin/ui/curd_opration/add_product_view.dart';
import 'package:shoping_app_admin/ui/curd_opration/update_product_view.dart';
import 'package:shoping_app_admin/utils/ui_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance; // Firebase initialize
  }

// delete product item
  Future<void> deleteProduct(String itemId) async {
    await db.collection('product').doc(itemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Admin Panel"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('product').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"), // show interNet error
            );
          } else if (snapshot.hasData) {
            final productData = snapshot.data!.docs;

            if (productData.isEmpty) {
              return const Center(
                child: Text("Data is Empty"),
              );
            }
            return ListView.builder(
              itemCount: productData.length,
              itemBuilder: (context, index) {
                final product = productData[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Product       : ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        wSpace(mWight: 10),
                                        Flexible(
                                            child: Text("${product['name']}")),
                                      ],
                                    ),
                                    hSpace(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Description : ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        wSpace(mWight: 10),
                                        Flexible(
                                            child: Text(
                                                "${product['description']}")),
                                      ],
                                    ),
                                    hSpace(),
                                    Row(
                                      children: [
                                        const Text(
                                          "Amount       : ",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        wSpace(mWight: 10),
                                        Text("${product['amount']}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              wSpace(),
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(
                                    "${product['image']}",
                                    fit: BoxFit.fill,
                                  ))
                            ],
                          ),
                          hSpace(),
                          Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                height: 40,
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateProductView(
                                                  productId: product.id,
                                                  productName:
                                                      "${product['name']}",
                                                  productDesc:
                                                      "${product['description']}",
                                                  amount:
                                                      "${product['amount']}",
                                                  imgpath:
                                                      "${product['image']}",
                                                )),
                                      );
                                    },
                                    child: const Text("Update")),
                              )),
                              wSpace(),
                              Expanded(
                                  child: SizedBox(
                                height: 40,
                                child: OutlinedButton(
                                    onPressed: () {
                                      deleteProduct(product.id);
                                    },
                                    child: const Text("Delete")),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductView(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
