import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

// enum primario com tipos de dados que presiso.
class Product with ChangeNotifier {
  final _baseUrl = Constants.productBaseUrl;
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

// atualizar favoritos
  void _toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    try {
      _toggleFavorite();

      // ignore: unused_local_variable
      final response = await http.patch(
        Uri.parse('$_baseUrl/$id.json'),
        body: jsonEncode({"isFavorite": isFavorite}),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (_) {
      // retona ao inicio
      _toggleFavorite();
    }
  }
}
