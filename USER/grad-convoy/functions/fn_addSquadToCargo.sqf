params ["_vehicle"];

private _position = getPos _vehicle;

private _group = [ 
    _position, 
    side _vehicle, 
    (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry" >> "rhs_group_rus_msv_infantry_squad")
] call BIS_fnc_spawnGroup;

{
  _x assignAsCargo _vehicle;
  _x moveInCargo _vehicle;
  [_x] call MissionControl_fnc_addKilledEH;
} forEach units _group;

(units _group)