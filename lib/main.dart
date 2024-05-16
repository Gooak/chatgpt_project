import 'dart:convert';
import 'package:chatgpt_project/db_helper.dart';
import 'package:chatgpt_project/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model.dart';
import 'package:http/http.dart' as https;
import 'package:flutter_share/flutter_share.dart';
import 'package:sqflite/sqflite.dart';
import 'storage.dart';
import 'package:intl/intl.dart';

var input='';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqlDataBase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MygptChatMain()
    );
  }
}

class MygptChatMain extends StatefulWidget {
  const MygptChatMain({super.key});

  @override
  State<MygptChatMain> createState() => _MygptChatMainState();
}

class _MygptChatMainState extends State<MygptChatMain> {

  late bool isLoading;
  TextEditingController _textControllor = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    isLoading= false;
  }
  Future<String> generateRespone(String prompt) async{
    const apikey = 'MyAPIKey';
    var url = Uri.https("api.openai.com","/v1/completions");
    final respone = await https.post(url,
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $apikey'
      },
      body: jsonEncode({
        'model':'text-davinci-003',
        'prompt':prompt,
        'temperature':0,
        'max_tokens': 2000,
        'top_p':1,
        'frequency_penalty':0.0,
        'presence_penalty':0.0,
      })
    );
    Map<String,dynamic> newresponse= jsonDecode(utf8.decode(respone.bodyBytes));
    return newresponse['choices'][0]['text'];
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.all(10),
            child: Text("ChatGPT in the Flutter App"),
          ),
          leading: IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyStorage()),
            );
          }, icon: Icon(Icons.menu)),
          actions: [
            IconButton(onPressed: (){SystemNavigator.pop();}, icon: Icon(Icons.arrow_back)),
          ],
          backgroundColor: Colors.black54,
        ),
        backgroundColor: Colors.grey,
        body: Column(children: [
          Expanded(
            child: _bulidList(),
          ),
          Visibility(
            visible: isLoading,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _bulidInput(),
                  _bulidSubmit(),
                ],
              ),  
            ),
        ]),
      )
    );
  }

  Expanded _bulidInput() {
    return Expanded(
      child: TextField(
        // textInputAction: TextInputAction.go,
        // onSubmitted: (value){
        //   _bulidSubmit();
        // },
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.white),
        controller: _textControllor,
        decoration: const InputDecoration(
          fillColor: Colors.black54,
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      )
    );
  }
  
  Widget _bulidSubmit(){
    return Visibility(
      visible: !isLoading,
      child: Container(
        color: Colors.black54,
        child: IconButton(
          icon: const Icon(Icons.send_rounded, color: Colors.black54,),
          onPressed: (){
            setState(() {
              messages.add(ChatMessage(
                text: _textControllor.text, 
                chatMessageType: ChatMessageType.user));
              isLoading= true;
            });
            input = _textControllor.text;
            _textControllor.clear();
            Future.delayed(const Duration(milliseconds: 50)).then((value) => _scrollDown());

            generateRespone(input).then((value){
                setState(() {
                  isLoading = false;
                  messages.add(ChatMessage(text: value, chatMessageType: ChatMessageType.bot));
                }); 
            });
            _textControllor.clear();
            Future.delayed(const Duration(milliseconds: 50)).then((value) => _scrollDown());
          },
        ),
      ),
    );
  }

  void _scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      );
  }
  ListView _bulidList(){
    return ListView.builder(
      itemCount: messages.length,
      controller: _scrollController,
      itemBuilder: ((context, index) {
        var messageschat = messages[index];
      return ChatMessageWidget(
        text: messageschat.text,
        chatMessageType: messageschat.chatMessageType,
      );
    }));
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageWidget({super.key, required this.text, required this.chatMessageType});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //margin: EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          color: chatMessageType == ChatMessageType.bot
            ? Colors.black54
            : Colors.black45,
            child: Row(children: [
              chatMessageType == ChatMessageType.bot 
              ? Container(margin: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
                child: Image.asset('asset/bot1.png',height: 30, width: 30,),
              ),
            )
            : Container(margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                child: Icon(Icons.person),),
              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8)
                    ),
                  ),
                  child:Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ), 
                  ),
              ],
              ),
              ),
            ]
          ),
        ),
        Container(child: 
        chatMessageType == ChatMessageType.bot
        ? Container(
          width: double.infinity,
          color: Colors.black54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
              icon: const Icon(
                Icons.copy, color: Colors.white,),
                 onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Copying is Complete'),
                          duration: Duration(seconds: 1),
                      ),
                  );
                 },),
              IconButton(
              icon: const Icon(
                Icons.share, color: Colors.white,),
                 onPressed: () {
                     FlutterShare.share(title: text);
                 },),
              IconButton(
              icon: const Icon(
                Icons.arrow_downward, color: Colors.white,),
                 onPressed: () {
                      SaveContents();
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Save is Complete'),
                          duration: Duration(seconds: 1),
                      ),
                  );
                 },),
            ],
          )
             )
        : Container()
        ),
      ],
    );
  }

  void SaveContents() async{
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    var contents = Contents
    (text: input,
    bottext: text,
    date: formattedDate);
    await SqlDataBase.create(contents);
  }
}
