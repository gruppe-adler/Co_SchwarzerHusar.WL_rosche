params ["_helper", "_pos"];

if (isNull _helper) exitWith {};

private _chemLight = createVehicle ["ACE_G_Chemlight_HiGreen", _pos, [], 0, "CAN_COLLIDE"];

[{
    params ["_helper", "_chemLight", "_pos"];

    if (!isNull _helper && !isNull _chemLight) then {
        deleteVehicle _chemLight;
        [_helper, _pos] execVM "USER\scripts\eternalChemlight.sqf";
    };
}, [_helper, _chemLight, _pos], 800] call CBA_fnc_waitAndExecute;

// #LIGHT RESPAWN TESTED 13.11.