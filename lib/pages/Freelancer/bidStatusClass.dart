import 'package:flutter/foundation.dart';

class BidStatus with ChangeNotifier {
  bool _hasPlacedBid = false;

  bool get hasPlacedBid => _hasPlacedBid;

  void placeBid() {
    _hasPlacedBid = true;
    notifyListeners();
  }
}
