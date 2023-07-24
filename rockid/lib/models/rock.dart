class Rock {
  final String category;
  final String crystalSystem;
  final String description;
  final String formula;
  final String luster;
  final String name;
  final String streak;
  final String imageURL;

  Rock({
    required this.category,
    required this.crystalSystem,
    required this.description,
    required this.formula,
    required this.luster,
    required this.name,
    required this.streak,
    required this.imageURL
  });

  factory Rock.fromFirestore(Map<String, dynamic> data) {
    return Rock(
      category: data['Category'] ?? '',
      crystalSystem: data['Crystal system'] ?? '',
      description: data['Description'] ?? '',
      formula: data['Formula'] ?? '',
      luster: data['Luster'] ?? '',
      name: data['Name'] ?? '',
      streak: data['Streak'] ?? '',
      imageURL: data['URL'] ?? ''
    );
  }
}
