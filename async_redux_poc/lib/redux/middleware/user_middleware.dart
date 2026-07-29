import 'dart:convert';

import 'package:async_redux_poc/models/user_model.dart';
import 'package:async_redux_poc/redux/actions/user_actions.dart';
import 'package:async_redux_poc/redux/app_state.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

List<Middleware<AppState>> createUserMiddleware({http.Client? client}) {
  final httpClient = client ?? http.Client();
  return [
    // ignore: implicit_call_tearoffs
    TypedMiddleware<AppState, FetchUserRequestAction>(
      (store, action, next) => _fetchUser(store, action, next, httpClient),
    ),
  ];
}

// This function runs when the FetchUserRequestAction is dispatched. It performs the API call to fetch the user and dispatches either a success or failure action based on the result.
void _fetchUser(
  Store<AppState> store,
  FetchUserRequestAction action,
  NextDispatcher next,
  http.Client client,
) async {
  // First, we always call next(action) so the reducer can process the action and update the state before we do the API call. This is important because we want to flip isLoading to true before we start the API call.
  next(action);

  try {
    final response = await client.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final user = UserModel.fromJson(json);
      // If the API call is successful, we dispatch a FetchUserSuccessAction with the user data. This is what pushes the result back into the redux cycle and updates the state.
      store.dispatch(FetchUserSuccessAction(user));
    } else {
      // If the API call fails (non-200 status code), we dispatch a FetchUserFailureAction
      store.dispatch(FetchUserFailureAction(
        'Server returned ${response.statusCode}'
       )
      );
    }
  } catch (e) {
    store.dispatch(FetchUserFailureAction('Failed to fetch user: $e'));
  }
}