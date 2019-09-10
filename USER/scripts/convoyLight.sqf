params ["_object"];

systemchat str _object;

(driver _object) addEventHandler ["PathCalculated", { 
    params ["_unit", "_path"];
    // systemchat str _path;
    [vehicle _unit, _path] execVM "USER\scripts\restartConvoy.sqf";
}];