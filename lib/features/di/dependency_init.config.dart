// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_structure/core/network/network_helper.dart' as _i866;
import 'package:flutter_structure/features/di/register_module.dart' as _i294;
import 'package:flutter_structure/features/shared/cubit/locale_cubit/locale_cubit.dart'
    as _i1030;
import 'package:flutter_structure/features/shared/cubit/theme_cubit/theme_cubit.dart'
    as _i347;
import 'package:flutter_structure/features/shared/widgets/custom_check_box/check_box_cubit.dart'
    as _i601;
import 'package:flutter_structure/features/shared/widgets/custom_date_picker/custom_date_picker_cubit.dart'
    as _i42;
import 'package:flutter_structure/features/shared/widgets/custom_file_picker/custom_file_picker_cubit.dart'
    as _i804;
import 'package:flutter_structure/features/shared/widgets/custom_map_picker/custom_map_picker_cubit.dart'
    as _i132;
import 'package:flutter_structure/features/shared/widgets/pdf_bottomsheet_widget/pdf_cubit.dart'
    as _i799;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i1030.LocaleCubit>(() => _i1030.LocaleCubit());
  gh.factory<_i347.ThemeCubit>(() => _i347.ThemeCubit());
  gh.factory<_i42.DatePickerCubit>(() => _i42.DatePickerCubit());
  gh.factory<_i804.FilePickerCubit>(() => _i804.FilePickerCubit());
  gh.factory<_i132.LocationCubit>(() => _i132.LocationCubit());
  gh.factory<_i799.PDFCubit>(() => _i799.PDFCubit());
  await gh.singletonAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.factory<String>(
    () => registerModule.baseUrl,
    instanceName: 'BaseUrl',
  );
  gh.factory<_i601.CheckboxCubit>(() => _i601.CheckboxCubit(gh<bool>()));
  gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<String>(instanceName: 'BaseUrl')));
  gh.factory<_i866.NetworkHelper>(() => _i866.NetworkHelper(gh<_i361.Dio>()));
  return getIt;
}

class _$RegisterModule extends _i294.RegisterModule {}
