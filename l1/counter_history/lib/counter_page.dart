import 'package:material_ui/material_ui.dart';

import 'history_item.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  final List<HistoryItem> _history = [];

  // щоб після нової дії список історії прокручувався наверх
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // додаємо запис на початок списку, зберігаємо тільки 10 останніх
  void _addToHistory(String action) {
    _history.insert(
      0,
      HistoryItem(action: action, value: _counter, time: DateTime.now()),
    );
    if (_history.length > 10) {
      _history.removeLast();
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _increment() {
    setState(() {
      _counter++;
      _addToHistory('+1');
    });
    _scrollToTop();
  }

  void _decrement() {
    // від'ємних значень бути не може
    if (_counter == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Лічильник не може бути менше нуля!')),
      );
      return;
    }
    setState(() {
      _counter--;
      _addToHistory('-1');
    });
    _scrollToTop();
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _addToHistory('Скинуто');
    });
    _scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    // кратне 10 -> підсвічуємо зеленим (0 не рахується)
    bool isTen = _counter != 0 && _counter % 10 == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Лічильник з історією'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text('Поточне значення:', style: TextStyle(fontSize: 18)),
          Text(
            '$_counter',
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: isTen ? Colors.green : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _decrement, child: const Text('-')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _reset, child: const Text('Скинути')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _increment, child: const Text('+')),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Історія (останні 10 дій):',
            style: TextStyle(fontSize: 16),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _history.length,
              itemBuilder: (context, index) {
                HistoryItem item = _history[index];
                return ListTile(
                  leading: Text('${index + 1}.'),
                  title: Text('${item.action}   (значення: ${item.value})'),
                  subtitle: Text(item.timeText()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
