import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "pages/counter/counter_page.view.dart";
/*
ProviderScope is a widget that stores the state of all the providers we create.
 */
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}