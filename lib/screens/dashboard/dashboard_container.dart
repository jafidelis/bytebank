import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/localization/i18_container.dart';
import 'package:bytebank/models/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_i18n.dart';
import 'dashboard_view.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit("Alexandre"),
      child: I18NLoadingContainer(
          viewKey: 'dashboard',
          creator: (messages) => DashboardView(DashboardViewLazyI18N(messages))
      ),
    );
  }
}