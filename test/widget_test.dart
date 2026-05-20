import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_mobile/features/auth/presentation/splash_screen.dart';

void main() {
  testWidgets('SplashScreen displays title and icon', (WidgetTester tester) async {
    // Build the SplashScreen
    await tester.pumpWidget(const MaterialApp(
      home: SplashScreen(),
    ));

    // Verify if 'EduCore' text is present
    expect(find.text('EduCore'), findsOneWidget);

    // Verify if School icon is present
    expect(find.byIcon(Icons.school), findsOneWidget);

    // Verify if Progress Indicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
