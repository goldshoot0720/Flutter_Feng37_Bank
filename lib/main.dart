import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
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
      home: const MyHomePage(title: 'Flutter_Feng37_Bank'),
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
  String selectedValue = "0"; // 在這裡聲明 selectedValue，而不是放在 build 方法裡
  List<String> bank_savings = ["0","0","0","0","0","0","0","0","0","0"];
  int calcSumSaving(List<String> bankSavings) {
    int sumSaving = 0;
    for (int i = 0; i < 10; i++) {
      sumSaving += int.parse(bankSavings[i]);
    }
    return sumSaving;
  }
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  bool isInteger(String str) {
    return int.tryParse(str) != null;
  }
  // 存儲 List<String> 到 SharedPreferences
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 將 List<String> 轉換為單一的字串
    String listAsString = bank_savings.join(","); // 用逗號將列表合併成字符串
    await prefs.setString('bank_savings', listAsString); // 存儲字符串
    print("Data saved!");
  }
  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? listAsString = prefs.getString('bank_savings');
    if (listAsString != null) {
      // 將字符串分割回 List<String>
      List<String> loadedList = listAsString.split(",");
      setState(() {
        bank_savings = loadedList;
      });
      print("Data loaded!");
      _controller.text = bank_savings[0];
    }
  }

  // 在這裡進行初始化
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    _controller2.text = _controller2.text = calcSumSaving(bank_savings).toString();
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 調整對齊方式，可以是 start, center, end
              children: <Widget>[
                SizedBox(width: 100),
                Text('金融機構：'),
                SizedBox(width: 50),
                CustomDropdown(
                  selectedValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  }, controller1: _controller, controller2: _controller2,bank_savings: bank_savings, ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 調整對齊方式，可以是 start, center, end
              children: <Widget>[
                SizedBox(width: 100),
                Text('存款金額：'),
                SizedBox(width: 50),
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 調整對齊方式，可以是 start, center, end
              children: <Widget>[
                SizedBox(width: 100),
                Text('累積存款：'),
                SizedBox(width: 50),
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 調整對齊方式，可以是 start, center, end
              children: <Widget>[
                SizedBox(width: 100),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(!isInteger(_controller.text)){
                        _controller2.text= "請輸入數字";
                        return;
                      }
                      // 更新存款金額
                      bank_savings[int.parse(selectedValue)] = _controller.text;
                      // 更新累積存款顯示框
                      _controller2.text = calcSumSaving(bank_savings).toString();
                      print(selectedValue);
                      Fluttertoast.showToast(
                        msg: "已修改",  // 顯示的訊息
                        toastLength: Toast.LENGTH_SHORT,  // 顯示時長
                        gravity: ToastGravity.CENTER,  // 顯示位置
                        timeInSecForIosWeb: 1,  // iOS Web 端顯示時間
                        backgroundColor: Colors.black,  // 背景顏色
                        textColor: Colors.white,  // 文字顏色
                      );
                    });
                  },
                  child: Text('修改'),
                ),
                SizedBox(width: 50),
                ElevatedButton(
                  onPressed: () {
                    _saveData();
                    Fluttertoast.showToast(
                      msg: "已存檔",  // 顯示的訊息
                      toastLength: Toast.LENGTH_SHORT,  // 顯示時長
                      gravity: ToastGravity.CENTER,  // 顯示位置
                      timeInSecForIosWeb: 1,  // iOS Web 端顯示時間
                      backgroundColor: Colors.black,  // 背景顏色
                      textColor: Colors.white,  // 文字顏色
                    );
                  },
                  child: Text('存檔'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 調整對齊方式，可以是 start, center, end
              children: <Widget>[
                SizedBox(width: 100),
                Text('(000)中央銀行(鋒兄分行)存款金額：∞ '),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 調整對齊方式，可以是 start, center, end
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Feng37_2025'),
                        content: Text('委任第五職等\n簡任第十二職等\n第12屆臺北市長\n第23任總統\n中央銀行鋒兄分行'),
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
              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomDropdown extends StatefulWidget {
  String selectedValue;  // 接收選擇的值
  ValueChanged<String?> onChanged;  // 當選擇改變時的回調函數
  TextEditingController controller1;  // 用來接收 TextEditingController 1
  TextEditingController controller2;  // 用來接收 TextEditingController 2
  List<String> bank_savings = List.filled(10, "0");

  // 透過構造函數傳遞參數
  CustomDropdown({
    required this.selectedValue,
    required this.onChanged,
    required this.controller1,
    required this.controller2,
    required this.bank_savings
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
        DropdownMenuItem(value: '0', child: Text('(006)合作金庫')),
        DropdownMenuItem(value: '1', child: Text('(013)國泰世華')),
        DropdownMenuItem(value: '2', child: Text('(017)兆豐銀行')),
        DropdownMenuItem(value: '3', child: Text('(048)王道銀行')),
        DropdownMenuItem(value: '4', child: Text('(103)新光銀行')),
        DropdownMenuItem(value: '5', child: Text('(396)街口支付')),
        DropdownMenuItem(value: '6', child: Text('(700)中華郵政')),
        DropdownMenuItem(value: '7', child: Text('(808)玉山銀行')),
        DropdownMenuItem(value: '8', child: Text('(812)台新銀行')),
        DropdownMenuItem(value: '9', child: Text('(822)中國信託')),
      ],
    );
  }
}

