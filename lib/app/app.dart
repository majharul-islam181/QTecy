import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/router/app_router.dart';
import '../core/theme/theme.dart';
import '../feature/auth/presentation/cubit/login_cubit.dart';
import '../feature/dashborad/presentation/bloc/product_bloc.dart';
import 'flavors.dart';
// import 'injection_container.dart' as di;
import '../core/injections/dependency_injection.dart' as di;
import 'dart:ui' as ui; 


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (_) => di.sl<LoginCubit>(), 
        ),
          BlocProvider<ProductBloc>(
          create: (_) => di.sl<ProductBloc>(),
        ),
        
        
      ],
      child: Builder(
        builder: (context) {
          return Directionality( 
            textDirection: ui.TextDirection.ltr, 
            child: _flavorBanner(
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: Flavors.title,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                locale: context.locale, 
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                 routerConfig: AppRouter.router,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) {
    return show
        ? Directionality( 
           textDirection: ui.TextDirection.ltr, 
            child: Banner(
              location: BannerLocation.topStart,
              message: Flavors.name,
              color: Colors.green.withOpacity(0.6),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                letterSpacing: 1.0,
              ),
              textDirection: ui.TextDirection.ltr,
              child: child,
            ),
          )
        : child;
  }
}