
waitUntil {!isNull player};
waitUntil {  time > 3 };

{

  
    _x addEventHandler ["CuratorGroupPlaced", {
        params ["", "_group"];

        ["GRAD_missionControl_setServerAsOwner", [_group]] call CBA_fnc_serverEvent;

        { 
            _x setSkill ["aimingShake", 0.2]; 
            _x setSkill ["aimingSpeed", 0.9]; 
            _x setSkill ["endurance", 0.6]; 
            _x setSkill ["spotDistance", 1]; 
            _x setSkill ["spotTime", 0.9]; 
            _x setSkill ["courage", 1]; 
            _x setSkill ["reloadSpeed", 1]; 
            _x setSkill ["commanding", 1];
            _x setSkill ["general", 1];

        } forEach units _group;
    }];

    /*
    _x addEventHandler ["CuratorWaypointPlaced", {
        params ["_curator", "_group", "_waypointID"];
        
        if (_group getVariable ["Husar_frozenGroup", true]) then {

          private _units = curatorSelected select 0;
          private _newGroup = createGroup east;

          _units joinSilent _newGroup;
          _newGroup enableDynamicSimulation false;
          {
            _x forceSpeed -1;
          } forEach units _newGroup;

        };
    }];

    
    _x addEventHandler ["CuratorGroupDoubleClicked", {
        params ["_curator", "_group"];
        
        _group enableDynamicSimulation true;
        _group forceSpeed 0;
    }];
    */

} forEach allCurators;


  ["HUSAR - Debug", "Show Unit Count",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

     private _allCuratorUnits = [];
      {
        _allCuratorUnits pushback (getAssignedCuratorUnit _x);
      } forEach allCurators;


      private _west = west countSide allUnits;
      private _east = east countSide allUnits;
      private _civilian = civilian countSide allUnits;
      private _logic = sideLogic countSide allUnits;
      private _total = _west + _east + _civilian + _logic;

      private _string = str (parseText format ["unitcounts:<br/>
         west: %1<br/>
         east: %2<br/>
         civ: %3<br/>
         logic: %4<br/>
         total: %5", 
      _west,_east,_civilian,_logic,_total]);
      [_string] remoteExec ["systemChat", _allCuratorUnits, true];

  }] call zen_custom_modules_fnc_register;


  ["HUSAR - Missionsablauf", "Init Halo Jump",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    [[],"USER\scripts\initHaloJump.sqf"] remoteExec ["BIS_fnc_execVM",0,false];

    systemChat "ZEUS debug: halo jump sequence started";

  }] call zen_custom_modules_fnc_register; 


  ["HUSAR - Missionsablauf", "Time Jump to Morning",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    // must be executed everywhere
    [[],"USER\scripts\timeJump.sqf"] remoteExec ["BIS_fnc_execVM",0,false];

    systemChat "ZEUS debug: Time Jump to morning started";

  }] call zen_custom_modules_fnc_register;



  ["HUSAR - Spawn", "Spawn Convoy EAST",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    // [[],"USER\scripts\convoy.sqf"] remoteExec ["BIS_fnc_execVM",2,false];
    [0, east] remoteExec ["GRAD_convoy_fnc_startConvoy", 2, false];

    systemChat "ZEUS debug: Convoy EAST spawned";

  }] call zen_custom_modules_fnc_register;

  ["HUSAR - Spawn", "Spawn Convoy NORTH",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    // [[],"USER\scripts\convoy.sqf"] remoteExec ["BIS_fnc_execVM",2,false];
    [1, east] remoteExec ["GRAD_convoy_fnc_startConvoy", 2, false];

    systemChat "ZEUS debug: Convoy NORTH spawned";

  }] call zen_custom_modules_fnc_register;


   ["HUSAR - Spawn", "Spawn Enemy Group",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    _position = ASLToAGL _position;
    [[_position],"USER\scripts\spawnGroup.sqf"] remoteExec ["BIS_fnc_execVM",2,false];

    systemChat "ZEUS debug: Group spawned";

  }] call zen_custom_modules_fnc_register;


  ["HUSAR - Mission End", "END MISSION W OUTRO",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    ["USER\scripts\outroServer.sqf"] remoteExec ["BIS_fnc_execVM", 2];

    systemChat "ZEUS debug: Outro started";

  }] call zen_custom_modules_fnc_register;

  ["HUSAR - Stellungen", "Freeze Unit to Speed 0",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    _objectUnderCursor forceSpeed 0;

    systemChat "ZEUS debug: Forcespeed unit set to 0";

  }] call zen_custom_modules_fnc_register;

  ["HUSAR - Stellungen", "Un-Freeze / Un-Group Unit",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
  
    private _newGroup = createGroup east;
    _objectUnderCursor forceSpeed -1;
    [_objectUnderCursor] joinSilent _newGroup;

    [{
      params ["_newGroup", "_objectUnderCursor"];
      _newGroup enableDynamicSimulation false;
      [_objectUnderCursor, true] remoteExecCall ["enableSimulationGlobal", 2];
      systemChat "ZEUS debug: Forcespeed unit reset and taken from group";
    }, [_newGroup, _objectUnderCursor], 2] call CBA_fnc_waitAndExecute;  

  }] call zen_custom_modules_fnc_register;


  ["HUSAR - Tracers", "Add Custom Tracers",
  {
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    // systemChat str _position;
    _position = ASLToAGL _position;
    [[_position], "USER\scripts\customTracers2.sqf"] remoteExec ["BIS_fnc_execVM", [0,2] select isDedicated, true];
    
    // systemChat "ZEUS debug: tracers spawned";

  }] call zen_custom_modules_fnc_register;

["Custom Modules", "Cool Hint", {hint str _this}] call zen_custom_modules_fnc_register;