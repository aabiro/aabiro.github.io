import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aabiro_github_io/home_page.dart';

void main() {
  testWidgets('portfolio renders core content and capability filter',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    expect(find.text('Aaryn Biro'), findsWidgets);
    expect(find.text('Download resume'), findsOneWidget);
    expect(find.text('Xcelsior distributed compute platform'), findsOneWidget);

    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -1800),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('AI Media').last);
    await tester.pumpAndSettle();

    expect(
      find.text(
          'GPU-heavy media systems built around repeatable pipelines instead of fragile demos.'),
      findsOneWidget,
    );
  });
}
