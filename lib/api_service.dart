import 'dart:convert';
import 'package:http/http.dart' as http;
import 'car_model.dart';

Future<List<Car>> fetchCars() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5168/api/Cars')); // ✅ Update your IP/port if needed

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Car.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load cars');
  }
}
