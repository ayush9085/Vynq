import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const VynkApp());
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(VynkApp), findsOneWidget);
  });
}
