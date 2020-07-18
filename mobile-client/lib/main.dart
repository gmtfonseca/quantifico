import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quantifico/app_blocs_provider.dart';
import 'package:quantifico/auth_guard.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/simple_bloc_delegate.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/data/provider/nf_web_provider.dart';
import 'package:quantifico/data/provider/token_local_provider.dart';
import 'package:quantifico/data/provider/user_local_provider.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/data/repository/nf_repository.dart';
import 'package:quantifico/data/repository/user_repository.dart';
import 'package:quantifico/presentation/screen/main_screen.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repository/chart_container_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final sharedPreferences = await SharedPreferences.getInstance();
  final webClient = WebClient();

  const tokenLocalProvider = TokenLocalProvider(storage: FlutterSecureStorage());
  final userLocalProvider = UserLocalProvider(sharedPreferences: sharedPreferences);
  final chartWebProvider = ChartWebProvider(
    webClient: webClient,
    tokenLocalProvider: tokenLocalProvider,
  );
  final nfWebProvider = NfWebProvider(
    webClient: webClient,
    tokenLocalProvider: tokenLocalProvider,
  );

  final userRepository = UserRepository(
    webClient: WebClient(),
    tokenLocalProvider: tokenLocalProvider,
    userLocalProvider: userLocalProvider,
  );
  final chartRepository = ChartRepository(chartWebProvider: chartWebProvider);
  final chartContainerRepository = ChartContainerRepository(sharedPreferences: sharedPreferences);
  final nfRepository = NfRepository(nfWebProvider: nfWebProvider);

  runApp(Quantifico(
    userRepository: userRepository,
    chartRepository: chartRepository,
    chartContainerRepository: chartContainerRepository,
    nfRepository: nfRepository,
  ));
}

class Quantifico extends StatelessWidget {
  final UserRepository userRepository;
  final ChartRepository chartRepository;
  final ChartContainerRepository chartContainerRepository;
  final NfRepository nfRepository;

  const Quantifico({
    this.userRepository,
    this.chartRepository,
    this.chartContainerRepository,
    this.nfRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantifico',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(userRepository: userRepository)..add(const CheckAuthentication()),
        child: AuthGuard(
          userRepository: userRepository,
          child: AppBlocsProvider(
            chartRepository: chartRepository,
            chartContainerRepository: chartContainerRepository,
            nfRepository: nfRepository,
            child: MainScreen(),
          ),
        ),
      ),
    );
  }
}
