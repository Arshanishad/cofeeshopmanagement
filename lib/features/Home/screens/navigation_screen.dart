import 'package:coffee_shop_management/core/pallete/theme.dart';
import 'package:coffee_shop_management/features/order/screen/orders_tabbarview.dart';
import 'package:coffee_shop_management/features/product/screen/product_add.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'home_page.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    OrderTabbarView1(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductAddScreen()));
          // Add your floating action button logic here
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFDB3022),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onItemTapped(0),
              color: pageIndex == 0 ? Palette.redLightColor : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => _onItemTapped(1),
              color: pageIndex == 1 ? Palette.redLightColor : Colors.grey,
            ),
            SizedBox(width: 48.0), // The width of the center button space
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () => _onItemTapped(2),  // Corrected index to 2
              color: pageIndex == 2 ? Palette.redLightColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
