import 'dart:convert';

class Model {
  List<Item> item;

  Model({required this.item});

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      item: (json['item'] as List).map((i) => Item.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item.map((i) => i.toJson()).toList(),
    };
  }
}

class Item {
  String name;
  Request request;
  List<dynamic> response;

  Item({required this.name, required this.request, required this.response});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      request: Request.fromJson(json['request']),
      response: json['response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'request': request.toJson(),
      'response': response,
    };
  }
}

class Request {
  String method;
  List<dynamic> header;
  Url url;

  Request({required this.method, required this.header, required this.url});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      method: json['method'],
      header: json['header'],
      url: Url.fromJson(json['url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'header': header,
      'url': url.toJson(),
    };
  }
}

class Url {
  String raw;
  String protocol;
  List<String> host;
  List<String> path;

  Url({
    required this.raw,
    required this.protocol,
    required this.host,
    required this.path,
  });

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      raw: json['raw'],
      protocol: json['protocol'],
      host: List<String>.from(json['host']),
      path: List<String>.from(json['path']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raw': raw,
      'protocol': protocol,
      'host': host,
      'path': path,
    };
  }
}
