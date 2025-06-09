import 'package:flutter/material.dart';

class PassengerForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const PassengerForm({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _fullName = "";
  String _birthDate = "";
  String _nik = "";
  DateTime? selectedDate;
  TextEditingController birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _title = widget.initialData["title"] ?? "";
    _fullName = widget.initialData["fullName"] ?? "";
    _birthDate = widget.initialData["birthDate"] ?? "";
    _nik = widget.initialData["nik_number"] ?? "";

    // Initialize birthDateController with formatted date
    if (_birthDate.isNotEmpty) {
      try {
        final date = DateTime.parse(_birthDate);
        selectedDate = date;
        birthDateController.text =
            "${date.day.toString().padLeft(2, '0')}/"
            "${date.month.toString().padLeft(2, '0')}/"
            "${date.year}";
      } catch (e) {
        // Handle invalid date format if necessary
        birthDateController.text = "";
      }
    }
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
            const Text(
              "Passenger info",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _fullName,
                    decoration: const InputDecoration(labelText: "Full Name"),
                    onChanged: (value) => _fullName = value,
                    validator:
                        (value) => value!.isEmpty ? "Must be filled" : null,
                  ),
                  const SizedBox(height: 12),
                  FormField<String>(
                    initialValue: _title,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? "Must select a title"
                                : null,
                    builder: (FormFieldState<String> field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  value: "Mr",
                                  groupValue: _title,
                                  title: const Text("Mr"),
                                  onChanged: (value) {
                                    setState(() {
                                      _title = value!;
                                      field.didChange(value);
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  value: "Mrs",
                                  groupValue: _title,
                                  title: const Text("Mrs"),
                                  onChanged: (value) {
                                    setState(() {
                                      _title = value!;
                                      field.didChange(value);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (field.errorText != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: Text(
                                field.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _nik,
                    decoration: const InputDecoration(
                      labelText: "NIK",
                      hintText: "Enter 16-digit NIK",
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    onChanged: (value) => _nik = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Must be filled";
                      }
                      if (value.length != 16) {
                        return "NIK must be exactly 16 digits";
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return "NIK must contain only digits";
                      }
                      return null;
                    },
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
                          _birthDate =
                              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          birthDateController.text =
                              "${picked.day.toString().padLeft(2, '0')}/"
                              "${picked.month.toString().padLeft(2, '0')}/"
                              "${picked.year}";
                        });
                      }
                    },
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Must be filled"
                                : null,
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
                            "nik_number": _nik,
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