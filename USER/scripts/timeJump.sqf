if (isServer) then {
    sleep 4;
    setDate [1989, 7, 8, 3, 5];

    private _vector = [0,5];
    [ _vector, markerDir "mrk_lz_north"] call BIS_fnc_rotateVector2D;
    _vector params ["_windX", "_windY"];
    setWind [_windX, _windY, true];

    setTimeMultiplier 1;
};

if (!hasInterface) exitWith {};

2 fadeSound 0;
cutText ["", "BLACK OUT", 2];

sleep 2;

// hint "moved into plane";
[["14/07/1984 - 4:00", 2, 4, 2], ["Morning dawns...", 3, 4, 2], ["...prepare your attack", 3, 4, 2]] spawn BIS_fnc_EXP_camp_SITREP;
sleep 4;
cutText ["", "BLACK IN", 4];
4 fadeSound 1;