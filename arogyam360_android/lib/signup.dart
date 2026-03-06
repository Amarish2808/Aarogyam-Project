import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'login.dart';

void main() {
  runApp(const MyMySignup());
}

class MyMySignup extends StatelessWidget {
  const MyMySignup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xfff2f2f2),
        useMaterial3: true,
      ),
      home: const MyMySignupPage(title: 'User Signup'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyMySignupPage extends StatefulWidget {
  const MyMySignupPage({super.key, required this.title});
  final String title;

  @override
  State<MyMySignupPage> createState() => _MyMySignupPageState();
}

class _MyMySignupPageState extends State<MyMySignupPage> {

  final _formKey = GlobalKey<FormState>();
  String gender = "Male";
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    placeController.dispose();
    ageController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const SizedBox(height: 10),

                // FULL NAME
                _buildTextField(
                  nameController,
                  "Full Name",
                  Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Full Name";
                    }
                    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return "Name must contain only alphabets and spaces";
                    }
                    return null;
                  },
                ),

                // USERNAME
                _buildTextField(
                  usernameController,
                  "Username",
                  Icons.account_circle,
                ),

                // EMAIL
                _buildTextField(
                  emailController,
                  "Email",
                  Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Email";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "Enter valid email address";
                    }
                    return null;
                  },
                ),

                // PHONE
                _buildTextField(
                  phoneController,
                  "Phone",
                  Icons.phone,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Phone Number";
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Phone must be exactly 10 digits";
                    }
                    return null;
                  },
                ),

                // PLACE
                _buildTextField(
                  placeController,
                  "Place",
                  Icons.location_on,
                ),

                // AGE (MIN 1, MAX 150)
                _buildTextField(
                  ageController,
                  "Age",
                  Icons.cake,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Age";
                    }

                    int? age = int.tryParse(value);

                    if (age == null) {
                      return "Age must be a valid number";
                    }

                    if (age < 1) {
                      return "Minimum age is 1";
                    }

                    if (age > 100) {
                      return "Maximum age is 100";
                    }

                    return null;
                  },
                ),

                // ADDRESS
                _buildTextField(
                  addressController,
                  "Address",
                  Icons.home,
                  maxLines: 3,
                ),

                const SizedBox(height: 10),

                // GENDER
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Gender",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      RadioListTile(
                          value: "Male",
                          groupValue: gender,
                          onChanged: (v) =>
                              setState(() => gender = v.toString()),
                          title: const Text("Male"),
                          activeColor: Colors.black),
                      RadioListTile(
                          value: "Female",
                          groupValue: gender,
                          onChanged: (v) =>
                              setState(() => gender = v.toString()),
                          title: const Text("Female"),
                          activeColor: Colors.black),
                      RadioListTile(
                          value: "Other",
                          groupValue: gender,
                          onChanged: (v) =>
                              setState(() => gender = v.toString()),
                          title: const Text("Other"),
                          activeColor: Colors.black),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // PASSWORD
                _buildTextField(
                  passwordController,
                  "Password",
                  Icons.lock,
                  obscure: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                // CONFIRM PASSWORD
                _buildTextField(
                  confirmpasswordController,
                  "Confirm Password",
                  Icons.lock,
                  obscure: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscureConfirmPassword =
                        !_obscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm your password";
                    }
                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendData,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                        color: Colors.white)
                        : const Text("Create Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                            const MyLoginPage(title: "Login")));
                  },
                  child: const Text("Already have an account? Login",
                      style: TextStyle(color: Colors.black87)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool obscure = false,
        int maxLines = 1,
        TextInputType? keyboardType,
        Widget? suffixIcon,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator ??
                (v) => v == null || v.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? baseUrl = sh.getString('url');

    if (baseUrl == null) {
      Fluttertoast.showToast(msg: "Server not configured");
      return;
    }

    final response =
    await http.post(Uri.parse('$baseUrl/user_register/'), body: {
      "username": usernameController.text,
      "password": passwordController.text,
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "place": placeController.text,
      "age": ageController.text,
      "address": addressController.text,
      "gender": gender,
    });

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == "ok") {
      Fluttertoast.showToast(
          msg: "Registration Successful",
          backgroundColor: Colors.green);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const MyLoginPage(title: "Login")));
    } else {
      Fluttertoast.showToast(
          msg: "Registration Failed",
          backgroundColor: Colors.red);
    }
  }
}