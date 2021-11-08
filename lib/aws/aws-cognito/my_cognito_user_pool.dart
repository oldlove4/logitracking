
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyCognitoUserPool {
  final SharedPreferences _prefs;
  MyCognitoUserPool(this._prefs);

  get userPool =>
      CognitoUserPool('ap-northeast-2_qTaV24FHL', '2d8pdg7043vi49o1qojt5o0lpu', storage: Storage(_prefs));

  Future<CognitoUserSession?> authenticateUser(
  {required String username, required String password}) async {

    print('2222222222222222222222222222222222');
    final cognitoUser = CognitoUser(username, userPool, storage: Storage(_prefs));
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    CognitoUserSession? session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
    } on CognitoUserNewPasswordRequiredException catch (e) {
      print(e);
      // handle New Password challenge
    } on CognitoUserMfaRequiredException catch (e) {
      print(e);
      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      print(e);
      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      print(e);
      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      print(e);
      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      print(e);
      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      print(e);
      // handle User Confirmation Necessary
    } on CognitoClientException catch (e) {
      print(e);
      // handle Wrong Username and Password and Cognito Client
    } catch (e) {
      print(e);
    }
    return session;
  }

  Future<CognitoUser?> getUser() async {
    return userPool.getCurrentUser();
  }

  Future<CognitoCredentials?> getCredentials(String token) async {

    // final credentials = CognitoCredentials(
    //     'ap-southeast-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx', userPool);
    //
    // await credentials.getAwsCredentials(session.getIdToken().getJwtToken());
    // print(credentials.accessKeyId);
    // print(credentials.secretAccessKey);
    // print(credentials.sessionToken);
  }
}

class Storage extends CognitoStorage {
  final SharedPreferences _prefs;
  Storage(this._prefs);

  @override
  Future<String?> getItem(String key) async {
    print('=================>>>> ' + key);
    return _prefs.getString(key);
  }

  @override
  Future<bool> setItem(String key, value) async {
    return _prefs.setString(key, value);
  }

  @override
  Future<bool> removeItem(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    _prefs.clear();
  }
}

