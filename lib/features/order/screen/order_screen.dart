import 'dart:convert';
import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:coffee_shop_management/model/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/loader.dart';
import '../../../model/order_model.dart';
import '../controller/order_controller.dart';
import 'order_add.dart';
import 'order_details.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key, });
  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  ProductModel?selectedProduct;
  final searchPurchaseProvider = StateProvider.autoDispose<String>((ref) => '');

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final fromDate=ref.watch(fromDateProvider);
    final toDate=ref.watch(toDateProvider);
    return  Scaffold(

      body: Padding(
        padding: EdgeInsets.all(w * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: h * 0.05,
                width: w,
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    ref
                        .watch(searchPurchaseProvider.notifier)
                        .update((state) => value.trim());
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.02, vertical: w * 0.02),
                    hintText: 'Search orderId',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F4F8),
                    prefixIcon: const Icon(
                      Icons.search_outlined,
                      color: Color(0xFF57636C),
                    ),
                    suffixIcon:
                    ref.watch(searchPurchaseProvider).isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        ref.read(searchPurchaseProvider.notifier).update((state) => "");
                      },
                    )
                        : const Icon(
                      Icons.shop,
                      color: Colors.transparent,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF1D2429),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: h*0.01,),
              Consumer(
                builder: (context, ref, child) {
                  var searchData=ref.watch(searchPurchaseProvider);
                  final dateStream=ref.watch(dateStreamProvider);
                  String? fromDateString=fromDate?.toIso8601String();
                  String? toDateString=toDate?.toIso8601String();
                  Map<String,dynamic> map = {'fromDate': fromDateString, 'toDate': toDateString,
                    "dateSort":dateStream,
                    "status":ref.watch(selectedIndexProvider),
                    "search":searchData};
                  return ref.read(selectedIndexProvider)!=6?ref.watch(getOrdersProvider((jsonEncode(map)))).when(
                    data: (data) {
                      return   data.isEmpty?
                      Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: h*0.3,),
                          Text("No Orders.....!!",style: TextStyle(fontWeight: FontWeight.w600,fontSize: w*0.06),),
                        ],
                      ):
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          OrderModel order = data[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderViewPage(
                                        order:order, id:order.id.toString(),
                                      )));
                            },
                            child: Container(
                              width: w,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius:
                                  BorderRadiusDirectional.circular(
                                      w * 0.02)),
                              child: Padding(
                                padding: EdgeInsets.all(w * 0.03),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Order Date : ",style: TextStyle(
                                            fontSize: w*0.035,fontWeight: FontWeight.w500
                                        ),),
                                        Text(DateFormat('dd-MM-yyyy , hh:mm a').format(data[index].orderDate).toString()
                                          ,style: TextStyle(
                                              fontSize: w*0.035,fontWeight: FontWeight.w500
                                          ),),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Order Id : ",style: TextStyle(
                                            fontSize: w*0.035,fontWeight: FontWeight.w500
                                        ),),
                                        Text(data[index].id.toString(),style: TextStyle(
                                            fontSize: w*0.035,fontWeight: FontWeight.w500
                                        ),),
                                      ],
                                    ),

                                    SizedBox(
                                      height: h*0.01,
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Total Qty : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: w*0.037), ),
                                            Text(data[index].quantity.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: w*0.044), )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Total Amount : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: w*0.037), ),
                                            Text('${data[index].grandTotal.toStringAsFixed(2)} ',style: TextStyle(fontWeight: FontWeight.w500,fontSize: w*0.040), )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: h * 0.01,
                          );
                        },
                      );
                    },
                    error: (error, stackTrace){
                      if(kDebugMode){
                        print(error);
                        print(stackTrace);
                      }
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ):SizedBox();
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedProduct != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddOrderPage(selectedProduct: selectedProduct, ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a product')),
            );
          }
        },
        backgroundColor: Palette.darkRedColor,
        child: Icon(Icons.add, color: Colors.white, size: w * 0.08),
      ),
    );
  }
}
