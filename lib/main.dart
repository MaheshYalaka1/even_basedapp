import 'package:EventBasedapp/screens/authenticationpage/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:EventBasedapp/screens/homepages/events_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final loginStatusProvider = FutureProvider<bool>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppNavigator(),
    );
  }
}

class AppNavigator extends ConsumerWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(loginStatusProvider);

    return isLoggedIn.when(
      data: (loggedIn) {
        if (loggedIn) {
          // User is logged in, show EventScreenList
          return const EventScreenList();
        } else {
          // User is not logged in, show LoginPage
          return const LoginPage();
        }
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => const Text('Error loading login status'),
    );
  }
}
