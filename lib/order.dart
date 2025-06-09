import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:terbangin/constants.dart';
import 'package:terbangin/eticket.dart';
import 'package:terbangin/models/UserModel.dart';
import 'package:terbangin/token_provider.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  String? name;
  User? user;
  List<Map<String, dynamic>> _activeOrders = [];
  List<Map<String, dynamic>> _historyOrders = [];
  List<Map<String, dynamic>> _allOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final token = Provider.of<TokenProvider>(context, listen: false).token;

    fetchProfile(token).then((_) {
      if (user != null) {
        fetchTicket(token);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> fetchProfile(token) async {
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

      print('Profile Response status: ${response.statusCode}');
      print('Profile Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          user = User.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          user = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Profile Fetch Error: $e');
      setState(() {
        user = null;
        isLoading = false;
      });
    }
  }

  Future<void> fetchTicket(token) async {
    print("Masuk");
    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('$baseUrl/tickets/user/${user!.id}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Ticket Response status: ${response.statusCode}');
      print('Ticket Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        if (data['status'] == 'success') {
          print("im hereeee");
          setState(() {
            _allOrders = List<Map<String, dynamic>>.from(data['data']);
            for (var order in _allOrders) {
              if (order['status'] == 'confirmed') {
                _historyOrders.add(order);
              } else if (order['status'] == 'active') {
                _activeOrders.add(order);
              }
            }
            isLoading = false;
          });
        } else {
          setState(() {
            _allOrders = [];
            isLoading = false;
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _allOrders = [];
          isLoading = false;
        });
      } else {
        setState(() {
          _allOrders = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Ticket Fetch Error: $e');
      setState(() {
        _allOrders = [];
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Your Orders",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          tabs: const [Tab(text: 'Active'), Tab(text: 'History')],
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [_buildActiveOrders(), _buildHistoryOrders()],
              ),
    );
  }

  Widget _buildActiveOrders() {
    if (_activeOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/traveler-waiting.png', height: 200),
            const SizedBox(height: 20),
            const Text(
              "Let’s book Terbangin!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Plan your trip with us!",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activeOrders.length,
      itemBuilder: (context, index) {
        final order = _activeOrders[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ETicket(order: order)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ticket ID ${order['ticket_id']}",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Flight ID ${order['flight_id']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    children: [
                      Icon(Icons.flight_takeoff, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text("E-Ticket: ${order['e_ticket']}"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    order['status'],
                    style: TextStyle(
                      color: Colors.green,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryOrders() {
    if (_historyOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/traveler-waiting.png', height: 200),
            const SizedBox(height: 20),
            const Text(
              "Let’s book Terbangin!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Plan your trip with us!",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historyOrders.length,
      itemBuilder: (context, index) {
        final order = _historyOrders[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ETicket(order: order)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ticket ID ${order['ticket_id']}",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Flight ID ${order['flight_id']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    children: [
                      Icon(Icons.flight_takeoff, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text("E-Ticket: ${order['e_ticket']}"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    order['status'],
                    style: TextStyle(
                      color: Colors.green,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
