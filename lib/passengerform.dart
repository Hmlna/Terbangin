import 'package:flutter/material.dart';

class PassengerForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const PassengerForm({super.key, required this.initialData, required this.onSave});

  @override
  State<PassengerForm> createState() => _PassengerFormState();
  
}

class _PassengerFormState extends State<PassengerForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _fullName = "";
  String _birthDate = "";
  DateTime? selectedDate;
  TextEditingController birthDateController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _title = widget.initialData["title"];
    _fullName = widget.initialData["fullName"];
    _birthDate = widget.initialData["birthDate"];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Passenger info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _fullName,
                    decoration: const InputDecoration(labelText: "Full Name"),
                    onChanged: (value) => _fullName = value,
                    validator: (value) => value!.isEmpty ? "Must be filled" : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: "Mr",
                          groupValue: _title,
                          title: const Text("Mr"),
                          onChanged: (value) => setState(() => _title = value!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: "Mrs",
                          groupValue: _title,
                          title: const Text("Mrs"),
                          onChanged: (value) => setState(() => _title = value!),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: birthDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Birth Date",
                      hintText: "DD/MM/YYYY",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final now = DateTime.now();
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: now,
                      );

                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                          birthDateController.text = "${picked.day.toString().padLeft(2, '0')}/"
                              "${picked.month.toString().padLeft(2, '0')}/"
                              "${picked.year}";
                        });
                      }
                    },
                    validator: (value) => value == null || value.isEmpty ? "Must be filled" : null,
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave({
                            "title": _title,
                            "fullName": _fullName,
                            "birthDate": _birthDate,
                          });
                        }
                      },
                      child: const Text("Save"),
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
}
