import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter_Feng37_Bank',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: '鋒兄三七銀行'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String howIRich = "";
  String? formattedDate; // null if no save data
  String selectedValue = "0"; // 在這裡聲明 selectedValue，而不是放在 build 方法裡
  List<String> bank_savings = [
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
  ];

  int calcSumSaving(List<String> bankSavings) {
    int sumSaving = 0;
    for (int i = 0; i < 10; i++) {
      sumSaving += int.parse(bankSavings[i]);
    }
    if ( sumSaving >= 100000000){
      howIRich = "億萬豪宅";
    }
    else if ( sumSaving >= 10000000){
      howIRich = "仟萬超跑";
    }
    else if ( sumSaving >= 1000000){
      howIRich = "佰萬第一桶金";
    }
    else if ( sumSaving >= 100000){
      howIRich = "十萬個為什麼";
    }
    else if ( sumSaving >= 10000){
      howIRich = "日本有萬元鈔";
    }
    else if ( sumSaving >= 1000){
      howIRich = "千元鈔票";
    }
    else if ( sumSaving >= 100){
      howIRich = "百元鈔票";
    }
    else if ( sumSaving >= 50){
      howIRich = "五十元銅板價";
    }
    else if ( sumSaving >= 10){
      howIRich = "十元硬幣";
    }
    else if ( sumSaving >= 5){
      howIRich = "五元硬幣";
    }
    else if ( sumSaving >= 1){
      howIRich = "壹元硬幣";
    }
    else if ( sumSaving ==  0){
      howIRich = "從零開始";
    }
    else if ( sumSaving < 0){
      howIRich = "不要負債";
    }
    return sumSaving;
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  bool isInteger(String str) {
    return int.tryParse(str) != null;
  }

  // 存儲 List<String> 到 SharedPreferences
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 將 List<String> 轉換為單一的字串
    // String listAsString = bank_savings.join(","); // 用逗號將列表合併成字符串
    // await prefs.setString('bank_savings', listAsString); // 存儲字符串
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
    print(formattedDate);
    await prefs.setString('file_date_time', formattedDate!); // 存儲字符串
    print("Data saved!");
    await prefs.setString('userNameStr', _controller3.text!);
    final conn = await Connection.open(
      Endpoint(
        host: 'dpg-cvn747bipnbc73d25080-a.oregon-postgres.render.com',
        database: 'rncoursefeng37',
        username: 'rncoursefeng37_user',
        password: '1b8AQoyVtIff8pUGS8by1x1yPV1gxQjT',
      ),
      // The postgres server hosted locally doesn't have SSL by default. If you're
      // accessing a postgres server over the Internet, the server should support
      // SSL and you should swap out the mode with `SslMode.verifyFull`.
      settings: ConnectionSettings(sslMode: SslMode.require),
    );
    print('has connection!');
    final result = await conn.execute(
      r"SELECT * FROM bankdata WHERE userName = $1",
      parameters: [_controller3.text],
    );
    print(result);
    if(result.isEmpty){
      print("_saveData() result2");
      int bank0 = int.parse(bank_savings[0]);
      int bank1 = int.parse(bank_savings[1]);
      int bank2 = int.parse(bank_savings[2]);
      int bank3 = int.parse(bank_savings[3]);
      int bank4 = int.parse(bank_savings[4]);
      int bank5 = int.parse(bank_savings[5]);
      int bank6 = int.parse(bank_savings[6]);
      int bank7 = int.parse(bank_savings[7]);
      int bank8 = int.parse(bank_savings[8]);
      int bank9 = int.parse(bank_savings[9]);
      final result2 = await conn.execute(
        r"INSERT INTO bankdata (userName, bank0, bank1, bank2, bank3, bank4, bank5, bank6, bank7, bank8, bank9) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
        parameters: [_controller3.text,bank0,bank1,bank2,bank3,bank4,bank5,bank6,bank7,bank8,bank9],
      );
      print(result2);
    }
    else{
      print("_saveData() result3");
      int bank0 = int.parse(bank_savings[0]);
      int bank1 = int.parse(bank_savings[1]);
      int bank2 = int.parse(bank_savings[2]);
      int bank3 = int.parse(bank_savings[3]);
      int bank4 = int.parse(bank_savings[4]);
      int bank5 = int.parse(bank_savings[5]);
      int bank6 = int.parse(bank_savings[6]);
      int bank7 = int.parse(bank_savings[7]);
      int bank8 = int.parse(bank_savings[8]);
      int bank9 = int.parse(bank_savings[9]);
      final result3 = await conn.execute(
        r"UPDATE bankdata SET bank0 = $1, bank1 = $2, bank2 = $3, bank3 = $4, bank4 = $5, bank5 = $6, bank6 = $7, bank7 = $8, bank8 = $9, bank9 = $10 WHERE userName = $11",
        parameters: [bank0,bank1,bank2,bank3,bank4,bank5,bank6,bank7,bank8,bank9,_controller3.text],
      );
      print(result3);
    }
    await conn.close();
  }

  void _loadData(bool isModify) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? listAsString = prefs.getString('bank_savings');
    // if (listAsString != null) {
      // 將字符串分割回 List<String>
      // List<String> loadedList = listAsString.split(",");
      final conn = await Connection.open(
        Endpoint(
          host: 'dpg-cvn747bipnbc73d25080-a.oregon-postgres.render.com',
          database: 'rncoursefeng37',
          username: 'rncoursefeng37_user',
          password: '1b8AQoyVtIff8pUGS8by1x1yPV1gxQjT',
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.require),
      );
      print('has connection!');
      if ( isModify ){
        await prefs.setString('userNameStr', _controller3.text!);
      }
      else{
        _controller3.text = prefs.getString('userNameStr')!;
      }
      final result = await conn.execute(
        r"SELECT * FROM bankdata WHERE userName = $1",
        parameters: [_controller3.text],
      );
      await conn.close();
      setState(() {
        bank_savings[0] = result[0][1].toString();
        bank_savings[1] = result[0][2].toString();
        bank_savings[2] = result[0][3].toString();
        bank_savings[3] = result[0][4].toString();
        bank_savings[4] = result[0][5].toString();
        bank_savings[5] = result[0][6].toString();
        bank_savings[6] = result[0][7].toString();
        bank_savings[7] = result[0][8].toString();
        bank_savings[8] = result[0][9].toString();
        bank_savings[9] = result[0][10].toString();
      });
      formattedDate = prefs.getString('file_date_time');
      print(formattedDate);
      print("Data loaded!");
      _controller.text = bank_savings[0];
    // }
  }

  // 在這裡進行初始化
  @override
  void initState() {
    super.initState();
    _loadData(false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // null if no save data
    if (formattedDate == null){
      formattedDate = "2025-02-05 20:25";
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double screenWidth = MediaQuery.of(context).size.width;
    double myWidth = screenWidth;
    if (screenWidth < 500) {
      myWidth = screenWidth / 8; // 62.5
    } else if (screenWidth < 1000) {
      myWidth = screenWidth / 12;
    } else if (screenWidth < 1500) {
      myWidth = screenWidth / 18; // 83.3
    } else {
      myWidth = 100;
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double myHeight = screenHeight;
    if (screenHeight < 1000) {
      myHeight = screenHeight / 20; // 50
    } else if (screenHeight < 1000) {
      myHeight = screenHeight / 30;
    } else if (screenHeight < 1500) {
      myHeight = screenHeight / 45; // 33.3
    } else {
      myHeight = 30;
    }

    myHeight /= 1.5;

    // print(screenWidth.toString() + "," + screenHeight.toString());
    _controller2.text =
        _controller2.text = calcSumSaving(bank_savings).toString();
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title+" "+formattedDate!),
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth,
                    vertical: myHeight,
                  ),
                  child: Text('金融機構：'),
                ),
                Container(
                  width: 200, // Set the width of the TextField

                  child: CustomDropdown(
                    selectedValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    controller1: _controller,
                    controller2: _controller2,
                    bank_savings: bank_savings,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth,
                    vertical: myHeight,
                  ),
                  child: Text('存款金額：'),
                ),
                Container(
                  width: 150, // Set the width of the TextField

                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '請輸入整數數字',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth,
                    vertical: myHeight,
                  ),
                  child: Text('累積存款：'),
                ),
                Container(
                  width: 150, // Set the width of the TextField

                  child: TextField(
                    controller: _controller2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabled: false,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth,
                    vertical: myHeight,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (!isInteger(_controller.text)) {
                          _controller2.text = "請輸入數字";
                          return;
                        }
                        // 更新存款金額
                        bank_savings[int.parse(selectedValue)] =
                            _controller.text;
                        // 更新累積存款顯示框
                        _controller2.text =
                            calcSumSaving(bank_savings).toString();
                        print(selectedValue);
                        Fluttertoast.showToast(
                          msg: "已修改",
                          // 顯示的訊息
                          toastLength: Toast.LENGTH_SHORT,
                          // 顯示時長
                          gravity: ToastGravity.CENTER,
                          // 顯示位置
                          timeInSecForIosWeb: 1,
                          // iOS Web 端顯示時間
                          backgroundColor: Colors.black,
                          // 背景顏色
                          textColor: Colors.white, // 文字顏色
                        );
                      });
                    },
                    child: Text('修改'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth,
                    vertical: myHeight,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _saveData();
                      Fluttertoast.showToast(
                        msg: "已存檔",
                        // 顯示的訊息
                        toastLength: Toast.LENGTH_SHORT,
                        // 顯示時長
                        gravity: ToastGravity.CENTER,
                        // 顯示位置
                        timeInSecForIosWeb: 1,
                        // iOS Web 端顯示時間
                        backgroundColor: Colors.black,
                        // 背景顏色
                        textColor: Colors.white, // 文字顏色
                      );
                    },
                    child: Text('存檔'),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth/2,
                    vertical: myHeight,
                  ),
                  child: Text('使用者名稱：'),
                ),
                Container(
                  width: 200, // Set the width of the TextField

                  child: TextField(
                    controller: _controller3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '請輸入使用者名稱',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth,
                    vertical: myHeight,
                  ),
                  child: Text('(000)中央銀行(鋒兄分行)存款金額：∞ '),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth,
                    vertical: myHeight,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Feng37_2025'),
                            content: Text(
                              howIRich+'\n㊣\n委任第五職等\n簡任第十二職等\n第12屆臺北市長\n第23任總統\n中央銀行鋒兄分行\n',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 關閉對話框
                                },
                                child: Text('關閉'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('彩蛋'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: myWidth,
                    vertical: myHeight,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _loadData(true);
                      Fluttertoast.showToast(
                        msg: "已讀檔",
                        // 顯示的訊息
                        toastLength: Toast.LENGTH_SHORT,
                        // 顯示時長
                        gravity: ToastGravity.CENTER,
                        // 顯示位置
                        timeInSecForIosWeb: 1,
                        // iOS Web 端顯示時間
                        backgroundColor: Colors.black,
                        // 背景顏色
                        textColor: Colors.white, // 文字顏色
                      );
                    },
                    child: Text('讀檔'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomDropdown extends StatefulWidget {
  String selectedValue; // 接收選擇的值
  ValueChanged<String?> onChanged; // 當選擇改變時的回調函數
  TextEditingController controller1; // 用來接收 TextEditingController 1
  TextEditingController controller2; // 用來接收 TextEditingController 2
  List<String> bank_savings = List.filled(10, "0");

  // 透過構造函數傳遞參數
  CustomDropdown({
    required this.selectedValue,
    required this.onChanged,
    required this.controller1,
    required this.controller2,
    required this.bank_savings,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          widget.onChanged(newValue); // 呼叫父元件的回調函數
          widget.selectedValue = newValue!; // Update the selected value
          widget.controller1.text = widget.bank_savings[int.parse(newValue!)];
          print(newValue);
          print(widget.bank_savings.toString());
        });
      },
      items: [
        DropdownMenuItem(value: '0', child: Text('(006)合作金庫(5880)')),
        DropdownMenuItem(value: '1', child: Text('(012)台北富邦(2881)')),
        DropdownMenuItem(value: '2', child: Text('(013)國泰世華(2882)')),
        DropdownMenuItem(value: '3', child: Text('(017)兆豐銀行(2886)')),
        DropdownMenuItem(value: '4', child: Text('(048)王道銀行(2897)')),
        DropdownMenuItem(value: '5', child: Text('(103)新光銀行(2888)')),
        DropdownMenuItem(value: '6', child: Text('(700)中華郵政')),
        DropdownMenuItem(value: '7', child: Text('(808)玉山銀行(2884)')),
        DropdownMenuItem(value: '8', child: Text('(812)台新銀行(2887)')),
        DropdownMenuItem(value: '9', child: Text('(822)中國信託(2891)')),
      ],
    );
  }
}
