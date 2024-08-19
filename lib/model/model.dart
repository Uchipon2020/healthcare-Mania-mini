
//定義クラス。同時に、アプリケーション稼働時にデータが補完させる場所。
//アプリを再度使う場合には、また初期化処理を入れておかないと、表記の保証ができない。
class Model {
  int? _id;
  String? _date; //更新日
  int? _priority; //定期・ドッグフラグ
  String? _1_height; //身長 *
  bool isHeightRedFlag = false;
  static const double MAX_HEIGHT = 200.0;
  static const double MIN_HEIGHT = 100.0;
  String? _2_weight; //体重 *
  String? _3_waist; //腹囲 *
  String? _on_the_day_24;//検査日

  Model(
      this._priority, [
        this._1_height = "",
        this._2_weight = "",
        this._3_waist = "",
        this._on_the_day_24 = "",

      ]);

  Model.withId(
      this._id,
      this._date,
      this._priority, [
        this._1_height,
        this._2_weight,
        this._3_waist,
        this._on_the_day_24,

      ]);

  int? get id => _id;
  String get height_1 => _1_height!;
  String get weight_2 => _2_weight!;
  String get waist_3 => _3_waist!;
  String get on_the_day_24 => _on_the_day_24!;
  String get date => _date!;
  int get priority => _priority!;

  /////setter aria
  set height_1(String newHeight) {
    try {
      double heightValue = double.parse(newHeight);
      if (heightValue >= MIN_HEIGHT && heightValue <= MAX_HEIGHT) {
        _1_height = newHeight;
        isHeightRedFlag = false; //ノーマル
      } else {
        _1_height = newHeight;
        isHeightRedFlag = true; //赤色フラグ
      }
    }catch (e) {
      print('Error; $e');
    }

  }
  set weight_2(String newWeight) {
    if (newWeight.length <= 255) {
      _2_weight = newWeight;
    }
  }
  set waist_3(String newWaist) {
    if (newWaist.length <= 255) {
      _3_waist = newWaist;
    }
  }


  set date(String value) {
    _date = value;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 3) {
      _priority = newPriority;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['height'] = _1_height;
    map['weight'] = _2_weight;
    map['waist'] = _3_waist;
    map['date'] = _date;
    map['priority'] = _priority;
    map['onTheDay'] = _on_the_day_24;
    return map;
  }

  Model.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _1_height = map['height'];
    _2_weight = map['weight'];
    _3_waist = map['waist'];
    _priority = map['priority'];
    _on_the_day_24 = map['onTheDay'];
    _date = map['date'];
}

  set on_the_day_24(String value) {
    _on_the_day_24 = value;
  }
}