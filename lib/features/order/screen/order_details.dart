import    'dart:async';
import 'dart:io';
import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/upload_message.dart';
import '../../../model/order_model.dart';
import '../controller/order_controller.dart';


class OrderViewPage extends ConsumerStatefulWidget {
  final String id;
  final OrderModel order;

  const OrderViewPage({super .key, required this.id, required this.order});

  @override
  ConsumerState<OrderViewPage> createState() => _PendingOrderViewState();
}

class _PendingOrderViewState extends ConsumerState<OrderViewPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController rejectController = TextEditingController();
  RoundedLoadingButtonController loading = RoundedLoadingButtonController();
  final selectedValueDrop = StateProvider<String>((ref) {
    return "";
  });
  final selectedKeyDrop = StateProvider<String?>((ref) {
    return null;
  });



  acceptOrder({required OrderModel orderModel}) {
    ref
        .read(orderControllerProvider.notifier)
        .acceptOrder(orderModel: orderModel, context: context);
  }

  rejectOrder({required OrderModel orderModel}) {
    ref.read(orderControllerProvider.notifier).rejectOrder(
        orderModel: orderModel,
        context: context,
        reject: rejectController.text.trim());
  }

  deliveredOrder({required OrderModel orderModel}) {
    ref
        .read(orderControllerProvider.notifier)
        .deliveredOrder(orderModel: orderModel, context: context);
  }

  readyForShippedOrder({required OrderModel orderModel}) {
    ref
        .read(orderControllerProvider.notifier)
        .readyForShipping(orderModel: orderModel, context: context);
  }

  dispatchOrder(
      {required OrderModel orderModel,
      }) {
    print("===================================");
    ref.read(orderControllerProvider.notifier).dispatchOrder(
        orderModel: orderModel,
        context: context, );
  }

  cancelOrder({required OrderModel orderModel, required String reject}) {
    print(reject);
    print("rejectsssssssssssssssssssssssssssssssssssss");
    ref.read(orderControllerProvider.notifier).cancelOrder(
        orderModel: orderModel, context: context,);
  }



  returnOrder({required OrderModel orderModel, required String returnText}) {
    print(returnText);
    print("sssssssssssssssssssssssssssssssssss");
    ref.read(orderControllerProvider.notifier).rejectOrder(
        orderModel: orderModel, context: context, reject: '', );
  }



  final imageProvider = StateProvider<File?>((ref) => null);
  final checkImage = StateProvider<bool>((ref) => false);
  final picker = ImagePicker();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref
          .watch(imageProvider.notifier)
          .update((state) => File(pickedFile.path));
    }
    if(mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      ref
          .watch(imageProvider.notifier)
          .update((state) => File(pickedFile.path));
    }
    if(mounted) {
      Navigator.of(context).pop();
    }
  }



  @override

  @override

  @override
  Widget build(BuildContext context) {

    return
        ref.watch(getOrderDetailsProvider(widget.id)).when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Palette.redLightColor,
            title: Text("${titleController.text} Order",
                style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontSize: h * 0.03,
                    fontWeight: FontWeight.w600)),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
            actions: [
              PopupMenuItem(
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Do you want to delete?"),
                            content: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    ref.watch(orderControllerProvider.notifier).deleteOrder(widget.order.id.toString());
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: w * 0.1,
                                    width: w * 0.15,
                                    decoration: BoxDecoration(
                                      color: Palette.lightRedColor,
                                      borderRadius: BorderRadius.circular(
                                          w * 0.03),
                                    ),
                                    child: const Center(
                                      child: Text("Yes",
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {

                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: w * 0.1,
                                    width: w * 0.15,
                                    decoration: BoxDecoration(
                                      color:Palette.lightRedColor,
                                      borderRadius: BorderRadius.circular(
                                          w * 0.03),
                                    ),
                                    child: const Center(
                                      child: Text("No",
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: w * 0.08,
                          color: Colors.grey,
                        ),
                        const Text("Delete")
                      ],
                    ),
                  )),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(w * 0.03),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: w * 1.2,
                        padding: EdgeInsets.all(w * 0.04),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                            BorderRadius.circular(w * 0.02)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: w * 0.06,
                                    child: Text(
                                      "SI.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: w * 0.04),
                                    )),
                                SizedBox(
                                    width: w * 0.42,
                                    child: Text(
                                      "   Name   ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: w * 0.04),
                                    )),
                                SizedBox(
                                    width: w * 0.16,
                                    child: Text(
                                      "  Qty  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: w * 0.04),
                                    )),
                                SizedBox(
                                    width: w * 0.16,
                                    child: Text(
                                      "  Mrp  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: w * 0.04),
                                    )),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemCount: data.bag.length,
                              itemBuilder: (context, index) {
                                var bag = data.bag[index];
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: h * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                            alignment:
                                            AlignmentDirectional
                                                .topStart,
                                            child: SizedBox(
                                                width: w * 0.05,
                                                child: Text(
                                                  '${(index + 1).toString()} . ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize:
                                                      w * 0.035),
                                                ))),
                                        Align(
                                          alignment:
                                          AlignmentDirectional.center,
                                          child: SizedBox(
                                              width: w * 0.4,
                                              child: Text(
                                                bag.productName,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: w * 0.035),
                                              )),
                                        ),
                                        Align(
                                            alignment:
                                            AlignmentDirectional
                                                .center,
                                            child: SizedBox(
                                                width: w * 0.14,
                                                child: Text(
                                                  bag.quantity.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize:
                                                      w * 0.035),
                                                ))),
                                        Align(
                                            alignment:
                                            AlignmentDirectional
                                                .center,
                                            child: SizedBox(
                                                width: w * 0.14,
                                                child: Text(
                                                  bag.mrp
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize:
                                                      w * 0.035),
                                                ))),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                      width: w,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(w * 0.02)),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.04),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order Id : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.04,
                                        color: Colors.black)),
                                Text(data.id.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.04,
                                        color: Colors.black))
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order Date : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.04,
                                        color: Colors.black)),
                                Text(
                                    DateFormat('dd-MM-yyyy')
                                        .format(data.orderDate),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.04,
                                        color: Colors.black))
                              ],
                            ),
                            Row(
                              children: [
                                Text("Total Amount : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.04,
                                        color: Colors.black)),
                                Text(data.grandTotal.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.05,
                                        color: Colors.black))
                              ],
                            ),
                            data.status == 2
                                ? Row(
                              children: [
                                Text("Rejected Reason : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.04,
                                        color: Colors.black)),
                                Text(data.rejectReason.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.045,
                                        color: Colors.black)),
                              ],
                            )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    if (data.status == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Reject',
                                        style: TextStyle(
                                            color:Palette.lightRedColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: w * 0.05),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment:
                                            AlignmentDirectional
                                                .topStart,
                                            child: Text(
                                              'Are You Sure To Reject',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize: w * 0.04),
                                            ),
                                          ),
                                          SizedBox(
                                            height: h * 0.01,
                                          ),
                                          SizedBox(
                                            height: h * 0.05,
                                            width: w,
                                            child: TextFormField(
                                              controller:
                                              rejectController,
                                              obscureText: false,
                                              keyboardType: TextInputType.text,
                                              textCapitalization: TextCapitalization.words,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                    w * 0.04,
                                                    vertical:
                                                    w * 0.02),
                                                hintText: 'Give Reason',
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color:
                                                    Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(30),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(
                                                    color:
                                                    Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(30),
                                                ),
                                                filled: true,
                                                fillColor: const Color(
                                                    0xFFF1F4F8),
                                              ),
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Color(0xFF1D2429),
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                            )),
                                        TextButton(
                                          onPressed: () async {
                                            if (rejectController
                                                .text.isNotEmpty) {
                                              rejectOrder(
                                                  orderModel: data);
                                              titleController.text =
                                              "Rejected";
                                              Navigator.pop(context);
                                            } else {
                                              showSnackBar(
                                                   context: context, text: '"Please Enter A Reason For Rejection."', color: true);
                                            }
                                          },
                                          child: const Text(
                                            'Reject',
                                            style: TextStyle(
                                                color: Colors.red),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: h * 0.04,
                              width: w * 0.2,
                              decoration: BoxDecoration(
                                color: Palette.lightRedColor,
                                borderRadius:
                                BorderRadius.circular(w * 0.02),
                              ),
                              child: const Center(
                                  child: Text(
                                    "Reject",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Accept',
                                        style: TextStyle(
                                            color: Palette.lightRedColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: w * 0.05),
                                      ),
                                      content: Text(
                                        'Are You Sure To Accept',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: w * 0.04),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              if (ref.watch(
                                                  selectedIndexProvider) ==
                                                  1) {
                                             acceptOrder(
                                                    orderModel: data);
                                              } else {
                                                acceptOrder(
                                                    orderModel: data);
                                              }
                                              titleController.text =
                                              "Accepted";
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Accept',
                                              style: TextStyle(
                                                  color: Colors.blue),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: h * 0.04,
                              width: w * 0.2,
                              decoration: BoxDecoration(
                                color:Palette.redLightColor,
                                borderRadius:
                                BorderRadius.circular(w * 0.02),
                              ),
                              child: const Center(
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (data.status == 1)
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Ready For Shipped',
                                        style: TextStyle(
                                            color: Palette.lightRedColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: w * 0.05),
                                      ),
                                      content: Text(
                                        'Are You Sure To Ready For Shipped',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: w * 0.04),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              titleController.text =
                                              "Ready For Shipped";
                                              readyForShippedOrder(orderModel: data);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Ready For Shipped',
                                              style: TextStyle(
                                                  color: Colors.blue),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: h * 0.04,
                              width: w * 0.4,
                              decoration: BoxDecoration(
                                color: Palette.redLightColor,
                                borderRadius:
                                BorderRadius.circular(w * 0.02),
                              ),
                              child: const Center(
                                  child: Text(
                                    "Ready For Shipped",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (data.status == 4)
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Deliver',
                                        style: TextStyle(
                                            color:Palette.lightRedColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: w * 0.05),
                                      ),
                                      content: Text(
                                        'Are You Sure To Deliver',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: w * 0.04),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              titleController.text =
                                              "Delivered";
                                              deliveredOrder(orderModel: data);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Delivered',
                                              style: TextStyle(
                                                  color: Colors.blue),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: h * 0.04,
                              width: w * 0.4,
                              decoration: BoxDecoration(
                                color:Palette.lightRedColor,
                                borderRadius:
                                BorderRadius.circular(w * 0.02),
                              ),
                              child: const Center(
                                  child: Text(
                                    "Deliver",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (data.status == 3)
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Deliver',
                                        style: TextStyle(
                                            color:Palette.lightRedColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: w * 0.05),
                                      ),
                                      content: Text(
                                        'Are You Sure To Dispatch',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: w * 0.04),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              titleController.text =
                                              "Dispatch";
                                              dispatchOrder(orderModel: data, );
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Dispatch',
                                              style: TextStyle(
                                                  color: Colors.blue),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: h * 0.04,
                              width: w * 0.4,
                              decoration: BoxDecoration(
                                color: Palette.lightRedColor,
                                borderRadius:
                                BorderRadius.circular(w * 0.02),
                              ),
                              child: const Center(
                                  child: Text(
                                    "Deliver",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        if (kDebugMode) {
          print(error);
          print(stackTrace);
        }
        return ErrorText(error: error.toString());
      },
      loading: () => const Loader(),
    );
  }
}
