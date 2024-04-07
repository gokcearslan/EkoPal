import 'package:cloud_firestore/cloud_firestore.dart';

  Future<void> addNewType(String typeName,{required String typeValue}) async {

    final CollectionReference collectionReference =
    FirebaseFirestore.instance.collection(typeName);

    await collectionReference
        .add({
      'typeName': typeValue,
    })
        .then((value) => print('New type added to Firestore'))
        .catchError((error) => print('Failed to add type: $error'));
  }

  /// Use below to add new advertisement type or category type
/// example:
///   String name='advertisementTypes';
//     addNewType(name, typeValue: 'Kitap');
//     addNewType(name, typeValue: 'Proje');
//     addNewType(name, typeValue: 'İş');
//     addNewType(name, typeValue: 'Staj');


Future<List<String>> getTypeNames() async {
  List<String> typeNames = [];
  try {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('advertisementTypes').get();

    querySnapshot.docs.forEach((doc) {
      // Assuming 'typeName' is the field in your document that holds the type name
      String typeName = doc['typeName'];
      typeNames.add(typeName);
    });
  } catch (error) {
    // Handle any potential errors
    print('Error fetching type names: $error');
  }
  return typeNames;
}


Future<List<String>> getCategoryNames() async {
  List<String> categoryNames = [];
  try {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('categoryTypes').get();

    querySnapshot.docs.forEach((doc) {
      // Assuming 'typeName' is the field in your document that holds the type name
      String? categoryName = doc['typeName'] as String?;
      if (categoryName != null) {
        categoryNames.add(categoryName);
      }
    });
  } catch (error) {
    // Handle any potential errors
    print('Error fetching type names: $error');
  }
  return categoryNames;
}








