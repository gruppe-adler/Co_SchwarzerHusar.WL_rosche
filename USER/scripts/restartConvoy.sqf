params ["_object", "_path"];


// systemChat str _path;


GRAD_convoyLight_fnc_healthCheck = {
    params ["_thisVeh", "_handle"];

    if (_thisVeh getVariable ["GRAD_convoyLoop", -1] < 0) exitWith {};

    // ensure convoy can always move, leading vehicle is first in array
    if (!canMove _thisVeh || !alive _thisVeh || _thisVeh getVariable ["GRAD_convoy_formationBroken", false]) exitWith {
        // [_convoyVehicles, _waypoints] call GRAD_convoy_fnc_breakFormation;
        // [_convoyID, _convoyVehicles, _thisVeh, _waypoints] call GRAD_convoy_fnc_removeVehicleFromConvoy;
        private _nodes = _thisVeh getVariable ["GRAD_convoyLight_debugNodes", []];
        [_thisVeh] join grpNull;

        {
          deleteVehicle _x;
        } forEach _nodes;

        [_handle] call CBA_fnc_removePerFrameHandler;
        _thisVeh setVariable ["GRAD_convoyLoop", -1];
        
    };
};


GRAD_convoyLight_fnc_createPathNodeDebug = {
    params ["_object", "_position"];

    private _nodes = _object getVariable ["GRAD_convoyLight_debugNodes", []];
    private _node = "Sign_Sphere200cm_F" createVehicle _position;
    _nodes pushBack _node;
    _object setVariable ["GRAD_convoyLight_debugNodes", _nodes];
};

// remove debug objects
private _nodes = _object getVariable ["GRAD_convoyLight_debugNodes", []];

{
  deleteVehicle _x;
} forEach _nodes;


_object removeAllEventHandlers "Deleted";

_object addEventHandler ["Deleted", {
    params ["_entity"];

    private _nodes = _entity getVariable ["GRAD_convoyLight_debugNodes", []];

    {
      deleteVehicle _x;
    } forEach _nodes;
}];


// remove running loops from previous orders
private _convoy = units group _object;

{
    private _handle = _x getVariable ["GRAD_convoyLoop", -1];

    if (_handle > -1) then {
        [_handle] call CBA_fnc_removePerFrameHandler;
        _x setVariable ["GRAD_convoyLoop", -1];
    };
} forEach _convoy;


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
_object forceFollowRoad true;


{
  [_object, _x] call GRAD_convoyLight_fnc_createPathNodeDebug;
} forEach _path;


for [{_i=0},{_i<count _convoy},{_i=_i+1}] do {

    // disable AI as we dont need it
    private _thisVeh = _convoy select _i;
    (driver _thisVeh) disableAI "FSM"; // safe some performance here
    // path planning necessary in first veh
    if (_i == 0) then {
        //   (driver _thisVeh) disableAI "PATH";   // potentially safe some performance here for following vehicles

        [{
            params ["_thisVeh", "_path"];

            _thisVeh setDriveOnPath _path;

        }, [_thisVeh, _path], 5] call CBA_fnc_waitAndExecute;
    };

    private _driver = driver _thisVeh;
    // _driver setCaptive true;
    
    // only driver maybe
    _driver setBehaviour "SAFE"; // to force lights off
    _driver setCombatMode "BLUE";  // disable him attacking
    _driver disableAi "autoCombat";
    _driver disableAI "TARGET";
    _driver disableAI "AUTOTARGET";
    
    _thisVeh setSpeedMode "FULL";
    _thisVeh setVariable ["GRAD_convoy_path", _path];
    

   

   
    // workaround/possible fix for vehicles stuck at beginning
    // lets them start with a delay
    [{  
        params ["_thisVeh", "_path"];

        speed _thisVeh > 10

    },{
        params ["_thisVeh", "_path"];

        private _vehicleBehind = _thisVeh getVariable ["GRAD_convoy_vehicleBehind", objNull];
        if (!isNull _vehicleBehind) then {
            [_path, getPos _thisVeh] call BIS_fnc_arrayUnShift;  
            _vehicleBehind setDriveOnPath _path;
            // systemChat "starting engines";
        };

    }, [_thisVeh, _path]] call CBA_fnc_waituntilAndExecute;


    private _handle = [{
        params ["_vehicles","_handle"];
        _vehicles params ["_thisVeh", "_path"];

        private _convoyVehicles = units (group _thisVeh);

        // remove vehicle from convoy if necessary
        [_thisVeh, _handle] call GRAD_convoyLight_fnc_healthCheck;

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

        
        private _pause = _thisVeh getVariable ["GRAD_convoyLight_isPaused", false];
        private _speedLimit = if (_pause) then { 0.001 } else { 
            [_thisVeh, _distFront, _distBack] call GRAD_convoy_fnc_getSpeedLimit 
        };


        // all fine, go rollin on path travelled from veh in front
        // private _path = _thisVeh getVariable ["grad_convoy_pathHistory", []];
        // _thisVeh setDriveOnPath _path;
        // _thisVeh setVariable ["GRAD_icons", _thisVeh getVariable ["grad_convoy_pathHistory", []]];
        _thisVeh limitSpeed _speedLimit;


    },0.2,[_thisVeh, _path]] call CBA_fnc_addPerFrameHandler;

    _thisVeh setVariable ["GRAD_convoyLoop", _handle];
};