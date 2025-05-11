import 'package:flutter/material.dart';
import 'car_model.dart';
import 'api_service.dart';
import 'gamescreen.dart'; // where game starts

class CarSelectionScreen extends StatelessWidget {
  const CarSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Car')),
      body: FutureBuilder<List<Car>>(
        future: fetchCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final cars = snapshot.data!;
            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return ListTile(
                  leading: Image.asset('assets/images/${car.sprite}', width: 50, height: 50),
                  title: Text('${car.name} ${car.make}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(selectedCar: car),
                      ),
                    );
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
