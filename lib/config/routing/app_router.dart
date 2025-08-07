import 'package:flutter_boilerplate/config/routing/routes_name.dart';
import 'package:flutter_boilerplate/ui/features/api_demo/api_demo_page.dart';
import 'package:flutter_boilerplate/ui/features/details/details_page.dart';
import 'package:flutter_boilerplate/ui/features/form/form_page.dart';
import 'package:flutter_boilerplate/ui/features/home/home_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: RouteNames.home.name,
      path: RouteNames.home.path,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: RouteNames.details.name,
      path: RouteNames.details.path,
      builder: (context, state) => const DetailsPage(),
    ),
    GoRoute(
      name: RouteNames.form.name,
      path: RouteNames.form.path,
      builder: (context, state) => const FormPage(),
    ),
    GoRoute(
      name: RouteNames.apiDemo.name,
      path: RouteNames.apiDemo.path,
      builder: (context, state) => const ApiDemoPage(),
    ),
  ],
);