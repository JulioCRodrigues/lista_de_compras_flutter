import 'package:Tarefas/models/product.dart';
import 'package:Tarefas/repositories/product_repository.dart';
import 'package:Tarefas/widgets/product_list_item.dart';
import 'package:flutter/material.dart';

class ComprasListPage extends StatefulWidget {
  ComprasListPage({Key? key}) : super(key: key);

  @override
  State<ComprasListPage> createState() => _ComprasListPageState();
}

class _ComprasListPageState extends State<ComprasListPage> {
  final TextEditingController productsController = TextEditingController();
  final ProductRepository productRepository = ProductRepository();

  List<Product> products = [];

  Product? deletedProduct;
  int? deletedProductPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    productRepository.getProductList().then((value) {
      setState(() {
        products = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Lista de Compras",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: productsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Item da compra",
                          labelStyle: TextStyle(
                            color: Color(0xff023047),
                          ),
                          hintText: "Ex: Arroz",
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 2,
                            color: Color(0xff023047),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = productsController.text;
                        if (text.isEmpty) {
                          setState(() {
                            errorText = "Insira um produto";
                          });
                          return;
                        }

                        setState(() {
                          Product newProduct =
                              Product(title: text, date: DateTime.now());
                          products.add(newProduct);
                          errorText = null;
                        });
                        productsController.clear();
                        productRepository.saveProductList(products);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff023047),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Product product in products)
                        ProductListItem(
                          product: product,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Faltam ${products.length} para comprar!'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDialogDeleteAll,
                      child: Text('Limpar tudo'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xff023047)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Product product) {
    deletedProduct = product;
    deletedProductPos = products.indexOf(product);

    setState(() {
      products.remove(product);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("O produto ${product.title} foi removido com sucesso!"),
      backgroundColor: Color(0xff023047),
      action: SnackBarAction(
        label: "Desfazer",
        textColor: Colors.white,
        onPressed: () {
          setState(() {
            products.insert(deletedProductPos!, deletedProduct!);
          });
        },
      ),
      duration: Duration(seconds: 4),
    ));
    productRepository.saveProductList(products);
  }

  void showDialogDeleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Limpar todos os itens"),
        content: Text("Você tem certea que deseja excluir todos os produtos?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: Color(0xff023047),
                ),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllProducts();
              },
              child: Text(
                "Limpar tudo",
                style: TextStyle(
                  color: Colors.red,
                ),
              )),
        ],
      ),
    );
  }

  void deleteAllProducts() {
    setState(() {
      products.clear();
    });
    productRepository.saveProductList(products);
  }
}
