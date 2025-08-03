import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          if (user == null) {
            return const Center(
              child: Text('User not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.green[700],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Name
                      Text(
                        user.name,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Email
                      Text(
                        user.email,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Member Since
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          'Member since ${_formatDate(user.createdAt)}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Profile Options
                _ProfileSection(
                  title: 'Account',
                  items: [
                    _ProfileItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      onTap: () {
                        // Navigate to edit profile screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit Profile feature coming soon'),
                          ),
                        );
                      },
                    ),
                    _ProfileItem(
                      icon: Icons.location_on_outlined,
                      title: 'Addresses',
                      subtitle: 'Manage your delivery addresses',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Address management coming soon'),
                          ),
                        );
                      },
                    ),
                    _ProfileItem(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      subtitle: 'Manage your payment options',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment methods coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _ProfileSection(
                  title: 'Preferences',
                  items: [
                    _ProfileItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage your notification preferences',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification settings coming soon'),
                          ),
                        );
                      },
                    ),
                    _ProfileItem(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: 'Change app language',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Language settings coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _ProfileSection(
                  title: 'Support',
                  items: [
                    _ProfileItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      subtitle: 'Get help and support',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Help center coming soon'),
                          ),
                        );
                      },
                    ),
                    _ProfileItem(
                      icon: Icons.feedback_outlined,
                      title: 'Send Feedback',
                      subtitle: 'Share your thoughts with us',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Feedback feature coming soon'),
                          ),
                        );
                      },
                    ),
                    _ProfileItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App version and information',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'About GroceryApp',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: Text(
                              'GroceryApp v1.0.0\n\nYour one-stop solution for fresh groceries delivered to your door.',
                              style: GoogleFonts.poppins(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Logout Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to logout?',
                            style: GoogleFonts.poppins(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await authProvider.logout();
                                if (context.mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login',
                                    (route) => false,
                                  );
                                }
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout),
                        const SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _ProfileSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                item,
                if (index < items.length - 1) const Divider(height: 24),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.green[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}