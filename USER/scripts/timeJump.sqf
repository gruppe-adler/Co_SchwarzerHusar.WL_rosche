if (isServer) then {
    sleep 4;
    setDate [1989, 7, 8, 3, 5];
};

if (!hasInterface) exitWith {};

2 fadeSound 0;
cutText ["", "BLACK OUT", 2];

sleep 2;

// hint "moved into plane";
[["17/04/1984 - 4:00", 2, 4, 2], ["Morning dawns...", 3, 4, 2], ["...prepare your attack", 3, 4, 2]] spawn BIS_fnc_EXP_camp_SITREP;
sleep 2;
cutText ["", "BLACK IN", 2];
2 fadeSound 1;