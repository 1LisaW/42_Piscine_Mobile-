import 'package:diary_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:diary_app/features/auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          // Handle successful login (e.g., navigate to home screen)
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),);
        },
        loading: () {
          // Show loading indicator
        },
        error: (error, stack) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: $error')),
          );
        },
      );
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email',
                contentPadding: EdgeInsets.all(10)),
              ),
            ),
            Container(
              width: 300,
              
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password', contentPadding: EdgeInsets.all(10)),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            authState.isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ref.read(authControllerProvider.notifier).signIn(
                                _emailController.text,
                                _passwordController.text,
                              );
                        },
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(authControllerProvider.notifier).signUp(
                                _emailController.text,
                                _passwordController.text,
                              );
                        },
                        child: const Text('Sign Up'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            ref.read(authControllerProvider.notifier).signInWithGoogle();
                          },
                          child: const Text('Sign in with Google'),
                        ),
                      ElevatedButton(
                          onPressed: () {
                            ref.read(authControllerProvider.notifier).signInWithGithub();
                          },
                          child: const Text('Sign in with Github'),
                        ),
                    ],
                  ),
          ],
        ),
        )
      )
    );
  }
}
