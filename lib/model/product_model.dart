import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  final String id;
  final String category;
  final String productName;
  final String description;
  final double tax;
  final double mrp;
  final int status;
  final bool delete;
  final DocumentReference? reference;
  final DateTime createdTime;
  final List<String> search;
  final String image;

//<editor-fold desc="Data Methods">
  const ProductModel(  {
    required this.id,
    required this.category,
    required this.productName,
    required this.description,
    required this.tax,
    required this.mrp,
    required this.status,
    required this.delete,
    this.reference,
    required this.createdTime,
    required this.search,
    required this.image,
  });

  ProductModel copyWith({
    String? id,
    String? categoryId,
    String? productName,
    String? description,
    double? tax,
    double? mrp,
    int? status,
    bool? delete,
    DocumentReference? reference,
    DateTime? createdTime,
    List<String>? search,
    String? image,
  }) {
    return ProductModel(
      id: id ?? this.id,
      category: categoryId ?? this.category,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      tax: tax ?? this.tax,
      mrp: mrp ?? this.mrp,
      status: status ?? this.status,
      delete: delete ?? this.delete,
      reference: reference ?? this.reference,
      createdTime: createdTime ?? this.createdTime,
      search: search ?? this.search,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': category,
      'productName': productName,
      'description': description,
      'tax': tax,
      'mrp': mrp,
      'status': status,
      'delete': delete,
      'reference': reference,
      'createdTime': createdTime,
      'search': search,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      category: map['category'] as String? ?? "",
      productName: map['productName'] as String? ?? "",
      description: map['description'] as String? ?? "",
      tax: double.tryParse(map['tax'].toString()) ?? 0.0,
      mrp: double.tryParse(map['mrp'].toString()) ?? 0.0,
      status: map['status'] as int? ?? 0,
      delete: map['delete'] as bool? ?? false,
      reference: map['reference'] as DocumentReference?,
      createdTime: (map['createdTime'] as Timestamp).toDate(),
      search: (map['search'] as List<dynamic>?)
          ?.map((e) => e.toString())
          ?.toList() ?? [],
      image: map['image'] as String,
    );
  }
}






