import 'package:bytebank/screens/counter.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/theme.dart';

void main() {
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Bloc.observer = LogObserver();
    return MaterialApp(
      theme: bytebankTheme,
      home: DashboardContainer(),
    );
  }
}

class LogObserver extends BlocObserver {

  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} > $change');
    super.onChange(cubit, change);
  }
}

