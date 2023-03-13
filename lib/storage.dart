import 'dart:ui';

import 'package:chatgpt_project/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'model.dart';

class MyStorage extends StatefulWidget {
  const MyStorage({super.key});

  @override
  State<MyStorage> createState() => _MyStorageState();
}

class _MyStorageState extends State<MyStorage> {
  late bool isLoading;
  final List<Contents> messages = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }
  void _scrollDown(){
    setState(() {
          _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      );
    });
  }

  Future<List<Contents>> _loadchatlist() async{
    return await SqlDataBase.getList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Questions"),
          ),
          backgroundColor: Colors.black54,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.grey,
      body: FutureBuilder<List<Contents>>(
        future: _loadchatlist(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(child: Text('Not List'),);
          }
          if(snapshot.hasData){
            
            var datas = snapshot.data;
            return ListView(
            children: List.generate(datas!.length, (index) => _contentList(datas[index]),
          ));
          }
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
  Widget _contentList(Contents contents){ 
    Size screenSize = MediaQuery.of(context).size;
    
    return InkWell(
      onLongPress: () {
       showDialog(context: context, builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Message'),
          content: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              // ignore: sort_child_properties_last
              SizedBox(child: const Center(child:
                  Text('Are you sure you want to delete it?'),),
                  width: screenSize.width,
                  height: screenSize.height/10,
                  ),
            ],
          ),
              actions: [
              TextButton(onPressed:() {
                SqlDataBase.instance.delete(contents.text);
                setState(() {
                });
                Navigator.pop(context);
               }, child: const Text('Yes')),
                TextButton(onPressed:() {
                    Navigator.pop(context);
                }, child: const Text('No')),
              ],
              );
          });
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.all(16),
          color: Colors.black54,
            child: Column(
              children: [
                Row(children: [
                    Container(margin: const EdgeInsets.only(right: 16),
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
                        contents.date.toString(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ), 
                      ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8)
                        ),
                        
                      ),
                      child:Text(
                        contents.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ), 
                      ),
                  ],
                  ),
                  ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(children: [
                  Container(margin: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
                    child: Image.asset('asset/bot1.png',height: 30, width: 30,),
                  ),
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
                        contents.bottext,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ), 
                      ),
                  ],
                  ),
                  ),
          ]
        ),
              ],
            )
      ),
    );
  }
}