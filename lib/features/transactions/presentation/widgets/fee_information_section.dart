import 'package:flutter/material.dart';
import '../../../../core/utils/appColor.dart';
import '../controller/new_transaction_controller.dart';

class FeeInformationSection extends StatelessWidget {
  final NewTransactionController controller;

  const FeeInformationSection({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kprimaryColor50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kprimaryColor100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fee Breakdown',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.kprimaryColor700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction Amount',
                style: TextStyle(fontSize: 14, color: AppColors.kgrayColor100),
              ),
              Text(
                NewTransactionController.dollarFormatter.format(
                  controller.amount,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Escrow Fee (2.5%)',
                style: TextStyle(fontSize: 14, color: AppColors.kgrayColor100),
              ),
              Text(
                NewTransactionController.dollarFormatter.format(
                  controller.escrowFee,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kBlack,
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kprimaryColor700,
                ),
              ),
              Text(
                NewTransactionController.dollarFormatter.format(
                  controller.totalAmount,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kprimaryColor700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
