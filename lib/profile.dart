import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terbangin/about.dart';
import 'package:terbangin/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:terbangin/models/UserModel.dart';
import 'package:terbangin/token_provider.dart';
import 'package:terbangin/constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = true;
  User? user;

  @override
  void initState() {
    super.initState();
    loadTokenAndProfile();
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
      } else if (response.statusCode == 401) {
        logout(token);
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

  Future<void> logout(String token) async {
    final url = Uri.parse('$baseUrl/logout');
    try {
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        Provider.of<TokenProvider>(context, listen: false).setToken('');

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } else {
        // showError('Logout gagal: ${response.statusCode}');
      }
    } catch (e) {
      // showError('Terjadi kesalahan saat logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Divider(color: Colors.grey.shade400, thickness: 1),
              const SizedBox(height: 25),
              // Profile Card
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 89,
                decoration: BoxDecoration(
                  color: const Color(0xFF006BFF),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 25),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        ClipOval(
                          child: Image.asset(
                            "assets/avatar.png",
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  "Hello, ${user?.name ?? 'User'}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "User Information",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF006BFF),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userInfoRow(
                                icon: Icons.person,
                                label: "Name",
                                value: user?.name ?? "Not available",
                              ),
                              const SizedBox(height: 12),
                              userInfoRow(
                                icon: Icons.email,
                                label: "Email",
                                value: user?.email ?? "Not available",
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    settingRow(
                      icon: Icons.info_outline,
                      text: "About",
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade600,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => About()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    settingRow(
                      icon: Icons.logout,
                      text: "Logout",
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade600,
                      ),
                      onTap: () {
                        if (token != null) {
                          logout(token);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingRow({
    required IconData icon,
    required String text,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget userInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 24,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}