import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class UserEvent extends Equatable {
  UserEvent();
}

class UserFacebookSignUpEvent extends UserEvent {
  @override
  List<Object> get props => null;
}

class UserInstagramSignUpEvent extends UserEvent {
  @override
  List<Object> get props => null;
}

class UserBiometricsEvent extends UserEvent {
  @override
  List<Object> get props => null;
}

