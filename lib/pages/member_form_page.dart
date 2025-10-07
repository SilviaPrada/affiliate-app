import 'package:affiliate_app/bloc/member/member_bloc.dart';
import 'package:affiliate_app/bloc/member/member_event.dart';
import 'package:affiliate_app/bloc/member/member_state.dart';
import 'package:affiliate_app/component/custom_appbar.dart';
import 'package:affiliate_app/component/custom_dropdown_field.dart';
import 'package:affiliate_app/component/custom_input_field.dart';
import 'package:affiliate_app/component/primary_button.dart';
import 'package:affiliate_app/constant/color.dart';
import 'package:affiliate_app/constant/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberFormPage extends StatefulWidget {
  final Map<String, dynamic>? member;
  final String? role;

  const MemberFormPage({super.key, this.member, this.role});

  @override
  State<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends State<MemberFormPage> {
  final nameCtrl = TextEditingController();
  final branchCtrl = TextEditingController();
  final repIdCtrl = TextEditingController();
  final positionCtrl = TextEditingController(text: "EPC");
  String? selectedManager;

  bool get isEdit => widget.member != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final m = widget.member!;
      nameCtrl.text = m["m_name"];
      branchCtrl.text = m["m_branch_id"];
      repIdCtrl.text = m["m_rep_id"];
      positionCtrl.text = m["m_current_position"] ?? "EPC";
      selectedManager = m["m_manager_id"];
    }

    context.read<MemberBloc>().add(LoadMembers());
  }

  void _saveOrUpdateMember() {
    if (isEdit) {
      context.read<MemberBloc>().add(
        UpdateMember(widget.member!["m_rep_id"], {
          "m_branch_id": branchCtrl.text,
          "m_rep_id": repIdCtrl.text,
          "m_name": nameCtrl.text,
          "m_current_position": positionCtrl.text,
          "m_manager_id": selectedManager,
        }),
      );
    } else {
      context.read<MemberBloc>().add(
        AddMember({
          "m_branch_id": branchCtrl.text,
          "m_rep_id": repIdCtrl.text,
          "m_name": nameCtrl.text,
          "m_current_position": positionCtrl.text,
          "m_manager_id": selectedManager,
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = widget.role == "Administrator";

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit
            ? (isAdmin ? "Edit Member" : "View Member")
            : "Add Member",
        showBackButton: true,
        onBack: () => Navigator.pop(context),
      ),
      body: BlocListener<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state.success != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryLight,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isEdit
                              ? "Member updated successfully!"
                              : "Member added successfully!",
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          }
        },

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: BlocBuilder<MemberBloc, MemberState>(
            builder: (context, state) {
              final managers = state.managers;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInputField(
                      label: "Branch",
                      hintText: "Enter 3 digit id branch",
                      prefixIcon: Icons.business_outlined,
                      controller: branchCtrl,
                      isEnabled: isAdmin || !isEdit,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: "Rep ID",
                      hintText: "Enter 7 digit Rep ID",
                      prefixIcon: Icons.badge_outlined,
                      controller: repIdCtrl,
                      isEnabled: isAdmin || !isEdit,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: "Name",
                      hintText: "Enter member name",
                      prefixIcon: Icons.person_outline,
                      controller: nameCtrl,
                      isEnabled: isAdmin || !isEdit,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: "Current Position",
                      hintText: "Enter current position",
                      prefixIcon: Icons.work_outline,
                      controller: positionCtrl,
                      isEnabled: false,
                    ),
                    const SizedBox(height: 20),
                    CustomDropdownField<String>(
                      label: "Manager",
                      hintText: "Select manager",
                      prefixIcon: Icons.supervisor_account_outlined,
                      value: selectedManager,
                      items: managers.map<DropdownMenuItem<String>>((m) {
                        return DropdownMenuItem<String>(
                          value: m["m_rep_id"].toString(),
                          child: Text("${m["m_name"]} (${m["m_rep_id"]})"),
                        );
                      }).toList(),
                      onChanged: isAdmin || !isEdit
                          ? (value) => setState(() => selectedManager = value)
                          : null,
                      isEnabled: isAdmin || !isEdit,
                    ),
                    const SizedBox(height: 50),
                    if (isAdmin || !isEdit)
                      PrimaryButton(
                        text: isEdit ? "Update Member" : "Save",
                        onPressed: _saveOrUpdateMember,
                      ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
