class BusAgency {
  final String id;
  final String name;
  final String logo;
  final int price;
  final TimeOfDay departureTime;
  final TimeOfDay arrivalTime;
  final List<String> amenities;

  BusAgency({
    required this.id,
    required this.name,
    required this.logo,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.amenities,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'price': price,
      'departureHour': departureTime.hour,
      'departureMinute': departureTime.minute,
      'arrivalHour': arrivalTime.hour,
      'arrivalMinute': arrivalTime.minute,
      'amenities': amenities,
    };
  }

  // Create from Firestore data
  factory BusAgency.fromMap(Map<String, dynamic> map) {
    return BusAgency(
      id: map['id'],
      name: map['name'],
      logo: map['logo'],
      price: map['price'],
      departureTime: TimeOfDay(
        hour: map['departureHour'],
        minute: map['departureMinute'],
      ),
      arrivalTime: TimeOfDay(
        hour: map['arrivalHour'],
        minute: map['arrivalMinute'],
      ),
      amenities: List<String>.from(map['amenities']),
    );
  }
}