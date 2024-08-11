import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:deep_scan/constants.dart';
import 'package:deep_scan/models/ingredient.dart';

import 'package:deep_scan/models/product.dart';
import 'package:deep_scan/models/recipe.dart';
import 'package:deep_scan/screens/recipe_screen.dart';
import 'package:deep_scan/services/gemini_service.dart';
import 'package:deep_scan/utils/prompts.dart';
import 'package:deep_scan/widgets/analyser_widgets/chart_card.dart';
import 'package:deep_scan/widgets/analyser_widgets/info_box.dart';
import 'package:deep_scan/widgets/analyser_widgets/tab_bar_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

class AnalyserScreen extends StatefulWidget {
  const AnalyserScreen({
    super.key,
    required this.images,
  });
  // images to be processed
  final List<XFile> images;
  @override
  State<AnalyserScreen> createState() => _AnalyserScreenState();
}

class _AnalyserScreenState extends State<AnalyserScreen> {
  Product? product;
  List<Ingredient>? ingredients;
  late GenerativeModel model;
  final geminiService = GeminiService();
  String? nutrients;
  String? ingredientDeepAnalysis;
  String? ecoDeepAnalysis;
  String? howTo;
  // String? productURL;
  Recipe? recipe;
  bool isLoading = false;
  bool canTalk = false;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final result = await geminiService.imageScan(widget.images, initialPrompt);

    if (result == null) {
      AlertDialog(
        title: const Text('Something went wrong!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    }
    setState(() {
      if (result != null) {
        product = result;
      }
    });

    _initializeIngredient();
    _initializeNutrient();
    _initializeHowTo();
  }

  Future<void> _initializeIngredientAnalysis() async {
    final result = await geminiService
        .getIngredientDeepAnalysis(ingredientDeepAnalysisPrompt);
    setState(() {
      ingredientDeepAnalysis = result;
      isLoading = false;
    });
    bottomSheetMarkdownView(ingredientDeepAnalysis);
  }

  Future<void> _initializeEcoDeepAnalysis() async {
    final result =
        await geminiService.getEcoDeepAnalysis(ecoDeepAnalysisPrompt);
    setState(() {
      ecoDeepAnalysis = result;
      isLoading = false;
    });
    bottomSheetMarkdownView(ecoDeepAnalysis);
  }

  void bottomSheetMarkdownView(String? data) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Markdown(
        data: data ?? '',
      ),
    );
  }

  Future<void> _initializeIngredient() async {
    final result = await geminiService.getIngredients(ingredientPrompt);
    setState(() {
      if (result != null) {
        ingredients = result;
      }
    });
  }

  Future<void> _initializeNutrient() async {
    final result = await geminiService.getNutrients(nutrientAnalysisPrompt);
    setState(() {
      if (result != null) {
        nutrients = result;
      }
    });
  }

  Future<void> _initializeHowTo() async {
    final result = await geminiService.howToUse(howToUsePrompt);
    setState(() {
      if (result != null) {
        howTo = result;
      }
      canTalk = true;
    });
  }

  Future<void> _initializeRecipe() async {
    final result = await geminiService.getHomeMadeRecipe(homeMadeRecipePrompt);
    setState(() {
      recipe = result;
      isLoading = false;
    });
    // Navigator.push(
    //   context,
    // MaterialPageRoute(
    //   builder: (ctx) => RecipeScreen(
    //     recipe: recipe!,
    //     images: widget.images,
    //   ),
    // ),
    //);
  }

  Widget onLoadData() {
    if (product != null) {
      return Stack(
        children: [
          // Background
          Container(
            color: AppColors.myPurple,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: InfoBox(
                          label: '',
                          icon: '',
                          info: "${product!.company}'s",
                          textColor: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InfoBox(
                        label: '',
                        icon: '',
                        info: product!.name,
                        textColor: Colors.white,
                        fontSize: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (recipe == null) {
                            setState(() {
                              isLoading = true;
                            });
                            _initializeRecipe();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => RecipeScreen(
                                  recipe: recipe!,
                                  images: widget.images,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 252, 170, 63),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InfoBox(
                            label: '',
                            icon: '',
                            info: 'Healthify Me !! ↗️',
                            textColor: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoBox(
                        label: '',
                        icon: product!.typeIcon,
                        info: product!.type,
                        textColor: Colors.white,
                        fontSize: 14,
                      ),
                      InfoBox(
                        label: '',
                        icon: product!.countryFlag,
                        info: product!.country,
                        textColor: Colors.white,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // White content area
          Positioned(
            top: 250, // Adjust as needed
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: TabBarWidget(
                    ingredients: ingredients,
                    nutrition: nutrients,
                    howTo: howTo,
                  ),
                )),
          ),
          // Overlapping circular progress indicators
          Positioned(
            top: 170, // Adjust to overlap as desired
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    if (ingredientDeepAnalysis == null) {
                      setState(() {
                        isLoading = true;
                      });
                      _initializeIngredientAnalysis();
                    } else {
                      bottomSheetMarkdownView(ingredientDeepAnalysis);
                    }
                  },
                  child: ChartCard(
                    percentage: product!.harmfulnessPercentage,
                    size: 100,
                    color: percentColor(product!.harmfulnessPercentage),
                    label: 'Ingredient Factor',
                    name: 'Ingred-O-Meter',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (ecoDeepAnalysis == null) {
                      setState(() {
                        isLoading = true;
                      });
                      _initializeEcoDeepAnalysis();
                    } else {
                      bottomSheetMarkdownView(ecoDeepAnalysis);
                    }
                  },
                  child: ChartCard(
                    percentage: product!.ecologicalHarmfulnessPercentage,
                    size: 100,
                    color:
                        percentColor(product!.ecologicalHarmfulnessPercentage),
                    label: 'Ecological Factor',
                    name: 'Eco-O-Meter',
                  ),
                )
              ],
            ),
          ),
          // Other UI elements...
        ],
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        floatingActionButton: canTalk
            ? FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppColors.myPurple,
                foregroundColor: Colors.white,
                child: const Icon(Icons.star_border),
              )
            : null,
        body: onLoadData(),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: LoadingAnimatedIcon(),
            ),
          ),
      ],
    );
  }
}

class LoadingAnimatedIcon extends StatefulWidget {
  const LoadingAnimatedIcon({super.key});

  @override
  State<LoadingAnimatedIcon> createState() => _LoadingAnimatedIconState();
}

class _LoadingAnimatedIconState extends State<LoadingAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: AnimatedIcon(
        icon: AnimatedIcons.ellipsis_search,
        progress: animation,
        size: 72.0,
        semanticLabel: 'Show menu',
      ),
    );
  }
}
