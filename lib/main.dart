import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_vendor_app/model/screen.dart';
import 'package:multi_vendor_app/model/style.dart';
import 'package:multi_vendor_app/provider/auth_provider.dart';
import 'package:multi_vendor_app/provider/location_provider.dart';
import 'package:multi_vendor_app/provider/vendor/auth_vendor_provider.dart';
import 'package:multi_vendor_app/provider/vendor/product_vendor_provider.dart';
import 'package:multi_vendor_app/provider/vendor_provider.dart';
import 'package:multi_vendor_app/screens/home_screen.dart';
import 'package:multi_vendor_app/screens/landing_screen.dart';
import 'package:multi_vendor_app/screens/login_phone_screen.dart';
import 'package:multi_vendor_app/screens/main_screen.dart';
import 'package:multi_vendor_app/screens/map_screen.dart';
import 'package:multi_vendor_app/screens/login_screen.dart';
import 'package:multi_vendor_app/screens/vendor/add_new_product_screen.dart';
import 'package:multi_vendor_app/screens/vendor/edit_view_product.dart';
import 'package:multi_vendor_app/screens/vendor/register_vendor_screen.dart';
import 'package:multi_vendor_app/screens/vendor/vendor_banner_screen.dart';
import 'package:multi_vendor_app/screens/vendor/vendor_dashboard_screen.dart';
import 'package:multi_vendor_app/screens/vendor/vendor_home_screen.dart';
import 'package:multi_vendor_app/screens/vendor/vendor_product_screen.dart';
import 'package:multi_vendor_app/screens/welcome_screen.dart';
import 'package:multi_vendor_app/services/user_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
        providers:[
          ChangeNotifierProvider( create: (_)=> AuthProvider()),
          ChangeNotifierProvider( create: (_)=> LocationProvider()),
          ChangeNotifierProvider( create: (_)=> VendorProvider()),
          ChangeNotifierProvider( create: (_)=> AuthVendorProvider()),
          ChangeNotifierProvider( create: (_)=> ProductVendorProvider()),
        ],
    child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primary,
        fontFamily: 'Lato'
      ),
      builder: EasyLoading.init(),
      initialRoute: SPLASH,
      routes: {
        SPLASH : (context) => const SplashScreen(),
        WELCOME: (context) => WelcomeScreen(),
        LOGIN: (context) => LoginScreen(),
        HOME: (context) => HomeScreen(),
        MAP: (context) => MapScreen(),
        LOGIN_PHONE: (context) => LoginPhoneScreen(),
        LANDING: (context) => LandingScreen(),
        MAIN: (context) => MainScreen(),
        REGISTER_VENDOR: (context) => RegisterVendorScreen(),
        VENDOR_DASHBOARD: (context) => VendorDashboardScreen(),
        VENDOR_HOME: (context) => VendorHomeScreen(),
        VENDOR_PRODUCT: (context) => VendorProductScreen(),
        ADD_NEW_PRODUCT: (context) => AddNewProduct(),
        VENDOR_BANNER: (context) => VendorBannerScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin<SplashScreen> {

  User? user = FirebaseAuth.instance.currentUser;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if(_seen) {
      Navigator.pushNamed(context, LOGIN);
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if(user == null) {
          Navigator.pushReplacementNamed(context, LOGIN);
        } else{
          getUserData();
        }
      });
    }else {
      await prefs.setBool('seen', true);
      Navigator.pushReplacementNamed(context, WELCOME);
    }
  }

  getUserData()async {
    UserServices _userServices = UserServices();
    _userServices.getUserById(user!.uid).then((result) {
      if(result.get('location.address')!= null) {
        updatePrefs(result);
      }else {
        Navigator.pushReplacementNamed(context, LANDING);
      }
    });
  }

  Future<void> updatePrefs(result) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['location.latitude']);
    prefs.setDouble('longitude', result['location.longitude']);
    prefs.setString('address', result['location.address']);
    prefs.setString('location', result['location.featureName']);
    Navigator.pushReplacementNamed(context, MAIN);
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Container(
      color:white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}



