import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "pages/counter/counter_page.view.dart";

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}