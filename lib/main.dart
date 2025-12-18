import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const DailyScheduler(),
    );
  }
}

class DailyScheduler extends StatelessWidget {
  const DailyScheduler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('12月18日(木) - Daily'),
        actions: [
          IconButton(icon: const Icon(Icons.view_week), onPressed: () {}), // 週間切り替え用
        ],
      ),
      body: Row(
        children: [
          // --- 左側：1日のバーチカル (6:00 - 22:00) ---
          Expanded(
            flex: 2, // 画面の40%
            child: Container(
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade300))),
              child: ListView.builder(
                itemCount: 17, // 22 - 6 + 1
                itemBuilder: (context, index) {
                  int hour = index + 6;
                  return Container(
                    height: 60, // 1時間を60ピクセルで表現
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Center(child: Text('$hour:00', style: const TextStyle(fontSize: 12, color: Colors.grey))),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                            // ここに予定データがあれば着色するロジックを入れます
                            color: (hour == 9 || hour == 10) ? Colors.blue.withOpacity(0.2) : null,
                            child: (hour == 9) ? const Text(' 講義：プログラミング') : null,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // --- 右側：Todoリスト & メモエリア ---
          Expanded(
            flex: 3, // 画面の60%
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TODO LIST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: const [
                        TodoItem(task: 'レポート提出'),
                        TodoItem(task: 'お昼の買い出し'),
                        TodoItem(task: 'iPad miniの充電'),
                        SizedBox(height: 20),
                        Text('FREE MEMO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Divider(),
                        TextField(
                          maxLines: 10,
                          decoration: InputDecoration(hintText: '自由にメモを書いてください', border: InputBorder.none),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final String task;
  const TodoItem({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(task),
      value: false,
      onChanged: (bool? value) {},
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}