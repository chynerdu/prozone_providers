import 'package:flutter/material.dart';
import 'package:prozone/services/authentication.dart';
import 'package:prozone/services/meta-data.dart';
import 'package:prozone/services/providers.dart';

class MainAppProvider
    with ChangeNotifier, MetaDataService, Authentication, ProviderService {}
