

typedef T Constructor<T>();



final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {

  _constructors[T.toString()] = constructor;
}

class ClassBuilder {


  // void registerClasses() {
  //   register<CustomerDashboard>(() => CustomerDashboard(model));
  //   // register<TransactionLogs>(() => TransactionLogs());
  
  // }
  // returned to main.dart

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}