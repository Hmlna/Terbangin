import 'package:flutter/material.dart';
import 'package:terbangin/eticket.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _activeOrders = [
    {
      'bookingId': '1239903782',
      'price': 'IDR 2.306.500',
      'route': 'Lombok → Jakarta',
    },
    {
      'bookingId': '1236766403',
      'price': 'IDR 1.476.269',
      'route': 'Jakarta → Lombok',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveOrders(),
          _buildHistoryOrders(),
        ],
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
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 14),
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
            MaterialPageRoute(
              builder: (context) => ETicket(order: order),
            ),
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
                Text("Booking ID ${order['bookingId']}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(order['price'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(height: 20, thickness: 1),
                Row(
                  children: [
                    Icon(Icons.flight_takeoff, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(order['route']),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Active",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
    return Center(
      child: Text(
        "No past orders yet!",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}

  // Widget _buildActiveOrders() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Image.asset(
  //           'assets/traveler-waiting.png',
  //           height: 200,
  //         ),
  //         const SizedBox(height: 20),
  //         const Text(
  //           "Let’s book Terbangin!",
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 16,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         const Text(
  //           "Plan your trip with us!",
  //           style: TextStyle(
  //             color: Colors.grey,
  //             fontWeight: FontWeight.w300,
  //             fontSize: 14,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
