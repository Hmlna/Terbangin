import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLocationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFEFE), // optional for visibility
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24, // Larger text size for the profile header
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 25),
            Divider(color: Colors.grey.shade400, thickness: 1),
            SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF006BFF),
                borderRadius: BorderRadius.circular(
                  5,
                ), // Adjust the radius for the circular effect
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.3,
                    ), // Shadow color with opacity
                    offset: Offset(
                      0,
                      4,
                    ), // Offset for the shadow (horizontal, vertical)
                    blurRadius: 6, // Blur radius for the shadow
                    spreadRadius: 2, // Spread radius for the shadow
                  ),
                ],
              ),
              width: 365, // Width of the box
              height: 89, // Height of the box
              child: Row(
                children: [
                  SizedBox(width: 25),
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
                    // This will take up the remaining space in the Row
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center text vertically
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hello, Elon",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1),
                        TextButton(
                          onPressed: () {
                            // Your action here
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            splashFactory: NoSplash.splashFactory,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: "Edit your profile",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Colors.white70, // 👈 underline color
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              width: 365,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pengaturan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Bahasa
                  settingRow(
                    icon: Icons.language,
                    text: "Bahasa",

                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Bahasa tapped!");
                      // Navigate or do something here
                    },
                  ),
                  SizedBox(height: 16),

                  // Mata Uang
                  settingRow(
                    icon: Icons.attach_money,
                    text: "Mata Uang",

                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Bahasa tapped!");
                      // Navigate or do something here
                    },
                  ),
                  SizedBox(height: 16),

                  // Notifikasi
                  settingRow(
                    icon: Icons.notifications_none,
                    text: "Notifikasi",

                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Bahasa tapped!");
                      // Navigate or do something here
                    },
                  ),
                  SizedBox(height: 4),

                  // Lokasi
                  settingRow(
                    icon: Icons.location_on_outlined,
                    text: "Lokasi",

                    trailing: Transform.scale(
                      scale: 0.8, // 👈 adjust this to your desired size
                      child: Switch(
                        value: isLocationEnabled,
                        onChanged: (val) {
                          setState(() {
                            isLocationEnabled = val;
                          });
                        },
                        activeColor: Color(0xFF006BFF), // Thumb color when ON
                        activeTrackColor:
                            Colors.blue[200], // Track color when ON
                        inactiveThumbColor: Colors.grey, // Thumb color when OFF
                        inactiveTrackColor:
                            Colors.grey[300], // Track color when OFF
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              width: 365,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lainnya",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Pusat Bantuan
                  settingRow(
                    icon: Icons.help_outline,
                    text: "Pusat Bantuan",

                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Bahasa tapped!");
                      // Navigate or do something here
                    },
                  ),
                  SizedBox(height: 16),

                  // Tentang Terbangin
                  settingRow(
                    icon: Icons.info_outline,
                    text: "Tentang Terbangin",
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Bahasa tapped!");
                      // Navigate or do something here
                    },
                  ),
                  SizedBox(height: 16),

                  // Keluar
                  settingRow(
                    icon: Icons.logout,
                    text: "Keluar",
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Bahasa tapped!");
                      // Navigate or do something here
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget settingRow({
  required IconData icon,
  required String text,
  required Widget trailing,
  VoidCallback? onTap, // <-- Add this
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
              SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
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
