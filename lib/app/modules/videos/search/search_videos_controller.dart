import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:live_video_apps/app/data/models/videos.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';

class SearchVideosController extends GetxController {
  var isLoading = false.obs;
  var results = [].obs;
  VideosRepositories _videosRepositories = VideosRepositories();
  RxList<String> captions = <String>[].obs;
  final TextEditingController searchTextController = TextEditingController();
  final GlobalKey<FormState> createSeachKeyForm = GlobalKey<FormState>();

  final Dio dio = Dio(
    BaseOptions(baseUrl: "http://127.0.0.1:8000/api"),
  );

  Future<void> search() async {
    if (createSeachKeyForm.currentState!.validate()) {
      createSeachKeyForm.currentState!.save();
      String query = searchTextController.text.trim();
      if (query.isEmpty) {
        results.clear();
        return;
      }

      try {
        isLoading(true);

        final response = await _videosRepositories.fetchSearchVideos(query);
        print("Response search controller: ${response}");
        results.assignAll([response]);
        print("Results from search controller : ${results}");
        // captions.value = results[0]
        //     .videos!
        //     .map<String>((v) => v.caption ?? "")
        //     .toSet() // remove duplicates
        //     .toList();
        // print("List of captions: ${captions}");
      } catch (e) {
        print("Search error: $e");
      } finally {
        isLoading(false);
      }
    }
  }
}
