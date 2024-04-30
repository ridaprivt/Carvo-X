class SessionManager {
  static final SessionManager _session = SessionManager._internal();

  String? userId;
  String? userRole;

  factory SessionManager() {
    return _session;
  }
  SessionManager._internal() {}
}

//sessionmanager().userid()=  .then((value) {SessionManager().userId=value.}