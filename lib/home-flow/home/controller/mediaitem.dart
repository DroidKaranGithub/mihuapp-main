class MediaItem {
  final String path;
  final bool isImage;
  final bool isVideo;
  final int id;

  MediaItem({required this.path, required this.isImage,required this.isVideo , required this.id});

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'],
      path: json['path'],
      isImage: json['isImage'],
      isVideo: json['isVideo'],
    );
  }
}
