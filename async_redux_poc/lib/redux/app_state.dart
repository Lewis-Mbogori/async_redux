// This is the SINGLE SOURCE OF TRUTH for the entire application. Every screen reads from this

import 'package:async_redux_poc/models/user_model.dart';

class AppState {
  final bool isLoading;
  final UserModel? user;
  final String? errorMessage;

  AppState({
    required this.isLoading,
    this.user,
    this.errorMessage,
  });

  // A Factory initial state is needed because every redux app needs a starting point before any action can be dispatched
  factory AppState.initial() {
  return AppState(
    isLoading: false,
    user: null,
    errorMessage: null,
   );
  }

  // copyWith lets you build a new object but only changing the fields you care about. This is important because AppState is IMMUTABLE (all fields final). Reducers can never mutate the old state directly — they must return a brand new AppState object.
  AppState copyWith({
    bool? isLoading,
    UserModel? user,
    String? errorMessage,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      // Error message is handled explicitly (not ?? this.errorMessage) so that a successful fetch can actually CLEAR a previous error.
      errorMessage: errorMessage,
    );
  }
}





