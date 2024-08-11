import 'package:flutter/material.dart';
import 'package:deep_scan/constants.dart';
import 'package:deep_scan/models/ingredient.dart';

class IngredientsWidget extends StatefulWidget {
  const IngredientsWidget({super.key, required this.ingredients});
  final List<Ingredient>? ingredients;

  @override
  State<IngredientsWidget> createState() => _IngredientsWidgetState();
}

class _IngredientsWidgetState extends State<IngredientsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.ingredients != null
        ? ListView.builder(
            itemCount: widget.ingredients?.length,
            itemBuilder: (ctx, id) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: IngredientsExpansionTile(
                  color: ingredientColor(
                      widget.ingredients![id].harmfulnessFactor),
                  comments: widget.ingredients![id].comments,
                  quantity: widget.ingredients![id].quantity,
                  title: widget.ingredients![id].name,
                  healtheirAlternatives:
                      widget.ingredients![id].healtheirAlternatives,
                  potentialAllergies: widget.ingredients![id].allergies,
                ),
              );
            })
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class IngredientsExpansionTile extends StatelessWidget {
  final String title;
  final Color color;
  final String? quantity;
  final String? comments;
  final String? healtheirAlternatives;
  final List<String>? potentialAllergies;

  const IngredientsExpansionTile({
    super.key,
    required this.title,
    required this.color,
    required this.quantity,
    required this.comments,
    required this.healtheirAlternatives,
    required this.potentialAllergies,
  });

  String? allergeyToList(List<String>? allergies) {
    if (allergies == null) return null;
    String allergyString = '';
    for (var allergy in allergies) {
      allergyString += '$allergy\n';
    }
    return allergyString;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      //expandedAlignment: Alignment.topLeft,

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: quantity != null
          ? CircleAvatar(
              child: Text(quantity!),
            )
          : null,
      collapsedBackgroundColor: color,
      backgroundColor: color,
      subtitle: comments != null ? Text(comments!) : null,
      collapsedIconColor: Colors.white,
      collapsedTextColor: Colors.white,
      iconColor: Colors.white,
      textColor: Colors.white,
      children: [
        const Text(
          'Healthier Alternative:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          healtheirAlternatives ?? 'N/A',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const Text(
          'Potential Allergies:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        potentialAllergies!.isNotEmpty
            ? Text(
                allergeyToList(potentialAllergies)!,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            : const Text(
                'N/A',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
      ],
    );
  }
}
