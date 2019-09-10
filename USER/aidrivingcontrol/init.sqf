private _vehicles = [];

if (isNil "_this") then{
	_vehicles = vehicles; //All vehicles
}else{
	null = call {
		if (_this isEqualType objNull) exitWith{_vehicles pushBack _this;}; //One vehicle
		if (_this isEqualType []) exitWith{_vehicles = _this}; //Array of vehicle(s)
	};
};

{
	//Add Event Handler
	_x addEventHandler ["Getin", {_this spawn RCA3_fnc_AIDCinit; _this execFSM "USER\aidrivingcontrol\engineoff.fsm"}];

	//Start function if driver inside
	if !(isNull (driver _x)) then{null=[_x,"driver",(driver _x)] spawn RCA3_fnc_AIDCinit; [_x,"driver",(driver _x)] execFSM "USER\aidrivingcontrol\engineoff.fsm"};
}forEach _vehicles;

//ZEUS
//No Headless Client or Dedicated Server Zeus
if ((!hasInterface && !isDedicated) || isDedicated) exitWith{};

//One Event Handler per client
if !(isNil "AIDC_ZEUS_EH") exitWith{};

waitUntil {!(isNull (getAssignedCuratorLogic player))};

AIDC_ZEUS_EH = (getAssignedCuratorLogic player) addEventHandler ["CuratorObjectPlaced", {
	params ["_curator", "_entity"];

	if (_entity isKindOf "Car" || _entity isKindOf "Motorcycle" || _entity isKindOf "Tank") then{
		//Add Event Handler
		_entity addEventHandler ["Getin", {_this spawn RCA3_fnc_AIDCinit; _this execFSM "USER\aidrivingcontrol\engineoff.fsm"}];

		//Start function if driver inside
		if !(isNull (driver _entity)) then{null=[_entity,"driver",(driver _entity)] spawn RCA3_fnc_AIDCinit; [_entity,"driver",(driver _entity)] execFSM "USER\aidrivingcontrol\engineoff.fsm"};
	};
}];