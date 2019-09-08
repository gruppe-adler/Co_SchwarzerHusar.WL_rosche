params ["_position"];

systemChat "blooo";

private _dummy = "rhsgref_cdf_btr70" createVehicle _position;

[[_dummy], "USER\scripts\customTracers.sqf"] remoteExec ["BIS_fnc_execVM", [0,-2] select isDedicated, true];

{
    private _curator = _x;          
    private _registered = curatorEditableObjects _curator;
    
    if !( _dummy in _registered ) then { _curator addCuratorEditableObjects [ [ _dummy ], true ]; };

} count allCurators;