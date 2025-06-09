import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ETicket extends StatelessWidget {
  final Map<String, dynamic> order;

  const ETicket({super.key, required this.order});

  String formatDateTime(String dateTimeStr) {
    try {
      DateTime dt = DateTime.parse(dateTimeStr);
      // Format contoh: 07 Jun 2025, 13:45
      return DateFormat('dd MMM yyyy, HH:mm').format(dt);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String formatPrice(dynamic price) {
    try {
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      if (price is String) {
        price = double.tryParse(price) ?? 0;
      }
      return formatter.format(price);
    } catch (e) {
      return price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final flight = order['flight'] ?? {};
    final passenger = order['passenger'] ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "E-Ticket",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Booking ID", style: _labelStyle),
                  Text(order['ticket_id'].toString(), style: _valueStyle),

                  const SizedBox(height: 16),
                  Text("Passenger Name", style: _labelStyle),
                  Text(passenger['name'] ?? '-', style: _valueStyle),

                  const SizedBox(height: 16),
                  Text("Airline", style: _labelStyle),
                  Text(flight['airline_name'] ?? '-', style: _valueStyle),

                  const SizedBox(height: 16),
                  Text("Flight Number", style: _labelStyle),
                  Text(flight['flight_number'] ?? '-', style: _valueStyle),

                  const SizedBox(height: 16),
                  Text("Route", style: _labelStyle),
                  Text(
                    "${flight['from'] ?? '-'} → ${flight['destination'] ?? '-'}",
                    style: _valueStyle,
                  ),

                  const SizedBox(height: 16),
                  Text("Departure", style: _labelStyle),
                  Text(
                    formatDateTime(flight['departure'] ?? ''),
                    style: _valueStyle,
                  ),

                  const SizedBox(height: 16),
                  Text("Arrival", style: _labelStyle),
                  Text(
                    formatDateTime(flight['arrival'] ?? ''),
                    style: _valueStyle,
                  ),

                  const SizedBox(height: 16),
                  Text("Price", style: _labelStyle),
                  Text(formatPrice(flight['price'] ?? 0), style: _valueStyle),

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
                  ),
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
