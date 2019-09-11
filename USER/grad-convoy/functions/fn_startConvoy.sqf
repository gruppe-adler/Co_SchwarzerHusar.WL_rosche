/*

	// use unique IDs (number) to start!
	[0, west] call GRAD_convoy_fnc_startConvoy;
	
*/

params ["_convoyID", "_side"];
missionNamespace setVariable ["GRAD_convoyActive", _convoyID];

private _convoyParams = [_convoyID, _side] call GRAD_convoy_fnc_createConvoy;
_convoyParams params ["_waypointStrings", "_convoy"];

private _waypoints = [];
{
  _waypoints pushback (getPos (call compile _x));
} forEach _waypointStrings;

// store convoy in MNS to be able to remove vehicles out of it later on
private _identifier = format ["GRAD_convoy_vehicleList_%1", _convoyID];
missionNamespace setVariable [_identifier, _convoy];

for [{_i=0},{_i<count _convoy},{_i=_i+1}] do {

	// disable AI as we dont need it
	private _thisVeh = _convoy select _i;
    // (driver _thisVeh) disableAI "FSM"; // safe some performance here
    // path planning necessary in first veh
    if (_i == 0) then {
        //   (driver _thisVeh) disableAI "PATH";   // potentially safe some performance here for following vehicles

        [{
            params ["_thisVeh", "_waypoints"];

            _thisVeh setDriveOnPath _waypoints;

        }, [_thisVeh, _waypoints], 5] call CBA_fnc_waitAndExecute;
    };

    private _driver = driver _thisVeh;
    _driver setCaptive true;

    // only driver maybe
    _driver setBehaviour "SAFE"; // to force lights off
    _driver setCombatMode "BLUE";  // disable him attacking
    _driver disableAi "autoCombat";
    _driver disableAI "TARGET";
    _driver disableAI "AUTOTARGET";
    
    _thisVeh setSpeedMode "FULL";
    _thisVeh setVariable ["GRAD_convoy_path", _waypoints];
    

    // workaround/possible fix for vehicles stuck at beginning
    // lets them start with a delay
    [{  
        params ["_thisVeh", "_waypoints"];

        speed _thisVeh > 10

    },{
        params ["_thisVeh", "_waypoints"];

        private _vehicleBehind = _thisVeh getVariable ["GRAD_convoy_vehicleBehind", objNull];
        if (!isNull _vehicleBehind) then {
            [_waypoints, getPos _thisVeh] call BIS_fnc_arrayUnShift;  
            _vehicleBehind setDriveOnPath _waypoints;
            // systemChat "starting engines";
        };

    }, [_thisVeh, _waypoints]] call CBA_fnc_waituntilAndExecute;


    private _handle = [{
        params ["_vehicles","_handle"];
        _vehicles params ["_convoyID", "_thisVeh", "_waypoints"];

        private _vehicleListIdentifier = format ["GRAD_convoy_vehicleList_%1", _convoyID];
        private _convoyVehicles = missionNamespace getVariable [_vehicleListIdentifier, []];

        // remove vehicle from convoy if necessary
        private _breakConvoy = [_thisVeh] call GRAD_convoy_fnc_healthCheck;
        if (_breakConvoy) exitWith {
            systemChat format ["breaking formation init %1", _convoyVehicles];
            diag_log format ["breaking formation init %1", _convoyVehicles];
            {
                systemChat format ["breaking formation init2 %1", _forEachIndex];
                [_x, _forEachIndex] call GRAD_convoy_fnc_breakFormation;
            } forEach _convoyVehicles;
        };

        private _firstVehicle = _convoyVehicles select 0;
        private _vehicleInFront = _thisVeh getVariable ["GRAD_convoy_vehicleInFront", objNull];
        private _vehicleBehind = _thisVeh getVariable ["GRAD_convoy_vehicleBehind", objNull];

        private _distFront = -1;
        private _distBack = -1;

        if (!isNull _vehicleInFront) then {
        	_distFront = _thisVeh distance _vehicleInFront;          
        };

        if (!isNull _vehicleBehind) then {
            _distBack = _thisVeh distance _vehicleBehind;
        };

        private _identifier = format ["GRAD_convoy_%1_pause", _convoyID];
        private _pause = missionNamespace getVariable [_identifier, false];
        private _speedLimit = if (_pause) then { 0.001 } else { 
            [_thisVeh, _distFront, _distBack] call GRAD_convoy_fnc_getSpeedLimit 
        };

        _thisVeh limitSpeed _speedLimit;


    },0.2,[_convoyID, _thisVeh, _waypoints]] call CBA_fnc_addPerFrameHandler;

    _thisVeh setVariable ["GRAD_convoy_loop", _handle];
};