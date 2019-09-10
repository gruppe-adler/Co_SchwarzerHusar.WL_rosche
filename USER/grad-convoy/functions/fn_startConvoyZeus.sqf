/*

    // use unique IDs (number) to start!
    [0, west] call GRAD_convoy_fnc_startConvoy;
    
*/

params ["_object"];
private _convoyID = missionNamespace getVariable ["GRAD_convoy_convoyCount", 0];
_convoyID = (_convoyID + 1);
missionNamespace setVariable ["GRAD_convoy_convoyCount", _convoyID];
missionNamespace setVariable ["GRAD_convoyActive", _convoyID];

private _convoy = units group _object;

private _agent = objNull;
isNil { 
    _agent = calculatePath ["wheeled_APC","careless",position _object,[12782.8,6950.55,0]] addEventHandler ["PathCalculated", { 
    (_this select 0) setVariable ["GRAD_convoy_pathCalculated", _this select 1];
    }] 
};
private _waypoints = _agent getVariable ["GRAD_convoy_pathCalculated", []];

[{
    count (_this select 0) > 0
},{
    
    // cache vehicle in front and in back for easier access
    {
        if (_forEachIndex > 0) then {
          _x setVariable ["GRAD_convoy_vehicleInFront", _convoy select (_forEachIndex - 1)];
        };

        if (_forEachIndex < ((count _convoy) - 1)) then {
          _x setVariable ["GRAD_convoy_vehicleBehind", _convoy select (_forEachIndex + 1)];
        };

    } forEach _convoy;


    (group _object) setFormation "COLUMN";

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
    };
}, [_waypoints]] call CBA_fnc_waituntilAndExecute;