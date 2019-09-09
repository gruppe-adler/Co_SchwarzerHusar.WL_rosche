params ["_convoyID", "_convoy", "_thisVeh", "_waypoints"];

private _identifier = format ["GRAD_convoy_vehicleList_%1", _convoyID];

if (_thisVeh getVariable ["GRAD_convoy_formationBroken", false]) exitWith {
    private _index = _convoy find _thisVeh;
    _convoy deleteAt _forEachIndex;
};

systemChat "remove vehicle from convoy";

private _index = _convoy find _thisVeh;
private _vehicleInFront = _thisVeh getVariable ["GRAD_convoy_vehicleInFront", objNull];
private _vehicleBehind = _thisVeh getVariable ["GRAD_convoy_vehicleBehind", objNull];

[_convoy, _waypoints] call GRAD_convoy_fnc_breakFormation;

missionNamespace setVariable [_identifier, []];