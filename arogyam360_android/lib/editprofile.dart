// import 'dart:convert';
// import 'package:arogyam360_android/viewprofile.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const MyEdit());
// }
//
// class MyEdit extends StatelessWidget {
//   const MyEdit({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Edit Profile',
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: Colors.black,
//         scaffoldBackgroundColor: const Color(0xfff2f2f2),
//         useMaterial3: true,
//       ),
//       home: const MyEditPage(title: 'Edit Profile'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class MyEditPage extends StatefulWidget {
//   const MyEditPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyEditPage> createState() => _MyEditPageState();
// }
//
// class _MyEditPageState extends State<MyEditPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   String gender = "Male";
//   bool _isLoading = false;
//   bool _isDataLoading = true;
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController placeController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _get_data();
//   }
//
//   void _get_data() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final response = await http.post(Uri.parse('$url/viewprofile/'), body: {'lid': lid});
//
//     if (response.statusCode == 200) {
//       var jsonBody = jsonDecode(response.body);
//       if (jsonBody['status'] == 'ok') {
//         setState(() {
//           nameController.text = jsonBody['name'] ?? '';
//           ageController.text = jsonBody['age'] ?? '';
//           emailController.text = jsonBody['email'] ?? '';
//           phoneController.text = jsonBody['phone'] ?? '';
//           placeController.text = jsonBody['place'] ?? '';
//           addressController.text = jsonBody['address'] ?? '';
//           gender = jsonBody['gender'] ?? 'Male';
//           _isDataLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff2f2f2),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
//       ),
//       body: _isDataLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//
//               _field(nameController, "Full Name", Icons.person),
//               _field(ageController, "Age", Icons.cake, TextInputType.number),
//
//               _gender(),
//
//               _field(emailController, "Email", Icons.email, TextInputType.emailAddress),
//               _field(phoneController, "Phone", Icons.phone, TextInputType.phone),
//               _field(placeController, "Place", Icons.location_on),
//               _field(addressController, "Address", Icons.home, TextInputType.text, 3),
//
//               const SizedBox(height: 20),
//
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
//                   onPressed: _isLoading ? null : _send_data,
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Save Changes", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _field(TextEditingController c,String label,IconData icon,[TextInputType type=TextInputType.text,int lines=1]){
//     return Padding(
//       padding: const EdgeInsets.only(bottom:14),
//       child: TextFormField(
//         controller: c,
//         keyboardType: type,
//         maxLines: lines,
//         validator: (v)=>v==null||v.isEmpty?"Enter $label":null,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon,color: Colors.black),
//           labelText: label,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
//
//   Widget _gender(){
//     return Container(
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.only(bottom:14),
//       decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Gender",style: TextStyle(fontWeight: FontWeight.bold)),
//           RadioListTile(value:"Male",groupValue:gender,onChanged:(v)=>setState(()=>gender="Male"),title:const Text("Male"),activeColor: Colors.black),
//           RadioListTile(value:"Female",groupValue:gender,onChanged:(v)=>setState(()=>gender="Female"),title:const Text("Female"),activeColor: Colors.black),
//           RadioListTile(value:"Other",groupValue:gender,onChanged:(v)=>setState(()=>gender="Other"),title:const Text("Other"),activeColor: Colors.black),
//         ],
//       ),
//     );
//   }
//
//   void _send_data() async {
//
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(()=>_isLoading=true);
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final response = await http.post(Uri.parse('$url/editprofile/'), body: {
//       'lid': lid,
//       'name': nameController.text,
//       'age': ageController.text,
//       'gender': gender,
//       'email': emailController.text,
//       'phone': phoneController.text,
//       'place': placeController.text,
//       'address': addressController.text,
//     });
//
//     setState(()=>_isLoading=false);
//
//     if(response.statusCode==200 && jsonDecode(response.body)['status']=='ok'){
//       Fluttertoast.showToast(msg:"Profile Updated",backgroundColor: Colors.green);
//       Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const ViewProfilePage(title:"Profile")));
//     }else{
//       Fluttertoast.showToast(msg:"Update Failed",backgroundColor: Colors.red);
//     }
//   }
// }



import 'dart:convert';
import 'package:arogyam360_android/viewprofile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyEdit());
}

class MyEdit extends StatelessWidget {
  const MyEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xfff2f2f2),
        useMaterial3: true,
      ),
      home: const MyEditPage(title: 'Edit Profile'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyEditPage extends StatefulWidget {
  const MyEditPage({super.key, required this.title});
  final String title;

  @override
  State<MyEditPage> createState() => _MyEditPageState();
}

class _MyEditPageState extends State<MyEditPage> {
  final _formKey = GlobalKey<FormState>();

  String gender = "Male";
  bool _isLoading = false;
  bool _isDataLoading = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _get_data();
  }

  void _get_data() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final response =
    await http.post(Uri.parse('$url/viewprofile/'), body: {'lid': lid});

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      if (jsonBody['status'] == 'ok') {
        setState(() {
          nameController.text = jsonBody['name'] ?? '';
          ageController.text = jsonBody['age'] ?? '';
          emailController.text = jsonBody['email'] ?? '';
          phoneController.text = jsonBody['phone'] ?? '';
          placeController.text = jsonBody['place'] ?? '';
          addressController.text = jsonBody['address'] ?? '';
          gender = jsonBody['gender'] ?? 'Male';
          _isDataLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title:
        const Text("Edit Profile", style: TextStyle(color: Colors.black)),
      ),
      body: _isDataLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(nameController, "Full Name", Icons.person),
              _field(ageController, "Age", Icons.cake,
                  TextInputType.number),

              _gender(),

              _field(emailController, "Email", Icons.email,
                  TextInputType.emailAddress),
              _field(phoneController, "Phone", Icons.phone,
                  TextInputType.phone),
              _field(placeController, "Place", Icons.location_on),
              _field(addressController, "Address", Icons.home,
                  TextInputType.text, 3),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black),
                  onPressed: _isLoading ? null : _send_data,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text("Save Changes",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon,
      [TextInputType type = TextInputType.text, int lines = 1]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        maxLines: lines,
        inputFormatters: label == "Age"
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            return "Enter $label";
          }

          if (label == "Full Name") {
            if (v.trim().length < 3) {
              return "Name must be at least 3 characters";
            }
            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(v)) {
              return "Only alphabets and spaces allowed";
            }
          }

          if (label == "Age") {
            int? age = int.tryParse(v);
            if (age == null) {
              return "Enter valid age";
            }
            if (age < 18) {
              return "Minimum age is 18";
            }
            if (age > 100) {
              return "Maximum age is 100";
            }
          }

          if (label == "Email") {
            if (!RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(v)) {
              return "Enter valid email";
            }
          }

          if (label == "Phone") {
            if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
              return "Phone must be 10 digits";
            }
          }

          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _gender() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gender",
              style: TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile(
              value: "Male",
              groupValue: gender,
              onChanged: (v) => setState(() => gender = "Male"),
              title: const Text("Male"),
              activeColor: Colors.black),
          RadioListTile(
              value: "Female",
              groupValue: gender,
              onChanged: (v) => setState(() => gender = "Female"),
              title: const Text("Female"),
              activeColor: Colors.black),
          RadioListTile(
              value: "Other",
              groupValue: gender,
              onChanged: (v) => setState(() => gender = "Other"),
              title: const Text("Other"),
              activeColor: Colors.black),
        ],
      ),
    );
  }

  void _send_data() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final response = await http.post(Uri.parse('$url/editprofile/'), body: {
      'lid': lid,
      'name': nameController.text.trim(),
      'age': ageController.text.trim(),
      'gender': gender,
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'place': placeController.text.trim(),
      'address': addressController.text.trim(),
    });

    setState(() => _isLoading = false);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 'ok') {
      Fluttertoast.showToast(
          msg: "Profile Updated", backgroundColor: Colors.green);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
              const ViewProfilePage(title: "Profile")));
    } else {
      Fluttertoast.showToast(
          msg: "Update Failed", backgroundColor: Colors.red);
    }
  }
}