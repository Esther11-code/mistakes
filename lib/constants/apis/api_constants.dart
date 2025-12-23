import '../../features/Authentication/presentation/cubit/authentication_cubit.dart';

class Apis {
  static const String baseUrl = 'https://guru.alwaysdata.net/craftman/api/v1';
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String delete = '$baseUrl/user';
  static const String verifyEmail = '$baseUrl/email/verify';
  static const String resendEmailOtp = '$baseUrl/email/send-code';
  static const String updateUserProfile = '$baseUrl/user';
  static String subCat(id) => '$baseUrl/user/artisans/$id';
  static const String categories = '$baseUrl/user/artisans/categories';
  static String bookArtisan(id) => '$baseUrl/user/artisans/book/$id';
  static const String bookingHistory = '$baseUrl/user/request/history';
  static const String getNotification = '$baseUrl/user/user-notifications';
  static String rateArtisan(id) => '$baseUrl/user/artisans/rate/$id';
  static String cancelBooking(id) => '$baseUrl/user/request/cancel/$id';
  static String popularService = '$baseUrl/user/artisans/popular/categories';
}

class ApiHeaders {
  static const unaunthenticatedHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static final aunthenticatedHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $bearerToken'
  };
}