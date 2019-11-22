params ["_vehicle", "_isWiesel"];

if (!isServer) exitWith {};

if (_isWiesel) then {
    switch (typeOf _vehicle) do { 
        case "Redd_Tank_Wiesel_1A2_TOW_Flecktarn" : { [_vehicle,'camonet',player] call Redd_fnc_wiesel_camonet; }; 
        case "Redd_Tank_Wiesel_1A4_MK20_Flecktarn" : { [_vehicle,'camonet',objNull] call Redd_fnc_mk20_camonet; }; 
        default {  /*...code...*/ }; 
    };
    
    _vehicle disableTIEquipment true;
} else {
    switch (typeOf _vehicle) do { 
        case "Redd_Tank_LKW_leicht_gl_Wolf_Flecktarn_FueFu" : { [_vehicle,'camonet',objNull] call Redd_fnc_wolf_camonet; };
        default {  /*...code...*/ }; 
    };
};