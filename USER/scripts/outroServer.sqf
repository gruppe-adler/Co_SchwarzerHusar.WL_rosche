private _startPos1 = getMarkerPos "mrk_outro_spawn1";

private _endPos1 = getMarkerPos "mrk_outro_target1";
private _endPos2 = getMarkerPos "mrk_outro_target2";

private _group = createGroup west;
private _type = "gm_ge_army_crew_mp2a1_80_oli";

_group setCombatMode "BLUE";
_group setBehaviour "CARELESS";
_group setSpeedMode "FULL";




for "_i" from 0 to 30 do {

    private _unit = _group createUnit [_type, _startPos1, [], 3, "NONE"];
    
    _unit setAnimSpeedCoef 1; // todo change to slowmo later
    _unit setUnitPos "UP";
    _unit disableAI "AUTOCOMBAT";
    _unit disableAI "TARGET";
    _unit disableAI "AUTOTARGET";
    _unit disableAI "SUPPRESSION";
    _unit disableAI "COVER";
    _unit setBehaviour "AWARE";
    _unit setSpeedMode "FULL";

    _unit addEventHandler ["AnimChanged", 
    {
        params ["_unit", "_anim"];
        if (_anim == "AmovPercMrunSnonWnonDf") then {_unit playmove "AmovPercMevaSnonWnonDf"};
        if (_anim == "AmovPercMrunSnonWnonDfl") then {_unit playmove "AmovPercMevaSnonWnonDfl"};
        if (_anim == "AmovPercMrunSnonWnonDfr") then {_unit playmove "AmovPercMevaSnonWnonDfr"};
    }];

    sleep 0.5;
};

private _wp = _group addWaypoint [_endPos1, 0];
_group setCurrentWaypoint [_group, 0];

outro_alarm = true;
publicVariable "outro_alarm";

["USER\scripts\outro.sqf"] remoteExec ["BIS_fnc_execVM", [0,-2] select isDedicated];