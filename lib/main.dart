///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 18/ 7/ 2021
///------------------------------------------------------------------

import 'package:counter_app/blocs/auth/authentication_bloc_provider.dart';
import 'package:counter_app/blocs/home/home_bloc.dart';
import 'package:counter_app/blocs/home/home_bloc_provider.dart';
import 'package:counter_app/pages/auth/login.dart';
import 'package:counter_app/pages/home.dart';
import 'package:counter_app/services/authentication.dart';
import 'package:counter_app/services/db_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'blocs/auth/authentication_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/// Class's document:
/// MyApp is a widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationService authService = AuthenticationService();
    final AuthenticationBloc authBloc = AuthenticationBloc(authService);

    return AuthenticationBlocProvider(
      authenticationBloc: authBloc,
      key: key!,
      child: StreamBuilder(
        initialData: null,
        stream: authBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return HomeBlocProvider(
                homeBloc: HomeBloc(DbFirestoreService(), authService),
                uid: snapshot.data,
                key: key!,
                child: _buildJournalApp(
                    HomePage(analytics: analytics, observer: observer)));
          } else {
            return _buildJournalApp(const Login());
          }
        },
      ),
    );
  }

  MaterialApp _buildJournalApp(Widget homePage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

          primarySwatch: Colors.lightGreen,
          canvasColor: Colors.lightGreen.shade50,
          bottomAppBarTheme: const BottomAppBarTheme(color: Colors.lightGreen)),
      navigatorObservers: <NavigatorObserver>[observer],
      home: HomePage(
        analytics: analytics,
        observer: observer,
      ),
    );
  }
}
