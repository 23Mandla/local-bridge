import 'package:flutter/material.dart';
import 'package:localbridge_frontend/app/theme/app_theme.dart';
import 'package:localbridge_frontend/base/bottom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localbridge_frontend/utils/bloc_observer.dart';
import 'features/opportunities/bloc/opportunities_bloc.dart';
import 'init_dependencies.dart';
import 'package:flutter/services.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  Bloc.observer = AppBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              serviceLocator<OpportunitiesBloc>()..add(GetOpportunities()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Local-bridge',
        theme: AppTheme.lightTheme,
        home: BottomNavBar(),
      ),
    );
  }
}
