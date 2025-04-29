import 'package:awee/screens/auth/data/auth_repositery.dart';
import 'package:awee/screens/auth/domain/login_usecase.dart';
import 'package:awee/screens/auth/presentation/bloc/auth_bloc.dart';
import 'package:awee/screens/auth/presentation/bloc/auth_event.dart';
import 'package:awee/screens/auth/presentation/bloc/auth_state.dart';
import 'package:awee/screens/dashbord/dashbord_screen.dart';
import 'package:awee/screens/dashbord/presentation/dashboard_screens.dart';
import 'package:awee/them/them.dart';
import 'package:awee/wideget/screenSlide/screenSlide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart'; // ➡️ for animated loader

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    // _checkNotificationPermission();
    _loadSavedCredentials();
  }

  // void _checkNotificationPermission() async {
  //   // final isAllowed = await AwesomeNotifications().isNotificationAllowed();
  //   if (!isAllowed) {
  //     // AwesomeNotifications().requestPermissionToSendNotifications();
  //   }
  // }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('saved_email') &&
        prefs.containsKey('saved_password')) {
      setState(() {
        _emailController.text = prefs.getString('saved_email') ?? '';
        _passwordController.text = prefs.getString('saved_password') ?? '';
        rememberMe = true;
      });
    }

    PageRouteBuilder _slideRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    }
  }

  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_email', _emailController.text.trim());
      await prefs.setString('saved_password', _passwordController.text);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
    }
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _saveCredentials();
      context.read<AuthBloc>().add(
        LoginButtonPressed(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
      return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // InputDecoration _inputDecoration(String label) {
  //   return InputDecoration(
  //     labelText: label,
  //     labelStyle: const TextStyle(color: Colors.black),
  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //     focusedBorder: OutlineInputBorder(
  //       borderSide: const BorderSide(color: Colors.blue, width: 2),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     filled: true,
  //     fillColor: const Color.fromARGB(255, 0, 0, 0),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(LoginUseCase(AuthRepository())),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          actions: [
            SwitchListTile(
              value:
                  Provider.of<ThemeProvider>(context).themeMode ==
                  ThemeMode.dark,
              title: const Text('Dark Mode'),
              onChanged: (value) {
                Navigator.pushReplacement(
                  context,
                  slideRoute(const DashboardScreen()),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // AwesomeNotifications().createNotification(
              //   content: NotificationContent(
              //     id: 1,
              //     channelKey: 'basic_channel',
              //     title: 'Welcome back!',
              //     body: 'You have successfully logged in.',
              //   ),
              // );
              Navigator.pushReplacement(
                context,
                slideRoute(const DashboardScreen()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Image.asset('assets/login.png', width: 800, height: 300),
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.shopping_bag),
                        ),

                        keyboardType: TextInputType.emailAddress,
                      ),

                      // TextField(
                      //   controller: _emailController,
                      //   validator:    _validateEmail
                      //   decoration: const InputDecoration(
                      //     labelText: 'Email',
                      //     prefixIcon: Icon(Icons.shopping_bag),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        validator: _validatePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.shopping_bag),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        title: const Text(
                          'Remember Me',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            state is AuthLoading ? null : () => _login(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(
                            255,
                            182,
                            108,
                            192,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child:
                            state is AuthLoading
                                ? SizedBox(
                                  height: 90,
                                  width: 80,
                                  child: Lottie.asset(
                                    'assets/rocket.json',
                                  ), // 🔥 Animated Loader
                                )
                                : const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
