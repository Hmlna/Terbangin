import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:terbangin/flighfacility.dart';
import 'package:terbangin/passenger.dart';

class TicketDetail extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketDetail({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Selected Flight",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.circle, size: 10, color: Colors.blue),
                            Container(
                              width: 2,
                              height: 250,
                              color: Colors.blue,
                            ),
                            const Icon(Icons.circle_outlined, size: 10, color: Colors.blue),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${formatToDayMonthDate(ticket['departure'])} - ${_formatTime(ticket['departure'])}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(ticket['fromTerminal'], style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 24),
                              _flightCard(context, ticket),
                              const SizedBox(height: 24),
                              Text(
                                "${formatToDayMonthDate(ticket['arrival'])} - ${_formatTime(ticket['arrival'])}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(ticket['toTerminal'], style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        formatPrice(ticket['price'] ?? 'IDR -'),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Passenger(ticket: ticket),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006BFF),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Select Ticket", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flightCard(BuildContext context, Map<String, dynamic> ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                _getLogo(ticket['airline']),
                height: 30,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket['airline'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${ticket['flightCode']} · ${ticket['class']} · ${ticket['duration']}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Ticket Included",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.work_outline, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text("Cabin: 7 kg. Bagage: 15 kg", style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.no_food, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text("Foods not included", style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlightFacility(ticket: ticket),
                    ),
                  );
                },
                child: const Text(
                  "Other facilities",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF006BFF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLogo(String airline) {
    if (airline.toLowerCase().contains('garuda')) {
      return 'assets/garuda-indonesia.png';
    } else if (airline.toLowerCase().contains('citilink')) {
      return 'assets/citilink.png';
    } else if (airline.toLowerCase().contains('airasia')) {
      return 'assets/air-asia.png';
    } else if (airline.toLowerCase().contains('lion')) {
      return 'assets/lion-air.png';
    } else {
      return 'assets/default-airline.png';
    }
  }
String formatToDayMonthDate(String rawDateTime) {
  try {
    // Coba langsung parse dulu
    DateTime parsedDate;

    if (rawDateTime.contains('T')) {
      // Format ISO 8601: 2024-06-04T15:00:00
      parsedDate = DateTime.parse(rawDateTime);
    } else {
      // Misal format: 2024-06-04 15:00:00
      parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(rawDateTime);
    }

    return DateFormat('EEEE, MMMM d').format(parsedDate);
  } catch (e) {
    print("Date parse error: $e | raw: $rawDateTime");
    return 'Invalid date';
  }
}
 String _formatTime(String dateTimeStr) {
  final dateTime = DateTime.parse(dateTimeStr);
  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

String formatPrice(String priceStr) {
  final doublePrice = double.tryParse(priceStr) ?? 0.0;
  final intPrice = doublePrice.toInt();

  return 'IDR ${intPrice.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  )}';
}
}