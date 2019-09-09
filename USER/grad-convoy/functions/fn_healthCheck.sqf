params ["_convoyID", "_convoyVehicles", "_thisVeh", "_waypoints", "_handle"];

// ensure convoy can always move, leading vehicle is first in array
if (!canMove _thisVeh || !alive _thisVeh || _thisVeh getVariable ["GRAD_convoy_formationBroken", false]) exitWith {
    // [_convoyVehicles, _waypoints] call GRAD_convoy_fnc_breakFormation;
    // [_convoyID, _convoyVehicles, _thisVeh, _waypoints] call GRAD_convoy_fnc_removeVehicleFromConvoy;
    [_handle] call CBA_fnc_removePerFrameHandler;
};

if (_convoyVehicles find _thisVeh < 0) exitWith {
    // delete loop for that vehicle
    [_handle] call CBA_fnc_removePerFrameHandler;
};