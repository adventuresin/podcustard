import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:podcustard/actions/redux_action.dart';
import 'package:podcustard/services/auth_service.dart';
import 'package:podcustard/widgets/app_widget.dart';

import '../test-doubles/faked_out_store.dart';
import '../test-doubles/plugins/apple_signin_mocks.dart';
import '../test-doubles/plugins/firebase_auth_mocks.dart';
import '../test-doubles/plugins/google_signin_mocks.dart';
import '../test-doubles/services/audio_player_service_mocks.dart';

void main() {
  group('PodcustardApp widget', () {
    testWidgets('observes auth state on load and navigates',
        (WidgetTester tester) async {
      final fakeFirebaseAuth = FakeFirebaseAuthOpen();
      final audioEventsController = StreamController<ReduxAction>();

      // create a basic store with middleware that uses the AuthService to
      // observe auth state and a reducer that saves the emitted auth state
      final store = FakedOutStore(
          authService: AuthService(
              fakeFirebaseAuth, FakeGoogleSignIn(), FakeAppleSignIn()),
          audioPlayerService: FakeAudioPlayerService(audioEventsController));

      fakeFirebaseAuth.add(null);

      // build our app and trigger a frame
      await tester.pumpWidget(PodcustardApp(store));

      // Create the Finders.
      final authPageFinder = find.text('Sign in with Google');
      final mainPageFinder = find.text('More');

      // Use the `findsOneWidget` matcher to verify that a Text widget with the
      // expected String appears exactly once in the widget tree, indicating the
      // AuthPage widget is present, so the expected navigation has occured
      expect(authPageFinder, findsOneWidget);
      expect(mainPageFinder, findsNothing);

      // add a FirebaseUser
      fakeFirebaseAuth.add(FakeFirebaseUser());

      await tester.pump();

      // Check that the Main Page is now shown
      expect(mainPageFinder, findsOneWidget);
      expect(authPageFinder, findsNothing);

      //
    });
  });
}
