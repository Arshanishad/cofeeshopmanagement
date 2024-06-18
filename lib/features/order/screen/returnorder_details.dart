// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:thara_warehouse_sales_manager/feature/login/controller/login_controller.dart';
// import 'package:thara_warehouse_sales_manager/model/order_model.dart';
// import 'package:thara_warehouse_sales_manager/model/returnOrder_model.dart';
// import '../../../core/common/error_text.dart';
// import '../../../core/common/loader.dart';
// import '../../../core/constants/firebase_constants.dart';
// import '../../../core/pdf/edit_pdf.dart';
// import '../../../core/providers/firebase_providers.dart';
// import '../../../model/distributor_model.dart';
// import '../../../model/invoice.dart';
// import '../../../model/products_model.dart';
// import '../../../model/supermarket_model.dart';
// import '../../../model/warehouse_model.dart';
// import '../controller/order_controller.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'number_to_words.dart';
//
// class ReturnOrderDetails extends ConsumerStatefulWidget {
//   final ReturnOrdersModel returnOrder;
//
//    const ReturnOrderDetails({super.key, required this.returnOrder,});
//
//   @override
//   ConsumerState<ReturnOrderDetails> createState() => _ReturnOrderDetailsState();
// }
//
// class _ReturnOrderDetailsState extends ConsumerState<ReturnOrderDetails> {
//   void deleteOrder(OrdersModel order) {
//     ref.read(orderControllerProvider.notifier).deleteOrder(order);
//   }
//
//   final RoundedLoadingButtonController _loadingController =
//   RoundedLoadingButtonController();
//
//   StreamSubscription? a;
//   TextEditingController editQtyController=TextEditingController();
//
//   checkBlocked(BuildContext context, WidgetRef ref) async {
//     ref.watch(blockedProvider.notifier).update((state) => false);
//     if (currentUserId != null) {
//       a = FirebaseFirestore.instance
//           .collection(FirebaseConstants.salesManagerCollection)
//           .doc(currentUserId)
//           .snapshots()
//           .listen((value) {
//         if (mounted) {
//           if (value.exists) {
//             ref
//                 .watch(blockedProvider.notifier)
//                 .update((state) => value.get("delete"));
//           } else {}
//         }
//       });
//       a?.onDone(() {
//         a?.cancel();
//       });
//     }
//   }
//   List<String> units = [
//     '',
//     'thousand',
//     'million',
//     'billion',
//     'trillion',
//     'quadrillion',
//     'quintillion',
//   ];
//   StateProvider loading = StateProvider((ref) => false);
//   int? loadingIndex;
//
//   String doubleToWords(double value) {
//     String result = '';
//
//     int intValue = value.truncate();
//     double fractionalPart = value - intValue;
//
//     // Convert integer part to words
//     result += _convertToWords(intValue);
//
//     // Add fractional part if it exists
//     if (fractionalPart > 0) {
//       result += ' point ${_convertFractionToWords(fractionalPart)}';
//     }
//
//     return result;
//   }
//
//   String _convertToWords(int value) {
//     if (value == 0) return 'zero';
//
//     List<String> ones = [
//       '',
//       'one',
//       'two',
//       'three',
//       'four',
//       'five',
//       'six',
//       'seven',
//       'eight',
//       'nine',
//       'ten',
//       'eleven',
//       'twelve',
//       'thirteen',
//       'fourteen',
//       'fifteen',
//       'sixteen',
//       'seventeen',
//       'eighteen',
//       'nineteen',
//     ];
//
//     List<String> tens = [
//       '',
//       '',
//       'twenty',
//       'thirty',
//       'forty',
//       'fifty',
//       'sixty',
//       'seventy',
//       'eighty',
//       'ninety',
//     ];
//
//     String result = '';
//
//     int index = 0;
//     do {
//       int segment = value % 1000;
//       if (segment != 0) {
//         result = '${_convertSegmentToWords(segment)} ${units[index]}${result.isNotEmpty ? ' $result' : ''}';
//       }
//       value ~/= 1000;
//       index++;
//     } while (value > 0);
//
//     return result;
//   }
//
//   String _convertSegmentToWords(int value) {
//     List<String> ones = [
//       '',
//       'one',
//       'two',
//       'three',
//       'four',
//       'five',
//       'six',
//       'seven',
//       'eight',
//       'nine',
//       'ten',
//       'eleven',
//       'twelve',
//       'thirteen',
//       'fourteen',
//       'fifteen',
//       'sixteen',
//       'seventeen',
//       'eighteen',
//       'nineteen',
//     ];
//
//     List<String> tens = [
//       '',
//       '',
//       'twenty',
//       'thirty',
//       'forty',
//       'fifty',
//       'sixty',
//       'seventy',
//       'eighty',
//       'ninety',
//     ];
//
//     String result = '';
//
//     int hundreds = value ~/ 100;
//     if (hundreds > 0) {
//       result += '${ones[hundreds]} hundred';
//       value %= 100;
//     }
//
//     if (value > 0) {
//       if (result.isNotEmpty) result += ' and';
//
//       if (value < 20) {
//         result += ' ${ones[value]}';
//       } else {
//         int tensDigit = value ~/ 10;
//         int onesDigit = value % 10;
//         result += ' ${tens[tensDigit]}';
//         if (onesDigit > 0) {
//           result += ' ${ones[onesDigit]}';
//         }
//       }
//     }
//
//     return result;
//   }
//
//   String _convertFractionToWords(double fractionalPart) {
//     // Rounding the fractional part to two decimal places
//     String fractionString = fractionalPart.toStringAsFixed(2).split('.')[1];
//     int fractionValue = int.parse(fractionString);
//     return _convertToWords(fractionValue);
//   }
//
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     checkBlocked(context, ref);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool blocked = ref.watch(blockedProvider);
//     return blocked
//         ? Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: height * 0.5,
//               ),
//               const Center(
//                 child: Text(
//                   'You Are Blocked',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     )
//         : Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           iconTheme: const IconThemeData(color: Colors.white),
//           backgroundColor: Colors.purple,
//           title: const Text("ReturnOrder Details",
//               style: TextStyle(color: Colors.white)),
//           actions: [
//             PopupMenuButton(
//               itemBuilder: (context) {
//                 return [
//                   PopupMenuItem(
//                       child: IconButton(
//                         onPressed: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //       builder: (context) => EditOrderScreen(
//                           //         order: widget.order,
//                           //       ),
//                           //     ));
//                         },
//                         icon: Row(
//                           children: [
//                             Icon(
//                               Icons.edit,
//                               size: width * 0.08,
//                               color: Colors.grey,
//                             ),
//                             const Text("Edit")
//                           ],
//                         ),
//                       )),
//                   if (ref.watch(userProvider)!.role ==
//                       "Zonal Sales Manager" ||
//                       ref.watch(userProvider)!.role ==
//                           "Senior Sales Manager" &&
//                           ref
//                               .watch(salesRoleProvider)
//                               ?.supermarketPurchaseOrder
//                               .delete ==
//                               true ||
//                       ref
//                           .watch(salesRoleProvider)
//                           ?.distributorPurchaseOrder
//                           .delete ==
//                           true)
//                     PopupMenuItem(
//                         child: IconButton(
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   title: const Text("Do you want to delete?"),
//                                   content: Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           // var a =widget.order.copyWith( delete: true );
//                                           // widget.order.reference?.update(a.toMap());
//                                           // deleteOrder(widget.order);
//                                           Navigator.pop(context);
//                                           Navigator.pop(context);
//                                           Navigator.pop(context);
//                                           // Navigator.of(context).popUntil((route) => route.isFirst);
//                                         },
//                                         child: Container(
//                                           height: width * 0.1,
//                                           width: width * 0.15,
//                                           decoration: BoxDecoration(
//                                             color: Colors.purple,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.03),
//                                           ),
//                                           child: const Center(
//                                             child: Text("Yes",
//                                                 style: TextStyle(
//                                                     color: Colors.white)),
//                                           ),
//                                         ),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: Container(
//                                           height: width * 0.1,
//                                           width: width * 0.15,
//                                           decoration: BoxDecoration(
//                                             color: Colors.purple,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.03),
//                                           ),
//                                           child: const Center(
//                                             child: Text("No",
//                                                 style: TextStyle(
//                                                     color: Colors.white)),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                           icon: Row(
//                             children: [
//                               Icon(
//                                 Icons.delete,
//                                 size: width * 0.08,
//                                 color: Colors.grey,
//                               ),
//                               const Text("Delete")
//                             ],
//                           ),
//                         )),
//                 ];
//               },
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(width * 0.04),
//             child: Column(children: [
//               widget.returnOrder.distributorId.isNotEmpty
//                   ? Consumer(builder: (context, ref, child) {
//                 var distributor = ref.watch(
//                     getDistributorDetailsProvider(
//                         widget.returnOrder.distributorId));
//                 return distributor.when(
//                   data: (data) {
//                     return SizedBox(
//                       width: width,
//                       child: Padding(
//                         padding: EdgeInsets.all(width * 0.03),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceAround,
//                             children: [
//                               Text("Distributor : ${data.name}",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: width * 0.04,
//                                       fontWeight: FontWeight.w600)),
//                               Text("Email : ${data.email}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text("Contact No : ${data.phoneNumber}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text(
//                                   "City : ${data.shippingAddress.city}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text(
//                                   "District : ${data.shippingAddress.district}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text(
//                                   "State : ${data.shippingAddress.state}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text(
//                                   "PinCode : ${data.shippingAddress.pinCode.toString()}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   error: (error, stackTrace) =>
//                       ErrorText(error: error.toString()),
//                   loading: () => const Loader(),
//                 );
//               })
//                   : Consumer(builder: (context, ref, child) {
//                 var superMarket = ref.watch(
//                     getSuperMarketDetailsProvider(
//                         widget.returnOrder.supermarketId));
//                 return superMarket.when(
//                   data: (data) {
//                     return SizedBox(
//                       width: width,
//                       child: Padding(
//                         padding: EdgeInsets.all(width * 0.03),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceAround,
//                             children: [
//                               Text("SuperMarket : ${data.name}",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: width * 0.04,
//                                       fontWeight: FontWeight.w600)),
//                               Text("Contact No : ${data.phoneNumber}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text("City : ${data.address.city}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text(
//                                   "District : ${data.address.district}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text("State : ${data.address.state}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                               Text(
//                                   "PinCode : ${data.address.pinCode.toString()}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.04,
//                                       color: Colors.black)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   error: (error, stackTrace) =>
//                       ErrorText(error: error.toString()),
//                   loading: () => const Loader(),
//                 );
//               }),
//               SizedBox(
//                 height: height * 0.01,
//               ),
//               SizedBox(
//                 child: Consumer(builder: (context, ref, child) {
//                   return ref
//                       .watch(getWareHouseProvider(widget.returnOrder.wareHouseId))
//                       .when(
//                     data: (data) {
//                       return Column(
//                         children: [
//                           SizedBox(
//                             width: width,
//                             child: Padding(
//                               padding: EdgeInsets.all(width * 0.03),
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text("WareHouse : ${data.name}",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * 0.04,
//                                           fontWeight: FontWeight.w600)),
//                                   Text("City : ${data.address.city}",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: width * 0.04,
//                                           color: Colors.black)),
//                                   Text(
//                                       "District : ${data.address.district}",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: width * 0.04,
//                                           color: Colors.black)),
//                                   Text("State : ${data.address.state}",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: width * 0.04,
//                                           color: Colors.black)),
//                                   Text(
//                                       "PinCode : ${data.address.pinCode.toString()}",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: width * 0.04,
//                                           color: Colors.black)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: height * 0.01,
//                           ),
//                           SizedBox(
//                             width: width * 2.4,
//                             child: Padding(
//                               padding: EdgeInsets.all(width * 0.02),
//                               child: Column(
//                                 children: [
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     physics:
//                                     const AlwaysScrollableScrollPhysics(),
//                                     child: SizedBox(
//                                       width: width * 2.75,
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment
//                                                 .spaceBetween,
//                                             children: [
//                                               SizedBox(
//                                                 width: width * 0.1,
//                                                 child: Text(
//                                                   'SI.',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.036,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.4,
//                                                 child: Text(
//                                                   'Name',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.036,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.25,
//                                                 child: Text(
//                                                   'Qty',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.036,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.25,
//                                                 child: Text(
//                                                   'Mrp',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.038,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.25,
//                                                 child: Text(
//                                                   'UnitPrice',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.038,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.25,
//                                                 child: Text(
//                                                   'Tax',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.036,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.23,
//                                                 child: Text(
//                                                   'SGST',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.036,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.23,
//                                                 child: Text(
//                                                   'CGST',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.036,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.28,
//                                                 child: Text(
//                                                   'Price',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.036,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width * 0.25,
//                                                 child: Text(
//                                                   'TotalPrice',
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w600,
//                                                     fontSize:
//                                                     width * 0.036,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: width*0.24,
//                                               )
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: height * 0.01,
//                                           ),
//                                           ListView.separated(
//                                             shrinkWrap: true,
//                                             scrollDirection:
//                                             Axis.vertical,
//                                             physics:
//                                             const NeverScrollableScrollPhysics(),
//                                             itemCount:
//                                             widget.returnOrder.bag.length,
//                                             itemBuilder:
//                                                 (context, index) {
//                                               return Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceBetween,
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment
//                                                     .start,
//                                                 children: [
//                                                   SizedBox(
//                                                     width: width * 0.06,
//                                                     child: Text(
//                                                       (index + 1)
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.34,
//                                                     child: Text(
//                                                       widget
//                                                           .returnOrder
//                                                           .bag[index]
//                                                           .productName,
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.20,
//                                                     child: Text(
//                                                       widget
//                                                           .returnOrder
//                                                           .bag[index]
//                                                           .quantity
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.22,
//                                                     child: Text(
//                                                       widget
//                                                           .returnOrder
//                                                           .bag[index]
//                                                           .mrp
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.2,
//                                                     child: Text(
//                                                       widget
//                                                           .returnOrder
//                                                           .bag[index]
//                                                           .unitPrice
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.19,
//                                                     child: Text(
//                                                       widget
//                                                           .returnOrder
//                                                           .bag[index]
//                                                           .tax
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.19,
//                                                     child: Text(
//                                                       (((widget.returnOrder.bag[index].tax * widget.returnOrder.bag[index].mrp / 100) *
//                                                           widget
//                                                               .returnOrder
//                                                               .bag[index]
//                                                               .quantity) /
//                                                           2)
//                                                           .toStringAsFixed(2),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.19,
//                                                     child: Text(
//                                                       (((widget.returnOrder.bag[index].tax * widget.returnOrder.bag[index].mrp / 100) *
//                                                           widget
//                                                               .returnOrder
//                                                               .bag[index]
//                                                               .quantity) /
//                                                           2)
//                                                           .toStringAsFixed(2),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.24,
//                                                     child: Text(
//                                                       (widget
//                                                           .returnOrder
//                                                           .bag[
//                                                       index]
//                                                           .mrp *
//                                                           widget
//                                                               .returnOrder
//                                                               .bag[
//                                                           index]
//                                                               .quantity)
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: width * 0.24,
//                                                     child: Text(
//                                                       ((widget.returnOrder.bag[index].mrp *
//                                                           widget
//                                                               .returnOrder
//                                                               .bag[
//                                                           index]
//                                                               .quantity) +
//                                                           (widget
//                                                               .returnOrder
//                                                               .bag[
//                                                           index]
//                                                               .tax *
//                                                               widget
//                                                                   .returnOrder
//                                                                   .bag[index]
//                                                                   .mrp /
//                                                               100))
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//
//                                                   GestureDetector(
//                                                       onTap: () {
//                                                         showDialog(
//                                                           context: context,
//                                                           builder: (BuildContext context) {
//                                                             editQtyController.text=widget.returnOrder.bag[index].quantity.toString();
//                                                             return AlertDialog(
//                                                               title:  Center(child: Text( widget.returnOrder.bag[index].productName,)),
//                                                               content:TextFormField(
//                                                                 textAlignVertical: TextAlignVertical.center,
//                                                                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                                                                 textInputAction: TextInputAction.next,
//                                                                 controller: editQtyController,
//                                                                 keyboardType: TextInputType.number,
//                                                                 cursorColor: Colors.black,
//                                                                 style: const TextStyle(color: Colors.black),
//                                                                 decoration: InputDecoration(
//                                                                     hintText: "Qty",
//                                                                     contentPadding: EdgeInsets.only(left: width * 0.08),
//                                                                     labelText: "Qty",
//                                                                     labelStyle: const TextStyle(
//                                                                       color: Colors.black,
//                                                                     ),
//                                                                     errorBorder: OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.circular(width * 0.09),
//                                                                       borderSide: const BorderSide(color: Colors.black45),
//                                                                     ),
//                                                                     focusedErrorBorder: OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.circular(width * 0.09),
//                                                                       borderSide: const BorderSide(color: Colors.black45),
//                                                                     ),
//                                                                     focusedBorder: OutlineInputBorder(
//                                                                         borderRadius: BorderRadius.circular(width * 0.09),
//                                                                         borderSide: const BorderSide(color: Colors.black45)),
//                                                                     enabledBorder: OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.circular(width * 0.09),
//                                                                       borderSide: const BorderSide(color: Colors.black45),
//                                                                     )),
//                                                               ),
//                                                               actions: [
//                                                                 TextButton(
//                                                                   onPressed: () {
//                                                                     // List<OrderBagModel> orderBags = widget.returnOrder.bag;
//                                                                     // ref.read(orderControllerProvider.notifier).createReturnOrder(widget.returnOrder,context,
//                                                                     //     int.parse(editQtyController.text),widget.returnOrder.bag[index]);
//                                                                     // editQtyController.clear();
//                                                                     // Navigator.pop(context);
//                                                                   },
//                                                                   child: const Text("Return"),
//                                                                 ),
//
//                                                               ],
//                                                             );
//                                                           },
//                                                         );
//                                                       },
//                                                       child: const Icon(Icons.edit,color: Colors.blue,)),
//                                                   SizedBox(
//                                                     width: width*0.02,
//                                                   ),
//
//                                                   GestureDetector(
//                                                       onTap: (){
//
//                                                       },
//                                                       child: const Icon(Icons.delete,color: Colors.red,))
//
//                                                 ],
//
//
//                                               );
//                                             },
//                                             separatorBuilder:
//                                                 (BuildContext context,
//                                                 int index) {
//                                               return SizedBox(
//                                                 height: height * 0.002,
//                                               );
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: height * 0.01,
//                           ),
//                           widget.returnOrder.image.isNotEmpty &&
//                               widget.returnOrder.description.isNotEmpty
//                               ? Column(
//                             children: [
//                               Container(
//                                 height: height * 0.12,
//                                 width: width * 0.35,
//                                 decoration: BoxDecoration(
//                                   borderRadius:
//                                   BorderRadius.circular(5),
//                                   image: DecorationImage(
//                                     image: NetworkImage(
//                                         widget.returnOrder.image),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 "description : ${widget.returnOrder.description}",
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           )
//                               : const SizedBox(),
//                           const Divider(
//                             thickness: 1,
//                             color: Colors.black45,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Total Qty      :",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * (0.03),
//                                           fontWeight: FontWeight.w500)),
//                                   data.address.state != "KERALA"
//                                       ? Text("IGST        :",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * (0.03),
//                                           fontWeight:
//                                           FontWeight.w500))
//                                       : Column(
//                                     children: [
//                                       Text("SGST            :",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize:
//                                               width * (0.03),
//                                               fontWeight:
//                                               FontWeight
//                                                   .w500)),
//                                       Text("CGST            :",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize:
//                                               width * (0.03),
//                                               fontWeight:
//                                               FontWeight
//                                                   .w500)),
//                                     ],
//                                   ),
//                                   Text("Total price   :  ",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * (0.03),
//                                           fontWeight: FontWeight.w500)),
//                                   Text("Grand Total :  ",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * (0.03),
//                                           fontWeight: FontWeight.w500)),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                       widget.returnOrder.totalQuantity
//                                           .toString(),
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * (0.03),
//                                           fontWeight: FontWeight.w500)),
//                                   data.address.state != "KERALA"
//                                       ? Text("${widget.returnOrder.iGst} ",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * (0.03),
//                                           fontWeight:
//                                           FontWeight.w500))
//                                       : Column(
//                                     children: [
//                                       Text("${widget.returnOrder.sGst}",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize:
//                                               width * (0.03),
//                                               fontWeight:
//                                               FontWeight
//                                                   .w500)),
//                                       Text("${widget.returnOrder.cGst}",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize:
//                                               width * (0.03),
//                                               fontWeight:
//                                               FontWeight
//                                                   .w500)),
//                                     ],
//                                   ),
//                                   Text("${widget.returnOrder.totalPrice} ",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * (0.03),
//                                           fontWeight: FontWeight.w600)),
//                                   Text("${widget.returnOrder.grandTotal} ",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width * (0.03),
//                                           fontWeight: FontWeight.w600)),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: width * (0.01),
//                               )
//                             ],
//                           )
//                         ],
//                       );
//                     },
//                     error: (error, stackTrace) =>
//                         ErrorText(error: error.toString()),
//                     loading: () => const Loader(),
//                   );
//                 }),
//               ),
//               SizedBox(
//                 height: height * 0.02,
//               ),
//               if (widget.returnOrder.status == 3 || widget.returnOrder.status == 5)
//                 RoundedLoadingButton(
//                   height: height * 0.055,
//                   width: height * 0.055,
//                   color: Colors.purple.shade600,
//                   controller: _loadingController,
//                   child: const Icon(
//                     Icons.print_outlined,
//                     color: Colors.white,
//                   ),
//                   onPressed: () async {
//                     SuperMarketModel? superMarket;
//                     DistributorModel? distributor;
//                     WareHouseModel? wareHouse;
//                     double totalGstAmount = 0;
//                     wareHouse = await ref.watch(
//                         getWareHouseProvider(widget.returnOrder.wareHouseId)
//                             .future);
//
//                     if (widget.returnOrder.distributorId != "") {
//                       distributor = await ref.watch(
//                           getDistributorDetailsProvider(
//                               widget.returnOrder.distributorId)
//                               .future);
//                     } else {
//                       superMarket = await ref.watch(
//                           getSuperMarketDetailsProvider(
//                               widget.returnOrder.supermarketId)
//                               .future);
//                     }
//                     Map items = {};
//                     List products = [];
//                     ProductModel? productModel;
//                     for (var a in widget.returnOrder.bag) {
//                       productModel = await ref
//                           .watch(getProductProvider(a.productId).future);
//                       items = {
//                         'productName': a.productName,
//                         'price': a.mrp,
//                         'quantity': a.quantity,
//                         'total': a.mrp * a.quantity +
//                             productModel!.tax * a.mrp / 100 * a.quantity,
//                         'gst': productModel.tax,
//                         "gstAmount":
//                         productModel.tax * a.mrp / 100 * a.quantity,
//                       };
//                       products.add(items);
//                     }
//                     List<InvoiceItem> item = [];
//                     double myDouble = widget.returnOrder.grandTotal;
//                     NumberToWordsConverter converter =
//                     NumberToWordsConverter();
//                     String words = converter.doubleToWords(myDouble);
//                     for (var data in products) {
//                       item.add(
//                         InvoiceItem(
//                             description: data['productName'],
//                             gst: data['gst'],
//                             price: data['price'],
//                             quantity: data['quantity'],
//                             tax: data['quantity'] *
//                                 data['price'] *
//                                 100 /
//                                 (100 + data['gst']),
//                             total: data['total'],
//                             unitPrice: data['price'],
//                             gstAmount: data["gstAmount"]),
//                       );
//                       totalGstAmount = totalGstAmount + data["gstAmount"];
//                     }
//                     final invoice = Invoice(
//                       invoiceNo: widget.returnOrder.invoice,
//                       discount: 000000,
//                       invoiceNoDate: widget.returnOrder.purchaseDate,
//                       orderId: widget.returnOrder.id,
//                       shipping: 00000,
//                       orderDate: widget.returnOrder.purchaseDate,
//                       total: widget.returnOrder.grandTotal,
//                       price: widget.returnOrder.totalPrice,
//                       // gst: widget.order.tax,
//                       amount: words,
//                       method: widget.returnOrder.paymentMode,
//                       b2b: false,
//                       shippingAddress: [
//                         ShippingAddress(
//                           gst: widget.returnOrder.distributorId != ""
//                               ? distributor!.gst
//                               : "",
//                           name: widget.returnOrder.distributorId != ""
//                               ? distributor!.name
//                               : superMarket!.name,
//                           area: widget.returnOrder.distributorId != ""
//                               ? distributor!.shippingAddress.city
//                               : superMarket!.address.city,
//                           address: widget.returnOrder.distributorId != ""
//                               ? distributor!.shippingAddress.district
//                               : superMarket!.address.district,
//                           mobileNumber: widget.returnOrder.distributorId != ""
//                               ? distributor!.phoneNumber
//                               : superMarket!.phoneNumber,
//                           pinCode: widget.returnOrder.distributorId != ""
//                               ? "${distributor!.shippingAddress.pinCode}"
//                               : "${superMarket!.address.pinCode}",
//                           city: widget.returnOrder.distributorId != ""
//                               ? distributor!.shippingAddress.city
//                               : superMarket!.address.city,
//                           state: widget.returnOrder.distributorId != ""
//                               ? distributor!.shippingAddress.state
//                               : superMarket!.address.state,
//                         ),
//                       ],
//                       salesItems: item,
//                     );
//                     await B2cPdfInvoiceApi.generate(
//                         invoice, wareHouse!.address.state, totalGstAmount,);
//                     _loadingController.stop();
//                   },
//                 ),
//             ]),
//           ),
//         ));
//   }
// }
//
