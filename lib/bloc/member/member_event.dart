import 'package:equatable/equatable.dart';

abstract class MemberEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMembers extends MemberEvent {}


class SearchMembersEvent extends MemberEvent {
  final String query;
  SearchMembersEvent(this.query);
}

class AddMember extends MemberEvent {
  final Map<String, dynamic> data;
  AddMember(this.data);

  @override
  List<Object?> get props => [data];
}

// ✅ Event Update
class UpdateMember extends MemberEvent {
  final String id;
  final Map<String, dynamic> data;
  UpdateMember(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

// ✅ Event Delete
class DeleteMember extends MemberEvent {
  final String id;
  DeleteMember(this.id);

  @override
  List<Object?> get props => [id];
}
