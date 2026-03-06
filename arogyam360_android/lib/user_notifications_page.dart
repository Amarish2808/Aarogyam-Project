// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserNotificationsPage extends StatefulWidget {
//   const UserNotificationsPage({super.key});
//
//   @override
//   State<UserNotificationsPage> createState() => _UserNotificationsPageState();
// }
//
// class _UserNotificationsPageState extends State<UserNotificationsPage> {
//
//   List<String> title_ = [];
//   List<String> message_ = [];
//   List<String> date_ = [];
//   List<String> gym_ = [];
//
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadNotifications();
//   }
//
//   Future<void> loadNotifications() async {
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     try {
//
//       var response = await http.post(
//         Uri.parse('$url/user_view_notifications/'),
//         body: {'lid': lid},
//       );
//
//       var jsondata = jsonDecode(response.body);
//
//       if (jsondata['status'] == 'ok') {
//
//         var arr = jsondata['data'];
//
//         title_.clear();
//         message_.clear();
//         date_.clear();
//         gym_.clear();
//
//         for (var n in arr) {
//           title_.add(n['title']);
//           message_.add(n['message']);
//           date_.add(n['date']);
//           gym_.add(n['gym']);
//         }
//       }
//
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error loading notifications");
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   Widget notificationCard(int index) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(18)),
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 18, 82, 98),
//               Color.fromARGB(255, 25, 110, 130),
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//             Row(children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.notifications, color: Colors.white),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(title_[index],
//                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 4),
//                   Text("From: ${gym_[index]}",
//                       style: const TextStyle(color: Colors.white70, fontSize: 12)),
//                 ]),
//               ),
//             ]),
//
//             const SizedBox(height: 14),
//
//             Text(message_[index],
//                 style: const TextStyle(color: Colors.white, height: 1.5)),
//
//             const SizedBox(height: 14),
//
//             Row(children: [
//               const Icon(Icons.calendar_today, color: Colors.white70, size: 14),
//               const SizedBox(width: 6),
//               Text(date_[index],
//                   style: const TextStyle(color: Colors.white70, fontSize: 12)),
//             ]),
//
//           ]),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text("Notifications"),
//         backgroundColor: const Color.fromARGB(255, 18, 82, 98),
//       ),
//
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : title_.isEmpty
//           ? const Center(child: Text("No Notifications"))
//           : RefreshIndicator(
//         color: const Color.fromARGB(255, 18, 82, 98),
//         onRefresh: loadNotifications,
//         child: ListView.builder(
//           itemCount: title_.length,
//           itemBuilder: (context, index) => notificationCard(index),
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotificationsPage extends StatefulWidget {
  const UserNotificationsPage({super.key});

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {

  List<String> title_ = [];
  List<String> message_ = [];
  List<String> date_ = [];
  List<String> gym_ = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    try {
      var response = await http.post(
        Uri.parse('$url/user_view_notifications/'),
        body: {'lid': lid},
      );

      var jsondata = jsonDecode(response.body);

      if (jsondata['status'] == 'ok') {
        var arr = jsondata['data'];

        title_.clear();
        message_.clear();
        date_.clear();
        gym_.clear();

        for (var n in arr) {
          title_.add(n['title']);
          message_.add(n['message']);
          date_.add(n['date']);
          gym_.add(n['gym']);
        }
      }

    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading notifications");
    }

    setState(() => isLoading = false);
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget notificationCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [

          // HEADER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.grey.shade800,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title_[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BODY
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                infoRow(Icons.business_outlined, "From: ${gym_[index]}"),

                const SizedBox(height: 10),

                Text(
                  message_[index],
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      date_[index],
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : title_.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 80,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "No Notifications",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "You don't have any notifications yet",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        color: Colors.black,
        onRefresh: loadNotifications,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: title_.length,
          itemBuilder: (context, index) => notificationCard(index),
        ),
      ),
    );
  }
}
