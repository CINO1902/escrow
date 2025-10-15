// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String initialCountryCode;
  final Function(PhoneNumber) onChanged;

  const CustomPhoneField({
    Key? key,
    required this.controller,
    required this.initialCountryCode,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntlPhoneField(
          controller: controller,
          initialCountryCode: initialCountryCode,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
