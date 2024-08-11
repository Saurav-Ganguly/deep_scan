class Recipe {
  final String productName;
  final String homemadeVersion;
  final String description;
  final String servings;
  final String prepTime;
  final String cookTime;
  final String totalTime;
  final List<RecipeIngredient> ingredients;
  final List<String> equipment;
  final List<Instruction> instructions;
  final NutritionalInfo nutritionalInfo;
  final List<String> healthBenefits;
  final String storageInstructions;
  final String shelfLife;
  final List<String> variations;
  final List<String> tips;

  Recipe({
    required this.productName,
    required this.homemadeVersion,
    required this.description,
    required this.servings,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.ingredients,
    required this.equipment,
    required this.instructions,
    required this.nutritionalInfo,
    required this.healthBenefits,
    required this.storageInstructions,
    required this.shelfLife,
    required this.variations,
    required this.tips,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      productName: json['productName'],
      homemadeVersion: json['homemadeVersion'],
      description: json['description'],
      servings: json['servings'],
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      totalTime: json['totalTime'],
      ingredients: List<RecipeIngredient>.from(
          json['ingredients'].map((x) => RecipeIngredient.fromJson(x))),
      equipment: List<String>.from(json['equipment']),
      instructions: List<Instruction>.from(
          json['instructions'].map((x) => Instruction.fromJson(x))),
      nutritionalInfo: NutritionalInfo.fromJson(json['nutritionalInfo']),
      healthBenefits: List<String>.from(json['healthBenefits']),
      storageInstructions: json['storageInstructions'],
      shelfLife: json['shelfLife'],
      variations: List<String>.from(json['variations']),
      tips: List<String>.from(json['tips']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'homemadeVersion': homemadeVersion,
      'description': description,
      'servings': servings,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'totalTime': totalTime,
      'ingredients': ingredients.map((x) => x.toJson()).toList(),
      'equipment': equipment,
      'instructions': instructions.map((x) => x.toJson()).toList(),
      'nutritionalInfo': nutritionalInfo.toJson(),
      'healthBenefits': healthBenefits,
      'storageInstructions': storageInstructions,
      'shelfLife': shelfLife,
      'variations': variations,
      'tips': tips,
    };
  }
}

class RecipeIngredient {
  final String item;
  final String amount;
  final String unit;
  final String? notes;

  RecipeIngredient({
    required this.item,
    required this.amount,
    required this.unit,
    this.notes,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      item: json['item'],
      amount: json['amount'],
      unit: json['unit'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'amount': amount,
      'unit': unit,
      'notes': notes,
    };
  }
}

class Instruction {
  final String step;
  final String action;
  final String? tip;

  Instruction({
    required this.step,
    required this.action,
    this.tip,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      step: json['step'],
      action: json['action'],
      tip: json['tip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'action': action,
      'tip': tip,
    };
  }
}

class NutritionalInfo {
  final String calories;
  final String protein;
  final String carbs;
  final String fat;
  final String fiber;

  NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      fiber: json['fiber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
    };
  }
}
