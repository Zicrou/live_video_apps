import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/data/models/Videos.dart';
import 'package:live_video_apps/app/data/models/videoActionState.dart';
import 'package:live_video_apps/app/data/models/videosInfo.dart';
import 'package:live_video_apps/app/data/providers/auth_providers.dart';
import 'package:live_video_apps/app/data/repositories/videos_repositories.dart';
import 'package:live_video_apps/app/data/services/remote_services.dart';
import 'package:live_video_apps/app/modules/auths/auth_controller.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_preview_screen.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_screen.dart';
import 'package:live_video_apps/app/utils/messages.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

Logger logger = Logger();

class VideoController extends GetxController {
  var isLoading = true.obs;
  VideosRepositories _videosRepositories = VideosRepositories();
  final authProvider = Get.find<AuthProvider>();
  final authControler = Get.find<AuthController>();

  final RemoteServices remoteService = Get.find<RemoteServices>();
  final GlobalKey<FormState> createVideoKeyForm = GlobalKey<FormState>();
  final GlobalKey<FormState> updateVideoKeyForm = GlobalKey<FormState>();
  RxList<Videos> videos = <Videos>[].obs;

  final ImagePicker _picker = ImagePicker();

  Rxn<File> selected_video = Rxn<File>();

  final caption = TextEditingController();
  final video_url = TextEditingController();
  var user_id;
  VideoPlayerController? videoPlayerController;
  RxBool isVideoInitialized = false.obs;

  VideoPlayerController? previewController;
  Rx<File?> selectedVideo = Rx<File?>(null);
  RxBool previewInitialized = false.obs;

  // final nombre = TextEditingController();
  // Add your login logic here

  // void initVideo(RxInt videoId) {
  //   videoStates[videoId] ??= VideoActionsState(
  //     id: videoId,
  //     isLiked: false.obs,
  //     isSaved: false.obs,
  //     likeCount: 0.obs,
  //     commentCount: 0.obs,
  //     url: ''.obs,
  //   );
  // }

  ProduitController() {
    final authProvider = Get.find<AuthProvider>();
    user_id = authProvider.user?.user?.id;
  }

  Future<void> createVideo() async {
    isLoading(true);
    try {
      //Retreive the parameter from video Screen then submit it to video_repositories after a preview of that video
      // var video = Videos();
      // video.id = produitFromForm.id; // Assuming produit has an id field

      var json = {
        "post_type": "video",
        "caption": caption.text.trim(),
        "video_url": video_url.text.trim(),
        // "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      };
      print(
          "Json: ${json["post_type"]}, caption: ${json["caption"]}, video url: ${json["video_url"]}}");

      final response = await _videosRepositories.createVideos(json);
      Get.offAll(VideosScreen());
    } catch (e) {
      print("Erreur: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // produit = Get.arguments ?? Produit();
    // video_url.value = Get.arguments.videoFile.path;
    // print("Video url on Init ${video_url}");
    super.onInit();
    //getTypes();
    // Initialize any necessary data or state here
  }

  @override
  void onClose() {
    caption.dispose();
    video_url.dispose();
    videoPlayerController?.dispose();
    super.onClose();
  }

  // @override
  // void dispose() {
  //   designation.dispose();
  //   montant.dispose();
  //   nombre.dispose();
  //   super.dispose();
  // }
  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selected_video.value = File(pickedFile.path);
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selected_video.value = File(pickedFile.path);
    }
  }

  // Future<void> pickVideo() async {
  //   final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
  //   // picked = ''
  //   if (picked == null) return;

  //   final controller = VideoPlayerController.networkUrl(Uri.parse(picked.path));
  //   logger.i('Picked video path: ${picked.path}');
  //   selected_video.value = File(picked.path);
  //   await controller.initialize();
  //   controller.setLooping(true);
  //   controller.play();

  //   isVideoInitialized.value = true;

  //   update(); // if using GetX
  // }

  //   Future<void> pickVideo() async {
  //   final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
  //   if (picked == null) return;

  //   final file = File(picked.path);

  //   logger.i('Picked video path: ${picked.path}');

  //   selectedVideo.value = file;

  //   previewController?.dispose();

  //   previewController = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'));

  //   await previewController!.initialize();

  //   previewController!.setLooping(true);
  //   previewController!.play();

  //   previewInitialized.value = true;
  // }

  //   Future<void> previewFromUrl(String url) async {
  //     previewController?.dispose();

  //     previewController = VideoPlayerController.networkUrl(Uri.parse(url));

  //     await previewController!.initialize();

  //     previewController!.play();

  //     update();
  //   }

  /// Convert selected image to Base64
  Future<String?> getImageBase64() async {
    if (selected_video.value == null) return null;
    final bytes = await selected_video.value!.readAsBytes();
    return base64Encode(bytes);
  }

  // Optional: clear the image
  void clearImage() {
    logger.i("Clearing image");
    if (selected_video.value.obs != null) {
      selected_video.value = null;
      // produit.image = null;
    }
    selected_video.value = null;
  }

  void createProduitWithImage() async {
    if (createVideoKeyForm.currentState!.validate()) {
      createVideoKeyForm.currentState!.save();

      // logger.w(
      //   "Creating Produits from form: Designation: ${designation.text.trim()}, Montant: ${montant.text.trim()}, Nombre: ${nombre.text.trim()}, User_id: ${user_id}",
      // );
      logger.i("User_id : ${user_id}");
      final image = await selected_video.value;
      try {
        isLoading(true);
        // Build JSON payload
        // final response = await produitsRepositories.createProduitWithImage(
        //   designation.text.trim(),
        //   int.parse(montant.text.trim()),
        //   int.parse(nombre.text.trim()),
        //   image!,
        // );

        // if (response != null) {
        //   goodMessage("Produit créé avec succès ✅");
        //   clearImage();

        //   await ProduitsController().fetchProduits();

        //   Future.delayed(const Duration(seconds: 2), () {
        //     Get.offAll(ProduitsScreen());
        //   });
        // } else {
        //   errorMessage("Erreur, échec de l’envoi (aucune réponse)");
        // }
      } catch (e) {
        errorMessage("Erreur: ${e.toString()}");
        print("error creating produit: $e.toString()");
      } finally {
        isLoading(false);
      }
    }
  }

  // void createProduit() async {
  //   if (createProduitKeyForm.currentState!.validate()) {
  //     createProduitKeyForm.currentState!.save();

  //     logger.w(
  //       "Creating Produits from form: Designation: ${designation.text.trim()}, Montant: ${montant.text.trim()}, Nombre: ${nombre.text.trim()}, User_id: ${user_id}",
  //     );
  //     logger.i("User_id : ${user_id}");
  //     isLoading(true);
  //     final imageBase64 = await getImageBase64();
  //     try {
  //       // Build JSON payload
  //       final payload = {
  //         'designation': designation.text.trim(),
  //         'montant': int.parse(montant.text.trim()),
  //         'nombre': int.parse(nombre.text.trim()),
  //         'user_id': user_id,
  //         'image': imageBase64,
  //       };
  //       logger.i("Payload: ${payload}");
  //       // 📨 Send request through your repository
  //       // Send JSON via your API provider
  //       //final response = await produitsRepositories.createProduitWithBase64(payload)
  //       await remoteService.createProduitWithBase64(payload);
  //       // if (response != null) {
  //       //   goodMessage("Produit créé avec succès ✅");
  //       //   clearImage();

  //       //   await ProduitsController().fetchProduits();

  //       //   Future.delayed(const Duration(seconds: 2), () {
  //       //     Get.offAll(ProduitsScreen());
  //       //   });
  //       // } else {
  //       //   errorMessage("Erreur, échec de l’envoi (aucune réponse)");
  //       // }
  //     } catch (e) {
  //       errorMessage("Erreur: ${e.toString()}");
  //       print("error creating produit: $e.toString()");
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  // }

  Future<Videos> getProduit(int id) async {
    try {
      // var res = await produitsRepositories.getProduit(id);

      // logger.w("Res: ${res}");

      // if (res == null) {
      //   errorMessage("Erreur");
      // }
      // return res;
      return Videos();
    } catch (e) {
      throw "Erreur: ${e}";
    } finally {
      isLoading(false);
    }
  }

  void updateProduit(produitFromForm) async {
    // Implement the logic to create a vente
    // You can access the controllers like this:
    if (updateVideoKeyForm.currentState!.validate()) {
      updateVideoKeyForm.currentState!.save();

      try {
        // var produit = Produit();
        // produit.id = produitFromForm.id; // Assuming produit has an id field
        // produit.designation = designation.text.trim();
        // produit.montant = int.parse(montant.text.trim());
        // produit.nombre = int.parse(nombre.text.trim());
        // produit.userId = user_id ?? produitFromForm.userId;

        // logger.i(
        //   "UPdating produit avec Selection with: Id ${produit.id}, ${produit.designation}, ${produit.montant}, ${produit.userId}, ${produit.nombre}}",
        // );

        logger.i("Produit From form: ${produitFromForm}");
        // var res = produitsRepositories.updateProduit(
        //   produitFromForm.id,
        //   produit.toJson(),
        // );
        // var designationV = designation.text.trim();
        // var montantV = int.parse(montant.text.trim());
        // var nombreV = int.parse(nombre.text.trim());
        // var res = await remoteService.updateProduits(
        //   designationV,
        //   montantV,
        //   nombreV,
        //   produitFromForm.id,
        // );
        // logger.i("Res: ${res}");

        // if (res != null) {
        //   goodMessage("Produit modifié avec succés");
        //   await ProduitsController().fetchProduits();
        //   Get.offAll(ProduitsScreen());
        // Future.delayed(Duration(seconds: 1), () {});
        // } else {
        //   errorMessage("Erreur");
        // }
      } catch (e) {
        throw "Erreur: ${e}";
      } finally {
        isLoading(false);
      }
    }
  }

  // Future<void> pickVideo() async {
  //   final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
  //   if (picked == null) return;

  //   final file = File(picked.path);

  //   logger.i('Picked video path: ${picked.path}');

  //   selected_video.value = file;

  //   Get.to(() => VideoPreviewScreen(videoFile: file));
  // }
  Future<void> pickVideo() async {
    // final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
    // if (picked == null) return;

    // final file = File(picked.path);

    // logger.i('Picked video path: ${picked.path}');

    // selectedVideo.value = file;

    // previewController?.dispose();

    // previewController = VideoPlayerController.networkUrl(
    //   Uri.parse(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   ),
    // );

    // await previewController!.initialize();

    // previewController!.setLooping(true);
    // previewController!.play();

    // previewInitialized.value = true;

    // final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
    // if (picked == null) return;

    final file = File(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );

    logger.i('Picked video path: ${file.path}');

    selectedVideo.value = file;
    video_url.text = file.path;
    print('Video url controller: ${video_url}');
    Get.to(() => VideoPreviewScreen(videoFile: file));
  }
}
