import 'package:affiliate_app/api_services.dart';
import 'package:affiliate_app/bloc/report/report_bloc.dart';
import 'package:affiliate_app/bloc/report/report_event.dart';
import 'package:affiliate_app/bloc/report/report_state.dart';
import 'package:affiliate_app/bloc/auth/auth_bloc.dart';
import 'package:affiliate_app/bloc/auth/auth_event.dart';
import 'package:affiliate_app/component/confirm_dialog.dart';
import 'package:affiliate_app/component/custom_appbar.dart';
import 'package:affiliate_app/constant/color.dart';
import 'package:affiliate_app/constant/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(LoadReport());
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ConfirmDialog(
        title: "Logout",
        message: "Are you sure you want to log out?",
        confirmText: "Logout",
        confirmColor: Color(0xFFF47C7C),
        icon: Icons.logout_rounded,
        iconColor: Color(0xFFF47C7C),
      ),
    );

    if (confirm == true) {
      context.read<AuthBloc>().add(LogoutRequested());
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Report", onLogout: () => _logout(context)),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(
              child: Text(
                "Error: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.report.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: state.report.length,
            itemBuilder: (_, i) {
              final r = state.report[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 4,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientPinkA,
                        AppColors.gradientPinkB,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.badge, color: AppColors.primary),
                    ),
                    title: Text(
                      "EPC: ${r["m_name"] ?? '-'}",
                      style: AppTextStyle.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    subtitle: Text(
                      "EPD: ${r["NamaEPD"] ?? '-'} | GEPD: ${r["NamaGEPD"] ?? '-'} | Branch: ${r["m_branch_id"] ?? '-'}",
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF47C7C),
        shape: const CircleBorder(),
        child: const Icon(Icons.download_outlined, color: Colors.white),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Downloading report..."),
              duration: Duration(seconds: 2),
            ),
          );

          final filePath = await ApiService.downloadReportExcel();
          if (filePath != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text("Report downloaded successfully!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to download report."),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
      ),
    );
  }
}
