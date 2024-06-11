//this is the app name, can be used in the appbar or anywhere else
import 'package:flutter/material.dart';

const String appName = 'I Aqoonsi';

const String logoBlue = 'assets/images/nirablue.png';
const String frontlogoBlue = 'assets/images/frontlogoblue.png';
const String frontlogoWhite = 'assets/images/frontlogowhite.png';
const String logoWhite = 'assets/images/nirawhite.png';
const String placeholderImage = 'assets/images/logoplaceholder.png';
const String forgroundImage = 'assets/images/frontground.jpg';
const String backgroundImage = 'assets/images/background.jpg';
const String profileImage = 'assets/images/profile.png';
const String signatureImage = 'assets/images/signature.png';
const String svgBackground = "assets/images/backgroundabstract.svg";
const String background = "assets/images/backgroundabstract.png";
const String backgroundabstractwhite =
    "assets/images/backgroundabstractwhite.png";

const String protovalidation = "assets/images/photovalidation.png";
const String frontlogin = "assets/images/frontlogin.png";

const String appparbackground = 'assets/images/appparbackground.png';
const String backgroundabstract = 'assets/images/backgroundabstract.png';
const String mobilePhone = 'assets/images/mobile.png';
const Color kYellowColor = Color(0xFFFCBA4C);
const Color kBlueColor = Color(0xFF025196);
const Color kWhiteColor = Color(0xFFFFFFFF);

//this is the app version
const String appVersion = '0.0.1';

//this is the base url for the api 'its just mockup' for now development
// const String apiBaseUrls = 'http://localhost:8088/api';

// android emulator
// const String baseUrl = 'http://10.0.2.2:8080/api';
// const String baseUrl = 'http://172.16.94.16:8080/api';

//this is the base url for the api 'its just mockup' for now production
// const String apiBaseUrl = 'https://api.nira.gov.so/api/v1';

const String baseUrl = 'http://localhost:8080/api';
// const String baseUrl = 'http://172.16.188.135:8080/api';
const String virsionV1 = 'v1';
const String apiBaseUrl = '$baseUrl/$virsionV1';

//create userUrl with apiBaseUrl
const String userUrl = '$apiBaseUrl/users';

const String loginUrl = '$apiBaseUrl/auth/login';
const String registerUrl = '$apiBaseUrl/auth/register';
const String verifyUrl = '$apiBaseUrl/auth/verify';
const kProfileUrl = 'http://10.0.2.2:9191/api/v1/profile';
//onboarding screen

const String first = "assets/images/first.png";
const String second = "assets/images/second.png";
const String third = "assets/images/third.png";
const String eaqoonsi = "assets/images/eaqoonsi.png";
const String generateid = "assets/images/generateid.png";
const String generateidback = "assets/images/generateidbackground.png";
