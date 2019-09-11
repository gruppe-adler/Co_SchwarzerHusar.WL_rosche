params ["_thisVeh"];

private _breakConvoy = false;

private _cantMove = !canMove _thisVeh;
private _boom = !alive _thisVeh;
// private _enemiesSpotted = _thisVeh findNearestEnemy _thisVeh;

if (_cantMove) then {
    _breakConvoy = true;
    systemChat "breaking Convoy - cant move";
    diag_log "breaking Convoy - cant move";
};

if (_boom) then {
    _breakConvoy = true;
    systemChat "breaking Convoy - dead";
    diag_log "breaking Convoy - dead";
};

/*
if (_enemiesSpotted != objNull) then {
    // _breakConvoy = true;

    systemChat format ["breaking Convoy - enemies %1", _enemiesSpotted];
    diag_log ["breaking Convoy - enemies %1", _enemiesSpotted];
};
*/



_breakConvoy