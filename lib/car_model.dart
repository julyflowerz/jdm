class Car {
  final String make;
  final String model;
  final String spritePath;

  Car({
    required this.make,
    required this.model,
    required this.spritePath,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      make: json['make'],
      model: json['model'],
      spritePath: json['spritePath'],
    );
  }
}
