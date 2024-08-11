import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:deep_scan/models/ingredient.dart';
import 'package:deep_scan/widgets/analyser_widgets/ingredient_widget.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required this.ingredients,
    required this.nutrition,
    required this.howTo,
  });
  final List<Ingredient>? ingredients;
  final String? nutrition;
  final String? howTo;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                child: Text('Ingredients'),
              ),
              Tab(
                child: Text('Nutrition'),
              ),
              Tab(
                child: Text('How to use?'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                TabBarContent(
                  content: IngredientsWidget(
                    ingredients: ingredients,
                  ),
                ),
                TabBarContent(
                  content: nutrition != null
                      ? Markdown(data: nutrition!)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                TabBarContent(
                  content: howTo != null
                      ? Markdown(data: howTo!)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabBarContent extends StatelessWidget {
  const TabBarContent({
    super.key,
    required this.content,
  });
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: content,
    );
  }
}
