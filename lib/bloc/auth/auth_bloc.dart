import 'package:affiliate_app/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null)); // ✅ mulai loading

    try {
      final res = await ApiService.login(event.username, event.password);

      if (res.containsKey("token")) {
        await ApiService.saveToken(res["token"], res["role"]);

        emit(
          state.copyWith(
            isAuthenticated: true,
            role: res["role"],
            isLoading: false, // ✅ selesai loading
          ),
        );
      } else {
        emit(
          state.copyWith(
            error: res["message"] ?? "Login failed",
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true)); // ✅ mulai loading logout

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    emit(
      const AuthState(
        isAuthenticated: false,
        role: null,
        isLoading: false, // ✅ selesai loading
      ),
    );
  }
}
