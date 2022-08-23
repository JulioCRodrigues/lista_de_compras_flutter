class Product {

  Product({required this.title, required this.date});

  Product.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      date = DateTime.parse(json['datetime']);

  String title;
  DateTime date;

  Map<String, dynamic>toJson(){
    return {
      'title': title,
      'datetime': date.toIso8601String(),
    };
  }


}