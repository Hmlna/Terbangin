import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:terbangin/constants.dart';
import 'package:terbangin/flight.dart';
import 'package:terbangin/login.dart';
import 'package:terbangin/models/UserModel.dart';
import 'package:intl/intl.dart';
import 'package:terbangin/token_provider.dart';

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
  DateTime? selectedDate;
  List<dynamic> flights = [];
  int? passenger_num = 1; // Initialize passenger_num
  List<Map<String, dynamic>> allOrders = [];
  List<Map<String, dynamic>> topDestinations = [];

  // Mapping of city names to image assets
  final Map<String, dynamic> cityImageMap = {
    'Jakarta': 'assets/jakarta.png',
    'Denpasar': 'assets/nusa-penida.png',
    'Yogyakarta': 'assets/borobudur.png',
    'Bandung': 'assets/bandung.png',
    'Medan': 'assets/medan.png',
    'Makassar': 'assets/makassar.png',
    'Surabaya': 'assets/surabaya.png',
    // Add more city-to-image mappings as needed
  };

  @override
  void initState() {
    super.initState();
    fetchFlightCities(1);
    loadTokenAndProfile();
    selectedDate = DateTime.now();
  }

  Future<void> loadTokenAndProfile() async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    if (token != null && token.isNotEmpty) {
      print('[GET] Token: $token'); // Log token for debugging
      await fetchProfile(token);
      if (user != null) {
        await fetchTickets(token);
      }
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

  Future<void> fetchTickets(String token) async {
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

      print('Tickets API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed Tickets Data: $data');
        if (data['status'] == 'success') {
          setState(() {
            allOrders = List<Map<String, dynamic>>.from(data['data']);
            topDestinations = _getTopDestinations(allOrders);
            isLoading = false;
          });
        } else {
          setState(() {
            allOrders = [];
            topDestinations = _getDefaultDestinations();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          allOrders = [];
          topDestinations = _getDefaultDestinations();
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(content: Text('Failed to fetch tickets: ${response.statusCode}')),
          print('Failed to fetch tickets: ${response.statusCode}');
        // );
      }
    } catch (e) {
      setState(() {
        allOrders = [];
        topDestinations = _getDefaultDestinations();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tickets: $e')),
      );
      print('Error fetching tickets: $e');
    }
  }

  List<Map<String, dynamic>> _getTopDestinations(List<Map<String, dynamic>> orders) {
    Map<String, int> destinationCount = {};
    for (var order in orders) {
      // Access nested 'destination' field in 'flight'
      String? destination;
      if (order['flight'] is Map && order['flight']['destination'] is String) {
        destination = order['flight']['destination'] as String;
        // Normalize destination by removing airport code (e.g., "Denpasar (DPS)" -> "Denpasar")
        destination = destination.split('(')[0].trim();
      }
      if (destination != null && destination.isNotEmpty && cityImageMap.containsKey(destination)) {
        destinationCount[destination] = (destinationCount[destination] ?? 0) + 1;
      } else {
        print('Invalid or unmapped destination in order: $order');
      }
    }

    var sortedDestinations = destinationCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<Map<String, dynamic>> topDestinations = sortedDestinations.take(3).map((entry) {
      return {
        'city': entry.key,
        'image': cityImageMap[entry.key] ?? 'assets/default.png',
      };
    }).toList();

    if (topDestinations.length < 3) {
      var defaultDestinations = _getDefaultDestinations();
      for (var def in defaultDestinations) {
        if (!topDestinations.any((dest) => dest['city'] == def['city']) &&
            topDestinations.length < 3) {
          topDestinations.add(def);
        }
      }
    }

    return topDestinations;
  }

  List<Map<String, dynamic>> _getDefaultDestinations() {
    return [
      {'city': 'Jakarta', 'image': 'assets/jakarta.png'},
      {'city': 'Denpasar', 'image': 'assets/nusa-penida.png'},
      {'city': 'Yogyakarta', 'image': 'assets/borobudur.png'},
      // {'city': 'Bandung', 'image': 'assets/bandung.png'},
      // {'city': 'Medan', 'image': 'assets/medan.png'},
      // {'city': 'Makassar', 'image': 'assets/makassar.png'},
      // {'city': 'Surabaya', 'image': 'assets/surabaya.png'},
    ];
  }

  Future<void> fetchFlightCities(action) async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/flights'),
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

  Map<String, dynamic> generateSearchJson() {
    String? formattedDate;
    if (selectedDate != null) {
      formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      print('Formatted departure date: $formattedDate');
    }
    return {
      'from': selectedFrom,
      'destination': selectedTo,
      'departure': formattedDate,
      'passengers': passenger_num, // Include passenger_num in search JSON
    };
  }

  @override
  Widget build(BuildContext context) {
    String displayName = user?.name ?? "User";
    String displayDate =
        selectedDate != null ? DateFormat('MMM d, yyyy').format(selectedDate!) : "Select Date";

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
                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.notifications_none_outlined,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      //   onPressed: () {},
                      // ),
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
                                          toCities = getAvailableDestinations(value);
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
                                          child: _buildPassengerDropdownField(
                                            icon: Icons.people,
                                            title: "Passengers",
                                            value: passenger_num?.toString(),
                                            items: ['1', '2', '3'],
                                            onChanged: (value) {
                                              setState(() {
                                                passenger_num = int.parse(value!);
                                              });
                                            },
                                          ),
                                        ),
                                        // const SizedBox(width: 12),
                                        // Expanded(
                                        //   child: _buildInputField(
                                        //     icon: Icons.event_seat,
                                        //     title: "Seat Class",
                                        //     value: "Economy",
                                        //   ),
                                        // ),
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
                                              selectedDate != null &&
                                              passenger_num != null) {
                                            final searchData = generateSearchJson();
                                            print(jsonEncode(searchData));
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => Flight(
                                                  searchData: searchData,
                                                  user_id: user!.id,
                                                  passenger_num: passenger_num!,
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Please select From, To, Departure date, and Passengers",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF006BFF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
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
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: topDestinations.isEmpty
                                      ? [
                                          const Center(
                                            child: Text(
                                              "No top destinations available",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ]
                                      : topDestinations.map((dest) {
                                          final city = dest['city'] as String;
                                          final image = dest['image'] as String;
                                          return _buildDestinationItem(image, city);
                                        }).toList(),
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

  Widget _buildPassengerDropdownField({
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
                    "Select Passengers",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  items: items.map((String number) {
                    return DropdownMenuItem<String>(
                      value: number,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          number,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                  menuMaxHeight: 300,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  selectedItemBuilder: (BuildContext context) {
                    return items.map((String number) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          number,
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
                  items: items.isEmpty
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
            errorBuilder: (context, error, stackTrace) {
              print('Image load error for $imagePath: $error');
              return const Placeholder();
            },
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