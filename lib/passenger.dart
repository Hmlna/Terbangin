import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:terbangin/constants.dart';
import 'package:terbangin/models/UserModel.dart';
import 'package:terbangin/passengerform.dart';
import 'package:terbangin/payment.dart';
import 'package:terbangin/token_provider.dart';

class Passenger extends StatefulWidget {
  final Map<String, dynamic> ticket;

  const Passenger({super.key, required this.ticket});

  @override
  _PassengerState createState() => _PassengerState();
}

class _PassengerState extends State<Passenger> {
  User? user;
  bool isLoading = true;

  List<Map<String, dynamic>> passengers = List.generate(3, (_) => {
        "title": "",
        "fullName": "",
        "birthDate": "",
      });

  @override
  void initState() {
    super.initState();
    loadTokenAndProfile();
  }

  Future<void> loadTokenAndProfile() async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    if (token != null && token.isNotEmpty) {
      await fetchProfile(token);
    }
  }

  Future<void> fetchProfile(String token) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('$baseUrl/user');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fetchedUser = User.fromJson(data);
        setState(() {
          user = fetchedUser;
          // Set passenger[0] hanya dengan name
          passengers[0]["fullName"] = fetchedUser.name;
          isLoading = false;
        });
      } else {
        setState(() {
          user = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        user = null;
        isLoading = false;
      });
    }
  }

  void _openPassengerForm(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PassengerForm(
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
                onPressed: () {
                 print("aaleokfoawkod");
                  print(widget.ticket);
                  print(widget.ticket['user_id']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Payment(
                        ticket: widget.ticket,
                        user_id: widget.ticket['user_id'],
                      ),
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
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
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
          const Text("Passenger details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const Text("All passenger data must be filled in*", style: TextStyle(color: Colors.red, fontSize: 13)),
          const SizedBox(height: 20),
          ...List.generate(1, (i) {
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                title: Text("Passenger ${i + 1}"),
                subtitle: Text(
                  passengers[i]["fullName"].isNotEmpty
                      ? "${passengers[i]["title"]} ${passengers[i]["fullName"]} (${passengers[i]["birthDate"]})"
                      : "Must be filled",
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
