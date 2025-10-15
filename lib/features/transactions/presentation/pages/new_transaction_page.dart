import 'package:PaySafe/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/appColor.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../controller/new_transaction_controller.dart';
import '../widgets/confirmation_bottom_sheet.dart';
import '../widgets/transaction_form_section.dart';
import '../widgets/participant_info_section.dart';
import '../widgets/transaction_settings_section.dart';
import '../widgets/image_upload_section.dart';
import '../widgets/fee_information_section.dart';

class NewTransactionPage extends ConsumerStatefulWidget {
  const NewTransactionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends ConsumerState<NewTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authProvider);
    final controller = ref.watch(
      newTransactionControllerProvider(authController),
    );

    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.kBlack,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Transaction',
          style: TextStyle(
            color: AppColors.kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.kgrayColor100,
            ),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.kWhite,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kprimaryColor50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.kprimaryColor100,
                        width: 1,
                      ),
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
                            'Create a secure escrow transaction to protect both buyer and seller.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.kprimaryColor700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kprimaryColor100.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TransactionFormSection(controller: controller),
                      const SizedBox(height: 16),
                      ImageUploadSection(controller: controller),
                      const SizedBox(height: 20),
                      ParticipantInfoSection(controller: controller),
                      const SizedBox(height: 20),
                      TransactionSettingsSection(controller: controller),
                      const SizedBox(height: 24),
                      FeeInformationSection(controller: controller),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => _showConfirmationDialog(controller),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kprimaryColor500,
                            foregroundColor: AppColors.kWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Create Transaction',
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
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(NewTransactionController controller) {
    if (_formKey.currentState!.validate()) {
      final summary = controller.getTransactionSummary();
      showDialog(
        context: context,
        builder: (context) => ConfirmationBottomSheet(
          controller: controller,
          summary: summary,
          onConfirm: () => controller.createTransaction(context),
        ),
      );
    }
  }
}

final newTransactionControllerProvider =
    ChangeNotifierProvider.family<NewTransactionController, AuthController>(
      (ref, authController) => NewTransactionController(authController),
    );
