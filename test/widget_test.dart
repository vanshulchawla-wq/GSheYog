import 'package:flutter_test/flutter_test.dart';
import 'package:gsheyog/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const GSheYogApp());
    expect(find.text('GSheYog'), findsOneWidget);
  });
}
