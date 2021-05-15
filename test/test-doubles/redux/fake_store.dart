import 'dart:async';

import 'package:podcustard/actions/redux_action.dart';
import 'package:podcustard/models/app_state.dart';
import 'package:redux/redux.dart';

import '../../test-data/models/user_examples.dart';
import 'empty_reducer.dart';

/// A [Store] with no reducers that takes an optional [AppState] and
/// keeps a list of dispatched actions that can be queried.
class FakeStore implements Store<AppState> {
  FakeStore({AppState? state})
      : _state = state ?? AppState.init(),
        _changeController = StreamController<AppState>.broadcast(),
        reducer = EmptyReducer();

  // Named constructor for creating an authenticated fake store that will
  // allow tests to bypass the auth UI
  FakeStore.authenticated()
      : _state =
            AppState.init().copyWith(user: UserExamples.basic, authStep: 0),
        _changeController = StreamController<AppState>.broadcast(),
        reducer = EmptyReducer();

  // The list of dispatched actions that can be queried by a test.
  List<ReduxAction> dispatchedActions = <ReduxAction>[];

  // AppState get state => _state;

  //
  void updateState(AppState state) {
    _state = state;
    _changeController.add(_state);
  }

  // We must override the reducer as a var in order to extend Store
  // but in our case it is always null.
  @override
  var reducer;

  // We keep our own state so we can have a default value
  AppState _state;

  // We need a StreamController to provide the onChange method
  final StreamController<AppState> _changeController;

  // Override dispatch to just add the action to the list.
  @override
  dynamic dispatch(dynamic action) {
    dispatchedActions.add(action as ReduxAction);
  }

  @override
  Stream<AppState> get onChange => _changeController.stream;

  @override
  AppState get state => _state;

  @override
  Future teardown() => _changeController.close();
}