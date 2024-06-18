import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/upload_message.dart';

import '../../../model/order_model.dart';
import '../../../model/product_model.dart';

import '../repository/order_repository.dart';

final orderControllerProvider = NotifierProvider<OrderController, bool>(() {
  return OrderController();
});
final getOrderProvider = StreamProvider.family.autoDispose((ref, String data) {
  return ref.watch(orderControllerProvider.notifier).getOrder(data: data);
});
final getProductNamesProvider = StreamProvider((ref) {
  return ref.watch(orderControllerProvider.notifier).getProducts();
});

final getOrdersProvider = StreamProvider.family.autoDispose((ref, String map) {
  return ref.watch(orderControllerProvider.notifier).getOrders(map: map);
});


final selectedIndexProvider = StateProvider.autoDispose<int>((ref) => 0);
final fromDateProvider = StateProvider<DateTime?>((ref) {
  return null;
});
final toDateProvider = StateProvider<DateTime?>((ref) {
  return null;
});
final dateStreamProvider = StateProvider<bool>((ref) {
  return false;
});
final salesManIdProvider = StateProvider<String>((ref) {
  return " ";
});
final datePicked1Provider =
    StateProvider.autoDispose<Timestamp?>((ref) => null);
final startDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final endDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);


final getOrderDetailsProvider = StreamProvider.family((ref, String id) => ref.read(orderControllerProvider.notifier).getOrderDetails(id));

class OrderController extends Notifier<bool> {
  @override
  bool build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  OrderRepository get _order => ref.read(orderRepositoryProvider);

  Future<void> orderAdd({
    required OrderModel orderModel,
    required BuildContext context,
  }) async {
    try {
      await _order.orderAdd(orderModel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add order: $e')),
      );
    }
  }


  Stream<QuerySnapshot<Object?>> getOrder({required String data}) {
    Map map = jsonDecode(data);
    return _order.getOrder(map: map);
  }


  Stream<List<ProductModel>> getProducts() {
    return _order.getProducts();
  }


  Stream<List<OrderModel>> getOrders({required String map}) {
    Map<String, dynamic> data = jsonDecode(map);
    return _order.getOrders(data: data);
  }


  Stream<ProductModel> getProduct(String id) {
    return _order.getProduct(id);
  }


  Stream<List<OrderModel>> getPendingOrder(String warehouseId) {
    return _order.getPendingOrder(warehouseId);
  }



  void deleteOrder(String id) {
    _order.deleteOrder(id);
  }


  editOrder({
    required String channel,
    required BuildContext context,
    required double totalPrice,
    required int totalQty,
    required OrderModel orderModel,
  }) async {
    state = true;
    var result = await _order.editOrder(
      totalPrice: totalPrice,
      totalQty: totalQty, ordersModel: orderModel,
    );
    state = false;
    result.fold((l) =>  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to edit order: ')),
    ),(r) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order added successfully!')),
      );      Navigator.pop(context);
    });
  }


  void deleteOrders(OrderModel order) {
    _order.deleteOrders(order);
  }


  Stream<OrderModel>getOrderDetails(String id){
    return _order.getOrderDetails(id);
  }



  acceptOrder({required OrderModel orderModel,required BuildContext context}) async {
    var res=await _order.acceptedOrder(orderModel: orderModel);
    res.fold((l) => showSnackBar( context: context, text: l.toString(), color: true), (r) {
      showSnackBar( context: context, text: 'Order Accepted Successfully', color: true);
    });
  }

  rejectOrder({required OrderModel orderModel,required BuildContext context,required String reject}) async {
    var res=await _order.rejectOrder(orderModel: orderModel,reject: reject);
    res.fold((l) =>  showSnackBar( context: context, text: l.toString(), color: true), (r) {
      showSnackBar( context: context, text: 'Order Accepted Successfully', color: true);
    });
  }

  deliveredOrder({required OrderModel orderModel,required BuildContext context}) async {
    var res = await _order.deliverOrder(orderModel: orderModel);
    res.fold((l) => showSnackBar( context: context, text: l.toString(), color: true), (r) {
      showSnackBar( context: context, text: 'Your Order Delivered Successfully', color: true);
    });
  }

  readyForShipping({required OrderModel orderModel,required BuildContext context}) async {
    var res = await _order.readyforShipping(orderModel: orderModel);
    res.fold((l) =>
        showSnackBar(context: context, text: l.toString(), color: true), (r) {
      showSnackBar(context: context,
          text: "Your Order  Ready For Shipped..",
          color: true);
    });
  }
    cancelOrder({required OrderModel orderModel,required BuildContext context}) async {
    var res = await _order.cancelOrder(  orderModel: orderModel);
    res.fold((l) => showSnackBar( context: context, text: l.toString(), color: true), (r) {
      showSnackBar( context: context, text:  "Your Order Cancelled.", color: true);
    });


  }
  dispatchOrder({required OrderModel orderModel,required BuildContext context}) async {
    var res = await _order.dispatchOrder(orderModel: orderModel);
    res.fold((l) =>
        showSnackBar(context: context, text: l.toString(), color: true), (r) {
      showSnackBar(context: context, text: "Your Order Dispach", color: true);
    });
  }
    pendingOrder({required OrderModel orderModel,required BuildContext context}) async {
    var res = await _order.pendingOrder(  orderModel: orderModel);
    res.fold((l) => showSnackBar( context: context, text: l.toString(), color: true), (r) {
      showSnackBar( context: context, text:  "Your Pending Orders", color: true);
    });


  }
}


