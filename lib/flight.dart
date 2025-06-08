import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:terbangin/constants.dart';
import 'package:terbangin/ticket_detail.dart';
import 'package:terbangin/token_provider.dart';

class Flight extends StatefulWidget {
  final Map<String, dynamic> searchData;
  final int user_id;
  const Flight({super.key, required this.searchData, required this.user_id});

  @override
  State<Flight> createState() => _FlightState();
}

class _FlightState extends State<Flight> {
  List<dynamic> flights = []; // Store full flight data

  @override
  void initState() {
    super.initState();

    fetchFlightSearch();
    // loadTokenAndProfile();
    // selectedDate = DateTime.now(); // Default to current date
  }

  Future<void> fetchFlightSearch() async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/flights/search'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },

        body: jsonEncode(widget.searchData),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            flights = jsonData['data'];
            print(flights);
            
          });
        }
      } else {
        print('Failed to search flights. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching flight cities: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // children: [
                    //   flights.isNotEmpty
                    //   ? Text(
                    //       "${flights[0]['from']} - ${flights[0]['destination']}",
                    //       style: const TextStyle(
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     )
                    //   : const Text(
                    //       "Loading...",
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     )
                    // ],
                  ),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
                ],
              ),
            ),
            SizedBox(height: 58),
            Expanded(
              child: flights.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: flights.length,
                      itemBuilder: (context, index) {
                        final flight = flights[index];
                        return _buildFlightCard(
                          context: context,
                          logoPath: getAirlineLogo(flight['airline_name']), // atau bisa sesuaikan berdasarkan airline_name
                          airline: flight['airline_name'] ?? '',
                          flightCode: flight['flight_number'] ?? '',
                          from: flight['from'] ?? '',
                          to: flight['destination'] ?? '',
                          departure: (flight['departure']),
                          arrival: (flight['arrival']),
                          duration: _calculateDuration(flight['departure'], flight['arrival']),
                          price: (flight['price']),
                          user_id: (widget.user_id),
                          flight_id: flight['flight_id'],
                          
                        );
                      },
                    ),
            ),

          ],
        ),
      ),
    );
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

String _calculateDuration(String departureStr, String arrivalStr) {
  final departure = DateTime.parse(departureStr);
  final arrival = DateTime.parse(arrivalStr);
  final duration = arrival.difference(departure);

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes != 1 ? 's' : ''}';
}

String getAirlineLogo(String airlineName) {
  if (airlineName.toLowerCase().contains('garuda')) {
    return 'assets/garuda-indonesia.png';
  } else if (airlineName.toLowerCase().contains('citilink')) {
    return 'assets/citilink.png';
  } else if (airlineName.toLowerCase().contains('airasia')) {
    return 'assets/air-asia.png';
  } else {
    return 'assets/lion-air.png';
  }
}


  Widget _buildFlightCard({
    required BuildContext context,
    required String logoPath,
    required String airline,
    required String flightCode,
    required String departure,
    required String arrival,
    required String duration,
    required String from,
    required String to,
    required String price,
    required int user_id,
    required int flight_id
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => TicketDetail(
                  ticket: {
                    'airline': airline,
                    'flightCode': flightCode,
                    'from': from,
                    'to': to,
                    'departure': departure,
                    'arrival': arrival,
                    'duration': duration,
                    'fromTerminal': 'Domestic Terminal',
                    'toTerminal': 'Terminal 3B',
                    'class': 'Economy',
                    'price': price,
                    'user_id': user_id,
                    'flight_id': flight_id
                  },
                ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  _formatTime(departure),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                   _formatTime(arrival),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      from,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 60,
                      child: Image.asset(logoPath, fit: BoxFit.contain),
                    ),
                    Text(
                      "$airline\n$flightCode",
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      to,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  duration,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatPrice(price),
                      style: const TextStyle(fontSize: 15, color: Colors.red),
                    ),
                    Text(
                      "per pax",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
