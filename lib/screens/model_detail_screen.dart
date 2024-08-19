import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/model.dart';
import '../utils/database_helper.dart';

class ModelDetailScreen extends StatefulWidget {
  final String appBarTitle;
  final Model model;
  const ModelDetailScreen(
      {Key? key, required this.appBarTitle, required this.model})
      : super(key: key);
  @override
  State<ModelDetailScreen> createState() => _ModelDetailScreenState();
}

class _ModelDetailScreenState extends State<ModelDetailScreen> {
  static final _priorities = ['定期健康診断', '人間ドック', '独自検査'];
  DatabaseHelper helper = DatabaseHelper();
  dynamic dateNow;
  dynamic dateFormat;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController onTheDayController = TextEditingController();
  final waistController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateFormat = DateTime.now();
    dateNow = DateFormat("yyyy年MM月dd日").format(dateFormat);

    heightController.text = widget.model.height_1;
    weightController.text = widget.model.weight_2;
    waistController.text = widget.model.waist_3;
  }

  double _selectedValue = 1.0;
  final double _minValue = 1.0;
  final double _maxValue = 10.0;


  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        dropDownStringItem,
                        style: const TextStyle(
                          fontSize: 20.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                style: textStyle,
                value: getPriorityAsString(widget.model.priority),
                onChanged: (String? value) {
                  setState(() {
                    updatePriorityAsInt(value!);
                  });
                },
              ),
            ),
            // 24 Element　受診日
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: TextField(
                focusNode: AlwaysDisabledFocusNode(),
                controller: onTheDayController,
                style: textStyle,
                textAlign: TextAlign.right,
                onTap: () {
                  _selectDate(context);
                  debugPrint('オンタップでカレンダーが表示されているはず');
                  //onTheDayController.text = dateNow;
                },
                onChanged: (value) {
                  setState(() {
                    onTheDayController.text = dateNow;
                  });
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: '受診日',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
            ),
            // Second Element　身長入力--------------------------
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                controller: heightController,
                style: textStyle,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateHeight();
                },
                decoration: InputDecoration(
                    labelText: '身長',
                    labelStyle: textStyle,
                    suffix: const Text(' cm'),
                    icon: const Icon(Icons.accessibility),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                controller: weightController,
                style: textStyle,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateWeight();
                },
                decoration: InputDecoration(
                    labelText: '体重',
                    labelStyle: textStyle,
                    suffix: const Text(' kg'),
                    icon: const Icon(Icons.accessibility),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            // Third Element　体重入力
            Padding(
              padding: const EdgeInsets.only(top: 2.5, bottom: 10.0),
              child: TextField(
                controller: waistController,
                style: textStyle,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                //onTap:() => _showDialog() ,
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                  updateWaist();
                },
                decoration: InputDecoration(
                    labelText: '腹囲',
                    labelStyle: textStyle,
                    suffix: const Text(' cm'),
                    icon: const Icon(Icons.accessibility),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  textStyle: const TextStyle(color: Colors.red)),
              child: const Text(
                'Delete',
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                setState(() {
                  debugPrint("Delete button clicked");
                  _delete();
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (widget.model.on_the_day_24 == null || widget.model.on_the_day_24!.isEmpty) {
              _showAlertDialog('警告', '受診日入力は必須です。');
              //moveToLastScreen();
            } else {
              _save();
            }});
        },
        tooltip: 'save',
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.save),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case '定期健康診断':
        widget.model.priority = 1;
        break;
      case '人間ドック':
        widget.model.priority = 2;
        break;
      case '独自検査':
        widget.model.priority = 3;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority = "";
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
      case 3:
        priority = _priorities[2];
    }
    return priority;
  }

  void updateHeight() {
    widget.model.height_1 = heightController.text;
  }

  void updateWeight() {
    widget.model.weight_2 = weightController.text;
  }

  void updateWaist(){
    widget.model.waist_3 = waistController.text;
  }

  void updateOTD() {
    widget.model.on_the_day_24 = onTheDayController.text;
    if (kDebugMode) {
      print('${onTheDayController.text}アップデートメソッドの中のテキスト');
    }
    if (kDebugMode) {
      print(widget.model.on_the_day_24);
    }
  }


  Future<void> _showDialog() async {
    double? selectedValue = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return NumberSelectDialog(
          selectedValue: _selectedValue,
          minValue: _minValue,
          maxValue: _maxValue,
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        _selectedValue = selectedValue;
      });
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        locale: const Locale("ja"),
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime.now().add(const Duration(days: 720)));
    if (selected != null) {
      setState(
            () => dateNow = DateFormat("yyyy年MM月dd日").format(selected).toString(),
      );
      debugPrint('$dateNow');
      //note.on_the_day = onTheDayController.text;
      onTheDayController.text = dateNow;
      updateOTD();
    }
  }

  void _save() async {
    moveToLastScreen();

    widget.model.date = DateFormat.yMMMd().format(DateTime.now());
    debugPrint(widget.model.on_the_day_24);
    int result;
    if (widget.model.id != null) {
      result = await helper.updateModel(widget.model);
    } else {
      result = await helper.insertModel(widget.model);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('状況', '保存完了！！');
    } else {
      // Failure
      _showAlertDialog('状況', '問題発生・保存されませんでした');
    }
  }

  void _delete() async {
    moveToLastScreen();
    if (widget.model.id == null) {
      _showAlertDialog('状況', '削除データなし');
      return;
    }
    int result = await helper.deleteModel(widget.model.id!);
    if (result != 0) {
      _showAlertDialog('状況', 'データ削除完了');
    } else {
      _showAlertDialog('状況', '問題発生・データ削除不可');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }


}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class NumberSelectDialog extends StatefulWidget {
  final double selectedValue;
  final double minValue;
  final double maxValue;

  const NumberSelectDialog({super.key,  required this.selectedValue, required this.minValue, required this.maxValue});

  @override
  _NumberSelectDialogState createState() => _NumberSelectDialogState();
}
class _NumberSelectDialogState extends State<NumberSelectDialog> {
  late double _selectedValue;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:const Text('Select a number'),
      content: SingleChildScrollView(
        child: ListBody(
          children: List<Widget>.generate(
            ((widget.maxValue - widget.minValue) * 10).toInt(),
                (index) {
              double value = widget.minValue + (index / 10);
              return RadioListTile<double>(
                value: value,
                groupValue: _selectedValue,
                title: Text(value.toStringAsFixed(1)),
                onChanged: (double? value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              );
            },
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child:const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child:const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_selectedValue);
          },
        ),
      ],
    );
  }
}