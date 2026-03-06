

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPage extends StatefulWidget {
  final String trainerId;
  final String trainerName;

  const FeedbackPage({super.key, required this.trainerId, required this.trainerName});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<String> id_ = [];
  List<String> trainer_ = [];
  List<String> title_ = [];
  List<String> feedback_ = [];
  List<String> date_ = [];
  List<String> gym_ = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  bool isLoading = true;
  bool isSending = false;
  bool showInputPanel = true;

  @override
  void initState() {
    super.initState();
    viewFeedback();
  }

  @override
  void dispose() {
    titleController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  // ---------------- VIEW FEEDBACK ----------------
  Future<void> viewFeedback() async {
    setState(() => isLoading = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    var response = await http.post(
      Uri.parse('$url/user_view_feedback/'),
      body: {
        'lid': lid,
        'trainer_id': widget.trainerId,
      },
    );

    var jsondata = json.decode(response.body);

    if (jsondata['status'] == 'ok') {
      var arr = jsondata['data'];

      id_.clear();
      trainer_.clear();
      title_.clear();
      feedback_.clear();
      date_.clear();
      gym_.clear();

      for (var f in arr) {
        id_.add(f['id'].toString());
        trainer_.add(f['trainer']);
        title_.add(f['title']);
        feedback_.add(f['feedback']);
        date_.add(f['date']);
        gym_.add(f['gym']);
      }
    }

    setState(() => isLoading = false);
  }

  // ---------------- SEND FEEDBACK ----------------
  Future<void> sendFeedback() async {
    if (titleController.text.isEmpty || feedbackController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter all fields");
      return;
    }

    setState(() => isSending = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    var response = await http.post(
      Uri.parse('$url/user_send_feedback/'),
      body: {
        'lid': lid,
        'trainer_id': widget.trainerId,
        'title': titleController.text,
        'feedback': feedbackController.text,
      },
    );

    var jsondata = json.decode(response.body);

    setState(() => isSending = false);

    if (jsondata['status'] == 'ok') {
      Fluttertoast.showToast(msg: "Feedback Submitted", backgroundColor: Colors.green);
      titleController.clear();
      feedbackController.clear();
      viewFeedback();
      setState(() => showInputPanel = false);
    }
  }

  // ---------------- CARD UI ----------------
  Widget buildFeedbackCard(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person,
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
                            trainer_[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.fitness_center,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  gym_[index],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.title,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title_[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
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
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.black54,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date_[index],
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                            Icons.feedback_outlined,
                            size: 18,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Feedback",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        feedback_[index],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showInputPanel) {
          setState(() => showInputPanel = false);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "Feedback - ${widget.trainerName}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        floatingActionButton: showInputPanel
            ? null
            : FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () => setState(() => showInputPanel = true),
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text(
            "Write Feedback",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double keyboard = MediaQuery.of(context).viewInsets.bottom;
            double panelHeight = showInputPanel
                ? (keyboard > 0 ? constraints.maxHeight * 0.45 : 210)
                : 0;

            return Column(
              children: [
                Expanded(
                  child: isLoading
                      ? const Center(
                      child: CircularProgressIndicator(color: Colors.black))
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
                          "No Feedback Yet",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Be the first to share your feedback",
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
                    onRefresh: viewFeedback,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          bottom: panelHeight + 10, top: 10),
                      itemCount: id_.length,
                      itemBuilder: (context, index) =>
                          buildFeedbackCard(index),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: panelHeight,
                  child: showInputPanel
                      ? Container(
                    padding: EdgeInsets.fromLTRB(
                        20, 20, 20, keyboard > 0 ? keyboard : 20),
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: "Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: feedbackController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "Write feedback...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isSending ? null : sendFeedback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: isSending
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                "Submit Feedback",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}