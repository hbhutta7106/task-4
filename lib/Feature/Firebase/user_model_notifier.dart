import 'package:riverpod/riverpod.dart';
import '../../Models/User/user.dart';

class UserModelNotifier extends StateNotifier<UserProfile> {
  UserModelNotifier(super._state);

  void loadUser(UserProfile newUser) {
    state = newUser;
  }

  void updateUser(UserProfile user) {
    state = user;
  }

  void updateLocationPoints(String latLngValue) {
    final values = latLngValue.split(',');
    if (values.length == 2) {
      String latitude = values[0].trim();
      String longitude = values[1].trim();
      if (latitude.contains('.') && longitude.contains('.')) {
        final updatesCoordinates = state.location!.coordinates!
            .copyWith(latitude: latitude, longitude: longitude);
        final updatedLocation =
            state.location!.copyWith(coordinates: updatesCoordinates);
        state = state.copyWith(location: updatedLocation);
      }
    }
  }
}
