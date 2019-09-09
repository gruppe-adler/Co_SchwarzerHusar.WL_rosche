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
  _waypoints pushback (call compile _x);
} forEach _waypointStrings;

// store convoy in MNS to be able to remove vehicles out of it later on
private _identifier = format ["GRAD_convoy_vehicleList_%1", _convoyID];
missionNamespace setVariable [_identifier, _convoy];

// debug
/*
addMissionEventHandler ["Draw3D", {
    private _id = missionNamespace getVariable ["GRAD_convoyActive", 0];
    private _vehicles = missionNamespace getVariable [format ["GRAD_convoy_vehicleList_%1", _id], objNull];
    
    {
        private _iconpositions = _x getVariable ["GRAD_icons", [[0,0,0]]];
        {
            drawIcon3D ["\A3\ui_f\data\map\markers\military\dot_CA.paa", [1,1,1,1], _x, 1, 1, 45, "", 1, 0.05, "TahomaB"];
        } forEach _iconpositions;
        private _holds = _x getVariable ["GRAD_convoy_vehicleThinks", 0];
        private _distance = round (_x getVariable ["GRAD_convoy_vehicleDistanceFront", -1]);
        private _speed = round speed _x;
        drawIcon3D ["\A3\ui_f\data\map\markers\military\dot_CA.paa", [1,1,1,0.8], getPos _x, 1, 1, 45, (str _speed + " | " + str _holds + " | " + str _distance), 1, 0.05, "TahomaB"];
    } forEach _vehicles;
}];
*/

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

    
    // only driver maybe
    _thisVeh setBehaviour "SAFE"; // to force lights off
    _thisVeh setCombatMode "BLUE";  // disable him attacking
    _thisVeh disableAi "autoCombat";
    _thisVeh disableAI "TARGET";
    _thisVeh disableAI "AUTOTARGET";
    
    _thisVeh setSpeedMode "FULL";
    _thisVeh setVariable ["GRAD_convoy_path", _waypoints];
    

    private _driver = driver _thisVeh;
    _driver setCaptive true;

    /*    
    {
        _x setBehaviour "SAFE"; // to force lights off
        _x setCombatMode "BLUE";  // disable him attacking
        _x disableAi "autoCombat";
        _x disableAI "TARGET";
        _x disableAI "AUTOTARGET";
        _x setSpeedMode "FULL";
    } forEach crew _thisVeh;
    */
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


    [{
        params ["_vehicles","_handle"];
        _vehicles params ["_convoyID", "_thisVeh", "_waypoints"];

        private _vehicleListIdentifier = format ["GRAD_convoy_vehicleList_%1", _convoyID];
		private _convoyVehicles = missionNamespace getVariable [_vehicleListIdentifier, _convoy];

        // remove vehicle from convoy if necessary
        [_convoyID, _convoyVehicles, _thisVeh, _waypoints, _handle] call GRAD_convoy_fnc_healthCheck;

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
        private _speedLimit = if (_pause) then { 0.001 } else { [_thisVeh, _distFront, _distBack] call GRAD_convoy_fnc_getSpeedLimit };


        // all fine, go rollin on path travelled from veh in front
        // private _path = _thisVeh getVariable ["grad_convoy_pathHistory", []];
        // _thisVeh setDriveOnPath _path;
        // _thisVeh setVariable ["GRAD_icons", _thisVeh getVariable ["grad_convoy_pathHistory", []]];
        _thisVeh limitSpeed _speedLimit;


    },0.2,[_convoyID, _thisVeh, _waypoints]] call CBA_fnc_addPerFrameHandler;

    // record history path of each vehicle (experimental)
    /*
    [{
        params ["_args", "_handle"];
        _args params ["_convoyID", "_thisVeh"];
        
        private _vehicleListIdentifier = format ["GRAD_convoy_vehicleList_%1", _convoyID];
        private _convoyVehicles = missionNamespace getVariable [_vehicleListIdentifier, []];


        if (count _convoyVehicles < 1) exitWith {
            [_handle] call CBA_fnc_removePerFramehandler;
        };

        {   
            private _vehicleBehind = _thisVeh getVariable ["GRAD_convoy_vehicleBehind", objNull];
            if (!isNull _vehicleBehind) then {
                private _vehicleInFront = _thisVeh getVariable ["GRAD_convoy_vehicleInFront", objNull];
                private _pathHistory = _vehicleBehind getVariable ["grad_convoy_pathHistory", []];

                private _distanceToBehind = _thisVeh distance _vehicleBehind;
                if (count _pathHistory > 0) then {
                    private _pathBefore = _pathHistory select (count _pathHistory - 1);
                    if (_pathBefore distance _thisVeh > 1) then {
                        // here we can tweak curve behaviour a bit
                        _pathHistory pushBackUnique (_thisVeh getPos [0, _thisVeh getDir _vehicleBehind]);
                    };
                }  else {
                    private _position= (getPos _thisVeh);
                    _pathHistory pushBackUnique _position;
                };

                // should be about 20m
                if (count _pathHistory > _distanceToBehind) then {
                    _pathHistory deleteAt 0;
                };
                _vehicleBehind setVariable ["grad_convoy_pathHistory", _pathHistory];

            };
        } forEach _convoyVehicles;

    }, 0.2, [_convoyID, _thisVeh]] call CBA_fnc_addPerFrameHandler;
    */
};




// check for stuck vehicle (experimental)
/*
[{
    params ["_args", "_handle"];
    _args params ["_convoyID"];
    
    private _vehicleListIdentifier = format ["GRAD_convoy_vehicleList_%1", _convoyID];
    private _convoyVehicles = missionNamespace getVariable [_vehicleListIdentifier, []];

    if (count _convoyVehicles < 1) exitWith {
        [_handle] call CBA_fnc_removePerFramehandler;
    };

    {   
        [_x] call GRAD_convoy_fnc_checkForStuckVehicle;
    } forEach _convoyVehicles;

}, 3, [_convoyID]] call CBA_fnc_addPerFrameHandler;
*/