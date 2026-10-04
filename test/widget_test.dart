import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:community_music_app/main.dart';

void main() {
  testWidgets('home loads and search filters sample tracks', (tester) async {
    await tester.pumpWidget(const SoundroomApp());
    await tester.pumpAndSettle();

    expect(find.text('Your community.\nIn rotation.'), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'No Small Thing');
    await tester.pumpAndSettle();

    expect(find.text('No Small Thing'), findsOneWidget);
    expect(find.text('Hold the Light'), findsNothing);
  });

  testWidgets('upload requires rights confirmation', (tester) async {
    await tester.pumpWidget(const SoundroomApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Upload'));
    await tester.pumpAndSettle();

    final buttonFinder = find.ancestor(
      of: find.text('Send for review'),
      matching: find.byType(FilledButton),
    );
    expect(tester.widget<FilledButton>(buttonFinder).onPressed, isNull);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(buttonFinder).onPressed, isNotNull);

    await tester.tap(find.text('Send for review'));
    await tester.pump();
    expect(
      find.text('Prototype only: a real submission would wait for review.'),
      findsOneWidget,
    );
  });
}
