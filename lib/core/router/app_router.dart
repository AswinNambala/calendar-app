import 'package:calendar_app/feature/auth/presentation/login_page.dart';
import 'package:calendar_app/feature/auth/presentation/sign_up_page.dart';
import 'package:calendar_app/feature/calendar/presentation/calendar_home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// go router path and details for calendar app
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignUpScreen(),
    ),

    GoRoute(
      path: '/calendar',
      name: 'calendar',
      builder: (context, state) => const CalendarHomeScreen(),
    ),
  ],

  // Fallback screen for undefined paths
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.error}'),
    ),
  ),
);