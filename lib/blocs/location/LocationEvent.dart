part of 'LocationBloc.dart';

@immutable
abstract class LocationEvent {}

class LocationSetupEvent extends LocationEvent {
  @override
  List<Object> get props => null;
}