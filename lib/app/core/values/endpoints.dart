import 'package:http/http.dart';

// const baseUrl = 'http://192.168.1.8:8000/api/V1';
// const baseUrl = 'http://127.0.0.1:8000/api/V1';

const baseUrl = 'http://10.0.2.2:8000/api/V1';

const loginEndpoint = '$baseUrl/login';
const registerEndPoint = '$baseUrl/register';
const signOutEndpoint = '$baseUrl/logout';
const uploadVideosEndpoint = '$baseUrl/upload-video';
const fetchVideosEndpoint = '$baseUrl/videos';

const listLivesEndpoint = '$baseUrl/lives';
const storeLiveEndpoint = '$baseUrl/lives';
const startLiveEndpoint = '$baseUrl/lives/start';

const venteListEndpoint = '$baseUrl/ventes/';
const depensesListEndpoint = '$baseUrl/depenses/';
const createDepenses = '$baseUrl/depenses/';
const venteDeleteEndpoint = '$baseUrl/ventes/';
const venteUpdateEndpoint = '$baseUrl/ventes/';
const updateDepenses = '$baseUrl/depenses/';
const depenseDeleteEndpoint = '$baseUrl/depenses/';
const typesListEndpoint = '$baseUrl/types/';
const produitsEndpoint = '$baseUrl/produits/';
const produitSupAZeroEndpoint = '$baseUrl/produits/supeAzero';
const rechercheProduits = '$baseUrl/produits/searchProduits';
const journauxEndpoints = '$baseUrl/journal/';
const teamEndpoints = '$baseUrl/team/';
const listVideosEndpoint = '$baseUrl/videos';
const createPostsEndpoint = '$baseUrl/posts';
const toggleLikesDislikesEndpoint = '$baseUrl/likes/toggleLikeDislike';
const toggleSavesUnSavesEndpoint = '$baseUrl/save/toggleSaveUnSaved';
const listCommentsEndpoint = '$baseUrl/videos/comments/';
const addCommentReplyEndpoint = '$baseUrl/comments/';
const addCommentEndpoint = '$baseUrl/comments/';
const toggleLikesDislikesCommentEndpoint = '$baseUrl/likeUnlike/comments';
const resultsSearchVideoEndpoint = '$baseUrl/videos/search';
const toggleFollowsEndpoint = '$baseUrl/follow';
const followersEndpoint = '$baseUrl/followers/';
const followingEndpoint = '$baseUrl/following/';
const suggestionsEndpoint = '$baseUrl/suggestions';
const profileEndpoint = '$baseUrl/profile';
const deleteCommentEndpoint = '$baseUrl/comments';
const deleteReplyEndpoint = '$baseUrl/comment/reply';
const toggleLikesDislikesReplyEndpoint = '$baseUrl/likeUnlike/replies';
const listVideosFollowingEndpoint = '$baseUrl/videos/following';
const listMyVideosEndpoint = '$baseUrl/videos/myvideos';
// const listLikedVideosEndpoint = '$baseUrl/profile';
// const listSavedVideosEndpoint = '$baseUrl/videos/saved';
// const listSharedVideosEndpoint = '$baseUrl/videos/shared';
