import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

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

class DailyScheduler extends StatefulWidget {
  const DailyScheduler({super.key});
  @override
  State<DailyScheduler> createState() => _DailySchedulerState();
}

class _DailySchedulerState extends State<DailyScheduler> {
  // 手書き用コントローラーの最適化
  late final SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('2025年12月18日'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear), 
            onPressed: () => _controller.clear()
          ),
        ],
      ),
      body: Row(
        children: [
          // 左側：バーチカル時間軸
          Container(
            width: 80,
            decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade300))),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // スクロールによる遅延を防止
              itemCount: 17,
              itemBuilder: (context, index) {
                int hour = index + 6;
                return Container(
                  height: 60,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                  child: Text('$hour', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                );
              },
            ),
          ),

          // 右側：ToDo List & 手書きエリア
          Expanded(
            child: Stack(
              children: [
                // 下層：ToDoリストのガイド線
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('ToDo List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 15,
                        separatorBuilder: (context, index) => const Divider(height: 40),
                        itemBuilder: (context, index) => const SizedBox(height: 10),
                      ),
                    ),
                  ],
                ),
                // 上層：高感度設定のSignature
                Positioned.fill(
                  child: Signature(
                    controller: _controller,
                    backgroundColor: Colors.transparent,
                    // 以下のプロパティを調整して感度を最大化
                    dynamicPressureSupported: true, // Apple Pencilの圧力を受け取る
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}