import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:coffee_shop_management/core/widget/textformfield.dart';
import 'package:coffee_shop_management/features/order/controller/order_controller.dart';
import 'package:coffee_shop_management/model/order_model.dart';
import 'package:coffee_shop_management/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/globals.dart';

class AddOrderPage extends ConsumerStatefulWidget {
  final ProductModel? selectedProduct;

  AddOrderPage({this.selectedProduct});

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends ConsumerState<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();
  double grandTotal = 0.0;

  final orderProductListProvider = StateProvider<List<OrderBagModel>>((ref) => []);

  @override
  void initState() {
    super.initState();
    if (widget.selectedProduct != null) {
      selectedProduct = widget.selectedProduct;
    }
  }

  ProductModel? selectedProduct;

  void addProduct() {
    if (selectedProduct != null && quantityController.text.isNotEmpty) {
      final quantity = int.parse(quantityController.text.trim());
      final totalPrice = selectedProduct!.mrp * quantity;

      final orderBagModel = OrderBagModel(
        productName: selectedProduct!.productName,
        quantity: quantity,
        mrp: selectedProduct!.mrp,
        productPrice: selectedProduct!.mrp,
        productId: selectedProduct!.id,
        tax: 0,
      );

      // Update order product list with Riverpod
      ref.read(orderProductListProvider.notifier).update((state) => [...state, orderBagModel]);

      grandTotal += totalPrice;

      // Clear selected product and controllers
      selectedProduct = null;
      quantityController.clear();
      totalPriceController.text = grandTotal.toStringAsFixed(2);

      // Update UI to reflect changes (trigger rebuild)
      setState(() {}); // If using StatefulWidgets
    }
  }

  // Function to add order
  void orderAdd() {
    if (_formKey.currentState!.validate()) {
      final products = ref.read(orderProductListProvider);
      final orderProducts = products.map((item) => OrderBagModel(
        productId: item.productId,
        quantity: item.quantity,
        productName: item.productName,
        mrp: item.mrp,
        productPrice: item.productPrice,
        tax: 0,
      )).toList();

      OrderModel orderModel = OrderModel(
        customerName: customerNameController.text.trim(),
        products: [],
        status: 0, // Default status to 0 (Pending)
        totalPrice: grandTotal,
        orderDate: DateTime.now(),
        search: [],
        delete: false,
        bag: orderProducts, // Can be kept for internal reference
        grandTotal: grandTotal,
        rejectReason: '',
        quantity: products.fold(0, (sum, item) => sum + item.quantity),
      );

      ref.read(orderControllerProvider.notifier).orderAdd(orderModel: orderModel, context: context);

      // Clear the order form
      customerNameController.clear();
      quantityController.clear();
      totalPriceController.clear();
      ref.read(orderProductListProvider.notifier).state = [];
      grandTotal = 0.0;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProductListState = ref.watch(orderProductListProvider);
    final productListAsyncValue = ref.watch(getProductNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
        backgroundColor: Palette.redLightColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedProduct != null) ...[
                  Image.network(selectedProduct!.image),
                  SizedBox(height: 10),
                  Text(
                    selectedProduct!.productName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
        CustomTextInput(controller: customerNameController, label: 'Customer Name', width: MediaQuery.of(context).size.width * 0.7, height: 0.1),

        // productListAsyncValue.when(
                //   data: (productList) {
                //     return DropdownButtonFormField<ProductModel>(
                //       value: selectedProduct,
                //       hint: Text('Select Product'),
                //       onChanged: (ProductModel? newValue) {
                //         setState(() {
                //           selectedProduct = newValue;
                //         });
                //       },
                //       items: productList.map((ProductModel product) {
                //         return DropdownMenuItem<ProductModel>(
                //           value: product,
                //           child: Text(product.productName),
                //         );
                //       }).toList(),
                //       decoration: InputDecoration(
                //         labelText: 'Product',
                //         border: OutlineInputBorder(),
                //       ),
                //     );
                //   },
                //   loading: () => CircularProgressIndicator(),
                //   error: (error, stack) {
                //     print('Error: $error');
                //     return Text('Error loading products: $error');
                //   },
                // ),
                SizedBox(height: 10),
                CustomTextInput(controller: quantityController, label: 'Quantity', width: MediaQuery.of(context).size.width * 0.7, height: 0.1),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addProduct,
                  child: Text('Add Product'),
                ),
                SizedBox(height: 10),
                CustomTextInput(controller: totalPriceController, label: 'Total Price', width: MediaQuery.of(context).size.width * 0.7, height: 0.1),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: orderAdd,
                  child: Text('Add Order'),
                ),
                SizedBox(height: 20),
                Text('Order Bag:'),
                ...orderProductListState.map((product) => ListTile(
                  title: Text(product.productName),
                  subtitle: Text('Price: \$${product.mrp} x ${product.quantity} = \$${product.mrp * product.quantity}'),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
