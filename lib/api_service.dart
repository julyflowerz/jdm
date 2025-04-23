import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<List<dynamic>> fetchCars() async {
  final url = kIsWeb
      ? Uri.parse('http://localhost:5168/api/cars')      // for Flutter Web
      : Uri.parse('http://10.0.2.2:5168/api/cars');       // for Android Emulator

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load cars');
  }
}
