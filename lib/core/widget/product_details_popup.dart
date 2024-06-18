import 'package:coffee_shop_management/features/order/screen/order_add.dart';
import 'package:coffee_shop_management/model/product_model.dart';
import 'package:flutter/material.dart';
import '../common/globals.dart';
import 'container_button_model.dart';
import '../../../core/pallete/theme.dart';


class ProductDetailsPopUp extends StatefulWidget {
  ProductModel data;

   ProductDetailsPopUp({Key? key, required this.data}) : super(key: key);

  @override
  State<ProductDetailsPopUp> createState() => _ProductDetailsPopUpState();
}

class _ProductDetailsPopUpState extends State<ProductDetailsPopUp> {
  late TextStyle isStyle;


  // List<Color> clrs = [
  //   Colors.red,
  //   Colors.green,
  //   Colors.indigo,
  //   Colors.amber,
  // ];

  @override
  void initState() {
    super.initState();
    isStyle = const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => Container(
            height: h / 2.5,
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(w*0.08),
                topRight: Radius.circular(w*0.08),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(w * 0.1),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("Size:", style: isStyle.copyWith(fontSize: w * 0.045)),
                            // SizedBox(height: h*0.02),
                            // Text("Color:",  style: isStyle.copyWith(fontSize: w * 0.045)),
                            // SizedBox(height: h*0.02),
                            // Text("Total:", style: isStyle.copyWith(fontSize: w * 0.045)),
                            // SizedBox(height: h*0.02),
                          ],
                        ),
                        SizedBox(width: w * 0.075),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   children: [
                            //     SizedBox(width: w * 0.025),
                            //     Text("S",  style: isStyle.copyWith(fontSize: w * 0.045)),
                            //     SizedBox(width:w * 0.075),
                            //     Text("M",  style: isStyle.copyWith(fontSize: w * 0.045)),
                            //     SizedBox(width: w * 0.075),
                            //     Text("L",  style: isStyle.copyWith(fontSize: w * 0.045)),
                            //     SizedBox(width: w * 0.075),
                            //     Text("XL", style: isStyle.copyWith(fontSize: w * 0.045)),
                            //     SizedBox(height: w * 0.075),
                            //   ],
                            // ),
                            // SizedBox(height: h * 0.02),
                            // Row(
                            //   children: [
                            //     for (var i = 0; i < clrs.length; i++)
                            //       Container(
                            //         margin:  EdgeInsets.symmetric(horizontal: w * 0.0125),
                            //         height:  h * 0.07,
                            //         width: w*0.07,
                            //         decoration: BoxDecoration(
                            //           color: clrs[i],
                            //           borderRadius: BorderRadius.circular(w*0.05),
                            //         ),
                            //       ),
                            //   ],
                            // ),
                            // SizedBox(height: h*0.02),
                            // Row(
                            //   children: [
                            //     SizedBox(width: w * 0.025),
                            //     Text("-",  style: isStyle.copyWith(fontSize: w * 0.045)),
                            //     SizedBox(width: w * 0.025),
                            //     Text("1",  style: isStyle.copyWith(fontSize: w * 0.045)),
                            //     SizedBox(width: w * 0.025),
                            //     Text("+",  style: isStyle.copyWith(fontSize: w * 0.045)),
                            //   ],
                            // )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: h * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Payment", style: isStyle),
                         Text(
                          "\$40.00",
                          style: TextStyle(
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.bold,
                            color:Palette.darkRedColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  AddOrderPage(selectedProduct:widget.data)),
                        );
                      },
                      child: ContainerButtonModel(
                        itext: "Check Out",
                        containerWidth: w,
                        bgColor: Palette.darkRedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: ContainerButtonModel(
        containerWidth: w / 1.5,
        itext: "Buy Now",
        bgColor:Palette.darkRedColor,
      ),
    );
  }
}
