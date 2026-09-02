import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/gen/assets.gen.dart';
import 'package:movies_app/core/widgets/custom_text_form_field.dart';
import 'package:movies_app/core/widgets/movie_card_item.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 0,
        title: CustomTextFormField(
          hintText: "Search",
          prefixIcon: Assets.icons.searchIcon.svg(width: 16.w, height: 16.h),
        ),
      ),
      body: GridView.builder(
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 8,
          crossAxisSpacing: 20,
          childAspectRatio: 0.62,
        ),
        itemCount: 10,
        itemBuilder: (context, index) => MovieGridItem(),
      ),
    );
  }
}
