// Actions are plain data classes that describe what happened in the application. They are dispatched to the store to trigger state changes.
// They do not contain any logic themselves, 

// This action is dispatched every moment a user taps 'Fetch User'. Tells the reducer to flip isLoading to true
class FetchUserRequestAction {}

// This action is dispatched by the middleware once the API call to fetch the user is successful.
class FetchUserSuccessAction {
  final dynamic user;
  FetchUserSuccessAction(this.user);
}

// This action is dispatched by the middleware once the API call to fetch the user fails.
class FetchUserFailureAction {
  final String errorMessage;
  FetchUserFailureAction(this.errorMessage);
}