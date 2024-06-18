import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_management/features/product/controller/product_controller.dart';
import 'package:coffee_shop_management/features/product/screen/product_screen.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/pallete/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });

  final selectedTabProvider = StateProvider<int>((ref) {
    return 0; // Default to "All" tab
  });

  final List<String> tabs = [
    "All",
    "Category",
  ];

  final List<String> imageList = [
    "assets/images/Black Coffee.png",
    "assets/images/Cold Coffee.png",
    "assets/images/Espresso.png",
    "assets/images/Latte.png",
  ];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    double sliderContainerHeight = h * 0.32;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.05,
              vertical: h * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: h * 0.07,
                            width: w * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.black12.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(h * 0.01),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Find Your Product",
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Palette.darkRedColor,
                                  ),
                                ),
                                onChanged: (value) {
                                  ref.read(searchProvider.notifier).state = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        Container(
                          height: h * 0.07,
                          width: w * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(h * 0.01),
                          ),
                          child: const Center(
                            child: Icon(Icons.notifications, color: Palette.darkRedColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: h * 0.02),
                Container(
                  width: double.infinity,
                  height: sliderContainerHeight,
                  decoration: BoxDecoration(
                    color: Palette.lightWhiteColor,
                    borderRadius: BorderRadius.circular(h * 0.02),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double sliderHeight = constraints.maxHeight * 0.80;
                      return SizedBox(
                        height: sliderContainerHeight,
                        child: FanCarouselImageSlider.sliderType1(
                          imagesLink: imageList,
                          isAssets: true,
                          autoPlay: true,
                          sliderHeight: sliderHeight,
                          initalPageIndex: 0,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: h * 0.02),
                SizedBox(
                  height: 50.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedTabProvider.notifier).state = index;
                        },
                        child: Container(
                          margin: EdgeInsets.all(w * 0.01),
                          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(h * 0.03),
                          ),
                          child: Center(
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: h * 0.02,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: h * 0.02),
                Consumer(
                  builder: (context, ref, child) {
                    final selectedTabIndex = ref.watch(selectedTabProvider);
                    final searchQuery = ref.watch(searchProvider);
                    return ref.watch(productDisplayStreamProvider(searchQuery)).when(
                      data: (products) {
                        // List<ProductModel> filteredProducts;
                        // if (selectedTabIndex == 0) {
                        //   // "All" tab selected
                        //   filteredProducts = products;
                        // } else if (selectedTabIndex == 1) {
                        //   // "Category" tab selected - replace with actual category filtering logic
                        //   filteredProducts = products.where((product) => product.category== "SomeCategory").toList();
                        // } else if (selectedTabIndex == 2) {
                        //   // "Top" tab selected - replace with actual top products filtering logic
                        //   filteredProducts = products.where((product) => product.isTopProduct).toList();
                        // } else if (selectedTabIndex == 3) {
                        //   // "Recommended" tab selected - replace with actual recommended products filtering logic
                        //   filteredProducts = products.where((product) => product.isRecommended).toList();
                        // } else {
                        //   filteredProducts = products;
                        // }
                        //
                        // if (filteredProducts.isEmpty) {
                        //   return Center(child: Text("No products found."));
                        // }

                        return GridView.builder(
                          itemCount: products.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(product: product),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 160.0,
                                          width: 160.0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: product.image,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          product.productName,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16.0,
                                            ),
                                            SizedBox(width: 4.0),
                                            Expanded(
                                              child: Text(
                                                '(${product.description})',
                                                style: TextStyle(fontSize: 14.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '\$${product.mrp.toString()}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) => Center(
                        child: Text('Error: $error'),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}