import 'package:get/get.dart';

class VideoActionsState {
  final RxInt id;
  final RxBool isLiked;
  final RxBool isSaved;
  final RxInt likeCount;
  final RxInt commentCount;
  final RxString url;

  VideoActionsState({
    required int id,
    required bool isLiked,
    required bool isSaved,
    required int likeCount,
    required int commentCount,
    required String url,
  }) : id = id.obs,
       isLiked = isLiked.obs,
       isSaved = isSaved.obs,
       likeCount = likeCount.obs,
       commentCount = commentCount.obs,
       url = url.obs;

  /// ✅ JSON constructor
  factory VideoActionsState.fromJson(Map<String, dynamic> json) {
    return VideoActionsState(
      id: json['id'],
      isLiked: json['isLiked'] ?? false,
      isSaved: json['isSaved'] ?? false,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      url: json['url'],
    );
  }

  @override
  String toString() {
    return 'VideoActionsState{id: $id, isLiked: $isLiked, isSaved: $isSaved, likeCount: $likeCount, commentCount: $commentCount, url: $url}';
  }
}
