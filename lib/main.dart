import 'package:mojocinema/Pages/MainNavigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const Mojocinema());
}

class Mojocinema extends StatelessWidget {
  const Mojocinema({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(384.0, 837.33),
      splitScreenMode: false,
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Apercu',
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF000000),
        ),
        debugShowCheckedModeBanner: false,
        title: "Mojocinema - Your Movie Universe",
        home: const MainNavigationPage(),
      ),
    );
  }
}
