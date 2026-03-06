


import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'my_health_reports_page.dart';

class UploadMedicalReportPage extends StatefulWidget {
  const UploadMedicalReportPage({super.key});

  @override
  State<UploadMedicalReportPage> createState() => _UploadMedicalReportPageState();
}

class _UploadMedicalReportPageState extends State<UploadMedicalReportPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? selectedFile;
  bool isUploading = false;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadReport() async {

    if (titleController.text.isEmpty || selectedFile == null) {
      Fluttertoast.showToast(msg: "Enter title and choose PDF");
      return;
    }

    setState(() => isUploading = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$url/user_upload_medical_report/"),
    );

    request.fields['lid'] = lid;
    request.fields['title'] = titleController.text;
    request.fields['description'] = descriptionController.text;

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      selectedFile!.path,
    ));

    var response = await request.send();
    var res = await http.Response.fromStream(response);
    var jsonData = jsonDecode(res.body);

    setState(() => isUploading = false);

    if (jsonData['status'] == 'ok') {
      titleController.clear();
      descriptionController.clear();
      selectedFile = null;

      showResult(jsonData['summary'], jsonData['dietplan']);
    } else {
      Fluttertoast.showToast(msg: jsonData['message'] ?? "Upload failed");
    }
  }

  Widget inputField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xfff5f5f5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget actionButton(String text, VoidCallback onPressed,
      {Color color = Colors.black, bool loading = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
            height: 18, width: 18,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void showResult(String summary, String diet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xfff2f2f2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text("AI Health Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),
                Text(summary, style: const TextStyle(height: 1.6)),
                const SizedBox(height: 25),

                const Text("Recommended Diet Plan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),
                Text(diet, style: const TextStyle(height: 1.6)),

                const SizedBox(height: 30),

                actionButton("Close", () => Navigator.pop(context)),
                const SizedBox(height: 10),

                actionButton(
                    "My Reports",
                        () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const MyHealthReportsPage()));
                    },
                    color: Colors.grey.shade800),

              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Upload Medical Report",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
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

              inputField(titleController, "Report Title"),
              const SizedBox(height: 15),

              inputField(descriptionController, "Symptoms / Notes (Optional)", maxLines: 3),
              const SizedBox(height: 15),

              actionButton(
                  selectedFile == null ? "Choose PDF" : "PDF Selected",
                  pickFile,
                  color: Colors.grey.shade800),

              const SizedBox(height: 25),

              actionButton("Generate AI Report", uploadReport, loading: isUploading),
              const SizedBox(height: 12),

              actionButton(
                  "View My AI Reports",
                      () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MyHealthReportsPage())),
                  color: Colors.grey.shade800),
            ],
          ),
        ),
      ),
    );
  }
}
