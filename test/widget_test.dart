import 'package:flutter_test/flutter_test.dart';
import 'package:khoj/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(JharkhandTourismApp());
    expect(find.text("Explore Jharkhand"), findsOneWidget); // Example check
  });
}
