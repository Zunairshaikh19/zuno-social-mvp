import 'package:flutter_test/flutter_test.dart';

import 'package:zunosocial/app.dart';

void main() {
  testWidgets('App boots to the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ZunoSocialApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
