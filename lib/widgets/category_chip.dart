import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.category,
    this.onTap,
    this.isSelected = false,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruits & vegetables':
        return Icons.eco;
      case 'dairy & eggs':
        return Icons.egg;
      case 'meat & seafood':
        return Icons.set_meal;
      case 'bakery':
        return Icons.bakery_dining;
      case 'pantry':
        return Icons.kitchen;
      case 'beverages':
        return Icons.local_drink;
      case 'snacks':
        return Icons.cookie;
      case 'frozen foods':
        return Icons.ac_unit;
      case 'personal care':
        return Icons.face;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'fruits & vegetables':
        return Colors.green;
      case 'dairy & eggs':
        return Colors.blue;
      case 'meat & seafood':
        return Colors.red;
      case 'bakery':
        return Colors.orange;
      case 'pantry':
        return Colors.brown;
      case 'beverages':
        return Colors.cyan;
      case 'snacks':
        return Colors.purple;
      case 'frozen foods':
        return Colors.lightBlue;
      case 'personal care':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(category);
    final categoryIcon = _getCategoryIcon(category);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? categoryColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: categoryColor,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              categoryIcon,
              size: 18,
              color: isSelected ? Colors.white : categoryColor,
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : categoryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}