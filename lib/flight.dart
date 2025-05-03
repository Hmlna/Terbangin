import 'package:flutter/material.dart';
import 'package:terbangin/ticket_detail.dart';

class Flight extends StatelessWidget {
  const Flight({super.key});

  @override
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
                    children: const [
                      Text(
                        "Denpasar - Jakarta",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "3 Passengers · Economy",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tune),
                  ),
                ],
              ),
            ),
            SizedBox(height: 58),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFlightCard(
                    context: context,
                    logoPath: 'assets/garuda-indonesia.png',
                    airline: 'Garuda Indonesia',
                    flightCode: 'GA-754',
                    from: 'DPS',
                    to: 'CGK',
                    departTime: '09:45 AM',
                    arriveTime: '10:35 AM',
                    duration: '1 hour 30 minutes',
                    price: 'IDR 1.500.000',
                  ),
                  _buildFlightCard(
                    context: context,
                    logoPath: 'assets/citilink.png',
                    airline: 'Citilink',
                    flightCode: 'QG-843',
                    from: 'DPS',
                    to: 'CGK',
                    departTime: '10:45 AM',
                    arriveTime: '11:30 AM',
                    duration: '1 hour 25 minutes',
                    price: 'IDR 1.200.000',
                  ),
                  _buildFlightCard(
                    context: context,
                    logoPath: 'assets/air-asia.png',
                    airline: 'AirAsia',
                    flightCode: 'QZ-457',
                    from: 'DPS',
                    to: 'CGK',
                    departTime: '11:45 AM',
                    arriveTime: '01:55 PM',
                    duration: '1 hour 50 minutes',
                    price: 'IDR 1.300.000',
                  ),
                  _buildFlightCard(
                    context: context,
                    logoPath: 'assets/lion-air.png',
                    airline: 'Lion Air',
                    flightCode: 'JT-384',
                    from: 'DPS',
                    to: 'CGK',
                    departTime: '02:25 PM',
                    arriveTime: '03:15 PM',
                    duration: '1 hour 50 minutes',
                    price: 'IDR 1.600.000',
                  ),
                  _buildFlightCard(
                    context: context,
                    logoPath: 'assets/lion-air.png',
                    airline: 'Lion Air',
                    flightCode: 'IN-843',
                    from: 'DPS',
                    to: 'CGK',
                    departTime: '04:45 PM',
                    arriveTime: '05:55 PM',
                    duration: '1 hour 10 minutes',
                    price: 'IDR 1.200.000',
                  ),
                  _buildFlightCard(
                    context: context,
                    logoPath: 'assets/lion-air.png',
                    airline: 'Lion Air',
                    flightCode: 'IN-843',
                    from: 'DPS',
                    to: 'CGK',
                    departTime: '04:45 PM',
                    arriveTime: '05:55 PM',
                    duration: '1 hour 10 minutes',
                    price: 'IDR 1.200.000',
                  ),
                  _buildFlightCard(
                    context: context,
                    logoPath: 'assets/lion-air.png',
                    airline: 'Lion Air',
                    flightCode: 'IN-843',
                    from: 'DPS',
                    to: 'CGK',
                    departTime: '04:45 PM',
                    arriveTime: '05:55 PM',
                    duration: '1 hour 10 minutes',
                    price: 'IDR 1.200.000',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightCard({
  required BuildContext context,
  required String logoPath,
  required String airline,
  required String flightCode,
  required String departTime,
  required String arriveTime,
  required String duration,
  required String from,
  required String to,
  required String price,

}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicketDetail(
            ticket: {
              'airline': airline,
              'flightCode': flightCode,
              'from': from,
              'to': to,
              'departure': departTime,
              'arrival': arriveTime,
              'duration': duration,
              'date': 'Sunday, March 30',
              'fromTerminal': 'Ngurah Rai - Domestic Terminal',
              'toTerminal': 'Soekarno Hatta - Terminal 3B',
              'class': 'Economy',
              'price': price,
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
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                departTime,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                arriveTime,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Column(
                children: [
                  Text(from, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Denpasar", style: const TextStyle(fontSize: 10)),
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
                  Text(to, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Jakarta", style: const TextStyle(fontSize: 10)),
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
                    price,
                    style: const TextStyle(fontSize: 15, color: Colors.red),
                  ),
                  Text(
                    "per pax",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );
}

}
