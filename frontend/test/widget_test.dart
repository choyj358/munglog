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
  testWidgets('이메일 버튼을 누르면 이메일 로그인 화면으로 이동한다', (WidgetTester tester) async {
    await tester.pumpWidget(const MungLogApp());

    await tester.tap(find.text('로그인하고 시작하기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('이메일로 계속하기'));
    await tester.pumpAndSettle();

    expect(find.text('이메일 로그인'), findsOneWidget);
  });

  testWidgets('이메일과 비밀번호가 비어 있으면 안내 문구가 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MungLogApp());

    await tester.tap(find.text('로그인하고 시작하기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('이메일로 계속하기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('로그인'));
    await tester.pump();

    expect(find.text('이메일을 입력해주세요.'), findsOneWidget);
    expect(find.text('비밀번호를 입력해주세요.'), findsOneWidget);
  });
  testWidgets('회원가입 버튼을 누르면 회원가입 화면으로 이동한다', (WidgetTester tester) async {
    await tester.pumpWidget(const MungLogApp());

    await tester.tap(find.text('로그인하고 시작하기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('이메일로 계속하기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('처음이신가요? 회원가입'));
    await tester.pumpAndSettle();

    expect(find.text('회원가입'), findsWidgets);
    expect(find.text('멍로그를 시작해볼까요?'), findsOneWidget);
  });
}
