import 'package:affiliate_app/bloc/auth/auth_bloc.dart';
import 'package:affiliate_app/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_page.dart';
import 'member_page.dart';
import 'report_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authState.role == null || !authState.isAuthenticated) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          });
          return const SizedBox.shrink();
        }

        if (authState.error != null) {
          return Scaffold(
            body: Center(child: Text('Error: ${authState.error}')),
          );
        }

        final List<Widget> pages = [];
        final List<BottomNavigationBarItem> navItems = [];

        // ✅ Semua role bisa melihat keduanya
        pages.add(const MemberPage());
        navItems.add(
          const BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Members",
          ),
        );

        pages.add(const ReportPage());
        navItems.add(
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Report",
          ),
        );

        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                items: navItems,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xFFF47C7C),
                unselectedItemColor: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
