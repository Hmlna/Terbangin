import 'package:flutter/material.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}
class _EditProfileState extends State<EditProfile> {
  final _identityFormKey = GlobalKey<FormState>(); 
  final _contactFormKey = GlobalKey<FormState>(); 
  final TextEditingController emailController =
      TextEditingController(text: "elon@spacex.com");
  final TextEditingController nameController =
      TextEditingController(text: "Jaka");
  final TextEditingController numberController =
      TextEditingController(text: "087654321234");
  final TextEditingController ninController =
      TextEditingController(text: "2838177329162516");

  String selectedCountry = 'Indonesia';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFEFE), 
       body: SafeArea(
        child:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Profile Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            Divider(color: Colors.grey.shade400, thickness: 1, height: 0,),
            SizedBox(height: 40),
            ClipOval(
              child: Image.asset(
                "assets/avatar.png",
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Elon Musk",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18, 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Center(
              child: Text(
                "YiilonMa@gmail.com",
                style: TextStyle(
                  color: Color(0xFFABABAB),
                  fontSize: 18, 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Center(
              child: Text(
                "08123456789",
                style: TextStyle(
                  color: Color(0xFFABABAB),
                  fontSize: 18, 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 50),
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
              child: Form(
                key: _identityFormKey, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Identity Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    labeledDropdownField(
                      label: "Country",
                      selectedValue: selectedCountry,
                      items: ['Indonesia', 'Malaysia', 'Singapore', 'United States'],
                      onChanged: (val) {
                        setState(() {
                          selectedCountry = val!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    labeledTextField(
                      label: "National Identity Number (NIN)",
                      controller: ninController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'NIN must be filled';
                        if (value.length != 16) return 'NIN must be 16 digits';
                        if (!RegExp(r'^\d{16}$').hasMatch(value)) {
                          return 'NIN must be numeric';
                        }                        
                        
                        return null;
                      },
                    ),
                  ],
                ),
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
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _contactFormKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Emergency Contact",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    labeledTextField(
                      label: "Name",
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Name must be filled';
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Name cannot contain numbers';
                        }  
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                            
                   
                    labeledTextField(
                      label: "Phone Number",
                      controller: numberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Phone Number must be filled';
                        if (!RegExp(r'^[0-9]+$').hasMatch(value) || value.length <7 || value.length > 15) {
                            return 'Phone Number not Valid';
                        }  
                        return null;
                      },
                    ),
                  
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
            
              style: ElevatedButton.styleFrom(
                
                backgroundColor: Color(0xFF006BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                if (_identityFormKey.currentState!.validate() &&
                    _contactFormKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Data successfully updated")),
                  );
                }
              },
              child: Text("Save Changes", style: TextStyle(color: Colors.white)),
            ),

          ],
        ),
        )
      ),
    
      
    );
  }
}

Widget labeledTextField({
  required String label,
  required TextEditingController controller,
  String? Function(String?)? validator, 
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      SizedBox(height: 4),
      TextFormField(
        controller: controller,
        validator: validator, 
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    ],
  );
}




Widget labeledDropdownField({
  required String label,
  required String? selectedValue,
  required List<String> items,
  required void Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 4),
      DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    ],
  );
}