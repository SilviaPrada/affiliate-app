import 'package:affiliate_app/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'member_event.dart';
import 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc() : super(const MemberState()) {
    on<LoadMembers>(_onLoadMembers);
    on<AddMember>(_onAddMember);
    on<UpdateMember>(_onUpdateMember);
    on<DeleteMember>(_onDeleteMember);
    on<SearchMembersEvent>(_onSearchMembers);
  }

  Future<void> _onLoadMembers(
    LoadMembers event,
    Emitter<MemberState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null)); // ✅ Start loading
    try {
      final members = await ApiService.getMembers();
      final managers = await ApiService.getManagers();
      emit(
        state.copyWith(
          members: members,
          allMembers: members,
          managers: managers,
          isLoading: false, // ✅ Stop loading
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onAddMember(AddMember event, Emitter<MemberState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await ApiService.addMember(event.data);
      emit(
        state.copyWith(
          success: "Member berhasil ditambahkan",
          isLoading: false,
        ),
      );
      add(LoadMembers());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateMember(
    UpdateMember event,
    Emitter<MemberState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await ApiService.updateMember(event.id, event.data);
      emit(
        state.copyWith(success: "Member berhasil diperbarui", isLoading: false),
      );
      add(LoadMembers());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteMember(
    DeleteMember event,
    Emitter<MemberState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await ApiService.deleteMember(event.id);
      emit(
        state.copyWith(success: "Member berhasil dihapus", isLoading: false),
      );
      add(LoadMembers());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSearchMembers(SearchMembersEvent event, Emitter<MemberState> emit) {
    final query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(state.copyWith(members: state.allMembers));
    } else {
      final filtered = state.allMembers.where((member) {
        final name = member['m_name']?.toString().toLowerCase() ?? '';
        final branch = member['m_branch_id']?.toString().toLowerCase() ?? '';
        final currentPosition =
            member['m_current_position']?.toString().toLowerCase() ?? '';
        return name.contains(query) ||
            branch.contains(query) ||
            currentPosition.contains(query);
      }).toList();
      emit(state.copyWith(members: filtered));
    }
  }
}
