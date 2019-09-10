params ["_car", "_gates"];

//All vehicles around
private _carsarray = _car nearEntities [["Man", "Car", "Motorcycle", "Tank"], (0.1*((speed _car) / 3.6)^2+((speed _car) / 3.6) max 50)]; //from center
_carsarray deleteAt (_carsarray findIf {_x isEqualTo _car});
_carsarray append _gates; //Append gates

_carsarray