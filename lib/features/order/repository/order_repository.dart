import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/common/search.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/type_def.dart';
import '../../../model/order_model.dart';
import '../../../model/product_model.dart';



final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(firestore: ref.watch(firestoreProvider));
});

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _order =>
      _firestore.collection(FirebaseConstants.ordersCollection);
  CollectionReference get _product =>
      _firestore.collection(FirebaseConstants.productsCollections);

  CollectionReference get _stock =>
      _firestore.collection(FirebaseConstants.stockCollection);


  DocumentReference get _settings => _firestore
      .collection(FirebaseConstants.settingsCollections)
      .doc(FirebaseConstants.settingsCollections);


  Stream<OrderModel> getOrderDetails(String id) {
    return _order.doc(id).snapshots().map(
            (event) => OrderModel.fromMap(event.data() as Map<String, dynamic>));
  }
  Future<int> getUid() async {
    DocumentSnapshot id =
    await _firestore.collection('settings').doc('settings').get();

    int uid = id['orderId'];

    uid++;

    await _firestore
        .collection('settings')
        .doc('settings')
        .update({'orderId': FieldValue.increment(1)});
    return uid;
  }


  FutureEither<OrderModel> orderAdd(OrderModel  orderModel) async {
    try {
      int a = await getUid();
      if (kDebugMode) {
        print("Generated UID: U$a");
      }
      DocumentReference ref = _order.doc("O$a");
      await ref.set(orderModel.toMap());
      if (kDebugMode) {
        print("User document created: U$a");
      }
      var pro = await ref.get();
      if (kDebugMode) {
        print("Fetched created document: ${pro.exists}");
      }
      var copy = orderModel.copyWith(
        reference: ref,
        id: "O$a",
        search: setSearchParam(
            "S$a ${orderModel.customerName} ${orderModel.products} "),
      );
      await ref.update(copy.toMap());
      if (kDebugMode) {
        print("User document updated: U$a");
      }
      return right(copy);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("FirebaseException: ${e.message}");
      }
      return left(Failure(e.message ?? "Firebase Exception occurred"));
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      return left(Failure(e.toString()));
    }
  }

  Stream<QuerySnapshot<Object?>> getOrder({required Map map}) {
    String dropValue = map["dropValue"];
    String search = map["search"];
    return _order
        .where('delete', isEqualTo: false)
        .where("status",
            isEqualTo: dropValue == "Pending Order"
                ? 0
                : dropValue == "Accept Order"
                    ? 1
                    : dropValue == "Reject Order"
                        ? 2
                        : dropValue == "Ready For Shipping"
                            ? 3
                            : dropValue == "Dispatch Order"
                                ? 4
                                : dropValue == "Delivered Order"
                                    ? 5
                                    : dropValue == "Return Order"
                                        ? 6
                                        : 7)
        .where('search',
            arrayContains: search.isEmpty ? null : search.toUpperCase().trim())
        .orderBy('createdDate', descending: true)
        .snapshots();
  }

  Stream<List<ProductModel>> getProducts() {
    return _product
        .where('delete', isEqualTo: false)
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((event) {
      List<ProductModel> product = [];
      for (var i in event.docs) {
        product.add(ProductModel.fromMap(i.data() as Map<String, dynamic>));
      }
      return product;
    });
  }






  Stream<ProductModel> getProduct(String id) {
    return _product
        .doc(id)
        .snapshots()
        .map((event) =>
            ProductModel.fromMap(event.data() as Map<String, dynamic>));
  }


  Stream<List<OrderModel>> getOrders({required Map<String ,dynamic> data}) {
if(data["fromDate"]!=null&&data["toDate"]!=null&&data["dateSort"]==true){
DateTime fromDate=DateTime.parse(data["fromDate"]);
DateTime toDate=DateTime.parse(data["toDate"]);
return _order
    .where("delete",isEqualTo: false)
    .where("orderDate",isGreaterThanOrEqualTo:fromDate)
    .where("orderDate",isLessThanOrEqualTo: toDate)
    .where("status", isEqualTo:data["status"])
    .where('search', arrayContains: data["search"].isEmpty ? null : data["search"].toUpperCase().trim())
    .orderBy('orderDate', descending: true)
    .snapshots().map((event) => event.docs.map((e) => OrderModel.fromMap(e.data() as Map<String,dynamic>)).toList());
}
else{
return _order
    .where("delete",isEqualTo: false)
    .where("status", isEqualTo:data["status"])
    .where('search', arrayContains: data["search"].isEmpty ? null : data["search"].toUpperCase().trim())
    .orderBy('orderDate', descending: true)
    .snapshots().map((event) => event.docs.map((e) => OrderModel.fromMap(e.data() as Map<String,dynamic>)).toList());
}
}



Stream<List<OrderModel>> getPendingOrder(String warehouseId) {
return _order.where("status",isEqualTo: 0).snapshots().map((event) =>  event.docs
    .map((e) =>OrderModel.fromMap(e.data() as Map<String, dynamic>))
.toList());
}


  deleteOrder(String id){
    _order.doc(id).update({
      'delete':true
    });
  }


  Futurevoid editOrder({
    required double totalPrice,
    required int totalQty,
    required OrderModel ordersModel,
  }) async {
    var a=ordersModel.copyWith(
      search: setSearchParam("${ordersModel.customerName.toUpperCase().trim()}"
          " ${ordersModel.id?.toUpperCase().trim()}"
    ),
      totalPrice: totalPrice,
    );
    return right(ordersModel.reference!.update(a.toMap()));
  }




  Futurevoid pendingOrder({required OrderModel orderModel}) async {
    try {
      OrderModel order = orderModel.copyWith(status:0);
      return right(await orderModel.reference!.update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  Futurevoid acceptedOrder({required OrderModel orderModel}) async {
    try {
      OrderModel order = orderModel.copyWith(status:1);
      return right(await orderModel.reference!.update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  Futurevoid rejectOrder({required OrderModel orderModel, required String reject}) async {
    try {
      OrderModel order = orderModel.copyWith(status:2);
      return right(await orderModel.reference!.update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }
  Futurevoid readyforShipping({required OrderModel orderModel}) async {
    try {
      OrderModel order = orderModel.copyWith(status:3);
      return right(await orderModel.reference!.update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }
  Futurevoid dispatchOrder({required OrderModel orderModel}) async {
    try {
      OrderModel order = orderModel.copyWith(status:4);
      return right(await orderModel.reference!.update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }
  Futurevoid deliverOrder({required OrderModel orderModel}) async {
    try {
      OrderModel order = orderModel.copyWith(status:5);
      return right(await orderModel.reference!.update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }
  Futurevoid returnOrder({required OrderModel orderModel}) async {
    try {
      OrderModel order = orderModel.copyWith(status:6);
      return right(await orderModel.reference!.update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }
  Futurevoid cancelOrder({required OrderModel orderModel}) async {
    try {
      OrderModel order = orderModel.copyWith(status:7);
      return right(await orderModel.reference!.update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }


  void deleteOrders(OrderModel order) {
    OrderModel ordersModel=order.copyWith(delete: true, );
    ordersModel.reference?.update(ordersModel.toMap());
  }


}

