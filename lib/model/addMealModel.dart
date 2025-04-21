class AddMealModel {
  String? bmi;
  String? age;
  String? healthCondition;
  String? mealTitle;
  List<Ingredient> ingredients;
  String? imageUrl;
  String? category;
  DateTime? date; // ✅ Add this line

  AddMealModel({
    this.bmi,
    this.age,
    this.healthCondition,
    this.mealTitle,
    required this.ingredients,
    this.imageUrl,
    this.category,
    this.date, // ✅ Add this
  });

  Map<String, dynamic> toJson() {
    return {
      'bmi': bmi,
      'age': age,
      'healthCondition': healthCondition,
      'mealTitle': mealTitle,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'imageUrl': imageUrl,
      'category': category,
      'date': date?.toIso8601String(), // ✅ Add this
    };
  }

  factory AddMealModel.fromJson(Map<String, dynamic> json) {
    return AddMealModel(
      bmi: json['bmi'],
      age: json['age'],
      healthCondition: json['healthCondition'],
      mealTitle: json['mealTitle'],
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null, // ✅ Add this
    );
  }
}

class Ingredient {
  String name;
  double calories;
  double protein;
  double carbs;
  Ingredient({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
    );
  }
}
