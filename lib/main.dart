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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationService authService = AuthenticationService();
    final AuthenticationBloc authBloc = AuthenticationBloc(authService);

    return AuthenticationBlocProvider(
      authenticationBloc: authBloc,
      child: StreamBuilder(
        initialData: null,
        stream: authBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child:  const CircularProgressIndicator(strokeWidth: 5.0));
          } else if (snapshot.hasData) {
            return HomeBlocProvider(
                homeBloc: HomeBloc(DbFirestoreService(), authService),
                uid: snapshot.data,
                child: _buildJournalApp(
                    const HomePage()));
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
          primarySwatch: Colors.lightGreen,
          canvasColor: Colors.lightGreen.shade50,
          bottomAppBarTheme: const BottomAppBarTheme(color: Colors.lightGreen)),
      home: homePage,
    );
  }
}
