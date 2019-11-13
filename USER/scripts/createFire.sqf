params ["_logic"];

if (!isServer) exitWith {};

private _position = getPos _logic;

private _fire = createVehicle ["test_EmptyObjectForFireBig﻿", _position, [], 0, "CAN_COLLIDE"];
_fire attachTo [_logic, [0,0,0]];

{
    _x addCuratorEditableObjects [[_fire],true];
} forEach allCurators;

[{
    params ["_logic", "_fire"];
    isNull _logic
}, {
    params ["_logic", "_fire"];
    if (!isNull _fire) then {
        deleteVehicle _fire;
    };
}, [_fire]] call CBA_fnc_waitUntilAndExecute;