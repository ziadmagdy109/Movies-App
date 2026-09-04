import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenresItem extends StatelessWidget {
  const GenresItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff252626),
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      child: Text(
        'Action',
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }
}
