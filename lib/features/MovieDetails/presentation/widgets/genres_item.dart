import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenresItem extends StatelessWidget {
  final String genres;
  const GenresItem({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff252626),
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        genres,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }
}