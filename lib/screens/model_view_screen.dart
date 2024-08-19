import 'package:flutter/material.dart';
import '../model/model.dart';

class ModelViewScreen2 extends StatefulWidget {
  final String appBarTitle;
  final Model model;
  final List<Model> modelList;
  const ModelViewScreen2(
      {super.key,
        required this.appBarTitle,
        required this.model,
        required this.modelList});
  @override
  State<ModelViewScreen2> createState() => _ModelViewScreen2State();
}

class _ModelViewScreen2State extends State<ModelViewScreen2> {
  static final _priorities = ['定期健康診断', '人間ドック', '独自検査'];
  late Map<int, String> modelViews;
  @override
  void initState() {
    super.initState();
    modelViews = {
      99: _priorities[widget.model.priority],
      1: widget.model.height_1,
      2: widget.model.weight_2,
      3: widget.model.waist_3,
    };
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 99; i++) {
      if (modelViews[i] == '') {
        modelViews[i] = ' -- ';
      }
    }
    return Scaffold(
      appBar: AppBar(
        title:
        Text('${widget.appBarTitle} : ${widget.model.on_the_day_24} 実施分'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Text('検査種別: ${modelViews[99]!}'),
          Card(
            elevation: 0.0,
            child: Text(
              '身長: ${modelViews[1]!} cm',
              style: TextStyle(
                fontWeight: weightCheck(1),
              ),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                },
                child: Card(
                  elevation: 0.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '体重: ${modelViews[2]!} kg',
                        style: TextStyle(
                          fontWeight: weightCheck(2),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: Icon(Icons.auto_graph_sharp),
              ),
            ],
          ),
          Card(
            elevation: 0.0,
            child: Text(
              '腹囲: ${modelViews[3]!} cm',
              style: TextStyle(
                fontWeight: weightCheck(3),
              ),
            ),
          ),



        ]),
      ),
    );
  }

  FontWeight weightCheck(int inside) {
    return modelViews[inside] == ' -- ' ? FontWeight.normal : FontWeight.bold;
  }
}
