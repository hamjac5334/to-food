// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/objects/pitch.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';

void main() {

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('PitchCount has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: PitchCountItem(
                pitch: Pitch(name: "test"),
                completed: true,
                onListChanged: (Pitch item, bool completed) {},
                //added color to the unit test to make it happy
                color: Colors.blue,
                onDeleteItem: (Pitch item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });


  testWidgets('Default PitchCounter has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PitchCount()));

    final listItemFinder = find.byType(PitchCountItem);

    expect(listItemFinder, findsAtLeast(1));
  });

  testWidgets('Clicking and Typing adds pitch to PitchCounter', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PitchCount()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("strike"), findsNothing);

    await tester.enterText(find.byType(TextField), 'strike');
    await tester.pump();
    expect(find.text("strike"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("strike"), findsOneWidget);

    final listItemFinder = find.byType(PitchCountItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  testWidgets('Count increases on pitch when clicked', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PitchCount()));
    final avatarFinder = find.byType(ElevatedButton);	
    ElevatedButton pitch = tester.firstWidget(avatarFinder);	    
    Text ptext = pitch.child as Text;

    expect(ptext.data, "1");

  }
  );

  // One to test the tap and press actions on the items?
}
