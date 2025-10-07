import 'package:affiliate_app/api_services.dart';
import 'package:affiliate_app/bloc/auth/auth_bloc.dart';
import 'package:affiliate_app/bloc/member/member_bloc.dart';
import 'package:affiliate_app/bloc/report/report_bloc.dart';
import 'package:affiliate_app/constant/color.dart';
import 'package:affiliate_app/pages/home_page.dart';
import 'package:affiliate_app/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => MemberBloc()),
        BlocProvider(create: (_) => ReportBloc()),
      ],
      child: MaterialApp(
        title: 'Affiliate App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
        ),
        home: FutureBuilder(
          future: ApiService.getToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data != null) {
              return const HomePage();
            }
            return const WelcomePage();
          },
        ),
      ),
    );
  }
}
