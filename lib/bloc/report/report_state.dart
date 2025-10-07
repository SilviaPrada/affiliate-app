import 'package:equatable/equatable.dart';

class ReportState extends Equatable {
  final List report;
  final String? error;

  const ReportState({this.report = const [], this.error});

  ReportState copyWith({List? report, String? error}) {
    return ReportState(report: report ?? this.report, error: error);
  }

  @override
  List<Object?> get props => [report, error];
}
