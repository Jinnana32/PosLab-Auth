
import 'package:bloc/bloc.dart';
import 'package:poslabauth/blocs/user/UserEvent.dart';
import 'package:poslabauth/blocs/user/UserState.dart';
import 'package:poslabauth/models/User.dart';
import 'package:poslabauth/services/UserService.dart';
import 'package:poslabauth/utils/logger.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  UserService userService;

  Logger logger;

  UserBloc({this.userService, this.logger}) : super(UserInitialState());
  
  @override
  UserState get initialState => UserInitialState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {

    if(event is UserFacebookSignUpEvent){
      yield UserIsAuthenticating();

      try {
        User user = await userService.facebookSignUp();
        yield UserIsAuthenticated(user);
      }catch(err){
        logger.error(err);
        yield UserAuthenticationFailed("Something went wrong. Please try again later");
      }
    }

    if(event is UserInstagramSignUpEvent){
      yield UserIsAuthenticating();
    }

    if(event is UserBiometricsEvent){
      yield UserIsAuthenticating();
    }

  }

}