import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/details_page.dart';
import '../pages/form_page.dart';
import '../pages/api_demo_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) => const DetailsPage(),
    ),
    GoRoute(
      path: '/form',
      builder: (context, state) => const FormPage(),
    ),
    GoRoute(
      path: '/api-demo',
      builder: (context, state) => const ApiDemoPage(),
    ),
  ],
);