class PremiumPlanEntity {
  final String id;
  final String name;
  final double price;
  final String currency;
  final int duration;
  final String description;
  final List<String> features;

  PremiumPlanEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.duration,
    required this.description,
    required this.features,
  });
}
