import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/main/presentation/main_shell.dart';

void main() {
  testWidgets('사진첩 홈의 주요 요소가 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));

    expect(find.text('멍로그'), findsOneWidget);
    expect(find.text('사진첩'), findsOneWidget);
    expect(find.text('지도'), findsOneWidget);
    expect(find.text('추억'), findsOneWidget);
    expect(find.text('설정'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsWidgets);
  });

  testWidgets('하단 메뉴를 누르면 선택한 화면으로 이동한다', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));

    await tester.tap(find.text('지도'));
    await tester.pumpAndSettle();

    expect(find.text('지도 화면을 준비하고 있어요.'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);

    await tester.tap(find.text('추억'));
    await tester.pumpAndSettle();

    expect(find.text('추억 화면을 준비하고 있어요.'), findsOneWidget);
  });

  testWidgets('플러스 버튼을 누르면 사진 추가 방법이 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('사진 추가'), findsOneWidget);
    expect(find.text('갤러리'), findsOneWidget);
    expect(find.text('카메라'), findsOneWidget);
  });
}
