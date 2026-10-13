import 'package:flutter/material.dart';

/// Tombol filter berbentuk pil (Semua / Hilang / Ditemukan, dst).
/// StatelessWidget: tidak menyimpan state sendiri, status aktif
/// ditentukan dari luar (isActive) dan diubah lewat provider.
class FilterChipButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.deepOrange : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isActive ? null : Border.all(color: Colors.grey.shade300),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
