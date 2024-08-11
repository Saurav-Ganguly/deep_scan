import 'package:flutter/material.dart';

import 'package:deep_scan/models/ingredient.dart';
import 'package:deep_scan/models/product.dart';
import 'package:deep_scan/widgets/product_card.dart';

class RecentSearchesWidget extends StatelessWidget {
  RecentSearchesWidget({super.key});
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Tomato Ketchup',
      company: 'Nissan',
      country: 'India',
      type: 'Food',
      ingredients: [
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
      ],
      harmfulnessPercentage: 40,
      ecologicalHarmfulnessPercentage: 60,
    ),
    Product(
      id: '2',
      name: 'Maggi 2 Min Noodle',
      company: "Nestle's",
      country: 'India',
      type: 'Food',
      ingredients: [
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
      ],
      harmfulnessPercentage: 70,
      ecologicalHarmfulnessPercentage: 60,
    ),
    Product(
      id: '3',
      name: 'UltraSheer Dry-Touch Sunblock',
      company: 'Neutrogena',
      country: 'India',
      type: 'Food',
      ingredients: [
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
        Ingredient(
          name: 'Palm Oil',
          harmfulnessFactor: 5,
          healtheirAlternatives: 'A',
          allergies: [],
        ),
      ],
      harmfulnessPercentage: 80,
      ecologicalHarmfulnessPercentage: 60,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _products.length,
          itemBuilder: (ctx, id) {
            final product = _products[id];
            return ProductCard(
              id: product.id,
              name: product.name,
              company: product.company!,
              ingredients: product.ingredients!,
              overallHealthRating: product.harmfulnessPercentage,
              country: product.country!,
            );
          }),
    );
  }
}
