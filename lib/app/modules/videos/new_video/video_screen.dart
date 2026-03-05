import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_video_apps/app/modules/videos/new_video/video_controller.dart';
import 'package:live_video_apps/app/modules/videos/videos/videos_screen.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

final logger = Logger();

// ignore: must_be_immutable
class VideoScreen extends StatelessWidget {
  final VideoController controller = Get.put(VideoController());
  // final Produit produit = Get.arguments ?? Produit();

  var stl = ''.obs;

  var title = "Nouveau Post";
  // Pick a video from gallery

  @override
  Widget build(BuildContext context) {
    // if (controller.produit.id != null && controller.produit is Produit) {
    //   title = "Modifier Produit";
    //   controller.designation.text = controller.produit.designation!;
    //   controller.montant.text = controller.produit.montant.toString();
    //   controller.nombre.text = controller.produit.nombre.toString();
    //   controller.selectedImage.value = controller.produit.image != null
    //       ? File(controller.produit.image!) // ✅ convert path → File
    //       : null;
    //   // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    //   // if (produit.image != null) {
    //   //   selectedImage = File(pickedFile.path); // ✅ convert path → File
    //   // }
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'avenir',
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 0, 173, 253),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.createVideoKeyForm,
            // controller.videos.id != null
            //     ? controller.updateProduitKeyForm
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Video",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 173, 253),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                Obx(() {
                  if (!controller.isVideoInitialized.value) {
                    return const Center(child: Text("Pick a video"));
                  }
                  return VisibilityDetector(
                    key: Key("video-1"),
                    onVisibilityChanged: (info) {
                      // if (info.visibleFraction > 0.6) {
                      controller.videoPlayerController!.play();
                      // } else {
                      //   controller.pause();
                      // }
                    },
                    child: Stack(
                      children: [
                        /// 🎥 VIDEO
                        SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              // width: controller.videoPlayerController!.,
                              // height: controller.videoPlayerController.size.height,
                              child: VideoPlayer(
                                controller.videoPlayerController!,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),
                // Obx(() {
                // final image = controller.selectedImage.value;
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.pickImageFromGallery,
                      icon: const Icon(Icons.photo),
                      label: const Text("Gallery"),
                    ),
                    // ElevatedButton.icon(
                    //   onPressed: controller.pickImageFromCamera,
                    //   icon: const Icon(Icons.camera_alt),
                    //   label: const Text("Camera"),
                    // ),
                    IconButton(
                      onPressed: () {
                        controller.clearImage();
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
                // }),
                SizedBox(height: 20),
                TextFormField(
                  controller: controller.caption,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.label,
                      color: Color.fromARGB(255, 0, 173, 253),
                    ),

                    labelText: "Caption",
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 173, 253),
                    ),
                    // errorText: controller.isDesignationValid.value
                    //     ? null
                    //     : "Désignation invalide",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: controller.video_url,

                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.video_file,
                      color: Color.fromARGB(255, 0, 173, 253),
                    ),
                    labelText: "Video Url",
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 173, 253),
                    ),
                    // errorText: controller.isPrixValid.value
                    //     ? null
                    //     : "Prix invalide",
                    filled: true,

                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20),

                // TextFormField(
                //   controller: controller.nombre,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Svp veuillez remplir le champs";
                //     }
                //     if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                //       return 'Nombre uniquement';
                //     }
                //     if (int.parse(value) < 0) {
                //       return "Le nombre n'est pas valide";
                //     }
                //     return null;
                //   },
                //   decoration: InputDecoration(
                //     prefixIcon: Icon(
                //       Icons.numbers,
                //       color: Color.fromARGB(255, 0, 173, 253),
                //     ),
                //     labelText: "Nombre",
                //     labelStyle: TextStyle(
                //       color: Color.fromARGB(255, 0, 173, 253),
                //     ),
                //     // errorText: controller.isNombreValid.value
                //     //     ? null
                //     //     : "Nombre invalide",
                //     filled: true,
                //     fillColor: Colors.white,
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //       borderSide: BorderSide.none,
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //       borderSide: BorderSide.none,
                //     ),
                //   ),
                //   keyboardType: TextInputType.number,
                // ),
                SizedBox(height: 20),
                // (controller.produit.id != null && controller.produit is Produit)
                // ? ElevatedButton(
                //     onPressed: () => {
                //       controller.updateProduit(
                //         controller.produit,
                //       ), // Update the vente
                //     }, //  controller.updateVente(vente),
                //     child: Text(
                //       "Modifier le produit",
                //       style: TextStyle(fontSize: 18),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Color.fromARGB(255, 0, 173, 253),
                //       foregroundColor: Colors.white,
                //       padding: EdgeInsets.symmetric(vertical: 16),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //   )
                // :
                ElevatedButton(
                  onPressed: () => {
                    controller.createVideo(), //createProduit(),
                  }, //  controller.createVente(),
                  child: Text("Créer Post", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 173, 253),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.offAll(() => VideosScreen()),
                  child: Text(
                    "Retour",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 173, 253),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
