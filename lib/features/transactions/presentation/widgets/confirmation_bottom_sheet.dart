import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/appColor.dart';
import '../controller/new_transaction_controller.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final NewTransactionController controller;
  final Map<String, String> summary;
  final VoidCallback onConfirm;

  const ConfirmationBottomSheet({
    super.key,
    required this.controller,
    required this.summary,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSheetHeight = screenHeight * 0.8;

    return Container(
      height: bottomSheetHeight,
      decoration: const BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.kgrayColor100,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.kprimaryColor100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: AppColors.kprimaryColor700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Transaction',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kBlack,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Review your transaction details',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kgrayColor100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kprimaryColor50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.kprimaryColor100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long_rounded,
                              color: AppColors.kprimaryColor700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Transaction Summary',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.kprimaryColor700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          'Amount',
                          NewTransactionController.dollarFormatter.format(
                            controller.amount,
                          ),
                        ),
                        _buildSummaryRow(
                          'Escrow Fee (2.5%)',
                          NewTransactionController.dollarFormatter.format(
                            controller.escrowFee,
                          ),
                        ),
                        const Divider(height: 16),
                        _buildSummaryRow(
                          'Total',
                          NewTransactionController.dollarFormatter.format(
                            controller.totalAmount,
                          ),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Transaction Details
                  const Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kBlack,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Product Information
                  _buildDetailSection(
                    'Product Information',
                    Icons.inventory_2_rounded,
                    [
                      _buildDetailRow('Title', controller.titleController.text),
                      _buildDetailRow('Category', controller.selectedCategory),
                      _buildDetailRow(
                        'Description',
                        controller.descriptionController.text,
                        isLong: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Participant Information
                  _buildDetailSection(
                    'Participant Information',
                    Icons.people_rounded,
                    [
                      _buildDetailRow(
                        'Seller',
                        controller.userDetails.email ?? 'No email available',
                      ),
                      _buildDetailRow(
                        'Buyer',
                        controller.buyerEmailController.text,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Transaction Settings
                  _buildDetailSection(
                    'Transaction Settings',
                    Icons.settings_rounded,
                    [
                      _buildDetailRow(
                        'Payment Method',
                        controller.selectedPaymentMethod,
                      ),
                      _buildDetailRow(
                        'Delivery Date',
                        controller.expectedDeliveryDate != null
                            ? DateFormat(
                                'MMM dd, yyyy',
                              ).format(controller.expectedDeliveryDate!)
                            : 'Not set',
                      ),
                      _buildDetailRow(
                        'Urgent',
                        controller.isUrgent ? 'Yes' : 'No',
                      ),
                      _buildDetailRow(
                        'Inspection Required',
                        controller.requiresInspection ? 'Yes' : 'No',
                      ),
                    ],
                  ),

                  if (controller.selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildDetailSection(
                      'Product Images',
                      Icons.photo_library_rounded,
                      [
                        _buildDetailRow(
                          'Images Count',
                          '${controller.selectedImages.length} images selected',
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Important Notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kprimaryColor50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.kprimaryColor100),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.kprimaryColor700,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'By confirming, you agree to our escrow terms and conditions. The transaction will be held securely until both parties are satisfied.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.kprimaryColor700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom spacing for actions
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kprimaryColor100.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Cancel button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.kBorderGrey),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.kgrayColor100,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kprimaryColor500,
                      foregroundColor: AppColors.kWhite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirm & Create Transaction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal
                  ? AppColors.kprimaryColor700
                  : AppColors.kgrayColor100,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppColors.kprimaryColor700 : AppColors.kBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.kprimaryColor700, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kBlack,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLong = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.kgrayColor100,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not provided' : value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: value.isEmpty ? AppColors.kgrayColor100 : AppColors.kBlack,
            ),
            maxLines: isLong ? 3 : 1,
            overflow: isLong ? TextOverflow.ellipsis : null,
          ),
        ],
      ),
    );
  }
}
