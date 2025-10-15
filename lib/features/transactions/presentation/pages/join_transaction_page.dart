import 'package:PaySafe/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/appColor.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../controller/join_transaction_controller.dart';
import 'package:collection/collection.dart';
// import '../widgets/transaction_card.dart';
// import '../widgets/search_filter_section.dart';

final joinTransactionControllerProvider =
    ChangeNotifierProvider.family<JoinTransactionController, AuthController>(
      (ref, authController) => JoinTransactionController(authController),
    );

class JoinTransactionPage extends ConsumerStatefulWidget {
  const JoinTransactionPage({super.key});

  @override
  ConsumerState<JoinTransactionPage> createState() =>
      _JoinTransactionPageState();
}

class _JoinTransactionPageState extends ConsumerState<JoinTransactionPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Delay to ensure context and ref are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = ref.read(authProvider);
      ref
          .read(joinTransactionControllerProvider(authController))
          .loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authProvider);
    final controller = ref.watch(
      joinTransactionControllerProvider(authController),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Transaction'),
        backgroundColor: AppColors.kprimaryColor500,
        foregroundColor: AppColors.kWhite,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_add_rounded,
              size: 80,
              color: AppColors.kprimaryColor500,
            ),
            const SizedBox(height: 24),
            const Text(
              'Join an Existing Transaction',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Enter a transaction code or browse available transactions to join as a participant.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.kgrayColor100),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter transaction code',
                  filled: true,
                  fillColor: AppColors.kBackgroundColor,
                  prefixIcon: Icon(Icons.vpn_key_rounded),
                  // Light grey border when the field is enabled (but not focused)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300, // very light grey
                      width: 1,
                    ),
                  ),
                  // Slightly darker grey when focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  // (optional) greyed-out border when disabled
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  // (optional) red border on error
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.red.shade200,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final code = _searchController.text.trim();
                if (code.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a transaction code.'),
                      backgroundColor: AppColors.kprimaryColor500,
                    ),
                  );
                  return;
                }
                // Look up transaction by code (id)
                final transaction = controller.allTransactions.firstWhereOrNull(
                  (t) => t['id'] == code,
                );
                if (transaction == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Transaction not found. Please check the code.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                // Show details preview dialog
                _showJoinConfirmation(transaction, controller);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kprimaryColor500,
                foregroundColor: AppColors.kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Join Transaction',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinConfirmation(
    Map<String, dynamic> transaction,
    JoinTransactionController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.kBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final bottomSheetHeight = screenHeight * 0.8;
        return Container(
          height: bottomSheetHeight,
          decoration: const BoxDecoration(
            color: AppColors.kBackgroundColor,
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header and content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.kprimaryColor100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: AppColors.kprimaryColor700,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'Transaction Preview',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kprimaryColor700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      transaction['title'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.kBlack,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.kprimaryColor200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      transaction['category'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.kprimaryColor700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '\$',
                                  decimalDigits: 2,
                                ).format(transaction['amount']),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.kprimaryColor700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 17,
                                    color: AppColors.kprimaryColor500,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    transaction['seller'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.kgrayColor100,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: AppColors.kprimaryColor500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat(
                                      'MMM d, yyyy',
                                    ).format(transaction['expectedDelivery']),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.kgrayColor100,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  if (transaction['isUrgent'] == true)
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Urgent',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  if (transaction['requiresInspection'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Inspection Required',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (transaction['images'] != null &&
                                  transaction['images'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 14,
                                    bottom: 6,
                                  ),
                                  child: SizedBox(
                                    height: 70,
                                    width: double.infinity,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: transaction['images'].length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 8),
                                      itemBuilder: (context, idx) {
                                        final img = transaction['images'][idx];
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Container(
                                            color: AppColors.kprimaryColor100,
                                            width: 70,
                                            height: 70,
                                            child: Center(
                                              child: Text(
                                                img,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors
                                                      .kprimaryColor700,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              const Divider(height: 24),
                              Text(
                                transaction['description'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.kBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Action buttons fixed at the bottom
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: BoxDecoration(
                  color: AppColors.kBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kprimaryColor100.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    Text(
                      'Would you like to join this transaction or reject it?',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.kgrayColor100,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Reject Transaction'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              controller.joinTransaction(transaction, context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kprimaryColor500,
                              foregroundColor: AppColors.kWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Join'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
