import 'package:flutter/material.dart';
import 'package:terbangin/edit_profile.dart';

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
      backgroundColor: Color(0xFFFEFEFE), 
      body: SafeArea(
        child:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
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
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 89, 
              decoration: BoxDecoration(
                color: Color(0xFF006BFF),
                borderRadius: BorderRadius.circular(
                  5,
                ), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                    offset: Offset(
                      0,
                      4,
                    ), 
                    blurRadius: 6, 
                    spreadRadius: 2, 
                  ),
                ],
              ),
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
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
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
                                Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfile()),
                          );
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
                                    Colors.white70, 
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
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Setting",
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
                    text: "Language",

                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Language tapped");
                    
                    },
                  ),
                  SizedBox(height: 16),

                  // Mata Uang
                  settingRow(
                    icon: Icons.attach_money,
                    text: "Currency",

                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Currency tapped");
                    },
                  ),
                  SizedBox(height: 16),

                  // Notifikasi
                  settingRow(
                    icon: Icons.notifications_none,
                    text: "Notification",

                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Notification tapped");
                    },
                  ),
                  SizedBox(height: 4),

                  settingRow(
                    icon: Icons.location_on_outlined,
                    text: "Location",

                    trailing: Transform.scale(
                      scale: 0.8, 
                      child: Switch(
                        value: isLocationEnabled,
                        onChanged: (val) {
                          setState(() {
                            isLocationEnabled = val;
                          });
                        },
                        activeColor: Color(0xFF006BFF), 
                        activeTrackColor:
                            Colors.blue[200], 
                        inactiveThumbColor: Colors.grey, 
                        inactiveTrackColor:
                            Colors.grey[300], 
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Container(
              width: MediaQuery.of(context).size.width * 0.95,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Other",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),

                  settingRow(
                    icon: Icons.help_outline,
                    text: "Help",

                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Help tapped");
                    },
                  ),
                  SizedBox(height: 16),

                  settingRow(
                    icon: Icons.info_outline,
                    text: "About",
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("About tapped");
                    },
                  ),
                  SizedBox(height: 16),

                  settingRow(
                    icon: Icons.logout,
                    text: "Logout",
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                    onTap: () {
                      print("Logout tapped");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        )
      ),
    );
  }
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
