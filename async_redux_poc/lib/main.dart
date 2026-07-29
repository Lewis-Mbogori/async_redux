import 'package:async_redux_poc/redux/app_state.dart';
import 'package:async_redux_poc/redux/middleware/user_middleware.dart';
import 'package:async_redux_poc/redux/reducers/user_reducer.dart';
import 'package:async_redux_poc/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


void main() {
// The Store is created once at the top of the app
final store = Store<AppState>(
  userReducer,
  initialState: AppState.initial(),
  middleware: createUserMiddleware()
);

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({super.key, required this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}