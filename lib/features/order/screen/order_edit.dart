// import  'dart:async';
// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import '../../../core/common/error_text.dart';
// import '../../../core/common/globals.dart';
// import '../../../core/common/loader.dart';
// import '../../../core/common/utils.dart';
// import '../../../core/constants/firebase_constants.dart';
// import '../../../core/providers/firebase_providers.dart';
// import '../../../model/order_model.dart';
// import '../../../model/product_model.dart';
// import '../controller/order_controller.dart';
//
// class EditOrderScreen extends ConsumerStatefulWidget {
//   final OrdersModel order;
//   const EditOrderScreen({super.key,required this.order});
//
//   @override
//   ConsumerState<EditOrderScreen> createState() => _EditOrderScreenState();
// }
//
// class _EditOrderScreenState extends ConsumerState<EditOrderScreen> {
//
//
//
//   void confirmBox({
//     required BuildContext context,
//     required String content,
//     required String actionText,
//     required Function onPressed,
//   }) {
//     showDialog(
//       context: context,
//       builder: (context1) => AlertDialog(
//         contentTextStyle: const TextStyle(
//           fontWeight: FontWeight.w500,
//           color: Colors.black,
//           fontSize: 16.0,
//         ),
//         actionsAlignment: MainAxisAlignment.center,
//         backgroundColor: Colors.white,
//         contentPadding: const EdgeInsets.all(20.0),
//         content: SizedBox(
//           width: 250.0,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 content,
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             style: TextButton.styleFrom(
//               minimumSize: const Size(100.0, 50.0),
//               backgroundColor: Colors.grey[300],
//             ),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               onPressed();
//               Navigator.pop(context);
//             },
//             style: TextButton.styleFrom(
//               minimumSize: const Size(100.0, 50.0),
//               backgroundColor: Colors.blue,
//             ),
//             child: Text(
//               actionText,
//               style: const TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(purchaseDateProvider.notifier).update((state) => widget.order.purchaseDate);
//       ref.read(dropDownProvider.notifier).update((state) => widget.order.paymentMode);
//       ref.read(productList.notifier).update((state) => widget.order.bag);
//       invoice1Controller = TextEditingController(text: widget.order.invoice1);
//       ref.read(grandTotalProvider.notifier).update((state) => widget.order.grandTotal);
//       ref.read(totalQtyProvider.notifier).update((state) => widget.order.totalQuantity!);
//       ref.read(totalPriceProvider.notifier).update((state) => widget.order.totalPrice);
//       ref.read(gstAmountProvider.notifier).update((state) => widget.order.sGst+widget.order.cGst+widget.order.iGst);
//       ref.read(dropProvider.notifier).update((state) => widget.order.channel);
//     });
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//   }
//
//   final dropDownProvider = StateProvider<String?>((ref) {
//     return null;
//   });
//   final dropProvider = StateProvider<String?>((ref) {
//     return null;
//   });
//   final customerProvider = StateProvider<String?>((ref) {
//     return null;
//   });
//   final purchaseDateProvider = StateProvider<DateTime?>((ref) {
//     return null;
//   });
//   final selectedDistributorName = StateProvider<String>((ref) {
//     return "";
//   });
//   final selectedDistributorId = StateProvider<String>((ref) {
//     return "";
//   });
//
//   final selectedSuperMarketName = StateProvider<String>((ref) {
//     return "";
//   });
//   final selectedSuperMarketId = StateProvider<String>((ref) {
//     return "";
//   });
//   final selectedProductId = StateProvider<String?>((ref) {
//     return null;
//   });
//   final productList = StateProvider<List<OrderBagModel>>((ref) {
//     return [];
//   });
//   final editUpdateBool = StateProvider<bool>((ref) {
//     return false;
//   });
//   final editIndex = StateProvider<int?>((ref) {
//     return null;
//   });
//   final totalPriceProvider = StateProvider<double>((ref) {
//     return 0.00;
//   });
//   final totalQtyProvider = StateProvider<int>((ref) {
//     return 0;
//   });
//   final selectedProductName = StateProvider<String>((ref) {
//     return " ";
//   });
//   final gstAmountProvider = StateProvider<double>((ref) {
//     return 0.00;
//   });
//   final grandTotalProvider = StateProvider<double>((ref) {
//     return 0.00;
//   });
//   final productModelProvider = StateProvider<ProductModel?>((ref) {
//     return null;
//   });
//   final batchCheckProvider = StateProvider<bool>((ref) {
//     return false;
//   });
//
//   final _formKey = GlobalKey<FormState>();
//   final _formKey1 = GlobalKey<FormState>();
//   TextEditingController invoice1Controller = TextEditingController();
//   TextEditingController qtyController = TextEditingController();
//   TextEditingController availableQtyController = TextEditingController();
//   TextEditingController productMrpController = TextEditingController();
//   TextEditingController unitPriceController = TextEditingController();
//   FocusNode productMrpFocusNode = FocusNode();
//
//   bool isEditable = false;
//
//   Color getBorderColor() {
//     return isEditable ? Colors.black : Colors.grey;
//   }
//
//
//
//   /// date
//   Future<void> _selectedToDate(
//       {required BuildContext context, required WidgetRef ref}) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime.now(),
//         lastDate: DateTime(2035, 8));
//     if (picked != null && picked != ref.read(purchaseDateProvider)) {
//       ref.read(purchaseDateProvider.notifier).update((state) =>
//           DateTime(picked.year, picked.month, picked.day, 23, 59, 59));
//     }
//   }
//
//   editOrder({
//     required BuildContext context,
//     required WidgetRef ref,
//     required double cGst,
//     required double iGst,
//     required double sGst,
//   }) {
//     final supermarketId = ref.read(selectedSuperMarketId);
//     if (_formKey.currentState!.validate()) {
//       ref.read(orderControllerProvider.notifier).editOrder(
//         totalQty: ref.read(totalQtyProvider),
//         totalPrice: ref.read(totalPriceProvider),
//         bag: ref.watch(productList),
//         paymentMode: ref.read(dropDownProvider)!,
//         context: context,
//         cGst: cGst,
//         iGst: iGst,
//         sGst: sGst,
//         channel: ref.read(dropProvider)!,
//         grandTotal: ref.watch(grandTotalProvider),
//         ordersModel: widget.order,
//       );
//     }
//     productMrpController.clear();
//     qtyController.clear();
//     invoice1Controller.clear();
//     ref.read(productList.notifier).update((state) => []);
//     ref.read(purchaseDateProvider.notifier).update((state) => null);
//     ref.read(dropDownProvider.notifier).update((state) => null);
//     ref.read(selectedDistributorName.notifier).update((state) => "");
//     ref.read(selectedDistributorId.notifier).update((state) => "");
//     Navigator.pop(context);
//   }
//
//   /// edit confirm
//   void editConfirmAlertBox({
//     required WidgetRef ref,
//     required double cGst,
//     required double iGst,
//     required double sGst,
//   }) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context1) => AlertDialog(
//         contentTextStyle: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//             fontSize: w * 0.032),
//         actionsAlignment: MainAxisAlignment.center,
//         backgroundColor: Colors.grey,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(w * 0.01)),
//         actionsPadding: EdgeInsets.only(bottom: h * 0.05),
//         content: SizedBox(
//           height: h * 0.15,
//           width: w * 0.25,
//           child: const Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Are You Sure Edit This ?'),
//             ],
//           ),
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               minimumSize: Size(w * 0.11, h * 0.06),
//               backgroundColor: Colors.white,
//             ),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                   fontSize: w * 0.03,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             ),
//           ),
//           SizedBox(
//             width: w * 0.02,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               editOrder(
//                 ref: ref,
//                 context: context1,
//                 cGst: cGst,
//                 iGst: iGst,
//                 sGst: sGst,
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               minimumSize: Size(w * 0.11, h * 0.06),
//               backgroundColor: Colors.white,
//             ),
//             child: Text(
//               '  Edit  ',
//               style: TextStyle(
//                   fontSize: w * 0.03,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     invoice1Controller.dispose();
//     qtyController.dispose();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Order",style:GoogleFonts.philosopher(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: w * 0.05),),
//         backgroundColor: Colors.purple.shade600,
//         centerTitle: true,
//         leading: IconButton(
//             hoverColor: Colors.grey,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//               size: w * (0.06),
//             )),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(w * 0.04),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(w * 0.02),
//             child: Column(
//               children: [
//                 Consumer(builder: (context, ref, child) {
//                   final purchaseDate =
//                   ref.watch(purchaseDateProvider);
//                   final gstAmount = ref.watch(gstAmountProvider);
//                   Map<String, dynamic> productNameToId = {};
//                   Map<String, dynamic> productNameToModel = {};
//                   final product = ref.watch(productList);
//                   return Column(
//                     mainAxisAlignment:
//                     MainAxisAlignment.spaceAround,
//                     children: [
//                       SizedBox(
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               Column(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment
//                                     .spaceAround,
//                                 children: [
//                                   Column(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment
//                                         .spaceAround,
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment
//                                         .start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment
//                                             .spaceBetween,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Container(
//                                             height: h *
//                                                 0.06,
//                                             width:
//                                             w * 0.5,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                 BorderRadius.circular(
//                                                     10),
//                                                 border: Border.all(
//                                                     color: Colors
//                                                         .grey)),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment
//                                                   .spaceEvenly,
//                                               children: [
//                                                 purchaseDate !=
//                                                     null
//                                                     ? Text(
//                                                     DateFormat('dd/MM/yyyy')
//                                                         .format(
//                                                         purchaseDate),
//                                                     style: const TextStyle(
//                                                         color: Colors
//                                                             .black,
//                                                         fontWeight: FontWeight
//                                                             .w500))
//                                                     : Text(
//                                                     "Choose Purchase Date",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: w * (0.032),
//                                                         fontWeight: FontWeight
//                                                             .w500)),
//                                                 InkWell(
//                                                     onTap:
//                                                         () {
//                                                       _selectedToDate(
//                                                           context: context,
//                                                           ref: ref);
//                                                     },
//                                                     child:
//                                                     Icon(
//                                                       Icons
//                                                           .calendar_month,
//                                                       color:
//                                                       Colors.grey,
//                                                       size: w *
//                                                           (0.08),
//                                                     ))
//                                               ],
//                                             ),
//                                           ),
//                                           Consumer(builder:
//                                               (context3,
//                                               ref3,
//                                               child3) {
//                                             return SizedBox(
//                                               height:
//                                               h *
//                                                   0.07,
//                                               width: w *
//                                                   0.35,
//                                               child: Theme(
//                                                 data: Theme.of(
//                                                     context)
//                                                     .copyWith(
//                                                   splashColor:
//                                                   Colors
//                                                       .transparent,
//                                                   highlightColor:
//                                                   Colors
//                                                       .transparent,
//                                                   hoverColor:
//                                                   Colors
//                                                       .white,
//                                                 ),
//                                                 child:
//                                                 DropdownButtonFormField(
//                                                   focusColor:
//                                                   Colors
//                                                       .transparent,
//                                                   validator:
//                                                       (value3) {
//                                                     var val2 =
//                                                         value3 ??
//                                                             '';
//                                                     if (val2
//                                                         .isEmpty) {
//                                                       return 'Please Select a PaymentMode';
//                                                     }
//                                                     return null;
//                                                   },
//                                                   decoration:
//                                                   InputDecoration(
//                                                     contentPadding: EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: w *
//                                                             0.01,
//                                                         vertical:
//                                                         w * 0.02),
//                                                     hintText:
//                                                     'PaymentMode',
//                                                     hintStyle:
//                                                     const TextStyle(
//                                                         color: Colors.black),
//                                                     enabledBorder:
//                                                     OutlineInputBorder(
//                                                       borderRadius:
//                                                       BorderRadius.circular(
//                                                           h * 0.01),
//                                                       borderSide:
//                                                       const BorderSide(
//                                                           color: Colors.grey),
//                                                     ),
//                                                     border: OutlineInputBorder(
//                                                         borderRadius: BorderRadius
//                                                             .circular(w *
//                                                             0.01),
//                                                         borderSide:
//                                                         const BorderSide(
//                                                             color: Colors
//                                                                 .grey)),
//                                                     focusedBorder:
//                                                     OutlineInputBorder(
//                                                       borderRadius:
//                                                       BorderRadius.circular(
//                                                           h * 0.01),
//                                                       borderSide:
//                                                       const BorderSide(
//                                                         color:
//                                                         Colors.grey,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   dropdownColor:
//                                                   Colors
//                                                       .white,
//                                                   value: ref3
//                                                       .watch(
//                                                       dropDownProvider),
//                                                   onChanged:
//                                                       (String?
//                                                   newValue) {
//                                                     ref3.read(dropDownProvider
//                                                         .notifier).update((
//                                                         state) =>
//                                                     newValue);
//                                                   },
//                                                   items:
//                                                   <String>[
//                                                     'Cash',
//                                                     'Cheque',
//                                                     "Bank",
//                                                   ].map<DropdownMenuItem<
//                                                       String>>((String
//                                                   value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value:
//                                                       value,
//                                                       child:
//                                                       Text(
//                                                         value,
//                                                         style:
//                                                         TextStyle(
//                                                             fontSize: w * 0.03,
//                                                             color: Colors
//                                                                 .black),
//                                                       ),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   // SizedBox(
//                                   //   height: height * 0.02,
//                                   // ),
//
//                                   SizedBox(
//                                     height: h * 0.02,
//                                   ),
//
//                                   Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment
//                                         .spaceBetween,
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment
//                                         .center,
//                                     children: [
//                                       SizedBox(
//                                         width:
//                                         w * (0.45),
//                                         child:
//                                         TextFormField(
//                                           style: const TextStyle(
//                                               color: Colors
//                                                   .black),
//                                           onChanged:
//                                               (value) {
//                                             setState(() {});
//                                           },
//                                           keyboardType:
//                                           TextInputType
//                                               .text,
//                                           controller:
//                                           invoice1Controller,
//                                           cursorColor:
//                                           Colors.black,
//                                           validator:
//                                               (value) {
//                                             var val =
//                                                 value ?? '';
//                                             if (val
//                                                 .trim()
//                                                 .isEmpty) {
//                                               return 'Please Enter a InvoiceNumber';
//                                             }
//                                             return null;
//                                           },
//                                           decoration:
//                                           InputDecoration(
//                                             prefix:
//                                             const Text(
//                                                 ""),
//                                             labelText:
//                                             "invoiceNumber",
//                                             labelStyle: const TextStyle(
//                                                 color: Colors
//                                                     .black,
//                                                 fontWeight:
//                                                 FontWeight
//                                                     .w500),
//                                             hintText:
//                                             "invoiceNumber",
//                                             hintStyle: const TextStyle(
//                                                 color: Colors
//                                                     .black,
//                                                 fontWeight:
//                                                 FontWeight
//                                                     .w500),
//                                             contentPadding: EdgeInsets.only(
//                                                 left: w *
//                                                     0.03,
//                                                 top: h *
//                                                     0.015),
//                                             border: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(h *
//                                                     0.01),
//                                                 borderSide:
//                                                 const BorderSide(
//                                                     color:
//                                                     Colors.grey)),
//                                             focusedBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(h *
//                                                     0.01),
//                                                 borderSide:
//                                                 const BorderSide(
//                                                     color:
//                                                     Colors.grey)),
//                                             focusedErrorBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(h *
//                                                     0.01),
//                                                 borderSide:
//                                                 const BorderSide(
//                                                     color:
//                                                     Colors.red)),
//                                             errorBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(h *
//                                                     0.01),
//                                                 borderSide:
//                                                 const BorderSide(
//                                                     color:
//                                                     Colors.red)),
//                                             enabledBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(h *
//                                                     0.01),
//                                                 borderSide:
//                                                 const BorderSide(
//                                                     color:
//                                                     Colors.grey)),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: h * (0.04),
//                               ),
//                               Center(
//                                 child: Text(
//                                   "Select Products",
//                                   style: GoogleFonts
//                                       .philosopher(
//                                       color:
//                                       Colors.black,
//                                       fontWeight:
//                                       FontWeight
//                                           .bold,
//                                       fontSize:
//                                       w * 0.05),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: h * (0.02),
//                               ),
//                               Form(
//                                 key: _formKey1,
//                                 child: Consumer(builder:
//                                     (context3, ref3,
//                                     child3) {
//                                   final productName =
//                                   ref.watch(
//                                       selectedProductName);
//                                   final totalPrice =
//                                   ref.watch(
//                                       totalPriceProvider);
//                                   final grandTotal =
//                                   ref.watch(
//                                       grandTotalProvider);
//                                   final productM = ref.watch(
//                                       productModelProvider);
//                                   final totalQty =
//                                   ref.watch(
//                                       totalQtyProvider);
//                                   return ref3
//                                       .watch(
//                                       getProductNamesProvider)
//                                       .when(
//                                     data: (data) {
//                                       Map<String,
//                                           dynamic>
//                                       items = {};
//                                       for (var a
//                                       in data) {
//                                         items[a.productName] =
//                                             a.id;
//                                         productNameToId[
//                                         a
//                                             .id] = a
//                                             .productName;
//                                         productNameToModel[
//                                         a.productName] = a;
//                                       }
//                                       items["Select Product"] =
//                                       "Select Product";
//                                       List<String>
//                                       productDropdown =
//                                       items.keys
//                                           .toList();
//                                       return Column(
//                                         children: [
//                                           Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment
//                                                 .center,
//                                             mainAxisAlignment:
//                                             MainAxisAlignment
//                                                 .spaceEvenly,
//                                             children: [
//                                               Consumer(builder:
//                                                   (context,
//                                                   ref,
//                                                   child) {
//                                                 return SizedBox(
//                                                   width:
//                                                   w * 0.9,
//                                                   child:
//                                                   Theme(
//                                                     data:
//                                                     Theme.of(context).copyWith(
//                                                       splashColor: Colors
//                                                           .transparent,
//                                                       highlightColor: Colors
//                                                           .transparent,
//                                                       hoverColor: Colors.white,
//                                                     ),
//                                                     child: DropdownButtonHideUnderline(
//                                                         child: CustomDropdown
//                                                             .search(
//                                                           validator: (value3) {
//                                                             var val2 = value3 ??
//                                                                 '';
//                                                             if (val2.isEmpty ||
//                                                                 val2 ==
//                                                                     "Select Product") {
//                                                               return 'Please Select Product';
//                                                             }
//                                                             return null;
//                                                           },
//                                                           initialItem: productDropdown
//                                                               .contains(
//                                                               productName)
//                                                               ? productName
//                                                               : "Select Product",
//                                                           hintText: productDropdown
//                                                               .contains(
//                                                               productName)
//                                                               ? productName
//                                                               : "Select Product",
//                                                           searchHintText: "Select Product",
//                                                           decoration: CustomDropdownDecoration(
//                                                             closedBorder: Border
//                                                                 .all(
//                                                                 color: Colors
//                                                                     .grey),
//                                                             headerStyle: TextStyle(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 fontSize: w *
//                                                                     (0.03),
//                                                                 fontWeight: FontWeight
//                                                                     .w500),
//                                                             hintStyle: TextStyle(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 fontSize: w *
//                                                                     (0.02),
//                                                                 fontWeight: FontWeight
//                                                                     .w500),
//                                                             searchFieldDecoration: const SearchFieldDecoration(
//                                                               hintStyle: TextStyle(
//                                                                   color: Colors
//                                                                       .black),
//                                                               textStyle: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontWeight: FontWeight
//                                                                       .w500),
//                                                             ),
//                                                           ),
//                                                           items: productDropdown,
//                                                           onChanged: (value) {
//                                                             ref3.watch(
//                                                                 selectedProductId
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) => items[value]);
//                                                             ref3.watch(
//                                                                 selectedProductName
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) => value
//                                                                 .toString());
//                                                             ProductModel productModel = productNameToModel[value];
//                                                             productMrpController
//                                                                 .text =
//                                                                 productModel.mrp
//                                                                     .toString();
//                                                             ref.read(
//                                                                 productModelProvider
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) => productModel);
//                                                           },
//                                                         )),
//                                                   ),
//                                                 );
//                                               }),
//
//                                               SizedBox(
//                                                 height: h *
//                                                     0.02,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   SizedBox(
//                                                     width:
//                                                     w * 0.4,
//                                                     child:
//                                                     TextFormField(
//                                                       onChanged: (value) {
//                                                         if (value.isNotEmpty) {
//                                                           if (int.parse(
//                                                               qtyController
//                                                                   .text) >
//                                                               int.parse(
//                                                                   availableQtyController
//                                                                       .text)) {
//                                                             qtyController.text =
//                                                                 availableQtyController
//                                                                     .text;
//                                                           }
//                                                           setState(() {});
//                                                         }
//                                                       },
//                                                       inputFormatters: [
//                                                         FilteringTextInputFormatter
//                                                             .digitsOnly
//                                                       ],
//                                                       style: const TextStyle(
//                                                           color: Colors.black),
//                                                       keyboardType: TextInputType
//                                                           .number,
//                                                       controller: qtyController,
//                                                       cursorColor: Colors.black,
//                                                       validator: (value) {
//                                                         RegExp regex = RegExp(
//                                                             r'^\d+(\.\d+)?$');
//                                                         if (!regex.hasMatch(
//                                                             value!)) {
//                                                           return "Please Enter the quantity";
//                                                         }
//                                                         return null;
//                                                       },
//                                                       decoration: InputDecoration(
//                                                         labelText: "quantity",
//                                                         labelStyle: const TextStyle(
//                                                             color: Colors
//                                                                 .black),
//                                                         hintText: "quantity",
//                                                         hintStyle: const TextStyle(
//                                                             color: Colors.black,
//                                                             fontWeight: FontWeight
//                                                                 .w400),
//                                                         contentPadding: EdgeInsets
//                                                             .only(
//                                                             left: w * 0.03,
//                                                             top: h * 0.015),
//                                                         border: OutlineInputBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .circular(
//                                                                 h * 0.01),
//                                                             borderSide: const BorderSide(
//                                                                 color: Colors
//                                                                     .grey)),
//                                                         focusedBorder: OutlineInputBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .circular(
//                                                                 h * 0.01),
//                                                             borderSide: const BorderSide(
//                                                                 color: Colors
//                                                                     .grey)),
//                                                         focusedErrorBorder: OutlineInputBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .circular(
//                                                                 h * 0.01),
//                                                             borderSide: const BorderSide(
//                                                                 color: Colors
//                                                                     .red)),
//                                                         errorBorder: OutlineInputBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .circular(
//                                                                 h * 0.01),
//                                                             borderSide: const BorderSide(
//                                                                 color: Colors
//                                                                     .red)),
//                                                         enabledBorder: OutlineInputBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .circular(
//                                                                 h * 0.01),
//                                                             borderSide: const BorderSide(
//                                                                 color: Colors
//                                                                     .grey)),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width:
//                                                     w * 0.4,
//                                                     child:
//                                                     TextFormField(
//                                                       style: const TextStyle(
//                                                           color: Colors.black),
//                                                       controller: productMrpController,
//                                                       focusNode: productMrpFocusNode,
//                                                       cursorColor: Colors.black,
//                                                       enabled: false,
//                                                       // Set to false to disable editing
//                                                       decoration: InputDecoration(
//                                                         labelText: "MRP Rate",
//                                                         labelStyle: const TextStyle(
//                                                             color: Colors
//                                                                 .black),
//                                                         contentPadding: EdgeInsets
//                                                             .only(
//                                                             left: w * 0.01,
//                                                             top: h * 0.015),
//                                                         border: OutlineInputBorder(
//                                                           borderRadius: BorderRadius
//                                                               .circular(
//                                                               h * 0.01),
//                                                           borderSide: BorderSide(
//                                                               color: getBorderColor()), // Dynamically set the border color
//                                                         ),
//                                                         focusedBorder: OutlineInputBorder(
//                                                           borderRadius: BorderRadius
//                                                               .circular(
//                                                               h * 0.01),
//                                                           borderSide: BorderSide(
//                                                               color: getBorderColor()), // Dynamically set the focused border color
//                                                         ),
//                                                         enabledBorder: OutlineInputBorder(
//                                                           borderRadius: BorderRadius
//                                                               .circular(
//                                                               h * 0.01),
//                                                           borderSide: BorderSide(
//                                                               color: getBorderColor()), // Dynamically set the enabled border color
//                                                         ),
//                                                         disabledBorder: OutlineInputBorder(
//                                                           borderRadius: BorderRadius
//                                                               .circular(
//                                                               h * 0.01),
//                                                           borderSide: BorderSide(
//                                                               color: getBorderColor()), // Dynamically set the disabled border color
//                                                         ),
//                                                         // Set the text color for non-editable state
//                                                         hintStyle: TextStyle(
//                                                             color: isEditable
//                                                                 ? Colors.grey
//                                                                 : Colors.red),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(height: h * 0.018,),
//                                               SizedBox(
//                                                 width:
//                                                 w * 0.4,
//                                                 child:
//                                                 TextFormField(
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   controller: productMrpController,
//                                                   focusNode: productMrpFocusNode,
//                                                   cursorColor: Colors.black,
//                                                   enabled: false,
//                                                   // Set to false to disable editing
//                                                   decoration: InputDecoration(
//                                                     labelText: "Unit Price",
//                                                     labelStyle: const TextStyle(
//                                                         color: Colors.black),
//                                                     contentPadding: EdgeInsets
//                                                         .only(left: w * 0.01,
//                                                         top: h * 0.015),
//                                                     border: OutlineInputBorder(
//                                                       borderRadius: BorderRadius
//                                                           .circular(h * 0.01),
//                                                       borderSide: BorderSide(
//                                                           color: getBorderColor()), // Dynamically set the border color
//                                                     ),
//                                                     focusedBorder: OutlineInputBorder(
//                                                       borderRadius: BorderRadius
//                                                           .circular(h * 0.01),
//                                                       borderSide: BorderSide(
//                                                           color: getBorderColor()), // Dynamically set the focused border color
//                                                     ),
//                                                     enabledBorder: OutlineInputBorder(
//                                                       borderRadius: BorderRadius
//                                                           .circular(h * 0.01),
//                                                       borderSide: BorderSide(
//                                                           color: getBorderColor()), // Dynamically set the enabled border color
//                                                     ),
//                                                     disabledBorder: OutlineInputBorder(
//                                                       borderRadius: BorderRadius
//                                                           .circular(h * 0.01),
//                                                       borderSide: BorderSide(
//                                                           color: getBorderColor()), // Dynamically set the disabled border color
//                                                     ),
//                                                     // Set the text color for non-editable state
//                                                     hintStyle: TextStyle(
//                                                         color: isEditable
//                                                             ? Colors.grey
//                                                             : Colors.red),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: h *
//                                                     0.05,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.spaceEvenly,
//                                                 children: [
//                                                   ElevatedButton(
//                                                     onPressed: () {
//                                                       final productName = ref
//                                                           .watch(
//                                                           selectedProductName);
//                                                       final productId = ref
//                                                           .watch(
//                                                           selectedProductId);
//                                                       final editBool = ref
//                                                           .watch(
//                                                           editUpdateBool);
//                                                       if (_formKey1
//                                                           .currentState!
//                                                           .validate()) {
//                                                         if (editBool == false) {
//                                                           if (productName != ""
//                                                           ) {
//                                                             bool contain = false;
//                                                             int index = 0;
//                                                             int i = 0;
//                                                             for (var a in product) {
//                                                               if (a.productId ==
//                                                                   productId
//                                                               // &&
//                                                               // a.batchId==batchId
//                                                               ) {
//                                                                 index = i;
//                                                                 contain = true;
//                                                                 break;
//                                                               }
//                                                               i++;
//                                                             }
//                                                             if (contain) {
//                                                               showSnackBar(
//                                                                   context,
//                                                                   'This product already added');
//                                                             } else {
//                                                               OrderBagModel bag = OrderBagModel(
//                                                                 productName: productName,
//                                                                 mrp: double
//                                                                     .parse(
//                                                                     productMrpController
//                                                                         .text
//                                                                         .trim()),
//                                                                 productId: items[productName],
//                                                                 quantity: int
//                                                                     .parse(
//                                                                     qtyController
//                                                                         .text
//                                                                         .trim()),
//                                                                 tax: productM!
//                                                                     .tax,
//                                                                 batchId: '',
//                                                                 batchName: '',
//                                                                 unitPrice: 0,
//                                                               );
//                                                               ref.read(
//                                                                   batchCheckProvider
//                                                                       .notifier)
//                                                                   .update((
//                                                                   state) => false);
//                                                               ref.watch(
//                                                                   productList
//                                                                       .notifier)
//                                                                   .update((
//                                                                   state) =>
//                                                               [...state, bag]);
//                                                               ref.read(
//                                                                   totalQtyProvider
//                                                                       .notifier)
//                                                                   .update((
//                                                                   state) =>
//                                                               totalQty +
//                                                                   int.parse(
//                                                                       qtyController
//                                                                           .text
//                                                                           .trim()));
//                                                               ref.read(
//                                                                   totalPriceProvider
//                                                                       .notifier)
//                                                                   .update((
//                                                                   state) =>
//                                                               totalPrice +
//                                                                   ((int.parse(
//                                                                       qtyController
//                                                                           .text
//                                                                           .trim())) *
//                                                                       (double
//                                                                           .parse(
//                                                                           unitPriceController
//                                                                               .text
//                                                                               .trim()))));
//                                                               ref.read(
//                                                                   grandTotalProvider
//                                                                       .notifier)
//                                                                   .update((
//                                                                   state) =>
//                                                               grandTotal +
//                                                                   ((int.parse(
//                                                                       qtyController
//                                                                           .text
//                                                                           .trim())) *
//                                                                       (double
//                                                                           .parse(
//                                                                           unitPriceController
//                                                                               .text
//                                                                               .trim())) +
//                                                                       ((int
//                                                                           .parse(
//                                                                           qtyController
//                                                                               .text
//                                                                               .trim())) *
//                                                                           (productM
//                                                                               .tax *
//                                                                               double
//                                                                                   .parse(
//                                                                                   unitPriceController
//                                                                                       .text
//                                                                                       .trim()) /
//                                                                               100))));
//                                                               ref.read(
//                                                                   gstAmountProvider
//                                                                       .notifier)
//                                                                   .update((
//                                                                   state) =>
//                                                               gstAmount +
//                                                                   ((int.parse(
//                                                                       qtyController
//                                                                           .text
//                                                                           .trim())) *
//                                                                       (productM
//                                                                           .tax *
//                                                                           double
//                                                                               .parse(
//                                                                               unitPriceController
//                                                                                   .text
//                                                                                   .trim()) /
//                                                                           100)));
//                                                               ref.read(
//                                                                   selectedProductId
//                                                                       .notifier)
//                                                                   .update((
//                                                                   state) =>
//                                                               null);
//                                                               ref.read(
//                                                                   selectedProductName
//                                                                       .notifier)
//                                                                   .update((
//                                                                   state) => "");
//                                                               productMrpController
//                                                                   .clear();
//                                                               qtyController
//                                                                   .clear();
//                                                               showSnackBar(
//                                                                   context,
//                                                                   "Product Added");
//                                                             }
//                                                           }
//                                                           else {
//                                                             showSnackBar(
//                                                                 context,
//                                                                 "Please select the batch-contained product");
//                                                           }
//                                                         }
//                                                         else {
//                                                           {
//                                                             OrderBagModel edit = OrderBagModel(
//                                                               productName: ref
//                                                                   .watch(
//                                                                   selectedProductName),
//                                                               mrp: double.parse(
//                                                                   productMrpController
//                                                                       .text
//                                                                       .trim()),
//                                                               productId: ref
//                                                                   .watch(
//                                                                   selectedProductId)!,
//                                                               quantity: int
//                                                                   .parse(
//                                                                   qtyController
//                                                                       .text
//                                                                       .trim()),
//                                                               tax: productM!
//                                                                   .tax,
//                                                               batchId: '',
//                                                               batchName: '',
//                                                               unitPrice: 0,
//                                                             );
//                                                             ref.read(
//                                                                 batchCheckProvider
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) => false);
//                                                             ref.watch(
//                                                                 productList
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) =>
//                                                             List.from(product)
//                                                               ..removeAt(
//                                                                   ref.read(
//                                                                       editIndex)!));
//                                                             final newList = ref
//                                                                 .watch(
//                                                                 productList);
//                                                             ref.watch(
//                                                                 productList
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) =>
//                                                             List.from(newList)
//                                                               ..insert(ref.read(
//                                                                   editIndex)!,
//                                                                   edit));
//                                                             ref.read(
//                                                                 totalQtyProvider
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) =>
//                                                             totalQty +
//                                                                 int.parse(
//                                                                     qtyController
//                                                                         .text
//                                                                         .trim()));
//                                                             ref.read(
//                                                                 totalPriceProvider
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) =>
//                                                             totalPrice +
//                                                                 ((int.parse(
//                                                                     qtyController
//                                                                         .text
//                                                                         .trim())) *
//                                                                     (double
//                                                                         .parse(
//                                                                         unitPriceController
//                                                                             .text
//                                                                             .trim()))));
//                                                             ref.read(
//                                                                 grandTotalProvider
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) =>
//                                                             grandTotal +
//                                                                 ((int.parse(
//                                                                     qtyController
//                                                                         .text
//                                                                         .trim())) *
//                                                                     (double
//                                                                         .parse(
//                                                                         unitPriceController
//                                                                             .text
//                                                                             .trim())) +
//                                                                     ((int.parse(
//                                                                         qtyController
//                                                                             .text
//                                                                             .trim())) *
//                                                                         (productM
//                                                                             .tax *
//                                                                             double
//                                                                                 .parse(
//                                                                                 unitPriceController
//                                                                                     .text
//                                                                                     .trim()) /
//                                                                             100))));
//                                                             ref.read(
//                                                                 gstAmountProvider
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) =>
//                                                             gstAmount +
//                                                                 ((int.parse(
//                                                                     qtyController
//                                                                         .text
//                                                                         .trim())) *
//                                                                     (productM
//                                                                         .tax *
//                                                                         double
//                                                                             .parse(
//                                                                             unitPriceController
//                                                                                 .text
//                                                                                 .trim()) /
//                                                                         100)));
//                                                             ref.read(
//                                                                 selectedProductId
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) => null);
//                                                             ref.read(
//                                                                 selectedProductName
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) => "");
//                                                             productMrpController
//                                                                 .clear();
//                                                             qtyController
//                                                                 .clear();
//                                                             unitPriceController
//                                                                 .clear();
//                                                             ref.read(
//                                                                 editUpdateBool
//                                                                     .notifier)
//                                                                 .update((
//                                                                 state) => false);
//                                                             showSnackBar(
//                                                                 context,
//                                                                 "Product Edited");
//                                                             // }
//                                                             // else
//                                                             // {
//                                                             //   // showSnackBar(context, "Please select the batch-contained product");
//                                                             //   showSnackBar(context, "Please select the  product");
//                                                             // }
//                                                           }
//                                                         }
//                                                       }
//                                                     },
//                                                     style:
//                                                     ElevatedButton.styleFrom(
//                                                       minimumSize: Size(
//                                                           w * 0.42, h * 0.07),
//                                                       backgroundColor: Colors
//                                                           .blue,
//                                                       shape: RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius
//                                                               .circular(
//                                                               h * 0.02),
//                                                           side: const BorderSide(
//                                                               color: Colors
//                                                                   .white)),
//                                                     ),
//                                                     child:
//                                                     Text(
//                                                       ref.watch(
//                                                           editUpdateBool) ==
//                                                           false
//                                                           ? 'Add'
//                                                           : "Update",
//                                                       style: TextStyle(
//                                                           fontSize: w * 0.03,
//                                                           fontWeight: FontWeight
//                                                               .bold,
//                                                           color: Colors.white),
//                                                     ),
//                                                   ),
//                                                   ElevatedButton(
//                                                     onPressed: () {
//                                                       if (ref.watch(
//                                                           editUpdateBool) ==
//                                                           true) {
//                                                         ref.read(
//                                                             totalQtyProvider
//                                                                 .notifier)
//                                                             .update((state) =>
//                                                         totalQty +
//                                                             product[ref.read(
//                                                                 editIndex)!]
//                                                                 .quantity);
//                                                         ref.read(
//                                                             totalPriceProvider
//                                                                 .notifier)
//                                                             .update((state) =>
//                                                         totalPrice +
//                                                             (product[ref.read(
//                                                                 editIndex)!]
//                                                                 .quantity *
//                                                                 product[ref
//                                                                     .read(
//                                                                     editIndex)!]
//                                                                     .unitPrice));
//                                                         ref.read(
//                                                             grandTotalProvider
//                                                                 .notifier)
//                                                             .update((state) =>
//                                                         grandTotal +
//                                                             ((product[ref.read(
//                                                                 editIndex)!]
//                                                                 .quantity) *
//                                                                 (product[ref
//                                                                     .read(
//                                                                     editIndex)!]
//                                                                     .unitPrice) +
//                                                                 ((product[ref
//                                                                     .read(
//                                                                     editIndex)!]
//                                                                     .quantity) *
//                                                                     (productM!
//                                                                         .tax *
//                                                                         product[ref
//                                                                             .read(
//                                                                             editIndex)!]
//                                                                             .unitPrice /
//                                                                         100))));
//                                                         ref.read(
//                                                             gstAmountProvider
//                                                                 .notifier)
//                                                             .update((state) =>
//                                                         gstAmount +
//                                                             ((productM!.tax *
//                                                                 product[ref
//                                                                     .read(
//                                                                     editIndex)!]
//                                                                     .unitPrice /
//                                                                 100) *
//                                                                 product[ref
//                                                                     .read(
//                                                                     editIndex)!]
//                                                                     .quantity));
//                                                         ref.read(editUpdateBool
//                                                             .notifier).update((
//                                                             state) => false);
//                                                       }
//                                                       ref.read(selectedProductId
//                                                           .notifier).update((
//                                                           state) => null);
//                                                       ref.read(
//                                                           selectedProductName
//                                                               .notifier)
//                                                           .update((
//                                                           state) => "");
//                                                       ref.watch(
//                                                           productModelProvider
//                                                               .notifier)
//                                                           .update((
//                                                           state) => null);
//                                                       productMrpController
//                                                           .clear();
//                                                       qtyController.clear();
//                                                       unitPriceController
//                                                           .clear();
//                                                     },
//                                                     style:
//                                                     ElevatedButton.styleFrom(
//                                                       minimumSize: Size(
//                                                           w * 0.42, h * 0.07),
//                                                       backgroundColor: Colors
//                                                           .red,
//                                                       shape: RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius
//                                                               .circular(
//                                                               h * 0.02),
//                                                           side: const BorderSide(
//                                                               color: Colors
//                                                                   .white)),
//                                                     ),
//                                                     child:
//                                                     Text(
//                                                       "Clear",
//                                                       style: TextStyle(
//                                                           fontSize: w * 0.03,
//                                                           fontWeight: FontWeight
//                                                               .bold,
//                                                           color: Colors.white),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                               height: h *
//                                                   (0.03)),
//                                           product.isNotEmpty
//                                               ? Column(
//                                             children: [
//
//                                               SizedBox(
//                                                 width: w * 2.4,
//                                                 child: Padding(
//                                                   padding: EdgeInsets.all(
//                                                       w * 0.02),
//                                                   child: Column(
//                                                     children: [
//                                                       SingleChildScrollView(
//                                                         scrollDirection: Axis
//                                                             .horizontal,
//                                                         physics: const AlwaysScrollableScrollPhysics(),
//                                                         child: SizedBox(
//                                                           width: w * 2.4,
//                                                           child: Column(
//                                                             children: [
//                                                               Row(
//                                                                 mainAxisAlignment: MainAxisAlignment
//                                                                     .spaceBetween,
//                                                                 children: [
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.05,
//                                                                     child: Text(
//                                                                         'SI.',
//                                                                         style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .w600,
//                                                                           fontSize: w *
//                                                                               0.036,
//                                                                         )),
//                                                                   ),
//
//
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.3,
//                                                                     child: Text(
//                                                                         'ProductName',
//                                                                         style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .w600,
//                                                                           fontSize: w *
//                                                                               0.036,
//                                                                         )),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.15,
//                                                                     child: Text(
//                                                                         'QTY',
//                                                                         style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .w600,
//                                                                           fontSize: w *
//                                                                               0.036,
//                                                                         )),
//                                                                   ),
//
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.2,
//                                                                     child: Text(
//                                                                         'MRP',
//                                                                         style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .w600,
//                                                                           fontSize: w *
//                                                                               0.038,
//                                                                         )),
//                                                                   ),
//
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.15,
//                                                                     child: Text(
//                                                                         'TAX',
//                                                                         style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .w600,
//                                                                           fontSize: w *
//                                                                               0.036,
//                                                                         )),
//                                                                   ),
//
//
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.15,
//                                                                     child: Text(
//                                                                         'GST',
//                                                                         style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .w600,
//                                                                           fontSize: w *
//                                                                               0.036,
//                                                                         )),
//                                                                   ),
//
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.25,
//                                                                     child: Text(
//                                                                         'Price',
//                                                                         style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .w600,
//                                                                           fontSize: w *
//                                                                               0.036,
//                                                                         )),
//                                                                   ),
//
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.28,
//                                                                     child: Text(
//                                                                         'TotalAmount',
//                                                                         style: TextStyle(
//                                                                           fontWeight: FontWeight
//                                                                               .w600,
//                                                                           fontSize: w *
//                                                                               0.036,
//                                                                         )),
//                                                                   ),
//
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.1,
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: w *
//                                                                         0.1,
//                                                                   ),
//
//                                                                 ],
//                                                               ),
//                                                               SizedBox(
//                                                                 height: h *
//                                                                     0.01,),
//                                                               ListView
//                                                                   .separated(
//                                                                 shrinkWrap: true,
//                                                                 scrollDirection: Axis
//                                                                     .vertical,
//                                                                 physics: const AlwaysScrollableScrollPhysics(),
//                                                                 itemCount: product
//                                                                     .length,
//                                                                 itemBuilder: (
//                                                                     context,
//                                                                     index) {
//                                                                   ProductModel productDetails = productNameToModel[product[index]
//                                                                       .productName];
//                                                                   return
//                                                                     SizedBox(
//                                                                       width: w *
//                                                                           2.4,
//
//                                                                       child: Row(
//                                                                         mainAxisAlignment: MainAxisAlignment
//                                                                             .spaceBetween,
//                                                                         crossAxisAlignment: CrossAxisAlignment
//                                                                             .start,
//                                                                         children: [
//                                                                           SizedBox(
//                                                                               width: w *
//                                                                                   0.04,
//                                                                               child: Text(
//                                                                                 (index +
//                                                                                     1)
//                                                                                     .toString(),
//                                                                                 style: const TextStyle(
//                                                                                     fontWeight: FontWeight
//                                                                                         .w500),)),
//
//                                                                           SizedBox(
//                                                                               width: w *
//                                                                                   0.29,
//                                                                               child: Text(
//                                                                                   product[index]
//                                                                                       .productName,
//                                                                                   style: const TextStyle(
//                                                                                       fontWeight: FontWeight
//                                                                                           .w500))),
//
//
//                                                                           SizedBox(
//                                                                               width: w *
//                                                                                   0.14,
//                                                                               child: Text(
//                                                                                   product[index]
//                                                                                       .quantity
//                                                                                       .toString(),
//                                                                                   style: const TextStyle(
//                                                                                       fontWeight: FontWeight
//                                                                                           .w500))),
//
//                                                                           SizedBox(
//                                                                               width: w *
//                                                                                   0.19,
//                                                                               child: Text(
//                                                                                   product[index]
//                                                                                       .mrp
//                                                                                       .toString(),
//                                                                                   style: const TextStyle(
//                                                                                       fontWeight: FontWeight
//                                                                                           .w500))),
//
//                                                                           SizedBox(
//                                                                               width: w *
//                                                                                   0.14,
//                                                                               child: Text(
//                                                                                   productDetails
//                                                                                       .tax
//                                                                                       .toString(),
//                                                                                   style: const TextStyle(
//                                                                                       fontWeight: FontWeight
//                                                                                           .w500))),
//
//
//                                                                           SizedBox(
//                                                                               width: w *
//                                                                                   0.16,
//                                                                               child: Text(
//                                                                                   ((productDetails
//                                                                                       .tax *
//                                                                                       product[index]
//                                                                                           .unitPrice /
//                                                                                       100) *
//                                                                                       product[index]
//                                                                                           .quantity)
//                                                                                       .toStringAsFixed(
//                                                                                       2),
//                                                                                   style: const TextStyle(
//                                                                                       fontWeight: FontWeight
//                                                                                           .w500))),
//
//                                                                           SizedBox(
//                                                                               width: w *
//                                                                                   0.26,
//                                                                               child: Text(
//                                                                                   (product[index]
//                                                                                       .unitPrice *
//                                                                                       product[index]
//                                                                                           .quantity)
//                                                                                       .toStringAsFixed(
//                                                                                       2),
//                                                                                   style: const TextStyle(
//                                                                                       fontWeight: FontWeight
//                                                                                           .w500))),
//                                                                           SizedBox(
//                                                                               width: w *
//                                                                                   0.26,
//                                                                               child: Text(
//                                                                                   ((product[index]
//                                                                                       .unitPrice *
//                                                                                       product[index]
//                                                                                           .quantity) +
//                                                                                       (productDetails
//                                                                                           .tax *
//                                                                                           product[index]
//                                                                                               .unitPrice /
//                                                                                           100) *
//                                                                                           product[index]
//                                                                                               .quantity)
//                                                                                       .toStringAsFixed(
//                                                                                       2),
//                                                                                   style: const TextStyle(
//                                                                                       fontWeight: FontWeight
//                                                                                           .w500))),
//                                                                           Row(
//                                                                             mainAxisAlignment: MainAxisAlignment
//                                                                                 .end,
//                                                                             children: [
//                                                                               ref
//                                                                                   .watch(
//                                                                                   editUpdateBool) ==
//                                                                                   false
//                                                                                   ?
//                                                                               InkWell(
//                                                                                   hoverColor: Colors
//                                                                                       .transparent,
//                                                                                   onTap: () {
//                                                                                     ref
//                                                                                         .read(
//                                                                                         editIndex
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) => index);
//                                                                                     ref
//                                                                                         .read(
//                                                                                         batchCheckProvider
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) => true);
//                                                                                     ref
//                                                                                         .read(
//                                                                                         selectedProductId
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) =>
//                                                                                     product[index]
//                                                                                         .productId);
//                                                                                     ref
//                                                                                         .read(
//                                                                                         editUpdateBool
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) => true);
//                                                                                     ref
//                                                                                         .read(
//                                                                                         selectedProductName
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) =>
//                                                                                     product[index]
//                                                                                         .productName);
//                                                                                     qtyController =
//                                                                                         TextEditingController(
//                                                                                             text: product[index]
//                                                                                                 .quantity
//                                                                                                 .toString());
//                                                                                     productMrpController =
//                                                                                         TextEditingController(
//                                                                                             text: product[index]
//                                                                                                 .mrp
//                                                                                                 .toString());
//                                                                                     ProductModel productModel = productNameToModel[product[index]
//                                                                                         .productName];
//                                                                                     ref
//                                                                                         .watch(
//                                                                                         productModelProvider
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) => productModel);
//                                                                                     ref
//                                                                                         .read(
//                                                                                         totalQtyProvider
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) =>
//                                                                                     totalQty -
//                                                                                         product[ref
//                                                                                             .read(
//                                                                                             editIndex)!]
//                                                                                             .quantity);
//                                                                                     ref
//                                                                                         .read(
//                                                                                         totalPriceProvider
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) =>
//                                                                                     totalPrice -
//                                                                                         ((product[ref
//                                                                                             .read(
//                                                                                             editIndex)!]
//                                                                                             .unitPrice) *
//                                                                                             (product[ref
//                                                                                                 .read(
//                                                                                                 editIndex)!]
//                                                                                                 .quantity)));
//                                                                                     ref
//                                                                                         .read(
//                                                                                         gstAmountProvider
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) =>
//                                                                                     gstAmount -
//                                                                                         ((productDetails
//                                                                                             .tax *
//                                                                                             product[ref
//                                                                                                 .read(
//                                                                                                 editIndex)!]
//                                                                                                 .unitPrice /
//                                                                                             100) *
//                                                                                             product[ref
//                                                                                                 .read(
//                                                                                                 editIndex)!]
//                                                                                                 .quantity));
//                                                                                     ref
//                                                                                         .read(
//                                                                                         grandTotalProvider
//                                                                                             .notifier)
//                                                                                         .update((
//                                                                                         state) =>
//                                                                                     grandTotal -
//                                                                                         ((int
//                                                                                             .parse(
//                                                                                             qtyController
//                                                                                                 .text
//                                                                                                 .trim())) *
//                                                                                             (double
//                                                                                                 .parse(
//                                                                                                 unitPriceController
//                                                                                                     .text
//                                                                                                     .trim())) +
//                                                                                             ((int
//                                                                                                 .parse(
//                                                                                                 qtyController
//                                                                                                     .text
//                                                                                                     .trim())) *
//                                                                                                 (productDetails
//                                                                                                     .tax *
//                                                                                                     double
//                                                                                                         .parse(
//                                                                                                         unitPriceController
//                                                                                                             .text
//                                                                                                             .trim()) /
//                                                                                                     100))));
//                                                                                   },
//                                                                                   child: Icon(
//                                                                                     Icons
//                                                                                         .edit,
//                                                                                     color: Colors
//                                                                                         .grey,
//                                                                                     size: w *
//                                                                                         (0.07),
//                                                                                   ))
//                                                                                   : Icon(
//                                                                                 Icons
//                                                                                     .update,
//                                                                                 color: Colors
//                                                                                     .grey
//                                                                                     .shade600,
//                                                                                 size: w *
//                                                                                     (0.07),
//                                                                               ),
//                                                                               SizedBox(
//                                                                                 width: w *
//                                                                                     0.1,
//                                                                               ),
//                                                                               InkWell(
//                                                                                   hoverColor: Colors
//                                                                                       .transparent,
//                                                                                   onTap: () {
//                                                                                     confirmBox(
//                                                                                         context: context,
//                                                                                         content: "Are you Sure To Delete..?",
//                                                                                         actionText: "Delete",
//                                                                                         onPressed: () {
//                                                                                           if (ref
//                                                                                               .watch(
//                                                                                               editUpdateBool) ==
//                                                                                               true &&
//                                                                                               ref
//                                                                                                   .read(
//                                                                                                   editIndex) ==
//                                                                                                   index) {
//                                                                                             ref
//                                                                                                 .watch(
//                                                                                                 productList
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) =>
//                                                                                             List
//                                                                                                 .from(
//                                                                                                 ref
//                                                                                                     .watch(
//                                                                                                     productList))
//                                                                                               ..removeAt(
//                                                                                                   ref
//                                                                                                       .read(
//                                                                                                       editIndex)!));
//                                                                                             ref
//                                                                                                 .read(
//                                                                                                 editUpdateBool
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) => false);
//                                                                                             ref
//                                                                                                 .read(
//                                                                                                 selectedProductId
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) => null);
//                                                                                             ref
//                                                                                                 .read(
//                                                                                                 selectedProductName
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) => "");
//                                                                                             ref
//                                                                                                 .watch(
//                                                                                                 productModelProvider
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) => null);
//                                                                                             productMrpController
//                                                                                                 .clear();
//                                                                                             qtyController
//                                                                                                 .clear();
//                                                                                           } else {
//                                                                                             ref
//                                                                                                 .watch(
//                                                                                                 productList
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) =>
//                                                                                             List
//                                                                                                 .from(
//                                                                                                 ref
//                                                                                                     .watch(
//                                                                                                     productList))
//                                                                                               ..removeAt(
//                                                                                                   index));
//                                                                                             ref
//                                                                                                 .watch(
//                                                                                                 editIndex
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) =>
//                                                                                             product
//                                                                                                 .length ==
//                                                                                                 1
//                                                                                                 ?
//                                                                                             state =
//                                                                                             0
//                                                                                                 : product
//                                                                                                 .length <
//                                                                                                 index
//                                                                                                 ?
//                                                                                             state =
//                                                                                                 product
//                                                                                                     .length -
//                                                                                                     1
//                                                                                                 : state! <
//                                                                                                 index
//                                                                                                 ? state
//                                                                                                 : state -
//                                                                                                 1);
//                                                                                             ref
//                                                                                                 .read(
//                                                                                                 totalQtyProvider
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) =>
//                                                                                             totalQty -
//                                                                                                 product[index]
//                                                                                                     .quantity);
//                                                                                             ref
//                                                                                                 .read(
//                                                                                                 totalPriceProvider
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) =>
//                                                                                             totalPrice -
//                                                                                                 ((product[index]
//                                                                                                     .unitPrice) *
//                                                                                                     (product[index]
//                                                                                                         .quantity)));
//                                                                                             ref
//                                                                                                 .read(
//                                                                                                 gstAmountProvider
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) =>
//                                                                                             gstAmount -
//                                                                                                 ((productDetails
//                                                                                                     .tax *
//                                                                                                     product[index]
//                                                                                                         .unitPrice /
//                                                                                                     100) *
//                                                                                                     product[index]
//                                                                                                         .quantity));
//                                                                                             ref
//                                                                                                 .read(
//                                                                                                 grandTotalProvider
//                                                                                                     .notifier)
//                                                                                                 .update((
//                                                                                                 state) =>
//                                                                                             grandTotal -
//                                                                                                 (product[index]
//                                                                                                     .quantity *
//                                                                                                     product[index]
//                                                                                                         .unitPrice +
//                                                                                                     (product[index]
//                                                                                                         .quantity *
//                                                                                                         (productDetails
//                                                                                                             .tax *
//                                                                                                             product[index]
//                                                                                                                 .unitPrice /
//                                                                                                             100))));
//                                                                                           }
//                                                                                           showSnackBar(
//                                                                                               context,
//                                                                                               "Product Deleted Successfully");
//                                                                                           Navigator
//                                                                                               .pop(
//                                                                                               context);
//                                                                                         });
//                                                                                   },
//                                                                                   child: Icon(
//                                                                                     Icons
//                                                                                         .delete,
//                                                                                     color: Colors
//                                                                                         .red,
//                                                                                     size: w *
//                                                                                         (0.08),
//                                                                                   )),
//                                                                             ],
//                                                                           ),
//
//                                                                         ],
//                                                                       ),
//                                                                     );
//                                                                 },
//                                                                 separatorBuilder: (
//                                                                     BuildContext context,
//                                                                     int index) {
//                                                                   return SizedBox(
//                                                                     height: h *
//                                                                         0.015,
//                                                                   );
//                                                                 },
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(height: h * 0.05,),
//                                               const Divider(
//                                                 thickness: 0.5,
//                                                 color: Colors.black54,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment
//                                                     .end,
//                                                 children: [
//                                                   Column(
//                                                     children: [
//                                                       Text("Total Qty   :",
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .black,
//                                                               fontSize: w *
//                                                                   (0.03),
//                                                               fontWeight: FontWeight
//                                                                   .w500)),
//                                                       Text(
//                                                           "I"
//                                                               "GST        :",
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .black,
//                                                               fontSize: w *
//                                                                   (0.03),
//                                                               fontWeight: FontWeight
//                                                                   .w500)),
//                                                       Column(
//                                                         children: [
//                                                           Text("SGST       :",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontSize: w *
//                                                                       (0.03),
//                                                                   fontWeight: FontWeight
//                                                                       .w500)),
//                                                           Text("CGST       :",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontSize: w *
//                                                                       (0.03),
//                                                                   fontWeight: FontWeight
//                                                                       .w500)),
//                                                         ],
//                                                       ),
//                                                       Text("Total price :  ",
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .black,
//                                                               fontSize: w *
//                                                                   (0.034),
//                                                               fontWeight: FontWeight
//                                                                   .w600)),
//                                                       Text("Grand Total :  ",
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .black,
//                                                               fontSize: w *
//                                                                   (0.034),
//                                                               fontWeight: FontWeight
//                                                                   .w600)),
//                                                     ],
//                                                   ),
//                                                   Column(
//                                                     children: [
//                                                       Text(totalQty.toString(),
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .black,
//                                                               fontSize: w *
//                                                                   (0.03),
//                                                               fontWeight: FontWeight
//                                                                   .w600)),
//                                                       Text("$gstAmount ",
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .black,
//                                                               fontSize: w *
//                                                                   (0.03),
//                                                               fontWeight: FontWeight
//                                                                   .w600)),
//                                                       Column(
//                                                         children: [
//                                                           Text((gstAmount / 2)
//                                                               .toStringAsFixed(
//                                                               2),
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontSize: w *
//                                                                       (0.03),
//                                                                   fontWeight: FontWeight
//                                                                       .w600)),
//                                                           Text(
//                                                               "${(gstAmount / 2)
//                                                                   .toStringAsFixed(
//                                                                   2)} ",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontSize: w *
//                                                                       (0.03),
//                                                                   fontWeight: FontWeight
//                                                                       .w600)),
//                                                         ],
//                                                       ),
//                                                       Text((totalPrice)
//                                                           .toStringAsFixed(2),
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .black,
//                                                               fontSize: w *
//                                                                   (0.036),
//                                                               fontWeight: FontWeight
//                                                                   .w600)),
//                                                       Text((grandTotal)
//                                                           .toStringAsFixed(2),
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .black,
//                                                               fontSize: w *
//                                                                   (0.036),
//                                                               fontWeight: FontWeight
//                                                                   .w600)),
//                                                     ],
//                                                   ),
//                                                   SizedBox(
//                                                     width: w * (0.01),
//                                                   )
//                                                 ],
//                                               )
//                                             ],
//                                           )
//                                               : const SizedBox(),
//                                           SizedBox(
//                                             height:
//                                             h *
//                                                 (0.03),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                     error: (error,
//                                         stackTrace) {
//                                       if (kDebugMode) {
//                                         print(error);
//                                       }
//                                       return ErrorText(
//                                           error: error
//                                               .toString());
//                                     },
//                                     loading: () =>
//                                     const Loader(),
//                                   );
//                                 }),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: h * (0.01),
//                       ),
//                       Consumer(
//                           builder: (context, ref, child) {
//                             final gstAmount =
//                             ref.watch(gstAmountProvider);
//                             final purchaseDate =
//                             ref.watch(purchaseDateProvider);
//                             final product =
//                             ref.watch(productList);
//                             return Center(
//                               child: ElevatedButton(
//                                 onPressed: () async {
//                                   if (_formKey.currentState!
//                                       .validate()) {
//                                     if (purchaseDate != null) {
//                                       if (product.isNotEmpty) {
//                                         editConfirmAlertBox(
//                                           ref: ref,
//                                           cGst: gstAmount / 2,
//                                           iGst: gstAmount / 2,
//                                           sGst: gstAmount / 2,
//                                         );
//                                       } else {
//                                         showSnackBar(context,
//                                             "Please Add Products");
//                                       }
//                                     } else {
//                                       showSnackBar(context,
//                                           "Please Select Date");
//                                     }
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   minimumSize: Size(w * 0.3,
//                                       h * 0.06),
//                                   backgroundColor: Colors.blue,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                       BorderRadius.circular(
//                                           h * 0.02),
//                                       side: const BorderSide(
//                                           color: Colors.white)),
//                                 ),
//                                 child: Text(
//                                   'Edit Order',
//                                   style: TextStyle(
//                                       fontSize: h * 0.03,
//                                       fontWeight:
//                                       FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             );
//                           }),
//                       SizedBox(
//                         height: h * (0.03),
//                       )
//                     ],
//                   );
//                 }
//
//     )],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
