import 'package:diary_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authState;
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AsyncData(null));

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authService.signUp(email, password));
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authService.signIn(email, password));
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authService.signInWithGoogle());
  }

  Future<void> signInWithGithub() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authService.signInWithGithub());
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      final authService = ref.watch(authServiceProvider);
      return AuthController(authService);
    });
