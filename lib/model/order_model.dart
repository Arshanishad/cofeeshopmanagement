import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  String customerName;
  String rejectReason;
  List<String> products;
  int quantity;
  int status;
  double totalPrice;
  DateTime orderDate;
  DocumentReference? reference;
  List search;
  bool delete;
  List<OrderBagModel> bag;
  double grandTotal;


  OrderModel({
    this.id,
    required this.bag,
    required this.customerName,
    required this.products,
    required this.quantity,
    required this.status,
    required this.totalPrice,
    required this.orderDate,
    this.reference,
    required this.search,
    required this.delete,
    required this.grandTotal,
    required this.rejectReason
  });

  OrderModel copyWith({
    String? id,
    String? customerName,
    List<String>? products,
    int? quantity,
    int? status,
    double? totalPrice,
    DateTime? orderDate,
    DocumentReference? reference,
    List?search,
    bool?delete,
    List<OrderBagModel> ?bag,
   double? grandTotal,
    String?rejectReason,


  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      products: products ?? this.products,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      orderDate: orderDate ?? this.orderDate,
      reference: reference??this.reference,
      search: search??this.search,
      delete: delete??this.delete,
      bag: bag??this.bag, grandTotal: grandTotal??this.grandTotal,
      rejectReason: rejectReason??this.rejectReason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'customerName': this.customerName,
      'products': this.products,
      'quantity': this.quantity,
      'status': this.status,
      'totalPrice': this.totalPrice,
      'orderDate': this.orderDate,
      'reference': this.reference,
      'search': this.search,
      'delete':this.delete,
      'bag':this.bag,
      'grandTotal':this.grandTotal,
      'rejectReason':this.rejectReason,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String?,
      customerName: map['customerName'] as String,
      products: List<String>.from(map['products'] as List<dynamic>), // Cast to List<dynamic>
      quantity: map['quantity'] as int,
      status: map['status'] as int,
      totalPrice: map['totalPrice'] as double,
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      reference: map['reference'] as DocumentReference?,
      search: map['search'] as List<dynamic>,
      delete: map['delete'] as bool,
      bag: List<OrderBagModel>.from((map['bag'] as List<dynamic>).map((e) => OrderBagModel.fromMap(e))),
      grandTotal: map['grandTotal'] as double,
      rejectReason: map['rejectReason'] as String,
    );
  }


}
class OrderBagModel {
  String productName;
  int quantity;
  double mrp;
  double productPrice;
  String productId;
  int tax;

  OrderBagModel({
    required this.productName,
    required this.quantity,
    required this.mrp,
    required this.productPrice,
    required this.productId,
    required this.tax,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'mrp': mrp,
      'productPrice': productPrice,
      'productId': productId,
      'tax': tax,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': this.productName,
      'quantity': this.quantity,
      'mrp': this.mrp,
      'productPrice': this.productPrice,
      'productId': this.productId,
      'tax': this.tax,
    };
  }

  factory OrderBagModel.fromMap(Map<String, dynamic> map) {
    return OrderBagModel(
      productName: map['productName'] as String,
      quantity: map['quantity'] as int,
      mrp: map['mrp'] as double,
      productPrice: map['productPrice'] as double,
      productId: map['productId'] as String,
      tax: map['tax'] as int,
    );
  }
}

