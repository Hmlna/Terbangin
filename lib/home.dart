import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terbangin/flight.dart';

import 'package:terbangin/models/UserModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  void getUserProfile() async {
    User? fetchedUser = await fetchProfile();
    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;
      });
    }
  }

  Future<User?> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return User.fromJson(jsonData);
      } else {
        print('Gagal ambil profil. Kode: ${response.statusCode}');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String displayName = user?.name ?? "User";

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 426,
            decoration: const BoxDecoration(color: Color(0xFF006BFF)),
            child: SvgPicture.asset(
              'assets/plane-cloud-back.svg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 21,
                        backgroundImage: const AssetImage("assets/avatar.png"),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 30),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text.rich(
                    TextSpan(
                      text: "Hello, ",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$displayName",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFFFF100)),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Where do you want to travel?",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Transform.translate(
                    offset: const Offset(0, -30),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x1A000000),
                                      offset: const Offset(0.4, 1.6),
                                      blurRadius: 3.6,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(26),
                                child: Column(
                                  children: [
                                    _buildInputField(
                                      icon: Icons.flight_takeoff,
                                      title: "From",
                                      value: "Yogyakarta (YIA)",
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInputField(
                                      icon: Icons.flight_land,
                                      title: "To",
                                      value: "Jakarta (CGK)",
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInputField(
                                      icon: Icons.date_range,
                                      title: "Departure",
                                      value: "Mar 19, 2025",
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInputField(
                                            icon: Icons.people,
                                            title: "Passengers",
                                            value: "3",
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInputField(
                                            icon: Icons.event_seat,
                                            title: "Seat Class",
                                            value: "Economy",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => const Flight()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF006BFF),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        child: const Text("Search Flight", style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: const Text("Top Destination", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDestinationItem("assets/jakarta.png", "Jakarta"),
                              _buildDestinationItem("assets/nusa-penida.png", "Denpasar"),
                              _buildDestinationItem("assets/borobudur.png", "Yogyakarta"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({required IconData icon, required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationItem(String imagePath, String cityName) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            width: 90,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(cityName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
