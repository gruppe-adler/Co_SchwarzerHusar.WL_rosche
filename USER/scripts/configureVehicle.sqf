params ["_vehicle", "_isWiesel"];

if (!isServer) exitWith {};

if (_isWiesel) then {
    [_vehicle,'camonet',objNull] call Redd_fnc_mk20_camonet;
    _vehicle disableTIEquipment true;
} else {
    [_vehicle,'camonet',objNull] call Redd_fnc_wolf_camonet;
};