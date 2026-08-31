// Widget test for the Async Redux POC.
//
// Unlike the default counter test, our MyApp requires a Redux Store
// to be passed in — so we build one here exactly like main.dart does,
// then pump MyApp with that store.

import 'dart:async';
import 'dart:convert';

import 'package:async_redux_poc/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:http/testing.dart';

import 'package:async_redux_poc/main.dart';
import 'package:async_redux_poc/redux/app_state.dart';
import 'package:async_redux_poc/redux/reducers/user_reducer.dart';
import 'package:async_redux_poc/redux/middleware/user_middleware.dart';
import 'package:async_redux_poc/redux/actions/user_actions.dart';

void main() {
  testWidgets('Shows Fetch User button before any fetch', (WidgetTester tester) async {
    // Build the store the same way main.dart does.
    final store = Store<AppState>(
      userReducer,
      initialState: AppState.initial(),
      middleware: createUserMiddleware(),
    );

    // MyApp is NOT const anymore because it holds a Store instance.
    await tester.pumpWidget(MyApp(store: store));

    // Before any action is dispatched, we expect the initial button.
    expect(find.text('Fetch User'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Shows loading spinner after dispatching FetchUserRequestAction', (WidgetTester tester) async {
    // A completer allows you to pause execution deterministically to verify intermediate app states
    final completer = Completer<http.Response>();
    final mockClient = MockClient((request) => completer.future);

    final store = Store<AppState>(
      userReducer,
      initialState: AppState.initial(),
      middleware: createUserMiddleware(client: mockClient),
    );

    await tester.pumpWidget(MyApp(store: store));

    store.dispatch(FetchUserRequestAction());

    expect(store.state.userFetchState, isA<Loading>());

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(http.Response(
      jsonEncode({
        'id': 1,
        'name': 'Shelby',
        'email': 'shelby@gmail.com'
      }), 200,
    ));

    await tester.pumpAndSettle(); 

    expect(store.state.userFetchState, isA<Loaded>());

    final expectedUser = UserModel(id: 1, name: 'Shelby', email: 'shelby@gmail.com');

    switch (store.state.userFetchState) {
      case Loaded(user: final loadedUser):
        expect(loadedUser, expectedUser);
      default:
      // If a bug ever causes the wrong variant to land here instead, fail witha clear message
      fail('Expected Loaded state but got ${store.state.userFetchState}');
    }
    expect(find.text('User: Shelby'), findsOneWidget);

    final state = store.state.userFetchState;
    switch (state) {
      case Loaded(user: final loadeduser):
      expect(loadeduser.name, 'Shelby');
      default:
      fail('Expected Loaded state but got $state');
    }

       
  });

  testWidgets('Shows error message when the API call fails', (WidgetTester tester) async {
    final completer = Completer<http.Response>();
    final mockClient = MockClient((request) => completer.future);

    final store = Store<AppState>(
      userReducer,
      initialState: AppState.initial(),
      middleware: createUserMiddleware(client: mockClient),
    );

    await tester.pumpWidget(MyApp(store: store));

    store.dispatch(FetchUserRequestAction());
    await tester.pump();

    // Now we resolve the fake response with a failure status this time
    completer.complete(http.Response('Not Found', 404));
    await tester.pumpAndSettle();

    expect(store.state.userFetchState, isA<FetchError>());

    switch (store.state.userFetchState) {
      case FetchError(message: final message):
        expect(message, contains('404'));
      default:
      fail('Expected FetchError state but got ${store.state.userFetchState}');
    }

    expect(find.textContaining('Error: '), findsOneWidget);
  });

//   testWidgets('Shows loading spinner after dispatching FetchUserRequestAction', (WidgetTester tester) async {
//   final store = Store<AppState>(
//     userReducer,
//     initialState: AppState.initial(),
//     middleware: createUserMiddleware(),
//   );

//   await tester.pumpWidget(MyApp(store: store));

//   store.dispatch(FetchUserRequestAction());

//   // Check the STORE state right away — the middleware's next(action)
//   // runs synchronously before it ever awaits the http call, so
//   // isLoading is already true here, with zero pumping needed.
//   expect(store.state.isLoading, true);

//   // Now pump one frame so the WIDGET TREE catches up to that state.
//   await tester.pump();
//   expect(find.byType(CircularProgressIndicator), findsOneWidget);

//   // Drain the pending fake-network response so no async work is left
//   // hanging when the test ends (avoids "pending timer" warnings).
//   await tester.pump(const Duration(milliseconds: 100));
// });



  // testWidgets('Shows loading spinner after dispatching FetchUserRequestAction', (WidgetTester tester) async {
  //   final store = Store<AppState>(
  //     userReducer,
  //     initialState: AppState.initial(),
  //     middleware: createUserMiddleware(),
  //   );

  //   await tester.pumpWidget(MyApp(store: store));

  //   // Instead of tapping the button (which would trigger a REAL http
  //   // call in this test), dispatch the action directly — this is the
  //   // "assert against Redux store state" pattern you're already using
  //   // on Be Well.
  //   store.dispatch(FetchUserRequestAction());
  //   expect(store.state.isLoading, true); // rebuild after the reducer updates state

  //   await tester.pump(); // Rebuild the widget tree after the state change
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);

  //   await tester.pump(const Duration(milliseconds: 100));
  // });
}