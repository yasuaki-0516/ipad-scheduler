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
  // 手書き用コントローラー
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

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
          IconButton(icon: const Icon(Icons.clear), onPressed: () => _controller.clear()), // 手書き消去
        ],
      ),
      body: Row(
        children: [
          // --- 左側：バーチカル時間軸 (PDFの構成を再現) ---
          Container(
            width: 80,
            decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade300))),
            child: ListView.builder(
              itemCount: 17, // 6時から22時まで
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

          // --- 右側：ToDo List & 手書きエリア ---
          Expanded(
            child: Stack(
              children: [
                // 下層：ToDoリストの項目（PDF風）
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('ToDo List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 15,
                        separatorBuilder: (context, index) => const Divider(height: 40),
                        itemBuilder: (context, index) => const SizedBox(height: 10),
                      ),
                    ),
                  ],
                ),
                // 上層：手書きキャンバス（全体を覆う）
                Signature(
                  controller: _controller,
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}