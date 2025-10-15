import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/appColor.dart';
import '../controller/new_transaction_controller.dart';

class TransactionSettingsSection extends StatelessWidget {
  final NewTransactionController controller;

  const TransactionSettingsSection({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.kBlack,
          ),
        ),
        const SizedBox(height: 20),

        // Payment Method
        _buildDropdownField(
          label: 'Payment Method',
          value: controller.selectedPaymentMethod,
          items: controller.paymentMethods,
          onChanged: (value) {
            controller.updatePaymentMethod(value!);
          },
          icon: Icons.payment_rounded,
        ),

        const SizedBox(height: 16),

        // Expected Delivery Date
        _buildDateField(context),

        const SizedBox(height: 16),

        // Additional Options
        _buildSwitchOption(
          title: 'Urgent Transaction',
          subtitle: 'Priority processing for urgent transactions',
          value: controller.isUrgent,
          onChanged: (value) {
            controller.toggleUrgent();
          },
          icon: Icons.priority_high_rounded,
        ),

        const SizedBox(height: 12),

        _buildSwitchOption(
          title: 'Requires Inspection',
          subtitle: 'Buyer will inspect before payment release',
          value: controller.requiresInspection,
          onChanged: (value) {
            controller.toggleRequiresInspection();
          },
          icon: Icons.verified_rounded,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.kBlack,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.kBorderGrey),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.kWhite,
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.kgrayColor100),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            dropdownColor: AppColors.kWhite,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expected Delivery Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.kBlack,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.kBorderGrey),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.kWhite,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.kgrayColor100,
                ),
                const SizedBox(width: 12),
                Text(
                  controller.expectedDeliveryDate != null
                      ? DateFormat(
                          'MMM dd, yyyy',
                        ).format(controller.expectedDeliveryDate!)
                      : 'Select delivery date',
                  style: TextStyle(
                    color: controller.expectedDeliveryDate != null
                        ? AppColors.kBlack
                        : AppColors.kgrayColor100,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    print('Date picker triggered'); // Debug print
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 7)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.kprimaryColor500,
                onPrimary: AppColors.kWhite,
                surface: AppColors.kWhite,
              ),
            ),
            child: child!,
          );
        },
      );
      print('Date picker result: $picked'); // Debug print
      if (picked != null && picked != controller.expectedDeliveryDate) {
        controller.updateExpectedDeliveryDate(picked);
        print(
          'Date updated to: ${DateFormat('MMM dd, yyyy').format(picked)}',
        ); // Debug print
      }
    } catch (e) {
      print('Error in date picker: $e'); // Debug print
    }
  }

  Widget _buildSwitchOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorderGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.kprimaryColor100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.kprimaryColor700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kBlack,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.kgrayColor100,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.kprimaryColor500,
          ),
        ],
      ),
    );
  }
}
