import 'package:Naqla/helper/firebase/firebase_options.dart';
import 'package:Naqla/helper/service/auth_methods.dart';
import 'package:Naqla/screens/HomeScreen/home_screen.dart';
import 'package:Naqla/screens/User/frieght/frieght_page.dart';
import 'package:Naqla/screens/splash_screen.dart';
import 'package:Naqla/stripe_payment/components/stripe_keys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthMethods()));

  Stripe.publishableKey = ApiKeys.publishableKey;
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: const DoubleTapToExit(
                snackBar: SnackBar(
                  content: Text(
                    'Tap again to exit !',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                // Use onPopInvoked for consistency
                child: SplashScreen()),
            routes: {
              HomeScreen.id: (context) => const HomeScreen(),
              Frieght.id: (context) => Frieght(),
            },
            initialRoute: "loginpage",
          );
        });
  }
}
