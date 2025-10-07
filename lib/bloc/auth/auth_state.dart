import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? role;
  final String? error;
  final bool isLoading; // ✅ Tambahan baru

  const AuthState({
    this.isAuthenticated = false,
    this.role,
    this.error,
    this.isLoading = false, // default tidak loading
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? role,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, role, error, isLoading];
}
