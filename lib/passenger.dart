import 'package:flutter/material.dart';
import 'package:terbangin/models/UserModel.dart';
import 'package:terbangin/passengerform.dart';
import 'package:terbangin/payment.dart';

class Passenger extends StatefulWidget {
  final Map<String, dynamic> ticket;
  final int passenger_num;
  const Passenger({
    super.key,
    required this.ticket,
    required this.passenger_num,
  });

  @override
  _PassengerState createState() => _PassengerState();
}

class _PassengerState extends State<Passenger> {
  User? user;
  bool isLoading = true;

  List<Map<String, dynamic>> passengers = List.generate(
    3,
    (_) => {"title": "", "fullName": "", "birthDate": "", "nik_number": ""},
  );

  @override
  void initState() {
    super.initState();
  }

  void _openPassengerForm(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => PassengerForm(
            initialData: passengers[index],
            onSave: (data) {
              setState(() {
                passengers[index] = data;
              });
              Navigator.pop(context);
            },
          ),
    );
  }

  // Check if all required fields for all passengers are filled
  bool _areAllPassengersFilled() {
    for (int i = 0; i < widget.passenger_num; i++) {
      final passenger = passengers[i];
      if (passenger["title"].isEmpty ||
          passenger["fullName"].isEmpty ||
          passenger["birthDate"].isEmpty ||
          passenger["nik_number"].isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
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
                  const Text(
                    "Finish your order",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _passengerDetailSection(),
            const Spacer(),
            SizedBox(
              width: 351,
              child: ElevatedButton(
                onPressed: _areAllPassengersFilled()
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => Payment(
                                  ticket: widget.ticket,
                                  user_id: widget.ticket['user_id'],
                                  passengerList: passengers,
                                  passenger_num: widget.passenger_num,
                                ),
                          ),
                        );
                      }
                    : null, // Disable button if not all fields are filled
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passengerDetailSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Passenger details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Text(
            "All passenger data must be filled in*",
            style: TextStyle(color: Colors.red, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ...List.generate(widget.passenger_num, (i) {
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  passengers[i]["fullName"].isNotEmpty
                      ? passengers[i]["fullName"]
                      : "Passenger ${i + 1}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openPassengerForm(i),
              ),
            );
          }),
        ],
      ),
    );
  }
}