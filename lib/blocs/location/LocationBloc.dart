import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:meta/meta.dart';
import 'package:poslabauth/services/LocationService.dart';
import 'package:poslabauth/utils/logger.dart';

part 'LocationEvent.dart';
part 'LocationState.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  LocationService locationService;

  Logger logger;

  LocationBloc({this.locationService, this.logger}) : super(LocationNotFound());

  @override
  LocationState get initialState => LocationNotFound();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if(event is LocationSetupEvent){
      yield FindingLocation();
      try {
        List<LatLng> coordinates = await locationService.getCoordinates();
        yield LocationEstablished(coordinates);
      }catch(err){
        logger.error(err);
        yield LocationSetupFailed();
      }
    }
  }
}
