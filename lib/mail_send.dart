import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailSendPage extends StatefulWidget {
  const MailSendPage({super.key});

  @override
  State<MailSendPage> createState() => _MailSendPageState();
}

class _MailSendPageState extends State<MailSendPage> {
  bool _isLoading = false;
  bool _isSubmited = false;
  final _formkey = GlobalKey<FormState>();

  String? name;
  String? email;
  String? msg;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController msgController = TextEditingController();

  final gmailSMTP = gmail(dotenv.env["MAIL"]!, dotenv.env["PASSWORD"]!);

  sendMail() async {
    final message = Message();
    message.from = Address(dotenv.env["MAIL"]!, 'Testing Mail');
    message.recipients.add(emailController.text);
    message.subject = 'Thank You for Your Submission!';
    message.text = '';
    message.html =
        "<h5>Dear ${nameController.text},</h5><p>Thank you for taking the time to fill out our form! We appreciate your effort and are thrilled to have you on board.</p><p>Your submission has been successfully received. Our team is currently reviewing your information, and we will get back to you shortly with the next steps.</p><p>Thank you once again!</p>";

    try {
      final sendReport = await send(message, gmailSMTP);
      print('Message sent: $sendReport');

      setState(() {
        _formkey.currentState?.reset();
        nameController.clear();
        emailController.clear();
        msgController.clear();
        _isSubmited = false;
        // Reset the form state
      });
      print("Controller Cleared");
      setState(() {});
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    setState(() {
      _isLoading = false; // Stop loading when the task is complete
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text("Mailer Plugin"),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 15.0,
                  right: 30.0,
                  left: 30.0,
                  bottom: 10.0,
                ),
                padding: const EdgeInsets.only(
                  top: 0.0,
                  right: 30.0,
                  left: 30.0,
                  bottom: 10.0,
                ),
                decoration: BoxDecoration(
                  // color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Lottie.asset("assets/images/contact_us.json",
                    fit: BoxFit.fill),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: TextFormField(
                  autovalidateMode: _isSubmited
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Name",
                    label: const Text(
                      "Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required Fields!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: TextFormField(
                  autovalidateMode: _isSubmited
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  controller: emailController,
                  decoration: InputDecoration(
                    label: const Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    hintText: "Enter Mail Address",
                    prefixIcon: const Icon(Icons.mail_outline),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mail is required Fields!';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please Enter A Valid Email Address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 10.0,
                  top: 10.0,
                ),
                child: TextFormField(
                  autovalidateMode: _isSubmited
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  controller: msgController,
                  decoration: InputDecoration(
                    label: const Text(
                      "Message",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    hintText: "Enter Message",
                    prefixIcon: const Icon(Icons.message),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message is required Fields!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    msg = value;
                  },
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.withOpacity(0.3),
                ),
                onPressed: () {
                  setState(() {
                    _isSubmited = true;
                  });
                  if (_formkey.currentState!.validate()) {
                    _formkey.currentState!.save();
                    setState(() {
                      _isLoading = true;
                    });
                    sendMail();
                  }
                },
                label: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
