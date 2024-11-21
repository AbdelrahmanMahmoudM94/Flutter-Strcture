import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationCubit extends Cubit<LatLng?> {
  LocationCubit() : super(null);

  void setLocation(LatLng location) => emit(location);
}
