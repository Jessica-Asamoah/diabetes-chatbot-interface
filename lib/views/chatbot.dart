import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/chatty-bqni-0ed5e8c604eb.json")
            .build();
    DialogFlow dialogflow = DialogFlow(authGoogle: authGoogle, language: "en");
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()![0]["text"]["text"][0].toString()
      });
    });
  }

  final messageInsert = TextEditingController();
  List<Map> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          "Ask Me Anything",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/image_2023-06-09_13-38-14.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) => chat(
                        messages[index]["message"].toString(),
                        messages[index]["data"]))),
            const Divider(
              height: 3.0,
            ),
            Container(
              // decoration: const BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              //   color: Colors.white,
              // ),
              padding: const EdgeInsets.only(bottom: 10.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                    controller: messageInsert,
                    decoration: const InputDecoration.collapsed(
                        hintText: "Send your message"),
                  )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          onPressed: () {
                            if (messageInsert.text.isEmpty) {
                              print("Empty message");
                            } else {
                              setState(() {
                                messages.insert(0,
                                    {"data": 1, "message": messageInsert.text});
                              });
                              response(messageInsert.text);
                              messageInsert.clear();
                            }
                          },
                          icon: const Icon(Icons.send)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget chat(String message, int data) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Bubble(
        radius: const Radius.circular(15.0),
        color: data == 0 ? Color(0xFFbde0fe) : Color(0xFFffeedd),
        elevation: 0.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                  child: Text(
                message,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        )),
  );
}
