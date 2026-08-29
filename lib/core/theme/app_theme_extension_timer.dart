import 'package:flutter/material.dart';

//من می‌خواهم قابلیت‌های اختصاصی خودم را به ThemeData اضافه کنم. پس از این کلاس استفاده میکنم

class AppThemeExtensionTimer extends ThemeExtension<AppThemeExtensionTimer> {
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
  const AppThemeExtensionTimer({required this.backgroundGradient});

  @override
  ThemeExtension<AppThemeExtensionTimer> copyWith({
    List<Color>? backgroundGradient,
  }) {
    //برای این است که بتوانیم یک نسخه جدید از Theme بسازیم، بدون اینکه همه چیز را دوباره تعریف کنیم.
    return AppThemeExtensionTimer(
      // ?? =>>>>   اگر backgroundGradient جدید وجود داشت، از آن استفاده کن؛ در غیر این صورت همان مقدار قبلی را نگه دار.
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  //برای تغییر نرم و تدریجی Theme است.
  ThemeExtension<AppThemeExtensionTimer> lerp(
    covariant ThemeExtension<AppThemeExtensionTimer>? other,
    double t,
  ) {
    if (other is! AppThemeExtensionTimer) {
      return this;
    }
    return AppThemeExtensionTimer(
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
