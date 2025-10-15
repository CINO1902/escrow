import 'package:flutter/material.dart';
import '../../../../core/utils/appColor.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.kBackgroundColor,
        leading: BackButton(color: AppColors.kprimaryColor500),
      ),
      backgroundColor: AppColors.kBackgroundColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/1.jpg',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Yankie Mensah',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'yankie.mensah@email.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.kgrayColor100,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+1 555 123 4567',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.kgrayColor100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.kprimaryColor500,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'KYC Verified',
                          style: TextStyle(
                            color: AppColors.kprimaryColor500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit Info'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kprimaryColor500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Security Settings',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.kprimaryColor700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.lock,
                      color: AppColors.kprimaryColor500,
                    ),
                    title: const Text('Change Password'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.security_rounded,
                      color: AppColors.kprimaryColor500,
                    ),
                    title: const Text('Two-Factor Authentication'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.shield_rounded,
                      color: AppColors.kprimaryColor500,
                    ),
                    title: const Text('Security Center'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
