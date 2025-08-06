import 'package:go_router/go_router.dart';
import '../../ui/features/home/home_page.dart';
import '../../ui/features/details/details_page.dart';
import '../../ui/features/form/form_page.dart';
import '../../ui/features/api_demo/api_demo_page.dart';

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