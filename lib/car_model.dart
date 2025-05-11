class Car {
  final int id;
  final String name;
  final String make;
  final String sprite;

  Car({required this.id, required this.name, required this.make, required this.sprite});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      make: json['make'],
      sprite: json['sprite'],
    );
  }
}
