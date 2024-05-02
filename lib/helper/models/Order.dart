class Order {
  final String userId; // Added user ID field
  final String pickupLocation;
  final String destination;
  final DateTime dateTime;
  final String cargoDescription;
  final String vehicleSize;
  final double offer;

  Order({
    required this.userId,
    required this.pickupLocation,
    required this.destination,
    required this.dateTime,
    required this.cargoDescription,
    required this.vehicleSize,
    required this.offer,
  });
}
