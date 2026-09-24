import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_strings.dart';
import 'package:movies_app/features/profile/data/models/user_profile.dart';

class SelectAvatar extends StatelessWidget {
  const SelectAvatar({
    super.key,
    required this.selectedKey,
    required this.onSelected,
  });

  final String selectedKey;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> keys = UserAvatars.keys;

    final int selectedIndex = keys.indexOf(selectedKey);
    final int centerIndex = selectedIndex == -1 ? 0 : selectedIndex;

    final double itemSize = 100.w;
    final double smallSize = itemSize * 0.62;
    final double stackWidth = itemSize * 3;
    final double stackHeight = itemSize * 1.25;

    return Column(
      children: [
        Text(
          AppStrings.avatar,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.mainText,
          ),
        ),
        SizedBox(height: 18.h),
        Center(
          child: ClipRect(
            child: SizedBox(
              width: stackWidth,
              height: stackHeight,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  for (int i = 0; i < keys.length; i++)
                    _CarouselItem(
                      key: ValueKey(keys[i]),
                      avatar: UserAvatars.imageFromKeyOrPath(keys[i]),
                      offset: i - centerIndex,
                      selected: i == centerIndex,
                      itemSize: itemSize,
                      smallSize: smallSize,
                      stackHeight: stackHeight,
                      onTap: () => onSelected(keys[i]),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CarouselItem extends StatelessWidget {
  const _CarouselItem({
    super.key,
    required this.avatar,
    required this.offset,
    required this.selected,
    required this.itemSize,
    required this.smallSize,
    required this.stackHeight,
    required this.onTap,
  });

  final AssetGenImage avatar;
  final int offset;
  final bool selected;
  final double itemSize;
  final double smallSize;
  final double stackHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double size = selected ? itemSize : smallSize;
    final double slotCenter = itemSize + offset * itemSize;
    final double left = slotCenter + (itemSize - size) / 2;
    final double top = (stackHeight - size) / 2;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      left: left,
      top: top,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 320),
          opacity: selected ? 1 : 0.72,
          child: Container(
            width: size,
            height: size,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.secondColor : AppColors.greyDark,
                width: 3,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.secondColor.withValues(alpha: 0.30),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ]
                  : const [],
            ),
            child: avatar.image(
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}