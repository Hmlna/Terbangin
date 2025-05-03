import 'package:flutter/material.dart';

class ETicket extends StatelessWidget {
  final Map<String, dynamic> order;

  const ETicket({super.key, required this.order});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "E-Ticket",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Booking ID", style: _labelStyle),
                  Text(order['bookingId'].toString(), style: _valueStyle),

                  const SizedBox(height: 16),
                  Text("Route", style: _labelStyle),
                  Text(order['route'], style: _valueStyle),

                  const SizedBox(height: 16),
                  Text("Price", style: _labelStyle),
                  Text(order['price'].toString(), style: _valueStyle),

                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/qrcode.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Scan this QR code at the gate",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get _labelStyle => const TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      );

  TextStyle get _valueStyle => const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );
}
