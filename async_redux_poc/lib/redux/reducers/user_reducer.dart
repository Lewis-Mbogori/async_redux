// The Reducer is a pure function that takes the current state and an action as the function's parameters, and returns a new state.
 
import 'package:async_redux_poc/redux/actions/user_actions.dart';
import 'package:async_redux_poc/redux/app_state.dart';

AppState userReducer(AppState state, dynamic action) {
  if (action is FetchUserRequestAction) {
    // When the user taps 'Fetch User', we want to flip isLoading to true so that the UI can show a loading spinner. This also clears any old error.
    return state.copyWith(isLoading: true, errorMessage: null);
  }

  if (action is FetchUserSuccessAction) {
    // When the API call is successful, we want to flip isLoading to false and store the user in state.
    return state.copyWith(isLoading: false, user: action.user);
  }

  if (action is FetchUserFailureAction) {
    // When the API call fails, we want to flip isLoading to false and store the error message in state.
    return state.copyWith(isLoading: false, errorMessage: action.errorMessage);
  }

  // If the action is not recognized, return the current state unchanged.
  return state; 
}  