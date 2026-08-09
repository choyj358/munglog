import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/pet/application/pet_state.dart';
import 'package:frontend/features/pet/infrastructure/pet_api.dart';
import 'package:frontend/features/pet/presentation/pet_create_screen.dart';
import 'package:frontend/features/pet/presentation/pet_onboarding_gate.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('반려견 등록 화면의 주요 요소가 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PetCreateScreen()));

    expect(find.text('반려견 등록'), findsOneWidget);
    expect(find.text('함께 기록할 아이를 알려주세요.'), findsOneWidget);
    expect(find.text('이름'), findsOneWidget);
    expect(find.text('등록하기'), findsOneWidget);
    expect(find.byIcon(Icons.add_a_photo_outlined), findsOneWidget);
  });

  testWidgets('이름 없이 등록하면 안내 문구가 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PetCreateScreen()));

    await tester.tap(find.text('등록하기'));
    await tester.pump();

    expect(find.text('반려견 이름을 입력해주세요.'), findsOneWidget);
  });

  testWidgets('반려견을 등록하면 사진첩 화면으로 전환된다', (WidgetTester tester) async {
    final client = MockClient((request) async {
      return http.Response(
        '[]',
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final petApi = PetApi(client);
    final petState = PetState();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<PetApi>.value(value: petApi),
          ChangeNotifierProvider<PetState>.value(value: petState),
        ],
        child: const MaterialApp(home: PetOnboardingGate()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('반려견 등록'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '푸딩');

    await tester.tap(find.text('등록하기'));
    await tester.pumpAndSettle();

    expect(petState.pets, hasLength(1));
    expect(petState.pets.first.name, '푸딩');
    expect(find.text('멍로그'), findsOneWidget);
    expect(find.text('사진첩'), findsOneWidget);
  });
}
