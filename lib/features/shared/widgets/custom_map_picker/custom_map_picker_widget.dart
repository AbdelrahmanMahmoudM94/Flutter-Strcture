import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 import 'package:flutter_structure/features/di/dependency_init.dart';
import 'package:flutter_structure/features/shared/widgets/custom_elevated_button_widget.dart';
import 'package:flutter_structure/features/shared/widgets/custom_map_picker/custom_map_picker_cubit.dart';

class MapPickerButton extends StatelessWidget {
  MapPickerButton({
    Key? key,
    this.buttonText = 'Pick Location',
  }) : super(key: key);
  final String buttonText;

  LocationCubit locationCubit = getIt<LocationCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => locationCubit,
        child: BlocBuilder<LocationCubit, LatLng?>(
          builder: (BuildContext context, LatLng? location) {
            return CustomElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapPickerScreen(locationCubit),
                  ),
                );
              },
              text: location == null
                  ? buttonText
                  : context.tr("selectedLocation") +
                      " ${location.latitude}, ${location.longitude}",
            );
          },
        ));
  }
}

class MapPickerScreen extends StatefulWidget {
  MapPickerScreen(this.locationCubit);
  final LocationCubit locationCubit;
  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.locationCubit,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Pick a Location'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: BlocBuilder<LocationCubit, LatLng?>(
            builder: (BuildContext context, LatLng? pickedLocation) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(0,0),
                  zoom: 15,
                ),
                onTap: (LatLng position) {
                  widget.locationCubit.setLocation(position);
                },
                markers: pickedLocation != null
                    ? <Marker>{
                        Marker(
                          markerId: MarkerId('pickedLocation'),
                          position: pickedLocation,
                        ),
                      }
                    : <Marker>{},
              );
            },
          )),
    );
  }
}
