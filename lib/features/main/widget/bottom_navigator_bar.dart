import 'package:flutter/material.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/features/main/widget/item_bottom_navigator_bar.dart';

class BottomNavigatorBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigatorBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: BottomNavigatorBarItem(
              iconPath: AppImage.icHomeTab,
              label: 'Trang chủ',
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: BottomNavigatorBarItem(
              iconPath: AppImage.icSearchTab,
              label: "Khám phá",
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ),
          Expanded(
            child: BottomNavigatorBarItem(
              iconPath: AppImage.icChat,
              label: 'Trò chuyện',
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ),
          Expanded(
            child: BottomNavigatorBarItem(
              iconPath: AppImage.icProfileTab,
              label: 'Cá nhân',
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ),
        ],
      ),
    );
  }
}
