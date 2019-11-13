params ["_logic"];

if (!isServer) exitWith {};

private _position = getPos _logic;

private _fire = "test_EmptyObjectForFireBig" createVehicle _position;
_fire attachTo [_logic, [0,0,0]];

[[_fire, _position], "USER\scripts\createFireLight.sqf"] remoteExecCall ["BIS_fnc_execVM", 0, true];

{
    _x addCuratorEditableObjects [[_fire],true];
} forEach allCurators;

[{
    params ["_logic", "_fire"];
    isNull _logic
}, {
    params ["_logic", "_fire"];
    if (!isNull _fire) then {
        /*
        _emitterArray = _fire getVariable "effects";
        {deleteVehicle _x} forEach _emitterArray;
        */
        deleteVehicle _fire;
    };
}, [_fire]] call CBA_fnc_waitUntilAndExecute;