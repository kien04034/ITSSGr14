import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/screens/auth/sign_in/sign_in_screen.dart';
import 'package:flutter_application_1/screens/home/home_screen.dart';

import 'config/providers.dart';
import 'config/routes.dart';
import 'config/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<AuthProvider>(
        builder: (ctx, authProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Road Help',
          theme: theme(),
          home: authProvider.authData.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: authProvider.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Container(
                              color: Colors.white,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : SignInScreen(),
                ),
          // We use routeName so that we dont need to remember the name
          /*initialRoute: value.item != null
              ? HomeScreen.routeName
              : SignInScreen.routeName,*/
          routes: routes,
        ),
      ),
    );
  }
}
