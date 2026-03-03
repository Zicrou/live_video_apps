// import 'package:get/get.dart';
// import 'package:live_video_apps/app/data/providers/auth_providers.dart';
// import 'package:logger/logger.dart';

// final logger = Logger();

// class VideosService extends GetxService {
//   final _authProvider = Get.find<AuthProvider>();
  

//   @override
//   void onInit() {
//     logger.w(
//       "Is AuthRepositories registered? ${Get.isRegistered<AuthRepositories>()}",
//     );
//     _venteServices;
//     super.onInit();
//   }

//   Future<VenteInfo> getAllVentes() async {
//     try {
//       // final response = await _dio.get('http://10.0.2.2:8000/api/V1/ventes');
//       return await _venteServices.listVentes();
//     } catch (e) {
//       throw Exception("Error fetching ventes: $e");
//     }
//   }

//   createVente(Map<String, dynamic> json) async {
//     //return await _venteServices.createVente();
//   }

//   // ListVentes() async {
//   //   logger.i('AuthService: Fetching list of ventes');
//   //   return await _authRepository.listVentes();
//   // }
// }
