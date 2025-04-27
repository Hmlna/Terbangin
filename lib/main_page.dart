import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';
import 'order.dart';
import 'promo.dart';
import 'profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Order(),
    Promo(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(assetName: 'assets/home-icon.svg', label: 'Home', index: 0),
              _buildTabItem(assetName: 'assets/cart-icon.svg', label: 'Orders', index: 1),
              _buildTabItem(assetName: 'assets/promo-icon.svg', label: 'Promo', index: 2),
              _buildTabItem(assetName: 'assets/profile-icon.svg', label: 'Profile', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({required String assetName, required String label, required int index}) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Color(0xFF006BFF) : Colors.grey[600];

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetName,
            colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
            width: 24,
            height: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
