
// disable all remaining ai to save resources

{
  _x disableAI "ALL";
} forEach allUnits;

sleep 1;

private _convoyStartPoints = [
    convoyOutroPos_0,
    convoyOutroPos_1,
    convoyOutroPos_2,
    convoyOutroPos_3,
    convoyOutroPos_4,
    convoyOutroPos_5,
    convoyOutroPos_6,
    convoyOutroPos_7,
    convoyOutroPos_8,
    convoyOutroPos_9,
    convoyOutroPos_10,
    convoyOutroPos_11,
    convoyOutroPos_12,
    convoyOutroPos_13,
    convoyOutroPos_14,
    convoyOutroPos_15,
    convoyOutroPos_16,
    convoyOutroPos_17,
    convoyOutroPos_18,
    convoyOutroPos_19,
    convoyOutroPos_20
];

reverse _convoyStartPoints;

private _startedVarName = "SH_convoyOutroStarted";
if (missionNamespace getVariable [_startedVarName,false]) exitWith { 
    systemChat "was already started - exiting";
};
missionNamespace setVariable [_startedVarName,true,true];


/*

*/

private _convoyVehicles = [
    "rnt_sppz_2a2_luchs_flecktarn",
    "rnt_sppz_2a2_luchs_flecktarn",
    "rnt_sppz_2a2_luchs_flecktarn",
    "rhsusf_m1a1hc_wd", 
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "Redd_Tank_Fuchs_1A4_Pi_Flecktarn",
    "Redd_Tank_Fuchs_1A4_Pi_Flecktarn",
    "Redd_Tank_Fuchs_1A4_Pi_Flecktarn",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd"
];

private _convoy = [];

{
    private _position = position (_convoyStartPoints select _forEachIndex);
    _position set [2,0.3];
    private _dir = getDir (_convoyStartPoints select _forEachIndex);

    private _veh = [_position,_dir,_x,west] call BIS_fnc_spawnVehicle;

    (_veh select 0) allowDamage false;

    _convoy pushBack (_veh select 0);
  
} forEach _convoyVehicles;

sleep 3;

{
    _x setDriveOnPath [(_x getPos [500, 90]), (_x getPos [5000, 90])];
    if (typeOf _x == "Redd_Tank_Fuchs_1A4_Pi_Flecktarn") then {
        _x setSpeedMode "FULL";
        _x limitSpeed 20;
    } else {
        _x setSpeedMode "FULL";
        _x limitSpeed 50;
    };
    
    (group _x) setBehaviour "AWARE";
    (group _x) setCombatMode "BLUE";
    _x disableAI "AUTOTARGET";
    _x disableAI "TARGET";
} forEach _convoy;


private _startHeli1 = getPos outroHeli1Start;
_startHeli1 set [2,60];
private _startHeli2 = getPos outroHeli2Start;
_startHeli2 set [2,60];
private _startHeli3 = getPos outroHeli3Start;
_startHeli3 set [2,60];

private _heli1 = ([_startHeli1, getDir outroHeli1Start,"RHS_UH1Y_UNARMED",west] call BIS_fnc_spawnVehicle) select 0;
private _heli2 = ([_startHeli2, getDir outroHeli2Start,"RHS_AH1Z",west] call BIS_fnc_spawnVehicle) select 0;
private _heli3 = ([_startHeli3, getDir outroHeli3Start,"RHS_UH1Y_UNARMED",west] call BIS_fnc_spawnVehicle) select 0;

_heli1 flyInHeight 50;
_heli2 flyInHeight 50;
_heli3 flyInHeight 50;
(group _heli1) addWaypoint [(getPos outroHeli1End), 0];
(group _heli2) addWaypoint [(getPos outroHeli2End), 0];
(group _heli3) addWaypoint [(getPos outroHeli3End), 0];

sleep 10;

[[_heli3],"USER\scripts\outro.sqf"] remoteExec ["BIS_fnc_execVM", [0, -2] select isDedicated];