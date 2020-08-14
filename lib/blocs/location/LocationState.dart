part of 'LocationBloc.dart';

@immutable
abstract class LocationState {}

class LocationNotFound extends LocationState {}

class FindingLocation extends LocationState {}

class LocationSetupFailed extends LocationState {}

class LocationEstablished extends LocationState {
  final List<LatLng> _coordinates;

  LocationEstablished(this._coordinates);

  List<LatLng> get getCoordinates => _coordinates;

  @override
  List<Object> get props => [_coordinates];
}