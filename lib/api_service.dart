import 'dart:convert';
import 'package:http/http.dart' as http;
import 'car_model.dart';

Future<List<Car>> fetchCars() async {
  final response = await http.get(Uri.parse('http://localhost:7066/api/Cars'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((car) => Car.fromJson(car)).toList();
  } else {
    throw Exception('Failed to load cars');
  }
}
