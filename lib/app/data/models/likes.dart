class Likes {
  String? userId;
  String? videoId;
  // int? likecount;
  Likes({this.userId, this.videoId});

  Likes.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    videoId = json['video_id'];
    // likecount = json['likescount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['video_id'] = this.videoId;
    return data;
  }

  @override
  String toString() {
    return "User: $userId, Video: $videoId";
  }
}
