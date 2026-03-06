import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'editprofile.dart';

void main() {
  runApp(const ViewProfile());
}

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xfff2f2f2),
        useMaterial3: true,
      ),
      home: const ViewProfilePage(title: 'My Profile'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key, required this.title});
  final String title;

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {

  String name_ = "";
  String username_ = "";
  String gender_ = "";
  String email_ = "";
  String phone_ = "";
  String place_ = "";
  String address_ = "";
  String age_ = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _send_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("My Profile", style: TextStyle(color: Colors.black)),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// PROFILE HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black12,
                    child: const Icon(Icons.person,size:60,color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Text(name_,style: const TextStyle(fontSize:22,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("@$username_",style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// STATS
            Row(
              children: [
                Expanded(child: _stat("Age", age_)),
                const SizedBox(width: 12),
                Expanded(child: _stat("Gender", gender_)),
              ],
            ),

            const SizedBox(height: 20),

            /// CONTACT
            _sectionTitle("Contact Information"),
            _info("Email", email_),
            _info("Phone", phone_),

            const SizedBox(height: 20),

            /// LOCATION
            _sectionTitle("Location"),
            _info("Place", place_),
            _info("Address", address_),

            const SizedBox(height: 30),

            /// EDIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyEditPage(title: "Edit Profile")),
                  ).then((_)=>_send_data());
                },
                child: const Text("Edit Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(bottom:10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,style: const TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _stat(String label,String value){
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label,style: const TextStyle(color: Colors.black54)),
          const SizedBox(height:5),
          Text(value.isEmpty?"-":value,style: const TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _info(String title,String value){
    return Container(
      margin: const EdgeInsets.only(bottom:10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.circle,size:8,color: Colors.black54),
          const SizedBox(width:10),
          Expanded(child: Text("$title : ${value.isEmpty?'Not provided':value}")),
        ],
      ),
    );
  }

  void _send_data() async {

    setState(() => isLoading=true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final response = await http.post(Uri.parse('$url/viewprofile/'), body: {'lid': lid});

    if(response.statusCode==200){
      final res=jsonDecode(response.body);
      if(res['status']=='ok'){
        setState(() {
          name_=res['name']??'';
          username_=res['username']??'';
          gender_=res['gender']??'';
          email_=res['email']??'';
          phone_=res['phone']??'';
          place_=res['place']??'';
          address_=res['address']??'';
          age_=res['age']?.toString()??'';
          isLoading=false;
        });
      }
    }else{
      setState(()=>isLoading=false);
      Fluttertoast.showToast(msg:"Network Error");
    }
  }
}
