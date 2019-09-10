params ["_cardir", "_carfrontpos", "_carsarray"];

//Vehicles relative direction front
private _carsinfrontarray = [];
private _carsinfrontarray = _carsarray select {cos ((_carfrontpos getDir _x) - _cardir) > 0 && !(_x isKindOf "Animal")};

_carsinfrontarray