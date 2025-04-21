import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class AiChatbot extends StatefulWidget {
  const AiChatbot({super.key});

  @override
  State<AiChatbot> createState() => _AiChatbotState();
}

class _AiChatbotState extends State<AiChatbot> {
  late final GenerativeModel chatModel;
  late final ChatSession chatSession;
  TextEditingController chatInput = TextEditingController();
  List<String> userInput = [];
  List<String> modelOutput = [];
  String chatModelOutput = '';

  Future<void> generateChatOutput(String msg ) async {
    final message = Content('user', [
      TextPart(msg)
    ]);
    final response = await chatSession.sendMessage(message);
    setState(() {
      chatModelOutput = response.text!;
      userInput.add(msg);
      modelOutput.add(chatModelOutput);
    });
    print(response.text);  
    }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatModel = GenerativeModel(
      model: 'gemini-2.0-flash', 
      apiKey: 'PUT_YOUR_API_KEY_HERE',
      systemInstruction: Content(
        'model', 
        [
          TextPart('when you asked about a hello message, return a message of two lines and for ecouraging engineers.'),
          TextPart('you dont answer anything rather than a morning message.'),
          TextPart('please add at least two emojis in your replay.'),
          
          ]
        )
      );
    chatSession = chatModel.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: chatInput,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: (){
                    generateChatOutput(chatInput.text);
                  }, 
                  icon: Icon(Icons.send))
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userInput.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(userInput[index])),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(modelOutput[index])),
                      ),
                    ],
                  );
                },
              ))
          ],
        ),
      ),
    );
  }
}