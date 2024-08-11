const initialPrompt = '''
I have attached images of different sides of a product. You need to analyze the images and answer the following questions. 

Instructions:
- Provide your answer ONLY in the specified JSON format.
- If the answer to a particular question is not found, use null for that field.
- For icon/emoji fields, use a single Unicode character that can be directly displayed.
- IMPORTANT: Always provide a value for harmfulness_percentage and ecological_harmfulness_percentage. If you cannot determine an exact percentage based on the available information, provide your best estimate based on similar products or general knowledge of the product type.
- IMPORTANT : JUST GIVE ME THE JSON OBJECT - NO TEXT ATTACHED AT THE START OR IN THE END
Questions to answer:

1 If the product is not related to FMCG / Cosmetics / Supplements / Pharma (medicine) give a false value.
2. What type of product is this? (Provide an icon/emoji)
3. What type of product is this? (Provide a string)
4. What is the product name?
5. What is the company of the product?
6. Who is the manufacturer of the product?
7. What is the country of manufacture?
8. What is the flag of the manufacturing country? (Provide as an icon/emoji)
9. What is the percentage of harmfulness of the product based on the ingredients used? (HIGHER PERCENTAGE MEANS LESS HARMFUL)
10. What is the percentage of ecological harmfulness of the product? (HIGHER PERCENTAGE MEANS LESS ECOLOGICALLY HARMFUL)

For questions 9 and 10:
- Always provide a percentage value between 0 and 100.
- If you cannot determine an exact percentage, provide your best estimate based on similar products or general knowledge of the product type.
- Explain your reasoning for the percentages in a brief comment within the JSON.

Provide your response in the following JSON format:

{
  "product_is_related": bool, 
  "product_type_icon": "",
  "product_type": "",
  "product_name": "",
  "company": "",
  "manufacturer": "",
  "country_of_manufacture": "",
  "country_flag": "",
  "harmfulness_percentage": 0,
  'harmfulness_percentage_explanation: "",
  "ecological_harmfulness_percentage": 0,
  "ecological_harmfullness_percentage_explanation": ""
}

Example of a filled JSON response:

{
  "product_is_related": true,
  "product_type_icon": "💊",
  "product_type": "Medicine",
  "product_name": "PainAway Extra Strength",
  "company": "HealthCorp Inc.",
  "manufacturer": "MediLabs Pharmaceuticals",
  "country_of_manufacture": "United States",
  "country_flag": "🇺🇸",
  "harmfulness_percentage": 85,
  'harmfulness_percentage_explanation: "Harmfulness: 85% (less harmful) based on common pain medication ingredients.",
  "ecological_harmfulness_percentage": 70,
  "percentage_explanation": "Ecological: 70% (less harmful) assuming standard pharmaceutical packaging and disposal methods."
}

Please provide your analysis of the product images in this JSON format only, ensuring that harmfulness_percentage and ecological_harmfulness_percentage are always included with a value between 0 and 100.
''';

const ingredientPrompt = '''

Based on the product images provided earlier, analyze all the ingredients in the product. For each ingredient, provide the following information:

1. Name of the ingredient
2. Quantity of the ingredient (if available)
3. Brief comments on the ingredient's purpose or effects
4. Harmfulness factor of the ingredient (scale of 0-10, where 0 is least harmful and 10 is most harmful)
5. A healthier alternatives to the ingredient (if applicable)
6. Potential allergies or sensitivities associated with the ingredient

Instructions:
- Provide your response ONLY in the specified JSON format.
- Include all ingredients listed on the product.
- If information for a particular field is not available, use null.
- For the harmfulness factor, always provide a number between 0 and 10.
- If a healthier alternative is not applicable or necessary, use null for that field.
- For allergies, list known allergies or sensitivities. If none are known, use an empty array [].
- IMPORTANT: Always provide a value for harmfulness_factor. If you cannot determine an exact value, provide your best estimate based on similar ingredient or general knowledge of the ingredient type.
- IMPORTANT : JUST GIVE ME THE JSON OBJECT - NO TEXT ATTACHED AT THE START OR IN THE END

Provide your response in the following JSON format:

{
 "ingredients": [
    {
      "name": String,
      "quantity": String,
      "comments": String,
      "harmfulness_factor": int (0-10),
      "healthier_alternative": String,
      "potential_allergies": List of String
    }
  ],
}

Example of a filled JSON response:

{
  "ingredients": [
    {
      "name": "Acetaminophen",
      "quantity": "500 mg",
      "comments": "Active ingredient for pain relief and fever reduction",
      "harmfulness_factor": 4,
      "healthier_alternative": "Natural alternatives like willow bark or turmeric, but consult a doctor",
      "potential_allergies": ["Rare cases of hypersensitivity or skin reactions"]
    },
    {
      "name": "Microcrystalline cellulose",
      "quantity": null,
      "comments": "Inactive ingredient used as a filler and binder",
      "harmfulness_factor": 1,
      "healthier_alternative": null,
      "potential_allergies": []
    },
    {
      "name": "Sodium starch glycolate",
      "quantity": null,
      "comments": "Disintegrant to help the tablet break down in the body",
      "harmfulness_factor": 2,
      "healthier_alternative": "Natural disintegrants like pregelatinized starch",
      "potential_allergies": ["May cause allergic reactions in individuals with corn allergies"]
    }
  ],
}

Please analyze the ingredients of the product shown in the images and provide your response in this JSON format only, ensuring to include potential allergies for each ingredient.

''';

const ingredientDeepAnalysisPrompt = '''
# Product Safety Analysis Prompt

Analyze the provided images of [PRODUCT_NAME] and generate a comprehensive safety report. Focus on the ingredients list and any visible warnings or claims on the packaging. Your analysis should cover the following aspects:

1. **Ingredient Safety Overview**
   - List all ingredients identified
   - Classify ingredients as safe, potentially harmful, or harmful
   - Highlight any ingredients known to be controversial or under regulatory scrutiny

2. **Allergen Information**
   - Identify and list all potential allergens
   - Mention if the product contains or may contain traces of common allergens (e.g., nuts, dairy, soy, gluten)
   - Note any allergen-related warnings on the packaging

3. **Potential Side Effects**
   - Describe possible side effects from individual ingredients or combinations
   - Indicate severity and likelihood of side effects

4. **Dosage and Usage Safety**
   - Analyze recommended dosage or usage instructions
   - Identify any warnings about excessive use or misuse
   - Note if usage instructions are clear and prominent on the packaging

5. **Interactions and Contraindications**
   - List potential interactions with other substances (e.g., medications, foods)
   - Highlight any contraindications for specific health conditions or demographics

6. **Regulatory Compliance**
   - Check for required safety labeling and warnings
   - Note any claims that may require verification (e.g., "clinically proven", "all-natural")

7. **Environmental and Ethical Considerations**
   - Identify ingredients with known environmental impacts
   - Note any claims about sustainability, cruelty-free status, or ethical sourcing

8. **Overall Safety Rating**
   - Provide a summary safety rating (e.g., Very Safe, Generally Safe, Use with Caution, Potentially Unsafe)
   - Justify the rating based on the analysis

9. **Recommendations**
   - Suggest any additional safety measures or precautions for users
   - Recommend if further research or expert consultation is needed

Format the report with clear headings, bullet points, and emphasis on key information. Use tables where appropriate to organize data. Conclude with a brief, easy-to-understand summary of the product's safety profile.

''';

const ecoDeepAnalysisPrompt = '''
# Ecological Impact Analysis Prompt

Analyze the provided images of [PRODUCT_NAME] and generate a comprehensive ecological impact report. Focus on the packaging materials, ingredient sources, and any environmental claims or certifications visible on the product. Your analysis should cover the following aspects:

1. **Packaging Assessment**
   - Identify primary packaging materials
   - Evaluate recyclability of each component
   - Assess presence of unnecessary packaging layers
   - Note any innovative or eco-friendly packaging solutions

2. **Recyclability**
   - Provide a recyclability rating for the overall product
   - Detail which components are recyclable, compostable, or neither
   - Identify any recycling symbols or instructions on the packaging
   - Suggest improvements for easier recycling

3. **Material Sourcing**
   - Identify any claims about sustainable sourcing of ingredients or materials
   - Assess the presence of potentially harmful or environmentally damaging materials
   - Note any certifications related to sustainable sourcing (e.g., FSC, RSPO)

4. **Carbon Footprint**
   - Estimate the relative carbon footprint based on packaging and ingredients
   - Identify any carbon-intensive ingredients or processes
   - Note any carbon neutrality claims or offsets mentioned

5. **Water Usage Impact**
   - Assess potential water usage in production
   - Identify any water-intensive ingredients
   - Note any claims about water conservation in manufacturing

6. **Biodegradability**
   - Evaluate the biodegradability of the product and its packaging
   - Identify any persistent chemicals or materials that may harm ecosystems

7. **Energy Efficiency**
   - If applicable, assess the energy efficiency of the product
   - Note any energy-saving features or claims

8. **Waste Reduction**
   - Identify any features designed to minimize waste (e.g., refillable containers, concentrated formulas)
   - Assess the overall waste footprint of the product

9. **Eco-Certifications and Claims**
   - List and explain any eco-certifications present (e.g., USDA Organic, EcoCert, Cradle to Cradle)
   - Evaluate the credibility and significance of environmental claims made

10. **Animal Welfare**
    - Identify any cruelty-free or vegan certifications
    - Assess potential impact on wildlife or ecosystems

11. **End-of-Life Considerations**
    - Describe the likely environmental impact after the product's useful life
    - Suggest optimal disposal methods

12. **Overall Ecological Impact Rating**
    - Provide a summary ecological impact rating (e.g., Low Impact, Moderate Impact, High Impact)
    - Justify the rating based on the analysis

13. **Recommendations**
    - Suggest improvements to reduce ecological impact
    - Recommend alternatives if the product is found to be particularly harmful

Format the report with clear headings, bullet points, and emphasis on key information. Use tables where appropriate to organize data. Conclude with a brief, easy-to-understand summary of the product's ecological impact profile.
''';

const nutrientAnalysisPrompt = '''
# Nutritional Analysis Prompt

Analyze the provided images of [PRODUCT_NAME] and generate a comprehensive nutritional report. Focus on the nutrition facts panel, ingredient list, and any nutritional claims visible on the packaging. Your analysis should cover the following aspects:

NOTE : IF THE PRODUCT IS NOT A CONSUMABLE THEN SIMPLY SAY "NOT APPLICABLE FOR THIS PRODUCT" in proper markdown at the center

## 1. Basic Product Information
- Product name and brand
- Serving size and number of servings per container

## 2. Calorie Content
- Total calories per serving
- Calories from fat (if listed)

## 3. Macronutrients
For each macronutrient, provide:
- Amount per serving
- Percentage of Daily Value (%DV)
- Any specific claims (e.g., "low fat", "high protein")

| Macronutrient | Amount per Serving | % Daily Value |
|---------------|---------------------|---------------|
| Total Fat     |                     |               |
| Saturated Fat |                     |               |
| Trans Fat     |                     |               |
| Cholesterol   |                     |               |
| Sodium        |                     |               |
| Total Carbohydrates |               |               |
| Dietary Fiber |                     |               |
| Total Sugars  |                     |               |
| Added Sugars  |                     |               |
| Protein       |                     |               |

## 4. Micronutrients
List all vitamins and minerals with their amounts per serving and %DV.

## 5. Ingredient Analysis
- List all ingredients in order of predominance
- Highlight any artificial additives, preservatives, or potential allergens
- Identify any whole food ingredients

## 6. Nutritional Claims
- List and explain any nutritional claims on the packaging (e.g., "Good source of fiber", "Low sodium")
- Verify if these claims are supported by the nutritional information

## 7. Dietary Considerations
- Assess suitability for common diets (e.g., vegan, keto, low-carb, gluten-free)
- Identify any potential allergens or sensitivities

## 8. Sugar and Sweeteners
- Analyze total sugar content
- Identify types of sugars or sweeteners used (natural vs. artificial)

## 9. Nutrient Density
- Evaluate the overall nutrient density of the product
- Compare calorie content to beneficial nutrient content

## 10. Portion Size Analysis
- Comment on the reasonableness of the stated serving size
- Calculate nutritional values for the entire package if relevant

## 11. Comparative Analysis
- If possible, compare the nutritional profile to similar products or a "standard" in its category

## 12. Health Impact Summary
- Provide a brief summary of potential health benefits or concerns based on the nutritional profile
- Suggest ideal consumption frequency or amount

## 13. Recommendations
- Offer suggestions for balancing this food in a healthy diet
- Recommend complementary foods to create a balanced meal, if applicable

Format the report with clear headings, subheadings, bullet points, and tables where appropriate. Conclude with a brief, easy-to-understand summary of the product's nutritional profile.
USE PROPER MARKDOWN FOR FORMATTING
''';

const howToUsePrompt = '''
# Product Usage Guide Prompt

Analyze the provided images of [PRODUCT_NAME] and generate a comprehensive, step-by-step guide for using the product. If usage instructions are visible on the packaging, accurately replicate these steps. If not, infer the most likely and safe method of use based on the product type and any visible information. Your guide should include the following elements:

## 1. Product Identification
- Product name and type
- Brief description of its purpose

## 2. Pre-Use Preparation
- Any necessary steps before using the product (e.g., charging, assembly, dilution)
- Required additional items not included with the product

## 3. Safety Precautions
- List all safety warnings visible on the packaging
- Include any standard safety measures for this type of product
- Highlight any specific user groups who should avoid the product

## 4. Step-by-Step Usage Instructions
Provide a numbered list of steps to use the product. For each step:
1. Describe the action clearly and concisely
2. Include any relevant measurements or timings
3. Note any safety considerations specific to that step

Example format:
1. **[Action]**: Description
   - *Safety note*: Any relevant precaution
   - *Tip*: Helpful advice for this step

## 5. Dosage or Application Information
- Specify the correct amount to use
- Frequency of use (if applicable)
- Duration of use (if applicable)

## 6. Storage Instructions
- Proper storage conditions (temperature, humidity, etc.)
- Any specific positioning requirements
- Shelf life information

## 7. Cleaning and Maintenance
- Instructions for cleaning the product after use (if applicable)
- Any regular maintenance required

## 8. Troubleshooting
- Address common issues that might occur during use
- Provide solutions or next steps for these issues

## 9. Disposal Guidelines
- Proper method for disposing of the product or its packaging
- Any recycling information

## 10. Additional Tips
- Offer advice for optimal use of the product
- Suggest any complementary products or methods to enhance the experience

## 11. Warnings and Contraindications
- Reiterate any crucial warnings
- List situations when the product should not be used

## 12. Contact Information
- Note any customer support information provided on the packaging

Format the guide with clear headings, numbered lists for steps, and bullet points for other information. Use bold text for actions and italics for safety notes and tips. If the product has distinct modes or multiple uses, consider creating separate sections for each.

Conclude with a brief summary emphasizing the most crucial points for safe and effective use of the product.

''';

const homeMadeRecipePrompt = '''

Analyze the provided images of [PRODUCT_NAME] and generate a recipe for a homemade version using healthier alternatives. The recipe should be achievable with common kitchen equipment and ingredients. Provide the response in valid JSON format with the following structure:
NOTE : 
1. JUST GIVE ME THE JSON OBJECT, NO ADDITIONAL TEXT OR EXPLANATION
2. All values should be string, even if numbers, they should be string of numbers.
{
  "productName": "Original product name",
  "homemadeVersion": "Name for the homemade alternative",
  "description": "Brief description of the homemade version and its health benefits",
  "servings": "Number of servings the recipe yields",
  "prepTime": "Preparation time in minutes",
  "cookTime": "Cooking time in minutes",
  "totalTime": "Total time in minutes",
  "ingredients": [
    {
      "item": "Ingredient name",
      "amount": "Quantity in string", 
      "unit": "Unit of measurement",
      "notes": "Any special notes about the ingredient (optional)"
    }
  ],
  "equipment": [
    "List of required kitchen equipment"
  ],
  "instructions": [
    {
      "step": "Step number",
      "action": "Detailed instruction for this step",
      "tip": "Optional tip or explanation for this step"
    }
  ],
  "nutritionalInfo": {
    "calories": "Estimated calories per serving",
    "protein": "Grams of protein per serving",
    "carbs": "Grams of carbohydrates per serving",
    "fat": "Grams of fat per serving",
    "fiber": "Grams of fiber per serving"
  },
  "healthBenefits": [
    "List of health benefits compared to the original product"
  ],
  "storageInstructions": "How to store the homemade version",
  "shelfLife": "Expected shelf life of the homemade version",
  "variations": [
    "Suggestions for recipe variations or customizations"
  ],
  "tips": [
    "Additional tips for success or customization"
  ]
}

Ensure all JSON keys and values are properly quoted and the structure is valid. Provide realistic and safe instructions, keeping in mind that this will be prepared in a home kitchen. Focus on using whole food ingredients and healthier alternatives to processed components found in the original product.

''';

// const findTheProductPrompt = '''
// Based on the provided images of [PRODUCT_NAME], generate a single, direct URL to the product listing on a major e-commerce website. Follow these guidelines:

// 1. Identify the exact product name, brand, and any unique identifiers (e.g., model number, size, color) visible in the images.

// 2. Using this information, construct a search query that would likely lead directly to the product on a major e-commerce platform.

// 3. Preferably choose a e-commerce website for searching.

// 4. Based on your knowledge of these websites' URL structures, generate a likely direct URL to the product page.

// 5. Do not include any explanatory text, search suggestions, or multiple options. Provide only the single most likely direct URL.

// 6. If you cannot generate a likely direct URL, respond with only: "URL_NOT_FOUND"

// Respond with only the URL or "URL_NOT_FOUND". Do not include any other text, punctuation, or formatting in your response.
// ''';
