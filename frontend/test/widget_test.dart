import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('멍로그 이름이 화면에 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('멍로그'), findsOneWidget);
  });
}
