params ["_vehicle"];

private _position = getPos _vehicle;

private _group = [ 
    _position, 
    side _vehicle, 
    (configfile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_infantry" >> "gm_gc_army_infantry_squad_str")
] call BIS_fnc_spawnGroup;

{
  _x assignAsCargo _vehicle;
  _x moveInCargo _vehicle;
  // [_x] call MissionControl_fnc_addKilledEH;
} forEach units _group;

(units _group)