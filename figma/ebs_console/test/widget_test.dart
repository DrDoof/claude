import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebs_console/main.dart';

void main() {
  testWidgets('EBS Console app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: EbsConsoleApp()));
    expect(find.text('E B S'), findsOneWidget);
  });
}
