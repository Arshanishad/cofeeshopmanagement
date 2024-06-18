import 'dart:async';
import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/utils.dart';
import '../controller/order_controller.dart';
import 'order_screen.dart';

class OrderTabbarView1 extends ConsumerStatefulWidget {
  const OrderTabbarView1({
    super.key,
  });

  @override
  ConsumerState<OrderTabbarView1> createState() => _OrderTabbarViewState();
}

class _OrderTabbarViewState extends ConsumerState<OrderTabbarView1>
    with TickerProviderStateMixin {
  late TabController _controller;

  int index = 0;
  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 8, vsync: this);
    _controller.addListener(() {
      setState(() {
        index = _controller.index;
      });
    });
  }



  @override


  Future<void> _selectedToDate(
      {required BuildContext context,
      required String time,
      required WidgetRef ref}) async {
    DateTime? fromDate = ref.watch(fromDateProvider);
    DateTime now = DateTime.now();
    DateTime beforeDate = now.subtract(const Duration(days: 1));
    DateTime? nextDay = fromDate?.add(const Duration(days: 1));
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: time == "from" ? beforeDate : now,
        firstDate:
            time == "from" ? DateTime(2000, 1) : nextDay ?? DateTime(2000, 1),
        lastDate: time == "from" ? beforeDate : now);
    if (time == "from") {
      if (picked != null && picked != ref.read(fromDateProvider)) {
        ref.read(fromDateProvider.notifier).update((state) =>
            DateTime(picked.year, picked.month, picked.day, 23, 59, 59));
      }
    } else {
      if (picked != null && picked != ref.read(toDateProvider)) {
        ref.read(toDateProvider.notifier).update((state) =>
            DateTime(picked.year, picked.month, picked.day, 23, 59, 59));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fromDate = ref.watch(fromDateProvider);
    final toDate = ref.watch(toDateProvider);

    return
       DefaultTabController(
            length: 8,
            initialIndex: 0,
            child: Scaffold(
              backgroundColor: Colors.purple.shade50,
              body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        title: Text("Orders Details",
                            style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: h * 0.03,
                                fontWeight: FontWeight.w600)),
                        backgroundColor: Colors.purple.shade700,
                        centerTitle: true,
                        elevation: 0,
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            CupertinoIcons.arrow_left,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                          pinned: true,
                          delegate: MyDelegate(TabBar(
                            onTap: (value) {
                              ref
                                  .watch(selectedIndexProvider.notifier)
                                  .update((state) => value);
                              index = value;
                            },
                            tabAlignment: TabAlignment.start,
                            controller: _controller,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: Colors.white,
                            padding: EdgeInsets.zero,
                            labelColor: Colors.purple.shade700,
                            labelPadding: EdgeInsets.symmetric(
                                vertical: h * 0.011,
                                horizontal: w * 0.06),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.purple.shade700,
                                fontSize: w * 0.043),
                            indicator: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(w * 0.04),
                              color: Colors.white,
                            ),
                            tabs: const [
                              Text('Pending'),
                              Text('Accepted'),
                              Text('Rejected'),
                              Text('Ready For Shipping'),
                              Text('Dispatch'),
                              Text('Delivered'),
                              Text('Returned'),
                              Text('Cancelled'),
                            ],
                          ))),
                      SliverToBoxAdapter(
                        child: Container(
                            width: double.infinity,
                            height: h * 0.05,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _selectedToDate(
                                        context: context,
                                        time: "from",
                                        ref: ref);
                                  },
                                  child: fromDate != null
                                      ? Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(fromDate),
                                          style: const TextStyle(
                                              color: Colors.grey))
                                      : Text("Choose From Date",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: w * 0.031)),
                                ),
                                Text(
                                  'To',
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontFamily: 'Poppins',
                                      fontSize: w * 0.04,
                                      fontWeight: FontWeight.w700),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _selectedToDate(
                                        context: context, time: "to", ref: ref);
                                  },
                                  child: toDate != null
                                      ? Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(toDate),
                                          style: const TextStyle(
                                              color: Colors.grey))
                                      : Text("Choose To Date",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: w * (0.031))),
                                ),
                                TextButton(
                                    onPressed: () {
                                      if (fromDate != null && toDate != null) {
                                        ref
                                            .watch(dateStreamProvider.notifier)
                                            .update((state) => true);
                                      } else {
                                        fromDate == null
                                            ? showSnackBar(
                                                context, 'Choose From Date')
                                            : toDate == null
                                                ? showSnackBar(
                                                    context, 'Choose To Date')
                                                : '';
                                      }
                                    },
                                    child: Text(
                                      'Go',
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontFamily: 'Poppins',
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.w700),
                                    )),
                                Consumer(builder: (context, ref, child) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .read(fromDateProvider.notifier)
                                          .update((state) => null);
                                      ref
                                          .read(toDateProvider.notifier)
                                          .update((state) => null);
                                      ref
                                          .read(dateStreamProvider.notifier)
                                          .update((state) => false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(w * 0.02),
                                      minimumSize:
                                          Size(w * 0.06, h * 0.02),
                                      backgroundColor: Colors.purple.shade50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            h * 0.02),
                                      ),
                                    ),
                                    child: Text(
                                      'Clear',
                                      style: TextStyle(
                                          fontSize: w * 0.025,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple.shade700),
                                    ),
                                  );
                                }),
                              ],
                            )),
                      ),
                    ];
                  },
                body:  SizedBox(
                  height: h,
                  child:GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.primaryVelocity! > 0) {
                          if(index!=0){
                            _controller.animateTo(index-1);
                            ref.watch(selectedIndexProvider.notifier).update((state) => state-1);
                            // index=index-1;
                            if (kDebugMode) {
                              print("index000000000");
                            }
                            if (kDebugMode) {
                              print(index);
                            }
                            if (kDebugMode) {
                              print("index");
                            }
                          }

                        } else if (details.primaryVelocity! < 0) {
                          if(index!=7){
                            _controller.animateTo(index+1);
                            ref.watch(selectedIndexProvider.notifier).update((state) => state+1);
                            // index=index+1;
                            if (kDebugMode) {
                              print(index);
                            }
                            if (kDebugMode) {
                              print("222222222222222222222");
                            }
                          }

                        }
                      },

                      child: OrderScreen()),
                ),
                    ),
                  )
            );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        height: h * 0.064, color: Palette.redLightColor, child: tabBar);
  }

  @override
  double get maxExtent => h * 0.064;

  @override
  double get minExtent => h * 0.064;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
