import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<int> _numbers = [];
  final StreamController<List<int>> _streamController = StreamController();
  String _currentSortAlgo = 'bubble';
  double _sampleSize = 320;
  bool isSorted = false;
  bool isSorting = false;
  int speed = 0;
  static int duration = 1500;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Duration _getDuration() {
    return Duration(microseconds: duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sampleSize = MediaQuery.of(context).size.width / 2;
    for (int i = 0; i < _sampleSize; ++i) {
      _numbers.add(Random().nextInt(500));
    }
    setState(() {});
  }

  _bubbleSort() async {
    for (int i = 0; i < _numbers.length; ++i) {
      for (int j = 0; j < _numbers.length - i - 1; ++j) {
        if (_numbers[j] > _numbers[j + 1]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
        }

        await Future.delayed(_getDuration(), () {});

        _streamController.add(_numbers);
      }
    }
  }

  _recursiveBubbleSort(int n) async {
    if (n == 1) {
      return;
    }
    for (int i = 0; i < n - 1; i++) {
      if (_numbers[i] > _numbers[i + 1]) {
        int temp = _numbers[i];
        _numbers[i] = _numbers[i + 1];
        _numbers[i + 1] = temp;
      }
      await Future.delayed(_getDuration());
      _streamController.add(_numbers);
    }
    await _recursiveBubbleSort(n - 1);
  }

  _selectionSort() async {
    for (int i = 0; i < _numbers.length; i++) {
      for (int j = i + 1; j < _numbers.length; j++) {
        if (_numbers[i] > _numbers[j]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[i];
          _numbers[i] = temp;
        }

        await Future.delayed(_getDuration(), () {});

        _streamController.add(_numbers);
      }
    }
  }

  _heapSort() async {
    for (int i = _numbers.length ~/ 2; i >= 0; i--) {
      await heapify(_numbers, _numbers.length, i);
      _streamController.add(_numbers);
    }
    for (int i = _numbers.length - 1; i >= 0; i--) {
      int temp = _numbers[0];
      _numbers[0] = _numbers[i];
      _numbers[i] = temp;
      await heapify(_numbers, i, 0);
      _streamController.add(_numbers);
    }
  }

  heapify(List<int> arr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && arr[l] > arr[largest]) largest = l;

    if (r < n && arr[r] > arr[largest]) largest = r;

    if (largest != i) {
      int temp = _numbers[i];
      _numbers[i] = _numbers[largest];
      _numbers[largest] = temp;
      heapify(arr, n, largest);
    }
    await Future.delayed(_getDuration());
  }

  _insertionSort() async {
    for (int i = 1; i < _numbers.length; i++) {
      int temp = _numbers[i];
      int j = i - 1;
      while (j >= 0 && temp < _numbers[j]) {
        _numbers[j + 1] = _numbers[j];
        --j;
        await Future.delayed(_getDuration(), () {});

        _streamController.add(_numbers);
      }
      _numbers[j + 1] = temp;
      await Future.delayed(_getDuration(), () {});

      _streamController.add(_numbers);
    }
  }

  cf(int a, int b) {
    if (a < b) {
      return -1;
    } else if (a > b) {
      return 1;
    } else {
      return 0;
    }
  }

  _quickSort(int leftIndex, int rightIndex) async {
    Future<int> partition(int left, int right) async {
      int p = (left + (right - left) / 2).toInt();

      var temp = _numbers[p];
      _numbers[p] = _numbers[right];
      _numbers[right] = temp;
      await Future.delayed(_getDuration(), () {});

      _streamController.add(_numbers);

      int cursor = left;

      for (int i = left; i < right; i++) {
        if (cf(_numbers[i], _numbers[right]) <= 0) {
          var temp = _numbers[i];
          _numbers[i] = _numbers[cursor];
          _numbers[cursor] = temp;
          cursor++;

          await Future.delayed(_getDuration(), () {});

          _streamController.add(_numbers);
        }
      }

      temp = _numbers[right];
      _numbers[right] = _numbers[cursor];
      _numbers[cursor] = temp;

      await Future.delayed(_getDuration(), () {});

      _streamController.add(_numbers);

      return cursor;
    }

    if (leftIndex < rightIndex) {
      int p = await partition(leftIndex, rightIndex);

      await _quickSort(leftIndex, p - 1);

      await _quickSort(p + 1, rightIndex);
    }
  }

  // _mergeSort(int leftIndex, int rightIndex) async {
  //   Future<void> merge(int leftIndex, int middleIndex, int rightIndex) async {
  //     int leftSize = middleIndex - leftIndex + 1;
  //     int rightSize = rightIndex - middleIndex;
  //
  //     List leftList = List(leftSize);
  //     List rightList = List(rightSize);
  //
  //     for (int i = 0; i < leftSize; i++) leftList[i] = _numbers[leftIndex + i];
  //     for (int j = 0; j < rightSize; j++) rightList[j] = _numbers[middleIndex + j + 1];
  //
  //     int i = 0, j = 0;
  //     int k = leftIndex;
  //
  //     while (i < leftSize && j < rightSize) {
  //       if (leftList[i] <= rightList[j]) {
  //         _numbers[k] = leftList[i];
  //         i++;
  //       } else {
  //         _numbers[k] = rightList[j];
  //         j++;
  //       }
  //
  //       await Future.delayed(_getDuration(), () {});
  //       _streamController.add(_numbers);
  //
  //       k++;
  //     }
  //
  //     while (i < leftSize) {
  //       _numbers[k] = leftList[i];
  //       i++;
  //       k++;
  //
  //       await Future.delayed(_getDuration(), () {});
  //       _streamController.add(_numbers);
  //     }
  //
  //     while (j < rightSize) {
  //       _numbers[k] = rightList[j];
  //       j++;
  //       k++;
  //
  //       await Future.delayed(_getDuration(), () {});
  //       _streamController.add(_numbers);
  //     }
  //   }
  //
  //   if (leftIndex < rightIndex) {
  //     int middleIndex = (rightIndex + leftIndex) ~/ 2;
  //
  //     await _mergeSort(leftIndex, middleIndex);
  //     await _mergeSort(middleIndex + 1, rightIndex);
  //
  //     await Future.delayed(_getDuration(), () {});
  //
  //     _streamController.add(_numbers);
  //
  //     await merge(leftIndex, middleIndex, rightIndex);
  //   }
  // }

  _shellSort() async {
    for (int gap = _numbers.length ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < _numbers.length; i += 1) {
        int temp = _numbers[i];
        int j;
        for (j = i; j >= gap && _numbers[j - gap] > temp; j -= gap) {
          _numbers[j] = _numbers[j - gap];
        }
        _numbers[j] = temp;
        await Future.delayed(_getDuration());
        _streamController.add(_numbers);
      }
    }
  }

  int getNextGap(int gap) {
    gap = (gap * 10) ~/ 13;

    if (gap < 1) return 1;
    return gap;
  }

  _combSort() async {
    int gap = _numbers.length;

    bool swapped = true;

    while (gap != 1 || swapped == true) {
      gap = getNextGap(gap);

      swapped = false;

      for (int i = 0; i < _numbers.length - gap; i++) {
        if (_numbers[i] > _numbers[i + gap]) {
          int temp = _numbers[i];
          _numbers[i] = _numbers[i + gap];
          _numbers[i + gap] = temp;
          swapped = true;
        }
        await Future.delayed(_getDuration());
        _streamController.add(_numbers);
      }
    }
  }

  _pigeonHole() async {
    int min = _numbers[0];
    int max = _numbers[0];
    int range, i, j, index;
    for (int a = 0; a < _numbers.length; a++) {
      if (_numbers[a] > max) max = _numbers[a];
      if (_numbers[a] < min) min = _numbers[a];
    }
    range = max - min + 1;
    List<int> phole = List.generate(range, (i) => 0);

    for (i = 0; i < _numbers.length; i++) {
      phole[_numbers[i] - min]++;
    }

    index = 0;

    for (j = 0; j < range; j++) {
      while (phole[j]-- > 0) {
        _numbers[index++] = j + min;
        await Future.delayed(_getDuration());
        _streamController.add(_numbers);
      }
    }
  }

  _cycleSort() async {
    int writes = 0;
    for (int cycleStart = 0; cycleStart <= _numbers.length - 2; cycleStart++) {
      int item = _numbers[cycleStart];
      int pos = cycleStart;
      for (int i = cycleStart + 1; i < _numbers.length; i++) {
        if (_numbers[i] < item) pos++;
      }

      if (pos == cycleStart) {
        continue;
      }

      while (item == _numbers[pos]) {
        pos += 1;
      }

      if (pos != cycleStart) {
        int temp = item;
        item = _numbers[pos];
        _numbers[pos] = temp;
        writes++;
      }

      while (pos != cycleStart) {
        pos = cycleStart;
        for (int i = cycleStart + 1; i < _numbers.length; i++) {
          if (_numbers[i] < item) pos += 1;
        }

        while (item == _numbers[pos]) {
          pos += 1;
        }

        if (item != _numbers[pos]) {
          int temp = item;
          item = _numbers[pos];
          _numbers[pos] = temp;
          writes++;
        }
        await Future.delayed(_getDuration());
        _streamController.add(_numbers);
      }
    }
  }

  _cocktailSort() async {
    bool swapped = true;
    int start = 0;
    int end = _numbers.length;

    while (swapped == true) {
      swapped = false;
      for (int i = start; i < end - 1; ++i) {
        if (_numbers[i] > _numbers[i + 1]) {
          int temp = _numbers[i];
          _numbers[i] = _numbers[i + 1];
          _numbers[i + 1] = temp;
          swapped = true;
        }
        await Future.delayed(_getDuration());
        _streamController.add(_numbers);
      }
      if (swapped == false) break;
      swapped = false;
      end = end - 1;
      for (int i = end - 1; i >= start; i--) {
        if (_numbers[i] > _numbers[i + 1]) {
          int temp = _numbers[i];
          _numbers[i] = _numbers[i + 1];
          _numbers[i + 1] = temp;
          swapped = true;
        }
        await Future.delayed(_getDuration());
        _streamController.add(_numbers);
      }
      start = start + 1;
    }
  }

  _gnomeSort() async {
    int index = 0;

    while (index < _numbers.length) {
      if (index == 0) index++;
      if (_numbers[index] >= _numbers[index - 1]) {
        index++;
      } else {
        int temp = _numbers[index];
        _numbers[index] = _numbers[index - 1];
        _numbers[index - 1] = temp;

        index--;
      }
      await Future.delayed(_getDuration());
      _streamController.add(_numbers);
    }
    return;
  }

  _stoogesort(int l, int h) async {
    if (l >= h) return;

    if (_numbers[l] > _numbers[h]) {
      int temp = _numbers[l];
      _numbers[l] = _numbers[h];
      _numbers[h] = temp;
      await Future.delayed(_getDuration());
      _streamController.add(_numbers);
    }

    if (h - l + 1 > 2) {
      int t = (h - l + 1) ~/ 3;
      await _stoogesort(l, h - t);
      await _stoogesort(l + t, h);
      await _stoogesort(l, h - t);
    }
  }

  _oddEvenSort() async {
    bool isSorted = false;

    while (!isSorted) {
      isSorted = true;

      for (int i = 1; i <= _numbers.length - 2; i = i + 2) {
        if (_numbers[i] > _numbers[i + 1]) {
          int temp = _numbers[i];
          _numbers[i] = _numbers[i + 1];
          _numbers[i + 1] = temp;
          isSorted = false;
          await Future.delayed(_getDuration());
          _streamController.add(_numbers);
        }
      }

      for (int i = 0; i <= _numbers.length - 2; i = i + 2) {
        if (_numbers[i] > _numbers[i + 1]) {
          int temp = _numbers[i];
          _numbers[i] = _numbers[i + 1];
          _numbers[i + 1] = temp;
          isSorted = false;
          await Future.delayed(_getDuration());
          _streamController.add(_numbers);
        }
      }
    }

    return;
  }

  _reset() {
    isSorted = false;
    _numbers = [];
    for (int i = 0; i < _sampleSize; ++i) {
      _numbers.add(Random().nextInt(500));
    }
    _streamController.add(_numbers);
  }

  _setSortAlgo(String type) {
    setState(() {
      _currentSortAlgo = type;
    });
  }

  _checkAndResetIfSorted() async {
    if (isSorted) {
      _reset();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  String _getTitle() {
    switch (_currentSortAlgo) {
      case "bubble":
        return "Bubble Sort";
      case "coctail":
        return "Coctail Sort";
      case "pigeonhole":
        return "Pigeonhole Sort";
      case "recursivebubble":
        return "Recursive Bubble Sort";
      case "heap":
        return "Heap Sort";
      case "selection":
        return "Selection Sort";
      case "insertion":
        return "Insertion Sort";
      case "quick":
        return "Quick Sort";
      case "merge":
        return "Merge Sort";
      case "shell":
        return "Shell Sort";
      case "comb":
        return "Comb Sort";
      case "cycle":
        return "Cycle Sort";
      case "gnome":
        return "Gnome Sort";
      case "stooge":
        return "Stooge Sort";
      case "oddeven":
        return "Odd Even Sort";
      default:
        return "Bubble Sort";
    }
  }

  _changeSpeed() {
    if (speed >= 3) {
      speed = 0;
      duration = 1500;
    } else {
      speed++;
      duration = duration ~/ 2;
    }

    // ignore: avoid_print
    print("$speed $duration");
    setState(() {});
  }

  _sort() async {
    setState(() {
      isSorting = true;
    });

    await _checkAndResetIfSorted();

    Stopwatch stopwatch = Stopwatch()..start();

    switch (_currentSortAlgo) {
      case "comb":
        await _combSort();
        break;
      case "coctail":
        await _cocktailSort();
        break;
      case "bubble":
        await _bubbleSort();
        break;
      case "pigeonhole":
        await _pigeonHole();
        break;
      case "shell":
        await _shellSort();
        break;
      case "recursivebubble":
        await _recursiveBubbleSort(_sampleSize.toInt() - 1);
        break;
      case "selection":
        await _selectionSort();
        break;
      case "cycle":
        await _cycleSort();
        break;
      case "heap":
        await _heapSort();
        break;
      case "insertion":
        await _insertionSort();
        break;
      case "gnome":
        await _gnomeSort();
        break;
      case "oddeven":
        await _oddEvenSort();
        break;
      case "stooge":
        await _stoogesort(0, _sampleSize.toInt() - 1);
        break;
      case "quick":
        await _quickSort(0, _sampleSize.toInt() - 1);
        break;
      // case "merge":
      //   await _mergeSort(0, _sampleSize.toInt() - 1);
      //   break;
    }

    stopwatch.stop();

    // _scaffoldKey.currentState.removeCurrentSnackBar();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // _scaffoldKey.currentState.showSnackBar(
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Sorting completed in ${stopwatch.elapsed.inMilliseconds} ms.",
        ),
      ),
    );
    setState(() {
      isSorting = false;
      isSorted = true;
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: const Color(0xFF0E4D64),
        actions: <Widget>[
          PopupMenuButton<String>(
            initialValue: _currentSortAlgo,
            itemBuilder: (ctx) {
              return [
                const PopupMenuItem(
                  value: 'bubble',
                  child: Text("Bubble Sort"),
                ),
                const PopupMenuItem(
                  value: 'recursivebubble',
                  child: Text("Recursive Bubble Sort"),
                ),
                const PopupMenuItem(
                  value: 'heap',
                  child: Text("Heap Sort"),
                ),
                const PopupMenuItem(
                  value: 'selection',
                  child: Text("Selection Sort"),
                ),
                const PopupMenuItem(
                  value: 'insertion',
                  child: Text("Insertion Sort"),
                ),
                const PopupMenuItem(
                  value: 'quick',
                  child: Text("Quick Sort"),
                ),
                const PopupMenuItem(
                  value: 'merge',
                  child: Text("Merge Sort"),
                ),
                const PopupMenuItem(
                  value: 'shell',
                  child: Text("Shell Sort"),
                ),
                const PopupMenuItem(
                  value: 'comb',
                  child: Text("Comb Sort"),
                ),
                const PopupMenuItem(
                  value: 'pigeonhole',
                  child: Text("Pigeonhole Sort"),
                ),
                const PopupMenuItem(
                  value: 'cycle',
                  child: Text("Cycle Sort"),
                ),
                const PopupMenuItem(
                  value: 'coctail',
                  child: Text("Coctail Sort"),
                ),
                const PopupMenuItem(
                  value: 'gnome',
                  child: Text("Gnome Sort"),
                ),
                const PopupMenuItem(
                  value: 'stooge',
                  child: Text("Stooge Sort"),
                ),
                const PopupMenuItem(
                  value: 'oddeven',
                  child: Text("Odd Even Sort"),
                ),
              ];
            },
            onSelected: (String value) {
              _reset();
              _setSortAlgo(value);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 0.0),
          child: StreamBuilder<List<int>>(
              initialData: _numbers,
              stream: _streamController.stream,
              builder: (context, snapshot) {
                // int counter = 0;

                /// Optimization 1 : instead of number of widgets, there should be 1 widget only
                /// so only one CustomPainter instead of multiple

                return Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    child: CustomPaint(
                      willChange: true,
                      child: Container(
                        color: Colors.transparent,
                      ),
                      painter: BarPainter(
                        /// No need of index counter, we will use a for loop in painter class
                        // index: counter,
                        numbers: snapshot.data!,

                        /// we will not send the width of each bar, instead we will let
                        /// customPainter deduce the width of each bar using canvas size.width
                        // eachBarWidth: MediaQuery.of(context).size.width / _sampleSize),
                      ),
                    ));

                // return Row(
                //   children: numbers.map((int num) {
                //     counter++;
                //     return CustomPaint(
                //       painter: BarPainter(
                //           index: counter,
                //           value: num,
                //           width: MediaQuery.of(context).size.width / _sampleSize),
                //     );
                //   }).toList(),
                // );
              }),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
                child: OutlinedButton(
                    onPressed: isSorting
                        ? null
                        : () {
                            _reset();
                            _setSortAlgo(_currentSortAlgo);
                          },
                    child: const Text("RESET"))),
            Expanded(
                child:
                    OutlinedButton(onPressed: isSorting ? null : _sort, child: const Text("SORT"))),
            Expanded(
                child: OutlinedButton(
                    onPressed: isSorting ? null : _changeSpeed,
                    child: Text(
                      "${speed + 1}x",
                      style: const TextStyle(fontSize: 20),
                    ))),
          ],
        ),
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  // final double width;
  final List<int> numbers;
  // final int index;

  BarPainter({
    // required this.eachBarWidth,
    required this.numbers,
    // required this.index
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double canvasWidth = size.width;

    final double eachBarWidth = canvasWidth / numbers.length;

    Paint paint = Paint()..strokeCap = StrokeCap.round;

    for (int i = 0; i < numbers.length; i++) {
      if (numbers[i] < 500 * .10) {
        paint.color = const Color(0xFFDEEDCF);
      } else if (numbers[i] < 500 * .20) {
        paint.color = const Color(0xFFBFE1B0);
      } else if (numbers[i] < 500 * .30) {
        paint.color = const Color(0xFF99D492);
      } else if (numbers[i] < 500 * .40) {
        paint.color = const Color(0xFF74C67A);
      } else if (numbers[i] < 500 * .50) {
        paint.color = const Color(0xFF56B870);
      } else if (numbers[i] < 500 * .60) {
        paint.color = const Color(0xFF39A96B);
      } else if (numbers[i] < 500 * .70) {
        paint.color = const Color(0xFF1D9A6C);
      } else if (numbers[i] < 500 * .80) {
        paint.color = const Color(0xFF188977);
      } else if (numbers[i] < 500 * .90) {
        paint.color = const Color(0xFF137177);
      } else {
        paint.color = const Color(0xFF0E4D64);
      }

      // Method 1
      Vertices vertices = Vertices(
        VertexMode.triangles,
        [
          /// imagine a box
          /// p4--------p3
          /// |         |
          /// |         |
          /// |         |
          /// |         |
          /// p1--------p2

          /// p1 = starting offset
          /// x = each bar width * how away from the center (i)
          // Offset(i * eachBarWidth, 0),
          Offset(Multiplication().multiply(i.ceilToDouble(), eachBarWidth), 0),

          /// p2 = point 2, height remains same but width increases
          /// x = starting point offset + each Bar Width
          ///
          /// here decreasing the each bar width by dividing it so there can be some whitespace between bars
          ///
          // Offset((i * eachBarWidth) + (eachBarWidth / 1.2), 0),
          Offset(
              Multiplication().multiply(i.ceilToDouble(), eachBarWidth) + (eachBarWidth / 1.2), 0),

          /// p3 = point 3, width and height both changes
          /// width = height remains same but width increases
          // Offset((i * eachBarWidth) + (eachBarWidth / 1.2), numbers[i].ceilToDouble()),
          Offset(Multiplication().multiply(i.ceilToDouble(), eachBarWidth) + (eachBarWidth / 1.2),
              numbers[i].ceilToDouble()),

          /// p4 = ending offset
          // Offset(i * eachBarWidth, numbers[i].ceilToDouble()),
          Offset(
              Multiplication().multiply(i.ceilToDouble(), eachBarWidth), numbers[i].ceilToDouble()),
        ],
        indices: [0, 1, 2, 0, 2, 3],
      );

      canvas.drawVertices(vertices, BlendMode.color, paint);
    }

    /// Optimization 2 : we will use drawVertices instead of drawing lines
    // paint.strokeWidth = width;
    // canvas.drawLine(Offset(index * width, 0), Offset(index * width, value.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Multiplication {
  Map<double, double> cachedSolutions = {};

  // Memozation
  double multiply(double a, double b) {
    if (cachedSolutions.containsKey(a + b)) {
      print("contains");
      return cachedSolutions[a + b]!;
    } else {
      print("does not contain");
      cachedSolutions[a + b] = a * b;
      return cachedSolutions[a + b]!;
    }
  }
}
