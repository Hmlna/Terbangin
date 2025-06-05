import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:terbangin/constants.dart';
import 'package:terbangin/main_page.dart';
import 'package:terbangin/token_provider.dart';

class Payment extends StatefulWidget {
  final Map<String, dynamic> ticket;
  final int user_id;
  const Payment({super.key, required this.ticket, required this.user_id});
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List<dynamic> promos = []; // Store full promo data
  final TextEditingController _couponController = TextEditingController();
  String _couponMessage = '';
  double discountAmount = 0;
  bool _isDiscountApplied = false; // Flag to track discount state

  // Fungsi untuk parsing harga string dengan titik ribuan
  int parsePrice(String priceString) {
    String cleaned = priceString.replaceAll(RegExp(r'\.(?=\d{3}\.)'), '');
    double priceDouble = double.tryParse(cleaned) ?? 0;
    return priceDouble.round();
  }

  late int originalPrice;

  @override
  void initState() {
    super.initState();
    originalPrice = parsePrice(widget.ticket['price'].toString());
  }

  Future<void> checkCoupon(String promoCode) async {
    setState(() {
      _isDiscountApplied = false;
      discountAmount = 0;
      _couponMessage = '';
    });

    final token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/promos/search'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'promo_code': promoCode}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            promos = jsonData['data'];
            print(promos);
            if (promos.isNotEmpty && promos.first['discount'] != null) {
              discountAmount = promos.first['discount'] / 100;
              _isDiscountApplied = true;
              _couponMessage = 'Coupon applied successfully!';
            } else {
              _isDiscountApplied = false;
              discountAmount = 0;
              _couponMessage = 'Invalid coupon code.';
            }
          });
        } else {
          setState(() {
            _isDiscountApplied = false;
            discountAmount = 0;
            _couponMessage = 'Failed to apply coupon.';
          });
          print('Failed to search promos. Status code: ${response.statusCode}');
        }
      } else {
        setState(() {
          _isDiscountApplied = false;
          discountAmount = 0;
          _couponMessage =
              'Failed to apply coupon: Status code ${response.statusCode}';
        });
        print('Failed to search promos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isDiscountApplied = false;
        discountAmount = 0;
        _couponMessage = 'Error applying coupon: $e';
      });
      print('Error fetching promo cities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    int finalPrice =
        _isDiscountApplied
            ? (originalPrice - (originalPrice * discountAmount)).round()
            : originalPrice;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Payment",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (discountAmount > 0)
              Text(
                currencyFormat.format(originalPrice),
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            Text(
              currencyFormat.format(finalPrice),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Coupon Code",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: const InputDecoration(
                      hintText: "Enter coupon code",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    checkCoupon(_couponController.text);
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),
            if (_couponMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _couponMessage,
                  style: TextStyle(
                    color: discountAmount > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text("Virtual Account BCA"),
                subtitle: const Text("1234567890 a.n. PT Terbangin"),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text("Successful Payment"),
                          content: const Text(
                            "Thank you, your order is being processed.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => MainPage()),
                                  (route) => false,
                                );
                              },
                              child: const Text("Back to Home"),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Finish Payment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
