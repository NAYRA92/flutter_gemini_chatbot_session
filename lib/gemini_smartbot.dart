import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class GeminiSmartbot extends StatefulWidget {
  const GeminiSmartbot({super.key});

  @override
  State<GeminiSmartbot> createState() => _GeminiSmartbotState();
}
  final _model = GenerativeModel(
    model: "gemini-2.0-flash", 
    apiKey: "AIzaSyAurk7gyMlYYT8hT8OZuc_scXffJXsPR8E",
    systemInstruction: Content.system("when you asked about any message, give a message from two line and add more than one emoji")
    );

class _GeminiSmartbotState extends State<GeminiSmartbot> {
  TextEditingController _chatMessage = TextEditingController();

  final modelChat = _model.startChat();
  String outputResponse = "";
  List<String> outputResponseList = [];

  Future<void> _generateChatResponse(
    String msg
  ) async {
    final content = Content.text(msg);
    final response = await modelChat.sendMessage(content);
    setState(() {
      outputResponseList.add(response.text!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: _chatMessage,
              decoration: InputDecoration(
                hintText: "Add your requst",
                suffixIcon: IconButton(
                  onPressed: (){
                    _generateChatResponse(_chatMessage.text);
                  }, 
                  icon: Icon(Icons.send))
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: outputResponseList.length,
                  itemBuilder: (context, index) {
                  return  Container(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(5),
                    color: Colors.amber,
                    child: Text(outputResponseList[index]));
                },),
              ),
            )
           
          ],
        ),
      ),
    );
  }
}