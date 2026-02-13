// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide MultipartFile, FormData;
// import 'package:live_video_apps/app/data/models/user_register.dart';
// import 'package:live_video_apps/app/data/providers/auth_providers.dart';
// import 'package:logger/logger.dart';

// final logger = Logger();

// class RemoteServices {
//   final AuthProvider authProvider = Get.find<AuthProvider>();

//   static final Dio _dio = Dio();

//   // Future<Produit> createProduit(String libelle, int montant, int nombre) async {
//   //   final userId = authProvider.user.user?.id;
//   //   logger.w(userId);
//   //   if (userId == null) {
//   //     throw Exception("User ID is null — user is not logged in.");
//   //   }
//   //   var body = {
//   //     "designation": libelle,
//   //     "montant": montant,
//   //     "user_id": userId,
//   //     'nombre': nombre,
//   //   };
//   //   var bodyToJson = jsonEncode(body);
//   //   print(bodyToJson);
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     final response = await _dio.post(
//   //       'http://10.0.2.2:8000/api/V1/produits',
//   //       data: body,
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );

//   //     logger.i("Response from remote service: ${response.data})");

//   //     if (response.statusCode == 200 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       var produits = Produit.fromJson(response.data);
//   //       //ventesList.assignAll([ventes]);
//   //       logger.i(
//   //         "Response Produit from Remote Services: ${produits.toString()}",
//   //       );
//   //       logger.i("Produit: ${produits}");
//   //       return produits;
//   //     } else {
//   //       throw Exception("Failed to load Produit with Dio");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Error fetching Produit: ${e.toString()}");
//   //   }
//   // }

//   // Future<dynamic> addUserToTeam(String numberPhone) async {
//   //   final userId = authProvider.user.user;
//   //   dynamic response = '';
//   //   logger.w(userId);
//   //   if (userId == null) {
//   //     throw Exception("User ID is null — user is not logged in.");
//   //   }
//   //   var body = {"name": "Team ${userId.name}", "phone_number": numberPhone};
//   //   var bodyToJson = jsonEncode(body);
//   //   print(bodyToJson);
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     response = await _dio.post(
//   //       'http://10.0.2.2:8000/api/V1/team/add-member',
//   //       data: body,
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );

//   //     logger.i("Response from remote service: ${response})");
//   //     if (response.data['status'] == 404) {
//   //       return response.data;
//   //     }
//   //     logger.i("Response.data from remote service: ${response.data})");
//   //     if (response.data['status'] == 201 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       var user = Membres.fromJson(response.data['user']);
//   //       //ventesList.assignAll([ventes]);
//   //       logger.i("Response User from Remote Services: ${user.toString()}");
//   //       logger.i("User: ${user}");
//   //       var message = response.data['message'];
//   //       var status = response.data['status'];

//   //       return {'user': user, 'message': message, 'status': status};
//   //     } else {
//   //       throw Exception("User not found");
//   //     }
//   //   } on DioException {
//   //     throw ("Response from dio: ${response}");
//   //   } catch (e) {
//   //     throw Exception("Error adding User to a team: ${e.toString()}");
//   //   }
//   // }

//   // Future<List<User>> fetchMembres() async {
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     final response = await _dio.get(
//   //       'http://10.0.2.2:8000/api/V1/team/members',
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );
//   //     logger.i("Team's users: ${response.data}");
//   //     final List data = response.data['users'];
//   //     logger.i("Users from Team: ${data}");

//   //     return data.map((item) => User.fromJson(item)).toList();
//   //     // var usersJson = response.data['users'];
//   //     // if (usersJson is List) {
//   //     //   var users = usersJson.map((u) => User.fromJson(u)).toList();
//   //     //   logger.i("Users from Team: ${users}");
//   //     //   return users;
//   //     // } else if (usersJson != null) {
//   //     //   var user = User.fromJson(usersJson);
//   //     //   logger.i("Users from Team: ${user}");
//   //     //   return [user];
//   //     // } else {
//   //     //   return <User>[];
//   //     // }
//   //   } catch (e) {
//   //     throw Exception("Error fetching membres: $e");
//   //   }
//   // }

//   // Future<List<Membres>> deleteMembre(id) async {
//   //   try {
//   //     final token = authProvider.authToken;
//   //     // final user = authProvider.user.user;
//   //     logger.i("Token from Authprovider: ${token}");

//   //     var response = await _dio.delete(
//   //       'http://10.0.2.2:8000/api/V1/team/members/${id}',
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );
//   //     logger.i("Response from remote service: ${response}");

//   //     final list = response.data['users'] as List;
//   //     List<Membres> users = list.map((e) => Membres.fromJson(e)).toList();
//   //     logger.i("user: ${users}");
//   //     return users;
//   //   } catch (e) {
//   //     // Ensure the function doesn't complete normally without returning a value.
//   //     throw Exception("Error removing User from a team: $e");
//   //   }
//   // }

//   // Future<void> createProduitWithBase64(dynamic payload) async {
//   //   final userId = authProvider.user.user?.id;
//   //   logger.w(userId);
//   //   if (userId == null) {
//   //     throw Exception("User ID is null — user is not logged in.");
//   //   }

//   //   var body = {
//   //     "designation": payload['designation'],
//   //     "montant": payload['montant'],
//   //     "user_id": userId,
//   //     'nombre': payload['nombre'],
//   //     'image': payload['image'],
//   //   };
//   //   var bodyToJson = jsonEncode(body);
//   //   print(bodyToJson);
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     logger.i({
//   //       'designation': body['designation'],
//   //       'montant': body['montant'],
//   //       'nombre': body['nombre'],
//   //       'user_id': userId,
//   //       'image': body['image'],
//   //     });
//   //     final response = await _dio.post(
//   //       'http://10.0.2.2:8000/api/V1/produits',
//   //       data: bodyToJson,
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );

//   //     logger.i("Response from remote service: ${response.data})");

//   //     if (response.statusCode == 200 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       var produits = Produit.fromJson(response.data);
//   //       //ventesList.assignAll([ventes]);
//   //       logger.i(
//   //         "Response Produit from Remote Services: ${produits.toString()}",
//   //       );
//   //       logger.i("Produit: ${produits}");
//   //       goodMessage("Produit créé avec succès ✅");
//   //       Get.find<ProduitController>().clearImage();
//   //       await ProduitsController().fetchProduits();
//   //       Future.delayed(const Duration(seconds: 2), () {
//   //         Get.offAll(ProduitsScreen());
//   //       });
//   //     } else {
//   //       errorMessage("Erreur lors de l'envoi");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Error fetching Produit: ${e.toString()}");
//   //   }
//   // }

//   // Future<void> createProduitWithImage(
//   //   String designation,
//   //   int montant,
//   //   int nombre,
//   //   File image,
//   // ) async {
//   //   final userId = authProvider.user.user?.id;
//   //   logger.w(userId);
//   //   if (userId == null) {
//   //     throw Exception("User ID is null — user is not logged in.");
//   //   }
//   //   final formData = FormData.fromMap({
//   //     "designation": designation,
//   //     "montant": montant,
//   //     "user_id": userId,
//   //     'nombre': nombre,
//   //     'image': await MultipartFile.fromFile(
//   //       image.path,
//   //       filename: image.path.split('/').last,
//   //     ),
//   //   });
//   //   logger.i("FormData from params: ${formData.fields}");
//   //   var imageField = formData.files.firstWhere((f) => f.key == 'image');
//   //   print('Image field key: ${imageField.key}');
//   //   print('Image filename: ${imageField.value.filename}');
//   //   logger.i("FormDataImage from params: ${imageField.value.filename}");
//   //   // var body = {
//   //   //   "designation": designation,
//   //   //   "montant": montant,
//   //   //   "user_id": userId,
//   //   //   'nombre': nombre,
//   //   //   'image': await MultipartFile.fromFile(
//   //   //     image.path,
//   //   //     filename: image.path.split('/').last,
//   //   //   ),
//   //   // };
//   //   // var bodyToJson = jsonEncode(body);
//   //   // print(bodyToJson);
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     // logger.i({
//   //     //   "Body: "
//   //     //           "designation":
//   //     //       body['designation'],
//   //     //   'montant': body['montant'],
//   //     //   'nombre': body['nombre'],
//   //     //   'user_id': userId,
//   //     //   'image': body['image'],
//   //     // });
//   //     // logger.w({
//   //     //   'designation': body['designation'],
//   //     //   'montant': body['montant'],
//   //     //   'nombre': body['nombre'],
//   //     //   'user_id': userId,
//   //     //   'image': body['image'],
//   //     // });
//   //     final response = await _dio.post(
//   //       'http://10.0.2.2:8000/api/V1/produits',
//   //       data: formData,
//   //       options: Options(
//   //         headers: {
//   //           // 'Content-type': 'application/json',
//   //           'Content-Type': 'multipart/form-data',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );

//   //     logger.i("Response from remote service: ${response.data})");

//   //     if (response.statusCode == 200 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       var produits = Produit.fromJson(response.data);
//   //       //ventesList.assignAll([ventes]);
//   //       logger.i(
//   //         "Response Produit from Remote Services: ${produits.toString()}",
//   //       );
//   //       logger.i("Produit: ${produits}");
//   //       goodMessage("Produit créé avec succès ✅");
//   //       Get.find<ProduitController>().clearImage();
//   //       await ProduitsController().fetchProduits();
//   //       Future.delayed(const Duration(seconds: 2), () {
//   //         Get.offAll(ProduitsScreen());
//   //       });
//   //     } else {
//   //       errorMessage("Erreur lors de l'envoi");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Error fetching Produit: ${e.toString()}");
//   //   }
//   // }

//   // Future<Produit> updateProduits(
//   //   String designation,
//   //   int nombre,
//   //   int montant,
//   //   int produitId,
//   // ) async {
//   //   final userId = authProvider.user.user?.id;
//   //   logger.w(userId);
//   //   if (userId == null) {
//   //     throw Exception("User ID is null — user is not logged in.");
//   //   }
//   //   var body = {
//   //     "designation": designation,
//   //     "montant": int.parse(montant.toString()),
//   //     "user_id": userId,
//   //     "nombre": int.parse(nombre.toString()),
//   //   };
//   //   var bodyToJson = jsonEncode(body);
//   //   logger.i("Body from params: ${body}, ProduitId: ${produitId}");
//   //   print(bodyToJson);
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     final response = await _dio.put(
//   //       'http://10.0.2.2:8000/api/V1/produits/${produitId}',
//   //       data: body,
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );

//   //     logger.i("Response from remote service: ${response.data})");

//   //     if (response.statusCode == 200 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       var produitUpdated = Produit.fromJson(response.data);
//   //       logger.i(
//   //         "Response Depense from Remote Services: ${produitUpdated.toString()}",
//   //       );
//   //       logger.i("Vente: ${produitUpdated}");
//   //       return produitUpdated;
//   //     } else {
//   //       throw Exception("Failed to load Produit with Dio");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Error Update Produit: ${e.toString()}");
//   //   }
//   // }

//   // Future<Vente> updateVente(int id, Vente vente) async {
//   //   final userId = authProvider.user.user?.id;
//   //   logger.w(userId);
//   //   if (userId == null) {
//   //     throw Exception("User ID is null — user is not logged in.");
//   //   }
//   //   var body = {
//   //     "designation": vente.designation,
//   //     "prix": int.parse(vente.prix.toString()),
//   //     "user_id": userId,
//   //     "nombre": int.parse(vente.nombre.toString()),
//   //     "type_id":
//   //         vente.types, // Assuming types is a list and you want the first type
//   //   };
//   //   // var bodyToJson = jsonEncode(body);
//   //   logger.i("Body from params: ${body}");
//   //   // print(bodyToJson);
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     final response = await _dio.put(
//   //       'http://10.0.2.2:8000/api/V1/ventes/${id}',
//   //       data: body,
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );

//   //     logger.i("Response from remote service: ${response.data})");

//   //     if (response.statusCode == 200 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       var venteUpdated = Vente.fromJson(response.data);
//   //       logger.i(
//   //         "Response Produit from Remote Services: ${venteUpdated.toString()}",
//   //       );
//   //       logger.i("Produit: ${venteUpdated}");
//   //       return vente;
//   //     } else {
//   //       throw Exception("Failed to load produit with Dio");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Error Update produit: ${e.toString()}");
//   //   }
//   // }

//   // Future<DepensesInfo> createDepense(String libelle, int montant) async {
//   //   final userId = authProvider.user.user?.id;
//   //   logger.w(userId);
//   //   if (userId == null) {
//   //     throw Exception("User ID is null — user is not logged in.");
//   //   }
//   //   var body = {"libelle": libelle, "montant": montant, "user_id": userId};
//   //   var bodyToJson = jsonEncode(body);
//   //   print(bodyToJson);
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     final response = await _dio.post(
//   //       'http://10.0.2.2:8000/api/V1/depenses',
//   //       data: body,
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );

//   //     logger.i("Response from remote service: ${response.data})");

//   //     if (response.statusCode == 200 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       var depenses = DepensesInfo.fromJson(response.data);
//   //       //ventesList.assignAll([ventes]);
//   //       logger.i(
//   //         "Response Depense from Remote Services: ${depenses.toString()}",
//   //       );
//   //       logger.i("Depense: ${depenses}");
//   //       return depenses;
//   //     } else {
//   //       throw Exception("Failed to load Depense with Dio");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Error fetching Depense: $e.");
//   //   }
//   // }

//   // Future<dynamic> login(String phone, String password) async {
//   //   try {
//   //     final response = await _dio.post('http://10.0.2.2:8000/api/V1/login');
//   //     logger.i("Response from remote service: ${response.data})");
//   //     if (response.statusCode == 200 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       return UserInfo.fromJson(response.data);
//   //     } else {
//   //       throw Exception("Failed to load userInfo with Dio");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Error fetching UserInfo: $e");
//   //   }
//   // }

//   // Future<Vente> storeVente(
//   //   String designation,
//   //   int nombre,
//   //   int prix,
//   //   int types,
//   // ) async {
//   //   final userId = authProvider.user.user?.id;
//   //   logger.w(userId);
//   //   if (userId == null) {
//   //     throw Exception("User ID is null — user is not logged in.");
//   //   }
//   //   var body = {
//   //     "nombre": nombre,
//   //     "designation": designation,
//   //     "prix": prix,
//   //     "user_id": userId,
//   //     "types": types,
//   //   };
//   //   var bodyToJson = jsonEncode(body);
//   //   print(bodyToJson);
//   //   try {
//   //     final token = authProvider.authToken;
//   //     logger.i("Token from Authprovider: ${token}");
//   //     final response = await _dio.post(
//   //       'http://10.0.2.2:8000/api/V1/ventes',
//   //       data: body,
//   //       options: Options(
//   //         headers: {
//   //           'Content-type': 'application/json',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );
//   //     logger.i("Response from remote service: ${response})");

//   //     if (response.statusCode == 200 && response.data != null) {
//   //       // Dio automatically parses JSON, so we use response.data
//   //       var vente = Vente.fromJson(response.data);
//   //       //ventesList.assignAll([ventes]);
//   //       logger.i("Response Vente from Remote Services: ${vente}");
//   //       logger.i(vente);
//   //       return vente;
//   //     } else {
//   //       throw Exception("Failed to load Vente with Dio");
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Error fetching Vente: $e.");
//   //   }
//   // }

//   Future<dynamic> signUp(String name, String phone, String password) async {
//     try {
//       // User _user = User();
//       // _user.name = name;
//       // _user.phoneNumber = phone;
//       // _user.password = password;
//       var body = {'name': name, 'phone_number': phone, 'password': password};

//       var bodyToJson = jsonEncode(body);
//       final response = await _dio.post(
//         'http://10.0.2.2:8000/api/V1/register',
//         data: body,
//         options: Options(
//           headers: {
//             'Content-type': 'application/json',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       logger.i("Response from remote service: ${response})");
//       if (response.statusCode == 200 && response.data != null) {
//         // Dio automatically parses JSON, so we use response.data
//         var userRegister = UserRegister.fromJson(response.data);
//         logger.i("Response User from Remote Services: ${userRegister}");
//         return userRegister;
//       } else {
//         throw Exception("Failed to load UserRegister with Dio");
//       }
//     } catch (e) {
//       throw Exception("Error fetching UserRegister: $e");
//     }
//   }

//   static Future<VenteResponse> fetchVentes() async {
//     try {
//       final response = await _dio.get('http://10.0.2.2:8000/api/V1/ventes');
//       if (response.statusCode == 200 && response.data != null) {
//         // Dio automatically parses JSON, so we use response.data
//         return VenteResponse.fromJson(response.data);
//         // if venteFromJson expects raw JSON string
//         // OR: return VenteResponse.fromJson(response.data); // if you have fromJson constructor
//       } else {
//         throw Exception("Failed to load ventes with Dio");
//       }
//     } catch (e) {
//       throw Exception("Error fetching ventes: $e");
//     }
//   }

//   static Future<DepensesInfo> fetchDepenses() async {
//     try {
//       final token = Get.find<AuthProvider>().authToken;
//       logger.i("Token from RemoteServices in  Authprovider: ${token}");
//       final response = await _dio.get(
//         'http://10.0.2.2:8000/api/V1/depenses',
//         options: Options(
//           headers: {
//             'Content-type': 'application/json',
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       logger.i("Response from remote service: ${response.data})");
//       if (response.statusCode == 200 && response.data != null) {
//         // Dio automatically parses JSON, so we use response.data
//         return DepensesInfo.fromJson(response.data);
//         // if venteFromJson expects raw JSON string
//         // OR: return VenteResponse.fromJson(response.data); // if you have fromJson constructor
//       } else {
//         throw Exception("Failed to load ventes with Dio");
//       }
//     } catch (e) {
//       throw Exception("Error fetching depenses: $e");
//     }
//   }
//   // Using HTTP
//   //static var client = http.Client();

//   // static Future<List<Product>> fetchProducts() async {
//   //   var response = await client.get(
//   //     Uri.parse(
//   //       'https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline',
//   //     ),
//   //   );

//   //   if (response.statusCode == 200 && response.body.isNotEmpty) {
//   //     var jsonString = response.body;
//   //     logger.i("RemoteServices: Fetching products from API: $jsonString");
//   //     return productFromJson(jsonString);
//   //   } else {
//   //     return [];
//   //   }
//   // }

//   // static Future<VenteResponse> fetchVentes() async {
//   //   var response = await client.get(
//   //     Uri.parse('http://10.0.2.2:8000/api/V1/ventes'),
//   //   );

//   //   if (response.statusCode == 200 && response.body.isNotEmpty) {
//   //     return venteFromJson(response.body);
//   //   } else {
//   //     throw Exception("Failed to load ventes");
//   //   }
//   // }
// }
