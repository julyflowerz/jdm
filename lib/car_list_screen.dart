import 'package:flutter/material.dart';
import 'package:jdm/api_service.dart'; //

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Car")),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final cars = snapshot.data!;
            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return ListTile(
                  title: Text(car['name']),
                  subtitle: Text(car['make']),
                  onTap: () {
                    // TODO: Save selected car for race logic
                    Navigator.pushNamed(context, '/game');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
