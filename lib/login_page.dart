import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final accent = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: primary, child: Icon(Icons.lock_open, color: Colors.white)),
                      SizedBox(width: 12),
                      Text("Sign in", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 18),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userCtrl,
                          decoration: InputDecoration(
                            labelText: "Username",
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? "Enter username" : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _pwdCtrl,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? "Enter password" : null,
                        ),
                        SizedBox(height: 18),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // placeholder auth - in real app replace with proper auth
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Signing in...")),
                                );
                                // NAVIGATE TO DASHBOARD (updated)
                                Navigator.pushReplacementNamed(context, '/dashboard');
                              }
                            },
                            child: Text("Login", style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // subtle footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Powered by ", style: TextStyle(color: Colors.grey[600])),
                      Text("RequestFlow", style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
