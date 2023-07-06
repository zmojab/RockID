class Rock {
  final String category;
  final String crystalSystem;
  final String formula;
  final String luster;
  final String streak;
  final String formation;
  final String name;
  final String properties;
  final String uses;

  Rock({
    required this.category,
    required this.crystalSystem,
    required this.formula,
    required this.luster,
    required this.streak,
    required this.formation,
    required this.name,
    required this.properties,
    required this.uses,
  });

  factory Rock.fromFirestore(Map<String, dynamic> data) {
    return Rock(
      category: data['Category'] ?? '',
      crystalSystem: data['Crystal System'] ?? '',
      formula: data['Formula'] ?? '',
      luster: data['Luster'] ?? '',
      streak: data['Streak'] ?? '',
      formation: data['formation'] ?? '',
      name: data['name'] ?? '',
      properties: data['properties'] ?? '',
      uses: data['uses'] ?? '',
    );
  }
}
