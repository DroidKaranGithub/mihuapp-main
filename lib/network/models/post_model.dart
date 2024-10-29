class PostModel {
  int? id;
  String? title;
  String? thumbUrl;
  String? frameUrl;
  String? itemUrl;
  String? slug;
  String? type;
  String? json;
  String? language;
  int? categoryId;
  int? subCategoryId;
  int? sectionId;
  String? orientation;
  int? height;
  int? width;
  int? views;
  int? status;
  int? premium;
  String? updatedAt;
  String? createdAt;
  String? userType;

  PostModel(
      {this.id,
        this.title,
        this.thumbUrl,
        this.frameUrl,
        this.itemUrl,
        this.slug,
        this.type,
        this.json,
        this.language,
        this.categoryId,
        this.subCategoryId,
        this.sectionId,
        this.orientation,
        this.height,
        this.width,
        this.views,
        this.status,
        this.premium,
        this.updatedAt,
        this.createdAt,
        this.userType});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbUrl = json['thumb_url'];
    frameUrl = json['frame_url'];
    itemUrl = json['item_url'];
    slug = json['slug'];
    type = json['type'];
    json = json['json'];
    language = json['language'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    sectionId = json['section_id'];
    orientation = json['orientation'];
    height = json['height'];
    width = json['width'];
    views = json['views'];
    status = json['status'];
    premium = json['premium'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumb_url'] = this.thumbUrl;
    data['frame_url'] = this.frameUrl;
    data['item_url'] = this.itemUrl;
    data['slug'] = this.slug;
    data['type'] = this.type;
    data['json'] = this.json;
    data['language'] = this.language;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['section_id'] = this.sectionId;
    data['orientation'] = this.orientation;
    data['height'] = this.height;
    data['width'] = this.width;
    data['views'] = this.views;
    data['status'] = this.status;
    data['premium'] = this.premium;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['user_type'] = this.userType;
    return data;
  }
}
