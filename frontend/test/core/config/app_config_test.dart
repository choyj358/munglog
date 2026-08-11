import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/config/app_config.dart';

void main() {
  test('환경 값을 전달하지 않으면 개발용 기본 설정을 사용한다', () {
    expect(AppConfig.apiBaseUrl, 'http://localhost:8080');
    expect(AppConfig.devUserId, '1');
  });
}
