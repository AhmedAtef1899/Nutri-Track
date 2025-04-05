
class AddMealModel {
  String? maxHeight;
  String? minHeight;
  String? maxWeight;
  String? minWeight;
  String? age;
  String? healthCondition;
  String? mealTitle;
  List<Ingredient> ingredients;
  String? imageUrl;
  String? category;

  AddMealModel({
    this.maxHeight,
    this.minHeight,
    this.maxWeight,
    this.minWeight,
    this.age,
    this.healthCondition,
    this.mealTitle,
    required this.ingredients,
    this.imageUrl,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'maxHeight': maxHeight,
      'minHeight': minHeight,
      'maxWeight': maxWeight,
      'minWeight': minWeight,
      'age': age,
      'healthCondition': healthCondition,
      'mealTitle': mealTitle,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory AddMealModel.fromJson(Map<String, dynamic> json) {
    return AddMealModel(
      maxHeight: json['maxHeight'],
      minHeight: json['minHeight'],
      maxWeight: json['maxWeight'],
      minWeight: json['minWeight'],
      age: json['age'],
      healthCondition: json['healthCondition'],
      mealTitle: json['mealTitle'],
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      imageUrl: json['imageUrl'],
      category: json['category'],
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
