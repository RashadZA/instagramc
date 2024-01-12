import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/screen/login_screen.dart';
import 'package:instagramc/screen/responsive/mobile_screen_layout.dart';
import 'package:instagramc/screen/responsive/responsive_layout.dart';
import 'package:instagramc/screen/responsive/web_screen_layout.dart';

import 'core/server/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          debugPrint("SnapShot : ${snapshot.data}");
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              );
            }else if(snapshot.hasError){
              return Center(
                child: Text("${snapshot.hasError}"),
              );
            }else{
              return const LoginScreen();
            }
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return  Center(
              child: defaultLoader().defaultContainer(),
            );
          }else{
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
