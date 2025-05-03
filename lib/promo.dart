import 'package:flutter/material.dart';

class Promo extends StatelessWidget {
  const Promo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'All Promos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: const [
          PromoBanner(gambar: 'sale-50'),
          PromoBanner(gambar: 'sale-50'), 
          PromoBanner(gambar: 'sale-50'), 
          PromoBanner(gambar: 'sale-50'), 
        ],
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  const PromoBanner({
    super.key,
    required this.gambar,
  });

  final String gambar;

  @override
  Widget build(BuildContext context) {    
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Image.asset('assets/$gambar.png'),
        ),
      ],
    );
  }
}
