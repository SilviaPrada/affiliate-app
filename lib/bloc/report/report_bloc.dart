import 'package:affiliate_app/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(const ReportState()) {
    on<LoadReport>(_onLoadReport);
  }

  Future<void> _onLoadReport(
    LoadReport event,
    Emitter<ReportState> emit,
  ) async {
    try {
      final data = await ApiService.getReport();
      emit(state.copyWith(report: data));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
