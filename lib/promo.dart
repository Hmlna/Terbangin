import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Promo {
  final int promoId;
  final String promoCode;
  final String description;
  final double discount;
  final String validUntil;

  Promo({
    required this.promoId,
    required this.promoCode,
    required this.description,
    required this.discount,
    required this.validUntil,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      promoId: json['promo_id'],
      promoCode: json['promo_code'],
      description: json['description'] ?? '',
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      validUntil: json['valid_until'],
    );
  }
}

class PromoScreen extends StatefulWidget {
  const PromoScreen({Key? key}) : super(key: key);

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  List<Promo> _promos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPromos();
  }

  Future<void> fetchPromos() async {
    const url = 'http://10.0.2.2:8000/api/promos'; // Ganti jika perlu
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          _promos = data.map((item) => Promo.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load promos');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _promos.isEmpty
              ? const Center(child: Text('No promos available'))
              : ListView.builder(
                  itemCount: _promos.length,
                  itemBuilder: (context, index) {
                    final promo = _promos[index];
                    return PromoBanner(promo: promo);
                  },
                ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final Promo promo;

  const PromoBanner({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            promo.promoCode,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(promo.description),
          const SizedBox(height: 8),
          Text('Discount: ${promo.discount.toStringAsFixed(0)}%'),
        ],
      ),
    );
  }
}
