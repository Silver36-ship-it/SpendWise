import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_notifier.dart';
import 'auth_state.dart';

final authProvider =
AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new,);
