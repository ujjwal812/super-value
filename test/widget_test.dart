import 'package:flutter_test/flutter_test.dart';
import 'package:learning_project/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RexBizApp());

    // Verify app renders
    expect(find.byType(RexBizApp), findsOneWidget);
  });
}
