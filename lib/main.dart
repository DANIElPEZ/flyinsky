import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/repository/weather_repository.dart';
import 'package:flyinsky/repository/charts_repository.dart';
import 'package:flyinsky/repository/token_repository.dart';
import 'package:flyinsky/repository/checklist_repository.dart';
import 'package:flyinsky/repository/auth_repository.dart';
import 'package:flyinsky/repository/purchase_repository.dart';
import 'package:flyinsky/blocs/weather/weather_bloc.dart';
import 'package:flyinsky/blocs/token/token_bloc.dart';
import 'package:flyinsky/blocs/charts/chart_bloc.dart';
import 'package:flyinsky/views/splashView.dart';
import 'package:flyinsky/blocs/checklist/checklist_bloc.dart';
import 'package:flyinsky/blocs/auth/auth_bloc.dart';
import 'package:flyinsky/blocs/purchase/purchase_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(Main());
  });
}

Future<void> init()async{
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(url: dotenv.env['SUPABASE_URL']??'', anonKey: dotenv.env['SUPABASE_KEY']??'');
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WeatherRepository>(
          create: (context) => WeatherRepository()
        ),
        RepositoryProvider<ChartsRepository>(
          create: (context) => ChartsRepository()
        ),
        RepositoryProvider<TokenRepository>(
          create: (context) => TokenRepository()
        ),
        RepositoryProvider<CheckListRepository>(
          create: (context) => CheckListRepository()
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository()
        ),
        RepositoryProvider<PurchaseRepository>(
          create: (context) => PurchaseRepository()
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TokenBloc>(
            create:
                (context) => TokenBloc(
                  tokenRepository: RepositoryProvider.of<TokenRepository>(
                    context,
                  ),
                ),
          ),
          BlocProvider<WeatherBloc>(
            create:
                (context) => WeatherBloc(
                  weatherRepository: RepositoryProvider.of<WeatherRepository>(
                    context,
                  ),
                ),
          ),
          BlocProvider<chartsBloc>(
            create: (context) {
              final tokenBloc = BlocProvider.of<TokenBloc>(context);
              final chartsrepository = RepositoryProvider.of<ChartsRepository>(context);

              return chartsBloc(
                tokenBloc: tokenBloc,
                chartsrepository: chartsrepository
              );
            }
          ),
          BlocProvider<ChecklistBloc>(create: (context)=>ChecklistBloc(
            checklistrepository: RepositoryProvider.of<CheckListRepository>(context)
          )),
          BlocProvider<AuthBloc>(create: (context)=>AuthBloc(
              authrepository: RepositoryProvider.of<AuthRepository>(context)
          )),
          BlocProvider<PurchaseBloc>(create: (context)=>PurchaseBloc(
              purchaseRepository: RepositoryProvider.of<PurchaseRepository>(context)
          ))
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, child){
                return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
                    child: SafeArea(child: child!));
              },
              home: splashPage()
            );
          },
        ),
      ),
    );
  }
}
