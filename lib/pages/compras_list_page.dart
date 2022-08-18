import 'package:Tarefas/models/product.dart';
import 'package:Tarefas/widgets/product_list_item.dart';
import 'package:flutter/material.dart';

class ComprasListPage extends StatefulWidget {
  ComprasListPage({Key? key}) : super(key: key);

  @override
  State<ComprasListPage> createState() => _ComprasListPageState();
}

class _ComprasListPageState extends State<ComprasListPage> {
  final TextEditingController productsController = TextEditingController();

  List<Product> products = [];
  Product? deletedProduct;
  int? deletedProductPos;

  bool get isNull => productsController == null;

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
                            hintText: "Ex: Arroz"),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: isNull
                          ? null
                          : () {
                              String text = productsController.text;
                              setState(() {
                                Product newProduct =
                                    Product(title: text, date: DateTime.now());
                                products.add(newProduct);
                              });
                              productsController.clear();
                            },
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff023047),
                        padding: EdgeInsets.all(14),
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
  }
}
