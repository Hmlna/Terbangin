import 'package:flutter/material.dart';

class FlightFacility extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const FlightFacility({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Fasilitas Penerbangan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Logo + Maskapai
          Row(
            children: [
              Image.asset(
                _getLogo(ticket['airline']),
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ticket['airline'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("${ticket['flightCode']} · ${ticket['class']} · ${ticket['duration']}",
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text("Tiket Sudah Termasuk", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          const Text("Kabin: 7 kg\nBagasi: 20 kg",
              style: TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          const Text(
            "Pembelian bagasi tambahan tersedia di halaman pemesanan.\n*Ketersediaan tergantung pihak maskapai.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 16),
          const Text("Tidak termasuk makanan", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          const Text(
            "Pembelian makanan tambahan tidak tersedia di halaman pemesanan.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Model", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(ticket['aircraftModel'] ?? 'Airbus A320'),
                const Divider(),
                const Text("Kelas", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(ticket['class']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLogo(String airline) {
    if (airline.toLowerCase().contains('super')) {
      return 'assets/super-air-jet.png';
    } else if (airline.toLowerCase().contains('garuda')) {
      return 'assets/garuda-indonesia.png';
    } else if (airline.toLowerCase().contains('lion')) {
      return 'assets/lion-air.png';
    } else if (airline.toLowerCase().contains('citilink')) {
      return 'assets/citilink.png';
    } else {
      return 'assets/default-airline.png';
    }
  }
}
