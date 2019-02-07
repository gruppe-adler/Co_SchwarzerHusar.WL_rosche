private _spawnVehicleLocal = compile preprocessFileLineNumbers "USER\scripts\spawnVehicleLocal.sqf";

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
missionNamespace setVariable [_startedVarName,true,true];

private _convoyVehicles = [
    "rhsgref_hidf_m113a3_unarmed",
    "rhsusf_m1045_w_s",
    "rhsusf_m998_w_s_2dr_fulltop",
    "rhsusf_m1043_w_s_m2", 
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsusf_m1a1hc_wd",
    "rhsgref_hidf_m113a3_unarmed",
    "rhsusf_m1045_w_s",
    "rhsusf_m998_w_s_2dr_fulltop",
    "rhsusf_m1043_w_s_m2"
];

private _convoy = [];

{
    private _position = position (_convoyStartPoints select _forEachIndex);
    _position set [2,0.3];
    private _dir = getDir (_convoyStartPoints select _forEachIndex);

    private _veh = [_position,_dir,_x,west] call BIS_fnc_spawnVehicle;

    _veh allowDamage false;

    _convoy pushBack (_veh select 0);
  
} forEach _convoyVehicles;

sleep 3;

(_convoy select 0) setDriveOnPath _convoyMoveToPoints;

for [{_i=0},{_i<count _convoy},{_i=_i+1}] do {
    [{
        params ["_vehicles","_handle"];
        _vehicles params ["_leader","_thisVeh","_follower","_vehicle1"];

        if (isNull (driver _vehicle1) && {speed _thisVeh < 1}) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        private _distFront = _thisVeh distance _leader;
        private _distBack = _thisVeh distance _follower;

        if (!isNull _leader) then {
            if (_distFront < 5) then {
                _thisVeh limitSpeed 0.5;
            } else {
                _thisVeh setDriveOnPath [getPos _thisVeh,_thisVeh getPos [0.8 * _distFront,_thisVeh getDir _leader]];
                private _speedLimit = if (_distFront > 15) then {if (_distFront < 20) then {30} else {34}} else {26};
                _thisVeh limitSpeed _speedLimit;
            };
        };

        if (!isNull _follower && {_distBack > 50}) then {
            _thisVeh limitSpeed 0.5;
        } else {
            if (isNull _leader) then {
                _thisVeh limitSpeed 30;
            };
        };

    },0.5,[_convoy param [_i-1,objNull],_convoy select _i,_convoy param [_i+1,objNull]],_convoy select 0] call CBA_fnc_addPerFrameHandler;
};


["USER\scripts\convoyOutro.sqf"] remoteExec ["BIS_fnc_execVM", [0, -2] select isDedicated];