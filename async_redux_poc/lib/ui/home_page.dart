import 'package:async_redux_poc/redux/actions/user_actions.dart';
import 'package:async_redux_poc/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Async Redux POC")),
      body: Center(
        child: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel(
            // isLoading: store.state.isLoading,
            // userName: store.state.user?.name,
            // error: store.state.errorMessage,
            state: store.state.userFetchState,
            onFetchUser: () => store.dispatch(FetchUserRequestAction()),
          ),
          builder: (context, vm) {
            return switch (vm.state) {
              Idle() => ElevatedButton(onPressed: vm.onFetchUser, child: Text('Fetch User'),),
              Loading() => CircularProgressIndicator(),
              Loaded(user: final user) => Text('User: ${user.name}'),
              FetchError(message: final message) => Text('Error: $message'),
            };
            // if (vm.isLoading) {
            //   return CircularProgressIndicator();
            // } else if (vm.error != null) {
            //   return Text('Error: ${vm.error}');
            // } else if (vm.userName != null) {
            //   return Text('User: ${vm.userName}');
            // } else {
            //   return ElevatedButton(
            //     onPressed: vm.onFetchUser,
            //     child: Text('Fetch User'),
            //   );
            // }
          },
        )
      ),
    );
  }
}

class _ViewModel {
  final UserFetchState state;
  final VoidCallback onFetchUser;

  _ViewModel({
    required this.state,
    required this.onFetchUser,
  });
}