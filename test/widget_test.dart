import 'package:flutter_test/flutter_test.dart';
import 'package:game_kimia_asambsa_app/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChemistryApp());
    // Give it a moment to render the splash screen
    await tester.pump();
    
    // We expect the app to build successfully without throwing exceptions.
    expect(find.byType(ChemistryApp), findsOneWidget);
  });
}
