params ["_convoyID"];

private _identifier = format ["GRAD_convoy_vehicleList_%1", _convoyID];
private _convoyVehicles = missionNamespace getVariable [_identifier, []];

diag_log format ["breaking convoy %1 for vehicles %2", _convoyID, _convoyVehicles];

[_convoyVehicles, []] call GRAD_convoy_fnc_breakFormation;