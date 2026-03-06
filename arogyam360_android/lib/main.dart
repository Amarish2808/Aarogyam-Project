import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arogyam 360 ',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xfff2f2f2),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Welcome to Arogyam 360 '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController ipc = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedIP();
  }

  Future<void> _loadSavedIP() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String? savedIP = sh.getString('ip');
    if (savedIP != null && savedIP.isNotEmpty) {
      setState(() {
        ipc.text = savedIP;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  const SizedBox(height: 60),

                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      size: 80,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Arogyam 360 ',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your Fitness Journey Starts Here',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 50),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Server Configuration',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextFormField(
                          controller: ipc,
                          decoration: InputDecoration(
                            labelText: 'Server IP Address',
                            prefixIcon: const Icon(Icons.dns_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter server IP address';
                            }
                            final ipPattern =
                            RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                            if (!ipPattern.hasMatch(value)) {
                              return 'Invalid IP address';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: Senddata,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Connect & Continue",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Senddata() async {
    if (!_formKey.currentState!.validate()) return;

    String ipdata = ipc.text.trim();

    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.setString("ip", ipdata);
    await sh.setString("url", "http://$ipdata:8000");
    await sh.setString("img_url", "http://$ipdata:8000");

    Fluttertoast.showToast(msg: 'Connected Successfully');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyLoginPage(title: 'Login'),
      ),
    );
  }
}
