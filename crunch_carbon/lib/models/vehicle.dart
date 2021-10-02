
class Vehicle{
  VehicleType vehicleType;
  EngineType engineType;
  double mileage;

  Vehicle({required this.vehicleType, required this.engineType, required this.mileage,});

  double get fuelEfficiency {
    if(engineType == EngineType.V6){
      return _eff(0.094);
    }else{
      if(vehicleType == VehicleType.Salon){
        return _eff(0.106916);
      }else if(vehicleType == VehicleType.Suv){
        return _eff(0.1176);
      }else{
        return _eff(0.11945);
      }
    }
  }

  double _eff (double init){
    if(mileage >= 40000){
      return (11.8/100) * init;
    }
    else if (mileage >= 20000){
      return (4.2/100) * init;
    }else{
      return init;
    }
  }
}

enum EngineType {
  V6,
  CYLINDER_4,
}

enum VehicleType{
  Truck,
  Suv,
  Salon
}