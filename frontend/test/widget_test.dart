import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/app.dart';

void main() {
  testWidgets('환영 화면에 서비스 정보가 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MungLogApp());

    expect(find.text('멍로그'), findsOneWidget);
    expect(find.text('우리 아이와 함께한 오늘을,\n내일도 기억할 수 있도록.'), findsOneWidget);
    expect(find.text('로그인하고 시작하기'), findsOneWidget);
  });

  testWidgets('시작 버튼을 누르면 로그인 선택 화면으로 이동한다', (WidgetTester tester) async {
    await tester.pumpWidget(const MungLogApp());

    await tester.tap(find.text('로그인하고 시작하기'));
    await tester.pumpAndSettle();

    expect(find.text('로그인 방법을 선택해주세요'), findsOneWidget);
  });
}
