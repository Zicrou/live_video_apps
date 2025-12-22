class Live {
  String? channelName;
  int? hostUserId;
  String? title;
  String? status;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? startedAt;
  String? endedAt;
  String? cdnPushUrl;
  int? viewersCount;
  String? liveToken;

  Live({
    this.id,
    this.channelName,
    this.hostUserId,
    this.title,
    this.status,
    this.startedAt,
    this.endedAt,
    this.cdnPushUrl,
    this.viewersCount,
    this.createdAt,
    this.updatedAt,
    this.liveToken,
  });

  factory Live.fromJson(Map<String, dynamic> json) {
    return Live(
      id: json['id'],
      channelName: json['channel_name'],
      hostUserId: json['host_user_id'],
      title: json['title'],
      status: json['status'],
      startedAt: json['started_at'],
      endedAt: json['ended_at'],
      cdnPushUrl: json['cdn_push_url'],
      viewersCount: json['viewers_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      liveToken: json['liveToken'], // 👈 note: NOT snake_case
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_name'] = this.channelName;
    data['host_user_id'] = this.hostUserId;
    data['title'] = this.title;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['liveToken'] = this.liveToken;
    return data;
  }

  @override
  String toString() {
    return " Id: ${id}, Channel Name: ${channelName}, Host User Id: ${hostUserId}, Title: ${title}, Status: ${status}, UpdatedAt: ${updatedAt}, CreatedAt: ${createdAt}, LiveToken: ${liveToken}";
  }
}
