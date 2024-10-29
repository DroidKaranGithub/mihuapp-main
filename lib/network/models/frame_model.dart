class FrameModel {
  String? name;
  String? path;
  Info? info;
  List<Layers>? layers;

  FrameModel({this.name, this.path, this.info, this.layers});

  FrameModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    if (json['layers'] != null) {
      layers = <Layers>[];
      json['layers'].forEach((v) {
        layers!.add(new Layers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['path'] = this.path;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    if (this.layers != null) {
      data['layers'] = this.layers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Info {
  String? description;
  String? file;
  String? date;
  String? title;
  String? author;
  String? keywords;
  String? generator;

  Info(
      {this.description,
        this.file,
        this.date,
        this.title,
        this.author,
        this.keywords,
        this.generator});

  Info.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    file = json['file'];
    date = json['date'];
    title = json['title'];
    author = json['author'];
    keywords = json['keywords'];
    generator = json['generator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['file'] = this.file;
    data['date'] = this.date;
    data['title'] = this.title;
    data['author'] = this.author;
    data['keywords'] = this.keywords;
    data['generator'] = this.generator;
    return data;
  }
}

class Layers {
  String? type;
  String? src;
  String? name;
  int? x;
  int? y;
  int? width;
  int? height;
  String? font;
  String? weight;
  String? justification;
  int? lineHeight;
  String? color;
  double? size;
  String? text;

  Layers(
      {this.type,
        this.src,
        this.name,
        this.x,
        this.y,
        this.width,
        this.height,
        this.font,
        this.weight,
        this.justification,
        this.lineHeight,
        this.color,
        this.size,
        this.text});

  Layers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    src = json['src'];
    name = json['name'];
    x = json['x'];
    y = json['y'];
    width = json['width'];
    height = json['height'];
    font = json['font'];
    weight = json['weight'];
    justification = json['justification'];
    lineHeight = json['lineHeight'];
    color = json['color'];
    size = double.tryParse(json['size'].toString());
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['src'] = this.src;
    data['name'] = this.name;
    data['x'] = this.x;
    data['y'] = this.y;
    data['width'] = this.width;
    data['height'] = this.height;
    data['font'] = this.font;
    data['weight'] = this.weight;
    data['justification'] = this.justification;
    data['lineHeight'] = this.lineHeight;
    data['color'] = this.color;
    data['size'] = this.size;
    data['text'] = this.text;
    return data;
  }
}
