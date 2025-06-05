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
  final String user_id;
  const Payment({super.key, required this.ticket, required this.user_id});
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController _couponController = TextEditingController();
  String _couponMessage = '';
  int discountAmount = 0;


  // Fungsi untuk parsing harga string dengan titik ribuan
  int parsePrice(String priceString) {
    // Hapus titik yang merupakan pemisah ribuan (titik sebelum tiga digit)
    String cleaned = priceString.replaceAll(RegExp(r'\.(?=\d{3}\.)'), '');
    // Parsing ke double
    double priceDouble = double.tryParse(cleaned) ?? 0;
    // Bulatkan ke int
    return priceDouble.round();
  }

  

  late int originalPrice;

  @override
  void initState() {
    super.initState();
    originalPrice = parsePrice(widget.ticket['price'].toString());

  }
  Future<void> checkCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('$baseUrl/promos'),
       headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      body: jsonEncode({"data": code}),
    );

    final data = jsonDecode(response.body);

    if (data['valid'] == true) {
      final type = data['type'];
      final value = data['value'];

      setState(() {
        if (type == 'percent') {
          discountAmount = (originalPrice * value ~/ 100);
        } else if (type == 'fixed') {
          discountAmount = value;
        }
        _couponMessage = "Coupon applied successfully!";
      });
    } else {
      setState(() {
        discountAmount = 0;
        _couponMessage = data['message'] ?? 'Invalid coupon';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'id_ID', // lokal Indonesia
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    int finalPrice = (originalPrice - discountAmount).clamp(0, originalPrice);

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
            const Text("Total Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),

            const SizedBox(height: 32),
            const Text("Coupon Code", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  onPressed: checkCoupon(),
                  child: const Text("Apply"),
                ),
              ],
            ),
            if (_couponMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _couponMessage,
                  style: TextStyle(color: discountAmount > 0 ? Colors.green : Colors.red),
                ),
              ),

            const SizedBox(height: 32),
            const Text("Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    builder: (_) => AlertDialog(
                      title: const Text("Successful Payment"),
                      content: const Text("Thank you, your order is being processed."),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Finish Payment", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
