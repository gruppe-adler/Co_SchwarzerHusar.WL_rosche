private _startPos1 = getMarkerPos "mrk_outro_spawn1";

private _endPos1 = getMarkerPos "mrk_outro_target1";
private _endPos2 = getMarkerPos "mrk_outro_target2";






for "_i" from 0 to 30 do {

    private _group = createGroup west;
    private _type = selectRandom ["gm_ge_army_crew_mp2a1_80_oli", "gm_ge_army_crew_mp2a1_80_oli", "gm_ge_army_crew_mp2a1_80_oli", "gm_ge_army_crew_mp2a1_80_oli", "gm_ge_army_officer_p1_80_oli"];

    _group setCombatMode "BLUE";
    _group setBehaviour "CARELESS";
    _group setSpeedMode "FULL";

    private _unit = _group createUnit [_type, _startPos1, [], 3, "NONE"];
    
    // _unit setAnimSpeedCoef 0.1; // todo change to slowmo later
    // [_unit, 0.1] remoteExecCall ["setAnimSpeedCoef", 0, false]; // slowmo everywhere?
    _unit setUnitPos "UP";
    _unit disableAI "AUTOCOMBAT";
    _unit disableAI "TARGET";
    _unit disableAI "AUTOTARGET";
    _unit disableAI "SUPPRESSION";
    _unit disableAI "COVER";
    _unit setBehaviour "AWARE";
    _unit setSpeedMode "FULL";
    removeAllWeapons _unit;

    _unit addEventHandler ["AnimChanged", 
    {
        params ["_unit", "_anim"];
        if (_anim == "AmovPercMrunSnonWnonDf") then {_unit playmove "AmovPercMevaSnonWnonDf"};
        if (_anim == "AmovPercMrunSnonWnonDfl") then {_unit playmove "AmovPercMevaSnonWnonDfl"};
        if (_anim == "AmovPercMrunSnonWnonDfr") then {_unit playmove "AmovPercMevaSnonWnonDfr"};
    }];

    // _unit doMove _endPos1;
    private _randomVehicle = selectRandom [outroTank1,outroTank2,outroTank3,outroTank4,outroTank5,outroTank6,outroTank7,outroTank8,outroTank9,outroTank10,outroTank11];
    _wp = _group addWaypoint [_randomVehicle,0];
    _wp  waypointAttachVehicle _randomVehicle;
    _wp setWaypointType "GETIN";

    sleep 0.5;
};



outro_alarm = true;
publicVariable "outro_alarm";

["USER\scripts\outro.sqf"] remoteExec ["BIS_fnc_execVM", [0,-2] select isDedicated];