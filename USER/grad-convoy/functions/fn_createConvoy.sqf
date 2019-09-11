/*
	


*/

params ["_id", "_side"];

private _convoyID = _id; // missionNamespace getVariable ["GRAD_convoy_convoyCount", 0];
missionNamespace setVariable ["GRAD_convoy_convoyCount", (_convoyID + 1)];

private _vehicleDefinitions = [_id] call GRAD_convoy_fnc_getVehicleDefinitions;

_vehicleDefinitions params ["_waypointStrings", "_startPositions", "_classnames"];

if (count _vehicleDefinitions < 1) exitWith {
	systemChat "no convoy of this ID found";
};


private _convoy = [];
private _group = createGroup _side;

{   
    private _startPosition = _x;

    private _position = getPos (call compile _startPosition);
    private _dir = getDir (call compile _startPosition);

    private _vehParams = ([_position,_dir,(_classnames select _forEachIndex),_group] call BIS_fnc_spawnVehicle);
    _vehParams params ["_veh", "_crew"];

    // workaround for stuck tanks / vehicles with turrets / commanders
    // make driver the commanding one
    private _originalGroup = _group;
    private _commandfuckergroup = createGroup east;
    _crew joinSilent _commandfuckergroup;
    [driver _veh] joinSilent _originalGroup;

    _convoy pushBack _veh;
    _veh setVariable ["GRAD_convoy_vehicleNumber", _forEachIndex];

    // [_veh] call MissionControl_fnc_addKilledEH;
    
    if (typeOf _veh == "gm_gc_army_ural4320_cargo"
        ) then {
        [_veh] call GRAD_convoy_fnc_addSquadToCargo;
    };

    if (typeOf _veh == "rhs_gaz66_msv" ||
            typeOf _veh == "rhs_tigr_m_msv" ||
            typeOf _veh == "rhs_gaz66_ammo_msv" || 
            typeOf _veh == "RHS_Ural_Fuel_MSV_01" ||
            typeOf _veh == "RHS_BM21_MSV_01"
        ) then {
                _veh animateSource ['light_hide',1,true];
        };
} forEach _startPositions;




// cache vehicle in front and in back for easier access
{
    if (_forEachIndex > 0) then {
      _x setVariable ["GRAD_convoy_vehicleInFront", _convoy select (_forEachIndex - 1)];
    };

    if (_forEachIndex < ((count _convoy) - 1)) then {
      _x setVariable ["GRAD_convoy_vehicleBehind", _convoy select (_forEachIndex + 1)];
    };

} forEach _convoy;


_group setFormation "COLUMN";

[_waypointStrings, _convoy]