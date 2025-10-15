import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controller/auth_controller.dart';

class JoinTransactionController extends ChangeNotifier {
  final AuthController _authController;

  JoinTransactionController(this._authController);

  // State variables
  bool isLoading = false;
  List<Map<String, dynamic>> allTransactions = [];
  List<Map<String, dynamic>> filteredTransactions = [];
  String searchQuery = '';

  // Filter variables
  String selectedCategory = 'All';
  String selectedPriceRange = 'All';
  String selectedSortBy = 'Latest';

  // Sample data - replace with actual API calls
  final List<Map<String, dynamic>> _sampleTransactions = [
    {
      'id': '1',
      'title': 'MacBook Pro M2 Chip',
      'description':
          'Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD, Brand new MacBook Pro with M2 chip, 16GB RAM, 512GB SSD',
      'amount': 2499.99,
      'category': 'Electronics',
      'seller': 'tech_seller@example.com',
      'buyer': null,
      'status': 'pending',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'expectedDelivery': DateTime.now().add(const Duration(days: 7)),
      'images': ['macbook1.jpg', 'macbook2.jpg'],
      'isUrgent': false,
      'requiresInspection': true,
    },
    {
      'id': '2',
      'title': 'iPhone 15 Pro Max',
      'description': 'Latest iPhone 15 Pro Max, 256GB, Natural Titanium',
      'amount': 1199.99,
      'category': 'Electronics',
      'seller': 'mobile_store@example.com',
      'buyer': null,
      'status': 'pending',
      'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
      'expectedDelivery': DateTime.now().add(const Duration(days: 5)),
      'images': ['iphone1.jpg'],
      'isUrgent': true,
      'requiresInspection': false,
    },
    {
      'id': '3',
      'title': 'Designer Watch Collection',
      'description': 'Luxury watch collection including Rolex and Omega pieces',
      'amount': 8500.00,
      'category': 'Fashion & Accessories',
      'seller': 'luxury_watches@example.com',
      'buyer': null,
      'status': 'pending',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'expectedDelivery': DateTime.now().add(const Duration(days: 14)),
      'images': ['watch1.jpg', 'watch2.jpg', 'watch3.jpg'],
      'isUrgent': false,
      'requiresInspection': true,
    },
    {
      'id': '4',
      'title': 'Gaming PC Setup',
      'description': 'High-end gaming PC with RTX 4090, 32GB RAM, 2TB NVMe',
      'amount': 3200.00,
      'category': 'Electronics',
      'seller': 'gaming_rigs@example.com',
      'buyer': null,
      'status': 'pending',
      'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
      'expectedDelivery': DateTime.now().add(const Duration(days: 3)),
      'images': ['pc1.jpg', 'pc2.jpg'],
      'isUrgent': false,
      'requiresInspection': false,
    },
    {
      'id': '5',
      'title': 'Vintage Camera Collection',
      'description': 'Rare vintage cameras from the 1950s-1970s',
      'amount': 1800.00,
      'category': 'Collectibles',
      'seller': 'vintage_cameras@example.com',
      'buyer': null,
      'status': 'pending',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'expectedDelivery': DateTime.now().add(const Duration(days: 10)),
      'images': ['camera1.jpg', 'camera2.jpg', 'camera3.jpg'],
      'isUrgent': false,
      'requiresInspection': true,
    },
  ];

  // Getters
  bool get hasActiveFilters =>
      selectedCategory != 'All' ||
      selectedPriceRange != 'All' ||
      selectedSortBy != 'Latest';

  // Methods
  Future<void> loadTransactions() async {
    isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      allTransactions = List.from(_sampleTransactions);
      _applyFilters();
    } catch (e) {
      _showSnackBar('Error loading transactions: $e', isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchTransactions(String query) {
    searchQuery = query;
    _applyFilters();
  }

  void updateCategory(String category) {
    selectedCategory = category;
    _applyFilters();
  }

  void updatePriceRange(String range) {
    selectedPriceRange = range;
    _applyFilters();
  }

  void updateSortBy(String sortBy) {
    selectedSortBy = sortBy;
    _applyFilters();
  }

  void clearAllFilters() {
    selectedCategory = 'All';
    selectedPriceRange = 'All';
    selectedSortBy = 'Latest';
    searchQuery = '';
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(allTransactions);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final title = transaction['title'].toString().toLowerCase();
        final description = transaction['description'].toString().toLowerCase();
        final query = searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Apply category filter
    if (selectedCategory != 'All') {
      filtered = filtered.where((transaction) {
        return transaction['category'] == selectedCategory;
      }).toList();
    }

    // Apply price range filter
    if (selectedPriceRange != 'All') {
      filtered = filtered.where((transaction) {
        final amount = transaction['amount'] as double;
        switch (selectedPriceRange) {
          case 'Under \$100':
            return amount < 100;
          case '\$100 - \$500':
            return amount >= 100 && amount <= 500;
          case '\$500 - \$1000':
            return amount > 500 && amount <= 1000;
          case '\$1000 - \$5000':
            return amount > 1000 && amount <= 5000;
          case 'Over \$5000':
            return amount > 5000;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sorting
    switch (selectedSortBy) {
      case 'Latest':
        filtered.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
        break;
      case 'Oldest':
        filtered.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
        break;
      case 'Price: Low to High':
        filtered.sort((a, b) => a['amount'].compareTo(b['amount']));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b['amount'].compareTo(a['amount']));
        break;
      case 'Urgent First':
        filtered.sort((a, b) {
          if (a['isUrgent'] == b['isUrgent']) {
            return b['createdAt'].compareTo(a['createdAt']);
          }
          return a['isUrgent'] ? -1 : 1;
        });
        break;
    }

    filteredTransactions = filtered;
    notifyListeners();
  }

  Future<void> joinTransaction(
    Map<String, dynamic> transaction,
    BuildContext context,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update transaction with current user as buyer
      final updatedTransaction = Map<String, dynamic>.from(transaction);
      updatedTransaction['buyer'] = _authController.userDetails.email;
      updatedTransaction['status'] = 'active';

      // Remove from available transactions
      allTransactions.removeWhere((t) => t['id'] == transaction['id']);
      _applyFilters();

      _showSnackBar('Successfully joined transaction!', isError: false);

      // Navigate back to dashboard or show success page
      Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar('Error joining transaction: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    // This would typically use a global snackbar service
    // For now, we'll just print the message
    print('SnackBar: $message');
  }
}

// Provider
final joinTransactionControllerProvider =
    ChangeNotifierProvider.family<JoinTransactionController, AuthController>(
      (ref, authController) => JoinTransactionController(authController),
    );
