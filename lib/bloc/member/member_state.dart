import 'package:equatable/equatable.dart';

class MemberState extends Equatable {
  final List members;
  final List allMembers;
  final List managers;
  final String? error;
  final String? success;
  final bool isLoading; // ✅ Tambahan

  const MemberState({
    this.members = const [],
    this.allMembers = const [],
    this.managers = const [],
    this.error,
    this.success,
    this.isLoading = false, // ✅ Tambahan
  });

  MemberState copyWith({
    List? members,
    List? allMembers,
    List? managers,
    String? error,
    String? success,
    bool? isLoading, // ✅ Tambahan
  }) {
    return MemberState(
      members: members ?? this.members,
      allMembers: allMembers ?? this.allMembers,
      managers: managers ?? this.managers,
      error: error,
      success: success,
      isLoading: isLoading ?? this.isLoading, // ✅ Tambahan
    );
  }

  @override
  List<Object?> get props => [
    members,
    allMembers,
    managers,
    error,
    success,
    isLoading,
  ]; // ✅ Tambahan
}
