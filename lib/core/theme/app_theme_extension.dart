import 'package:flutter/material.dart';
//من می‌خواهم قابلیت‌های اختصاصی خودم را به ThemeData اضافه کنم. پس از این کلاس استفاده میکنم

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  //و این ویژگی یک لیست از Colorهاست.
  /*
  backgroundGradient
      ↓
[
  Color 1,
  Color 2,
  Color 3,
  Color 4
]
   */

  final List<Color> backgroundGradient;
  //Constructor
  //یعنی وقتی می‌خواهیم این Theme را بسازیم، باید Gradient را به آن بدهیم.
  const AppThemeExtension({required this.backgroundGradient});

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    List<Color>? backgroundGradient,
  }) {
    //برای این است که بتوانیم یک نسخه جدید از Theme بسازیم، بدون اینکه همه چیز را دوباره تعریف کنیم.
    return AppThemeExtension(
      // ?? =>>>>   اگر backgroundGradient جدید وجود داشت، از آن استفاده کن؛ در غیر این صورت همان مقدار قبلی را نگه دار.
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  //برای تغییر نرم و تدریجی Theme است.
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      backgroundGradient: List.generate(backgroundGradient.length, (index) {
        //Color.lerp بین دو رنگ مقدار میانی پیدا می‌کند.
        //این باعث می‌شود تغییر Theme نرم‌تر باشد.
        return Color.lerp(
          backgroundGradient[index],
          other.backgroundGradient[index],
          t,
        )!;
      }),
    );
  }
}
