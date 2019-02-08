
waitUntil {!isNull player};
waitUntil {  time > 3 };

{

  
    _x addEventHandler ["CuratorGroupPlaced", {
        params ["", "_group"];

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

    _x addEventHandler ["CuratorObjectPlaced", {
        params ["", "_object"];
        

        _object setSkill ["aimingShake", 0.2]; 
        _object setSkill ["aimingSpeed", 0.9]; 
        _object setSkill ["endurance", 0.6]; 
        _object setSkill ["spotDistance", 1]; 
        _object setSkill ["spotTime", 0.9]; 
        _object setSkill ["courage", 1]; 
        _object setSkill ["reloadSpeed", 1]; 
        _object setSkill ["commanding", 1];
        _object setSkill ["general", 1];

    }];

} forEach allCurators;


if (  
  isClass (configFile >> "CfgPatches" >> "achilles_modules_f_achilles")
) then
{
  // Note that the line below has to be uncommented if your mission is a Zeus Game Master mission.
  // TODO check if below is necessary to uncomment
  waitUntil {not isNil "ares_category_list"};

  ["SCHWARZER HUSAR", "Show Unit Count",
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

  }] call Ares_fnc_RegisterCustomModule;


  ["SCHWARZER HUSAR", "Init Halo Jump",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    [[],"USER\scripts\initHaloJump.sqf"] remoteExec ["BIS_fnc_execVM",0,false];

    systemChat "ZEUS debug: halo jump sequence started";

  }] call Ares_fnc_RegisterCustomModule; 


  ["SCHWARZER HUSAR", "Time Jump to Morning",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    // must be executed everywhere
    [[],"USER\scripts\timeJump.sqf"] remoteExec ["BIS_fnc_execVM",0,false];

    systemChat "ZEUS debug: Time Jump to morning started";

  }] call Ares_fnc_RegisterCustomModule;


  ["SCHWARZER HUSAR", "Spawn Convoy",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    [[],"USER\scripts\convoy.sqf"] remoteExec ["BIS_fnc_execVM",2,false];

    systemChat "ZEUS debug: Convoy spawned";

  }] call Ares_fnc_RegisterCustomModule;


   ["SCHWARZER HUSAR", "Spawn Enemy Group",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    [[_position],"USER\scripts\spawnGroup.sqf"] remoteExec ["BIS_fnc_execVM",2,false];

    systemChat "ZEUS debug: Group spawned";

  }] call Ares_fnc_RegisterCustomModule;


  ["SCHWARZER HUSAR - END MISSION", "END MISSION W OUTRO",
  {
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    [] execVM "USER\scripts\convoyOutro.sqf";

    systemChat "ZEUS debug: Outro started";

  }] call Ares_fnc_RegisterCustomModule;



   

};