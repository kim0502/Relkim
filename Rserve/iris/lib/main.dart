import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController sepalLength;
  late TextEditingController sepalWidth;
  late TextEditingController petalLength;
  late TextEditingController petalWidth;
  late String irisImages;
  late String flower;

  @override
  void initState() {
    super.initState();
    sepalLength = TextEditingController();
    sepalWidth = TextEditingController();
    petalLength = TextEditingController();
    petalWidth = TextEditingController();
    //irisImages = "images/all.jpg";
    flower = 'all';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iris 품종 예측',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: sepalLength,
              decoration: const InputDecoration(
                labelText: 'Sepal Length의 크기를 입력하세요',
              ),
            ),
            TextField(
              controller: sepalWidth,
              decoration: const InputDecoration(
                labelText: 'Sepal Width의 크기를 입력하세요',
              ),
            ),
            TextField(
              controller: petalLength,
              decoration: const InputDecoration(
                labelText: 'Petal Length의 크기를 입력하세요',
              ),
            ),
            TextField(
              controller: petalWidth,
              decoration: const InputDecoration(
                labelText: 'Petal Width의 크기를 입력하세요',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  getIRISData();
                });
              },
              child: const Text('입력'),
            ),
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              backgroundImage: AssetImage(
                'images/$flower.jpg'
              ),
              radius: 70,
            ),
          ],
        ),
      ),
    );
  }

//function

  Future<bool> getIRISData() async {
    var url = Uri.parse(
        'http://localhost:8080/Rserve/response_iris.jsp?sepalLength=${sepalLength.text}&sepalWidth=${sepalWidth.text}&petalLength=${petalLength.text}&petalWidth=${petalWidth.text}');
    var response = await http.get(url);
 print(url);
    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      String result = dataConvertedJSON['result'];
      flower =result;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('품종 예측 결과'),
              content: Text('입력하신 품종은 $flower 입니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                  
                  Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    });
    return true;
  }
}//end
