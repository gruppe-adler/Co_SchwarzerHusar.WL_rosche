/*
    


*/

params ["_id", "_side"];

private _convoyID = _id; // missionNamespace getVariable ["GRAD_convoy_convoyCount", 0];
missionNamespace setVariable ["GRAD_convoy_convoyCount", (_convoyID + 1)];

private _vehicleDefinitions = [_id] call GRAD_convoy_fnc_getVehicleDefinitions;

_vehicleDefinitions params ["_waypoints", "_vehicles"];

if (count _vehicleDefinitions < 1) exitWith {
    systemChat "no convoy of this ID found";
};


private _convoy = [];
private _group = createGroup _side;

{   
    _x params ["_classname", "_position", "_dir"];

    private _position = call compile _position;
    private _dir = call compile _dir;

    private _vehParams = ([_position,_dir,_classname,_group] call BIS_fnc_spawnVehicle);
    _vehParams params ["_veh", "_crew"];

    // workaround for stuck tanks / vehicles with turrets / commanders
    // make driver the commanding one
    private _originalGroup = _group;
    private _commandfuckergroup = createGroup east;
    _crew joinSilent _commandfuckergroup;
    [driver _veh] joinSilent _originalGroup;

    _convoy pushBack _veh;


    [_veh, true] call BC_flagsOnVehicles_fnc_toggleFlag;

    if (typeOf _veh == "rhs_gaz66_ammo_msv") then {
        _veh addWeaponCargoGlobal ["rhs_weap_rpg7", 5];
        _veh addMagazineCargoGlobal ["rhs_rpg7_PG7V_mag", 10];
        _veh addMagazineCargoGlobal ["ATMine_Range_Mag", 10];
        _veh addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 6];
        _veh addMagazineCargoGlobal ["sfp_strvm5_mag", 6];
    };

    [_veh] call MissionControl_fnc_addKilledEH;
    
    if (typeOf _veh == "rhs_gaz66_msv"
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
} forEach _vehicles;




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

_convoy