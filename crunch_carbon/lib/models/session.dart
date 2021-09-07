
import 'package:crunch_carbon/models/fuel.dart';

class Session{
  Fuel fuel;
  double distance;
  double emissionQuantity;

  Session(this.fuel, this.distance): emissionQuantity = (fuel.quantityConsumed / distance) * fuel.factor;
}


enum PutSessionStatus{
  Success, Failure
}