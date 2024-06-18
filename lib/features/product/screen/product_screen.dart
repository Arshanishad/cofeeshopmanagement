// import 'package:coffee_shop_management/features/widget/product_details_popup.dart';
// import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
//
// class ProductScreen extends StatefulWidget {
//   const ProductScreen({super.key});
//
//   @override
//   State<ProductScreen> createState() => _ProductScreenState();
// }
//
// class _ProductScreenState extends State<ProductScreen> {
//    // 50% of screen height
//
//   List<String> images = [
//     "assets/images/freed.png",
//     "assets/images/freed.png",
//     "assets/images/freed.png",
//     "assets/images/freed.png"
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double sliderContainerHeight = MediaQuery.of(context).size.height * 0.4;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.all(screenWidth * 0.05), // 5% of screen width
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 LayoutBuilder(
//                   builder: (context, constraints) {
//                     double sliderHeight = constraints.maxWidth * 0.9;
//                     return Container(
//                       height: sliderHeight,
//                       width: screenWidth,
//                       child: Flexible(
//                         child: FanCarouselImageSlider.sliderType1(
//                           imagesLink: images,
//                           isAssets: true,
//                           autoPlay: true,
//                           sliderHeight: sliderContainerHeight * 0.85, // Adjust as necessary
//                           initalPageIndex: 0,
//                         ),
//                       ),
//
//                     );
//                   },
//                 ),
//                 SizedBox(height: screenHeight * 0.02), // 2% of screen height
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Warm Zipper",
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w900,
//                             fontSize: screenWidth * 0.06, // 6% of screen width
//                           ),
//                         ),
//                         SizedBox(height: screenHeight * 0.01), // 1% of screen height
//                         Text(
//                           "Hooded Jacket",
//                           style: TextStyle(
//                             color: Colors.black54,
//                             fontWeight: FontWeight.w500,
//                             fontSize: screenWidth * 0.04, // 4% of screen width
//                           ),
//                         ),
//                         Text(
//                           "\$300",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: screenWidth * 0.06, // 6% of screen width
//                             color: Color(0xFFDB3022),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: screenHeight * 0.02), // 2% of screen height
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: RatingBar.builder(
//                     initialRating: 3,
//                     minRating: 1,
//                     direction: Axis.horizontal,
//                     allowHalfRating: true,
//                     itemCount: 5,
//                     itemSize: screenWidth * 0.05, // 5% of screen width
//                     itemPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01), // 1% of screen width
//                     itemBuilder: (context, _) => Icon(
//                       Icons.star,
//                       color: Colors.amber,
//                     ),
//                     onRatingUpdate: (rating) {
//                       // Handle rating update
//                     },
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.02), // 2% of screen height
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Cool, windy weather is on its way. Send him out "
//                         "the door in a jacket he wants to wear. Warm "
//                         "Zooper Hooded Jacket.",
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontWeight: FontWeight.w400,
//                       fontSize: screenWidth * 0.04, // 4% of screen width
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.05), // 5% of screen height
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Container(
//                       height: screenWidth * 0.15, // 15% of screen width
//                       width: screenWidth * 0.15, // 15% of screen width
//                       decoration: BoxDecoration(
//                         color: Color(0x1F989797),
//                         borderRadius: BorderRadius.circular(screenWidth * 0.075), // 7.5% of screen width
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.shopping_cart,
//                           color: Color(0xFFDB3022),
//                         ),
//                       ),
//                     ),
//                     ProductDetailsPopUp(),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:coffee_shop_management/features/product/controller/product_controller.dart';
import 'package:coffee_shop_management/features/product/screen/edit_product.dart';
import 'package:coffee_shop_management/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/globals.dart';
import '../../../core/widget/product_details_popup.dart';

class ProductScreen extends ConsumerStatefulWidget {
  ProductModel product;

   ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  List<String> images = [
    "assets/images/freed.png",
    "assets/images/freed.png",
    "assets/images/freed.png",
    "assets/images/freed.png"
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double sliderContainerHeight = screenHeight * 0.4;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.redLightColor,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductEdit(data:widget.product),
                            ));
                      },
                      icon: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: w * 0.08,
                            color: Colors.grey,
                          ),
                          const Text("Edit")
                        ],
                      ),
                    )),
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
                                          ref.read(productControllerProvider.notifier).deleteProduct(widget.product.id);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: w * 0.1,
                                        width: w * 0.15,
                                        decoration: BoxDecoration(
                                          color: Colors.purple,
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
                                          color: Colors.purple,
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
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), // 5% of screen width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BackButton(color: Colors.black87,),
                CachedNetworkImage(
                  imageUrl: widget.product.image,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  // fit: BoxFit.cover,
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                Text(
                  widget.product.productName,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: screenWidth * 0.06, // 6% of screen width
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // 1% of screen height
                Text(
                 widget.product.mrp.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06, // 6% of screen width
                    color: Color(0xFFDB3022),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: screenWidth * 0.05, // 5% of screen width
                  itemPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01), // 1% of screen width
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    // Handle rating update
                  },
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                Text(
                  widget.product.description,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: screenWidth * 0.04, // 4% of screen width
                  ),
                ),
                SizedBox(height: screenHeight * 0.05), // 5% of screen height
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: screenWidth * 0.15, // 15% of screen width
                      width: screenWidth * 0.15, // 15% of screen width
                      decoration: BoxDecoration(
                        color: Color(0x1F989797),
                        borderRadius: BorderRadius.circular(screenWidth * 0.075), // 7.5% of screen width
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_cart,
                          color: Color(0xFFDB3022),
                        ),
                      ),
                    ),
                    ProductDetailsPopUp(data:widget.product),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
