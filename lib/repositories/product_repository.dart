import 'dart:convert';

import 'package:Tarefas/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

const productListKey = 'products_list';

class ProductRepository {

  late SharedPreferences sharedPreferences;

  Future<List<Product>> getProductList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(productListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Product.fromJson(e)).toList();
  }

  void saveProductList(List<Product> products){
    final jsonString = json.encode(products);
    sharedPreferences.setString('products_list', jsonString);
  }
}