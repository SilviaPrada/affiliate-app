import 'package:affiliate_app/bloc/member/member_bloc.dart';
import 'package:affiliate_app/bloc/member/member_event.dart';
import 'package:affiliate_app/bloc/member/member_state.dart';
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
import 'member_form_page.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MemberBloc>().add(LoadMembers());

    _searchController.addListener(() {
      context.read<MemberBloc>().add(
        SearchMembersEvent(_searchController.text.trim()),
      );
    });
  }

  void _deleteMember(String repId) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ConfirmDialog(
        title: "Confirm Delete",
        message: "Are you sure you want to delete this member?",
        confirmText: "Delete",
        confirmColor: Color(0xFFF47C7C),
      ),
    );

    if (confirm == true) {
      context.read<MemberBloc>().add(DeleteMember(repId));
    }
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthBloc>().state.role;
    final bool isAdmin = role == "Administrator";

    return Scaffold(
      appBar: CustomAppBar(
        title: isAdmin ? "Manage Members" : "Members",
        showSearch: true,
        onLogout: () => _logout(context),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              style: AppTextStyle.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search member by name, position, or branch...',
                hintStyle: AppTextStyle.bodyLarge.copyWith(color: Colors.grey),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 2),
                  child: Icon(Icons.search, color: AppColors.primary, size: 24),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.error != null) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      "Error: ${state.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.members.isEmpty) {
            return const Center(child: Text("No members found"));
          }

          return ListView.builder(
            itemCount: state.members.length,
            itemBuilder: (_, i) {
              final m = state.members[i];
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
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    title: Text(
                      m["m_name"] ?? "-",
                      style: AppTextStyle.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    subtitle: Text(
                      "${m["m_branch_id"] ?? '-'} • ${m["m_current_position"] ?? '-'}",
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: isAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: AppColors.secondary,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MemberFormPage(
                                              member: m,
                                              role: role,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () =>
                                          _deleteMember(m["m_rep_id"]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MemberFormPage(member: m, role: role),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFF47C7C),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MemberFormPage()),
                );
              },
            )
          : null,
    );
  }
}
