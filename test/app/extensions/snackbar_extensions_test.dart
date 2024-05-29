import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vrit_birthday/app/extensions/extensions.dart';
import 'package:vrit_birthday/app/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  group(
    'Snackbar extensions',
    () {
      testWidgets(
        'success renders snackbar with correct text',
        (tester) async {
          await tester.pumpApp(
            VritScaffold(
              body: Column(
                children: [
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          context.snackbar.success('this is snack');
                        },
                        child: const Text('success snack'),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle();
          final button = find.byType(ElevatedButton);
          expect(button, findsOneWidget);
          await tester.tap(button);
          await tester.pumpAndSettle();
          final snackbar = find.text('this is snack');
          expect(snackbar, findsOneWidget);
        },
      );
    },
  );
}
