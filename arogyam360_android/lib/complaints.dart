// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const ComplaintScreen());
// }
//
// class ComplaintScreen extends StatelessWidget {
//   const ComplaintScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Complaints',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//             seedColor: const Color.fromARGB(255, 18, 82, 98)),
//         useMaterial3: true,
//       ),
//       home: const ComplaintPage(title: 'My Complaints'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class ComplaintPage extends StatefulWidget {
//   const ComplaintPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ComplaintPage> createState() => _ComplaintPageState();
// }
//
// class _ComplaintPageState extends State<ComplaintPage> {
//   List<String> id_ = [];
//   List<String> complaint_ = [];
//   List<String> date_ = [];
//   List<String> reply_ = [];
//
//   final TextEditingController complaintController = TextEditingController();
//   bool isLoading = true;
//   bool isSending = false;
//
//   @override
//   void initState() {
//     super.initState();
//     user_view_complaints();
//   }
//
//   @override
//   void dispose() {
//     complaintController.dispose();
//     super.dispose();
//   }
//
//   Future<void> user_view_complaints() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String urls = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     if (urls.isEmpty || lid.isEmpty) {
//       Fluttertoast.showToast(
//         msg: 'Configuration error',
//         backgroundColor: Colors.red,
//       );
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }
//
//     String url = '$urls/user_view_complaints/';
//
//     try {
//       var response = await http.post(Uri.parse(url), body: {'lid': lid});
//       var jsondata = json.decode(response.body);
//
//       if (jsondata['status'] == 'ok') {
//         List<String> id = [];
//         List<String> complaint = [];
//         List<String> date = [];
//         List<String> reply = [];
//
//         var arr = jsondata["data"];
//         for (var comp in arr) {
//           id.add(comp['id'].toString());
//           complaint.add(comp['complaint'].toString());
//           date.add(comp['date'].toString());
//           reply.add(comp['reply'].toString());
//         }
//
//         setState(() {
//           id_ = id;
//           complaint_ = complaint;
//           date_ = date;
//           reply_ = reply;
//           isLoading = false;
//         });
//       } else {
//         Fluttertoast.showToast(
//           msg: 'No complaints found',
//           backgroundColor: Colors.orange,
//         );
//         setState(() {
//           id_ = [];
//           complaint_ = [];
//           date_ = [];
//           reply_ = [];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Error: ${e.toString()}',
//         backgroundColor: Colors.red,
//       );
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void _sendData() async {
//     String complaintText = complaintController.text.trim();
//     if (complaintText.isEmpty) {
//       Fluttertoast.showToast(msg: "Please enter your complaint");
//       return;
//     }
//
//     setState(() {
//       isSending = true;
//     });
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//
//     if (url == null || url.isEmpty) {
//       Fluttertoast.showToast(
//         msg: "Configuration error",
//         backgroundColor: Colors.red,
//       );
//       setState(() {
//         isSending = false;
//       });
//       return;
//     }
//
//     Uri apiUrl = Uri.parse('$url/user_send_complaint/');
//
//     try {
//       var response = await http.post(apiUrl, body: {
//         'complaint': complaintText,
//         'lid': lid,
//       });
//
//       setState(() {
//         isSending = false;
//       });
//
//       if (response.statusCode == 200) {
//         var jsonData = jsonDecode(response.body);
//         if (jsonData['status'] == 'ok') {
//           Fluttertoast.showToast(
//             msg: 'Complaint sent successfully',
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//           );
//           complaintController.clear();
//           await user_view_complaints();
//         } else {
//           Fluttertoast.showToast(
//             msg: jsonData['message'] ?? 'Failed to send complaint',
//             backgroundColor: Colors.red,
//           );
//         }
//       } else {
//         Fluttertoast.showToast(
//           msg: 'Network Error: ${response.statusCode}',
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       setState(() {
//         isSending = false;
//       });
//       Fluttertoast.showToast(
//         msg: 'Error: ${e.toString()}',
//         backgroundColor: Colors.red,
//       );
//     }
//   }
//
//   Widget buildComplaintCard(int index) {
//     bool hasReply = reply_[index].isNotEmpty && reply_[index] != "null";
//
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 18, 82, 98),
//               Color.fromARGB(255, 25, 110, 130),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with Icon and Status
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.report_problem_rounded,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Complaint #${id_[index]}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.calendar_today_rounded,
//                               color: Colors.white70,
//                               size: 12,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               date_[index],
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: hasReply
//                           ? const Color(0xFF66BB6A).withOpacity(0.3)
//                           : const Color(0xFFFFA726).withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: hasReply
//                             ? const Color(0xFF66BB6A).withOpacity(0.5)
//                             : const Color(0xFFFFA726).withOpacity(0.5),
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           hasReply ? Icons.check_circle : Icons.pending,
//                           size: 14,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           hasReply ? "Resolved" : "Pending",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 11,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // Complaint Text
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(
//                           Icons.comment_rounded,
//                           color: Colors.white70,
//                           size: 16,
//                         ),
//                         SizedBox(width: 6),
//                         Text(
//                           "Your Complaint",
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       complaint_[index],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Reply Section
//               if (hasReply) ...[
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF66BB6A).withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: const Color(0xFF66BB6A).withOpacity(0.4),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Row(
//                         children: [
//                           Icon(
//                             Icons.reply_rounded,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                           SizedBox(width: 6),
//                           Text(
//                             "Admin Response",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         reply_[index],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           height: 1.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ] else ...[
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Row(
//                     children: [
//                       Icon(
//                         Icons.info_outline_rounded,
//                         color: Colors.white70,
//                         size: 16,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         "Waiting for admin response...",
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 12,
//                           fontStyle: FontStyle.italic,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => true,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//           ),
//           backgroundColor: const Color.fromARGB(255, 18, 82, 98),
//           elevation: 0,
//           title: Text(
//             widget.title,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: isLoading
//                   ? const Center(
//                 child: CircularProgressIndicator(
//                   color: Color.fromARGB(255, 18, 82, 98),
//                 ),
//               )
//                   : id_.isEmpty
//                   ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 18, 82, 98)
//                             .withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.report_problem_outlined,
//                         size: 80,
//                         color: const Color.fromARGB(255, 18, 82, 98)
//                             .withOpacity(0.5),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Text(
//                       "No Complaints Yet",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 40),
//                       child: Text(
//                         "Your complaints and feedback will appear here",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[500],
//                           height: 1.5,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//                   : RefreshIndicator(
//                 color: const Color.fromARGB(255, 18, 82, 98),
//                 onRefresh: user_view_complaints,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   itemCount: id_.length,
//                   itemBuilder: (context, index) {
//                     return buildComplaintCard(index);
//                   },
//                 ),
//               ),
//             ),
//
//             // Fixed bottom complaint input & send button
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(16),
//               child: SafeArea(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Submit a Complaint",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 18, 82, 98),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: const Color.fromARGB(255, 18, 82, 98)
//                                     .withOpacity(0.3),
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: TextField(
//                               controller: complaintController,
//                               maxLines: 3,
//                               decoration: const InputDecoration(
//                                 hintText: "Write your complaint here...",
//                                 hintStyle: TextStyle(fontSize: 14),
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.all(12),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Container(
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color.fromARGB(255, 18, 82, 98),
//                                 Color.fromARGB(255, 25, 110, 130),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color.fromARGB(255, 18, 82, 98)
//                                     .withOpacity(0.3),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: ElevatedButton(
//                             onPressed: isSending ? null : _sendData,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               foregroundColor: Colors.white,
//                               shadowColor: Colors.transparent,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 24, vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: isSending
//                                 ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white),
//                               ),
//                             )
//                                 : const Row(
//                               children: [
//                                 Icon(Icons.send_rounded, size: 18),
//                                 SizedBox(width: 6),
//                                 Text(
//                                   "Send",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ComplaintScreen());
}

class ComplaintScreen extends StatelessWidget {
  const ComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaints',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xfff2f2f2),
        useMaterial3: true,
      ),
      home: const ComplaintPage(title: 'Complaints & Feedback'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key, required this.title});
  final String title;

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage>
    with SingleTickerProviderStateMixin {
  List<String> id_ = [];
  List<String> complaint_ = [];
  List<String> date_ = [];
  List<String> reply_ = [];

  final TextEditingController complaintController = TextEditingController();
  bool isLoading = true;
  bool isSending = false;
  bool showInputSection = false;

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    user_view_complaints();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    complaintController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleInputSection() {
    setState(() {
      showInputSection = !showInputSection;
    });

    if (showInputSection) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> user_view_complaints() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    if (urls.isEmpty || lid.isEmpty) {
      Fluttertoast.showToast(msg: 'Configuration error');
      setState(() {
        isLoading = false;
      });
      return;
    }

    String url = '$urls/user_view_complaints/';

    try {
      var response = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(response.body);

      if (jsondata['status'] == 'ok') {
        List<String> id = [];
        List<String> complaint = [];
        List<String> date = [];
        List<String> reply = [];

        var arr = jsondata["data"];
        for (var comp in arr) {
          id.add(comp['id'].toString());
          complaint.add(comp['complaint'].toString());
          date.add(comp['date'].toString());
          reply.add(comp['reply'].toString());
        }

        setState(() {
          id_ = id;
          complaint_ = complaint;
          date_ = date;
          reply_ = reply;
          isLoading = false;
        });
      } else {
        setState(() {
          id_ = [];
          complaint_ = [];
          date_ = [];
          reply_ = [];
          isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sendData() async {
    String complaintText = complaintController.text.trim();
    if (complaintText.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your complaint");
      return;
    }

    setState(() {
      isSending = true;
    });

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    if (url == null || url.isEmpty) {
      Fluttertoast.showToast(msg: "Configuration error");
      setState(() {
        isSending = false;
      });
      return;
    }

    Uri apiUrl = Uri.parse('$url/user_send_complaint/');

    try {
      var response = await http.post(apiUrl, body: {
        'complaint': complaintText,
        'lid': lid,
      });

      setState(() {
        isSending = false;
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Complaint sent successfully');
          complaintController.clear();
          _toggleInputSection(); // Close input section
          await user_view_complaints();
        } else {
          Fluttertoast.showToast(
              msg: jsonData['message'] ?? 'Failed to send complaint');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isSending = false;
      });
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  Widget buildComplaintCard(int index) {
    bool hasReply = reply_[index].isNotEmpty && reply_[index] != "null";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  Colors.grey.shade800,
                ],
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
                  child: const Icon(
                    Icons.feedback_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Complaint #${id_[index]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            date_[index],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasReply
                        ? Colors.green.shade700.withOpacity(0.2)
                        : Colors.orange.shade700.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasReply
                          ? Colors.green.shade700.withOpacity(0.4)
                          : Colors.orange.shade700.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasReply ? Icons.check_circle : Icons.pending,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasReply ? "Resolved" : "Pending",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your Complaint
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.comment_outlined,
                            size: 16,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Your Complaint",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        complaint_[index],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Admin Reply
                if (hasReply) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.reply,
                              size: 16,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Admin Response",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          reply_[index],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green.shade900,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.orange.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Waiting for admin response...",
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
                  : id_.isEmpty
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
                        Icons.feedback_outlined,
                        size: 80,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "No Complaints Yet",
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
                        "Your complaints and feedback will appear here",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                color: Colors.black,
                onRefresh: user_view_complaints,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: id_.length,
                  itemBuilder: (context, index) {
                    return buildComplaintCard(index);
                  },
                ),
              ),
            ),

            // Animated Input Section
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return showInputSection
                    ? Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Submit Complaint",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _toggleInputSection,
                                  icon: const Icon(Icons.close),
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.15),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: complaintController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  hintText:
                                  "Describe your complaint or feedback...",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black38,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isSending ? null : _sendData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: isSending
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                    AlwaysStoppedAnimation<
                                        Color>(Colors.white),
                                  ),
                                )
                                    : const Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      "Send Complaint",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    : const SizedBox();
              },
            ),
          ],
        ),

        // Floating Action Button
        floatingActionButton: !showInputSection
            ? FloatingActionButton.extended(
          onPressed: _toggleInputSection,
          backgroundColor: Colors.black,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "New Complaint",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : null,
      ),
    );
  }
}