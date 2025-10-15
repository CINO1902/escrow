import 'dart:io';
import 'package:PaySafe/features/transactions/presentation/controller/join_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/appColor.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../auth/domain/entities/UserDetailsResponse.dart';

class NewTransactionController extends ChangeNotifier {
  final AuthController _authController;

  NewTransactionController(this._authController);

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController buyerEmailController = TextEditingController();

  // Form state
  String selectedCategory = 'Electronics';
  String selectedPaymentMethod = 'Escrow';
  DateTime? expectedDeliveryDate;
  bool isUrgent = false;
  bool requiresInspection = false;

  // Image related variables
  List<File> selectedImages = [];
  final ImagePicker imagePicker = ImagePicker();
  bool isPickingImage = false;

  // Formatters
  static final dollarFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  // Dropdown options
  final List<String> categories = [
    'Electronics',
    'Fashion & Accessories',
    'Home & Garden',
    'Sports & Outdoors',
    'Books & Media',
    'Automotive',
    'Real Estate',
    'Services',
    'Other',
  ];

  final List<String> paymentMethods = [
    'Escrow',
    'Direct Payment',
    'Bank Transfer',
    'Credit Card',
  ];

  // Getters
  UserDetails get userDetails => _authController.userDetails;

  double get amount => double.tryParse(amountController.text) ?? 0.0;
  double get escrowFee => amount * 0.025; // 2.5% escrow fee
  double get totalAmount => amount + escrowFee;

  bool get canAddMoreImages => selectedImages.length < 5;
  bool get hasImages => selectedImages.isNotEmpty;

  // Methods
  void updateCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void updatePaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  void updateExpectedDeliveryDate(DateTime? date) {
    expectedDeliveryDate = date;
    notifyListeners();
  }

  void toggleUrgent() {
    isUrgent = !isUrgent;
    notifyListeners();
  }

  void toggleRequiresInspection() {
    requiresInspection = !requiresInspection;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    if (!canAddMoreImages) {
      _showSnackBar(context, 'Maximum 5 images allowed', isError: true);
      return;
    }

    isPickingImage = true;
    notifyListeners();

    try {
      List<XFile> pickedFiles = [];

      if (source == ImageSource.gallery) {
        // For gallery, allow multiple selection
        pickedFiles = await imagePicker.pickMultiImage(
          imageQuality: 80,
          maxWidth: 1024,
          maxHeight: 1024,
        );
      } else {
        // For camera, single image
        final XFile? pickedFile = await imagePicker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1024,
          maxHeight: 1024,
        );
        if (pickedFile != null) {
          pickedFiles = [pickedFile];
        }
      }

      if (pickedFiles.isNotEmpty) {
        // Check if adding these images would exceed the limit
        final remainingSlots = 5 - selectedImages.length;
        final imagesToAdd = pickedFiles.take(remainingSlots).toList();

        if (imagesToAdd.length < pickedFiles.length) {
          _showSnackBar(
            context,
            'Only ${imagesToAdd.length} images added. Maximum 5 images allowed.',
            isError: true,
          );
        }

        for (final file in imagesToAdd) {
          selectedImages.add(File(file.path));
        }
        notifyListeners();
      }
    } catch (e) {
      _showSnackBar(context, 'Error picking image: $e', isError: true);
    } finally {
      isPickingImage = false;
      notifyListeners();
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  void addImage(File image) {
    selectedImages.add(image);
    notifyListeners();
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? AppColors.kErrorColor300
            : AppColors.ksuccessColor300,
      ),
    );
  }

  // Form validation
  bool validateForm() {
    if (titleController.text.isEmpty) return false;
    if (descriptionController.text.isEmpty ||
        descriptionController.text.length < 10)
      return false;
    if (amount <= 0) return false;
    if (buyerEmailController.text.isEmpty ||
        !_isValidEmail(buyerEmailController.text))
      return false;
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Transaction creation
  Future<void> createTransaction(BuildContext context) async {
    if (!validateForm()) {
      _showSnackBar(
        context,
        'Please fill all required fields correctly',
        isError: true,
      );
      return;
    }

    // TODO: Implement actual transaction creation logic
    // For now, just show success message
    _showSnackBar(context, 'Transaction created successfully!');

    // Clear form after successful creation
    clearForm();
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    amountController.clear();
    buyerEmailController.clear();
    selectedCategory = 'Electronics';
    selectedPaymentMethod = 'Escrow';
    expectedDeliveryDate = null;
    isUrgent = false;
    requiresInspection = false;
    selectedImages.clear();
    notifyListeners();
  }

  // Get transaction summary for confirmation dialog
  Map<String, String> getTransactionSummary() {
    final Map<String, String> summary = {
      'Product': titleController.text,
      'Category': selectedCategory,
      'Amount': dollarFormatter.format(amount),
      'Escrow Fee': dollarFormatter.format(escrowFee),
      'Total': dollarFormatter.format(totalAmount),
      'Seller': userDetails.email ?? 'No email available',
      'Buyer': buyerEmailController.text,
      'Payment Method': selectedPaymentMethod,
      'Images':
          '${selectedImages.length} image${selectedImages.length != 1 ? 's' : ''}',
    };

    if (expectedDeliveryDate != null) {
      summary['Delivery Date'] = DateFormat(
        'MMM dd, yyyy',
      ).format(expectedDeliveryDate!);
    }

    if (isUrgent) {
      summary['Urgent'] = 'Yes';
    }

    if (requiresInspection) {
      summary['Inspection Required'] = 'Yes';
    }

    return summary;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    buyerEmailController.dispose();
    super.dispose();
  }
}

// Provider
final joinTransactionControllerProvider =
    ChangeNotifierProvider.family<JoinTransactionController, AuthController>(
      (ref, authController) => JoinTransactionController(authController),
    );
