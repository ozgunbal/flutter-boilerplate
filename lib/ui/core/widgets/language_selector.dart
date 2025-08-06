import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: 'Select Language',
      onSelected: (Locale locale) {
        debugPrint('🌍 Language selected: ${locale.languageCode}');
        context.setLocale(locale);
        debugPrint('✅ Locale set to: ${locale.languageCode}');
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              Text('🇺🇸', style: TextStyle(fontSize: 18.sp)),
              SizedBox(width: 8.w),
              const Text('English'),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('ru'),
          child: Row(
            children: [
              Text('🇷🇺', style: TextStyle(fontSize: 18.sp)),
              SizedBox(width: 8.w),
              const Text('Русский'),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('az'),
          child: Row(
            children: [
              Text('🇦🇿', style: TextStyle(fontSize: 18.sp)),
              SizedBox(width: 8.w),
              const Text('Azərbaycan'),
            ],
          ),
        ),
      ],
    );
  }
}