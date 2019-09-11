params ["_thisVeh"];

private _breakConvoy = false;
// ensure convoy can always move, leading vehicle is first in array
if (!canMove _thisVeh || !alive _thisVeh || (count (_thisVeh call BIS_fnc_enemyTargets) > 0)) then {
    _breakConvoy = true;
    systemChat "breaking Convoy true";
    diag_log "breaking Convoy true";
};

_breakConvoy