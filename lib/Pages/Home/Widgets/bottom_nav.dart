import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class MojocinemaBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MojocinemaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.03),
                ],
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                _buildNavItem(0, Iconsax.home_1, Iconsax.home_1),
                _buildNavItem(1, Iconsax.discover, Iconsax.discover),
                _buildNavItem(2, Iconsax.video_circle, Iconsax.video_circle),
                _buildNavItem(3, Iconsax.archive_book, Iconsax.archive_book),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon) {
    bool isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 54.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.red.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? Colors.red : Colors.white60,
                  size: 26.sp,
                ),
                if (isSelected)
                  Positioned(
                    bottom: 6.h,
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
