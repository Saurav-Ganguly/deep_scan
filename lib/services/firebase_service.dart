import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_scan/models/product.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadScannedProduct(Product product) async {
    try {
      // Create a unique identifier for the product
      String productId = '${product.company}_${product.name}'
          .toLowerCase()
          .replaceAll(' ', '_');

      // Check if the product already exists
      DocumentSnapshot docSnapshot =
          await _firestore.collection('products').doc(productId).get();

      if (docSnapshot.exists) {
        // Product already exists, update if necessary
        await _firestore
            .collection('products')
            .doc(productId)
            .update(product.toJson());
        print('Product updated: ${product.name}');
      } else {
        // Product doesn't exist, create a new document
        await _firestore
            .collection('products')
            .doc(productId)
            .set(product.toJson());
        print('New product added: ${product.name}');
      }
    } catch (e) {
      print('Error uploading product: $e');
      throw e;
    }
  }

  Future<Product?> getProduct(String company, String name) async {
    try {
      String productId =
          '${company}_${name}'.toLowerCase().replaceAll(' ', '_');
      DocumentSnapshot docSnapshot =
          await _firestore.collection('products').doc(productId).get();

      if (docSnapshot.exists) {
        return Product.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product: $e');
      throw e;
    }
  }

  Stream<List<Product>> streamProductsByType(String type) {
    return _firestore
        .collection('products')
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
