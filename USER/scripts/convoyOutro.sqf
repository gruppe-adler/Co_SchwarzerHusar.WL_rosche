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
    convoyOutroPos_20,
    convoyOutroPos_21,
    convoyOutroPos_22
];

private _convoyMoveToPoints = [
    getPos convoyMoveToPos_0,
    getPos convoyMoveToPos_1,
    getPos convoyMoveToPos_2,
    getPos convoyMoveToPos_3,
    getPos convoyMoveToPos_4,
    getPos convoyMoveToPos_5,
    getPos convoyMoveToPos_6,
    getPos convoyMoveToPos_7,
    getPos convoyMoveToPos_8,
    getPos convoyMoveToPos_9,
    getPos convoyMoveToPos_10,
    getPos convoyMoveToPos_11,
    getPos convoyMoveToPos_12,
    getPos convoyMoveToPos_13,
    getPos convoyMoveToPos_14,
    getPos convoyMoveToPos_15,
    getPos convoyMoveToPos_16
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
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd", 
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
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

/*
(_convoy select 0) setDriveOnPath _convoyMoveToPoints;

{
    _x setDriveOnPath [(_convoyMoveToPoints select _forEachIndex)];
    _x limitSpeed 30;
} forEach _convoy;
*/

private _startHeli1 = getPos outroHeli1Start;
_startHeli1 set [2,60];
private _startHeli2 = getPos outroHeli2Start;
_startHeli2 set [2,60];
private _heli1 = ([_startHeli1, getDir outroHeli1Start,"RHS_UH1Y_UNARMED",west] call BIS_fnc_spawnVehicle) select 0; 
private _heli2 = ([_startHeli2, getDir outroHeli2Start,"RHS_AH1Z",west] call BIS_fnc_spawnVehicle) select 0; 



(group _heli1) addWaypoint [(getPos outroHeli1End), 0];
(group _heli2) addWaypoint [(getPos outroHeli2End), 0];

sleep 10;

[[],"USER\scripts\outro.sqf"] remoteExec ["BIS_fnc_execVM", [0, -2] select isDedicated];