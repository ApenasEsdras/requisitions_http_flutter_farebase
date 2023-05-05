import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart.dart';
import 'package:shop/models/order.dart';

import '../utils/constants.dart';

class OrderList with ChangeNotifier {
  final ordersUrl = Constants.ordersBaseUrl;
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders(bool Function() param0) async {
    // linpar lista
    _items.clear();
    // retornavalores
    final response = await http.get(
      Uri.parse('$ordersUrl.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    // data.forEach((ordertId, orderData) {
    //   _items.add(
    //     Product(
    //       id: productId,
    //       name: productData['name'],
    //       description: productData['description'],
    //       price: productData['price'],
    //       imageUrl: productData['imageUrl'],
    //       isFavorite: productData['isFavorite'],
    //     ),
    //   );
    // });
    // notifyListeners();
    print(data);
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      // esse .json cria uma arquivo json valido p/ o firebase
      Uri.parse('$ordersUrl.json'),
      // converte o input(string qualuquer) para json
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          // para trazer os itens presiso mapear antes
          'products': cart.items.values
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                },
              )
              .toList(),
        },
      ),
    );
    // obtendo o ID do produtos
    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
