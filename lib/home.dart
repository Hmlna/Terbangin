import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terbangin/constants.dart';
import 'package:terbangin/flight.dart';
import 'package:terbangin/login.dart';
import 'package:terbangin/models/UserModel.dart';
import 'package:intl/intl.dart';
import 'package:terbangin/profile.dart';
import 'package:terbangin/token_provider.dart'; // For formatting dates

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  String? name;

  User? user;
  List<String> fromCities = [];
  List<String> toCities = [];
  String? selectedFrom;
  String? selectedTo;
  DateTime? selectedDate; // Store selected date
  List<dynamic> flights = []; // Store full flight data

  @override
  void initState() {
    super.initState();

    fetchFlightCities(1);
    loadTokenAndProfile();
    selectedDate = DateTime.now(); // Default to current date
  }

  Future<void> loadTokenAndProfile() async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    if (token != null && token.isNotEmpty) {
      await fetchProfile(token);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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
      setState(() {
        user = null;
        isLoading = false;
      });
    }
  }

  Future<void> fetchFlightCities(action) async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;

    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/flights'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            if (action == 1) {
              flights = jsonData['data'];
              fromCities =
                  flights
                      .map((flight) => flight['from'] as String)
                      .toSet()
                      .toList()
                    ..sort();
              selectedFrom = null;
              selectedTo = null;
            } else {
              toCities =
                  flights
                      .map((flight) => flight['destination'] as String)
                      .toSet()
                      .toList()
                    ..sort();
            }
          });
        }
      } else {
        print('Failed to fetch flights. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching flight cities: $e');
    }
  }

  List<String> getAvailableDestinations(String? selectedFrom) {
    if (selectedFrom == null) {
      return flights
          .map((flight) => flight['destination'] as String)
          .toSet()
          .toList()
        ..sort();
    }
    return flights
        .where((flight) => flight['from'] == selectedFrom)
        .map((flight) => flight['destination'] as String)
        .toSet()
        .toList()
      ..sort();
  }

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Generate JSON for search
  Map<String, dynamic> generateSearchJson() {
    return {
      'from': selectedFrom,
      'to': selectedTo,
      'date':
          selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
              : null,
    };
  }

  @override
  Widget build(BuildContext context) {
    String displayName = user?.name ?? "User";
    String displayDate =
        selectedDate != null
            ? DateFormat('MMM d, yyyy').format(selectedDate!)
            : "Select Date";

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
                        icon: const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: displayName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFF100),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Where do you want to travel?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
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
                                    _buildDropdownField(
                                      icon: Icons.flight_takeoff,
                                      title: "From",
                                      value: selectedFrom,
                                      items: fromCities,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedFrom = value;
                                          selectedTo = null;
                                          toCities = getAvailableDestinations(
                                            value,
                                          );
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildDropdownField(
                                      icon: Icons.flight_land,
                                      title: "To",
                                      value: selectedTo,
                                      items: toCities,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedTo = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildDateField(
                                      icon: Icons.date_range,
                                      title: "Departure",
                                      value: displayDate,
                                      onTap: () => _selectDate(context),
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
                                          if (selectedFrom != null &&
                                              selectedTo != null &&
                                              selectedDate != null) {
                                            // Generate JSON
                                            final searchData =
                                                generateSearchJson();
                                            print(
                                              jsonEncode(searchData),
                                            ); // For debugging
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => Flight(
                                                      searchData: searchData,
                                                    ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Please select From, To, and Departure date",
                                                ),
                                              ),
                                            );
                                          }
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF006BFF,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Search Flight",
                                          style: TextStyle(color: Colors.white),
                                        ),
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
                          child: const Text(
                            "Top Destination",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDestinationItem(
                                "assets/jakarta.png",
                                "Jakarta",
                              ),
                              _buildDestinationItem(
                                "assets/nusa-penida.png",
                                "Denpasar",
                              ),
                              _buildDestinationItem(
                                "assets/borobudur.png",
                                "Yogyakarta",
                              ),
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

  Widget _buildInputField({
    required IconData icon,
    required String title,
    required String value,
  }) {
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  Text(
                    title,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text(
                    "Select City",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  items:
                      items.isEmpty
                          ? [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                "No destinations available",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ]
                          : items.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  city,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                  onChanged: items.isEmpty ? null : onChanged,
                  menuMaxHeight: 300,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  selectedItemBuilder: (BuildContext context) {
                    return items.map((String city) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          city,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  itemHeight: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
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
        Text(
          cityName,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
