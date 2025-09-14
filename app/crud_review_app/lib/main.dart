import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/search/pages/search_page.dart';
import 'features/search/bloc/search_bloc.dart';
import 'features/results/bloc/results_bloc.dart';
import 'features/business_detail/bloc/business_detail_bloc.dart';
import 'shared/repository/api_repository.dart';

void main() {
  // Initialize API client
  ApiClient.init();

  runApp(const CrudApp());
}

class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Repository
        RepositoryProvider<ApiRepository>(create: (context) => ApiRepository()),
        // BLoCs
        BlocProvider<SearchBloc>(
          create: (context) =>
              SearchBloc(apiRepository: context.read<ApiRepository>()),
        ),
        BlocProvider<ResultsBloc>(create: (context) => ResultsBloc()),
        BlocProvider<BusinessDetailBloc>(
          create: (context) =>
              BusinessDetailBloc(apiRepository: context.read<ApiRepository>()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: const SearchPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
