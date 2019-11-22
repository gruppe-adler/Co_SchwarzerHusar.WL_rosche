/*
*   Wird zum Missionsstart auf Server und Clients ausgeführt.
*   Funktioniert wie die init.sqf.
*/
cutText ["","BLACK FADED",999];
STHud_UIMode = 0;
diwako_dui_main_toggled_off = true;

[] execVM "USER\scripts\addModules.sqf";

"mrk_lz_north" setMarkerAlphaLocal 0;
"mrk_lz_south" setMarkerAlphaLocal 0;
"mrk_lz_command" setMarkerAlphaLocal 0;

enableEnvironment [false, true];


// intro script
["CBA_loadingScreenDone", {
    STHud_UIMode = 0;
    diwako_dui_main_toggled_off = true;
    private _waitCondition = {time > (_this + 3)};

    [_waitCondition,{
        STHud_UIMode = 0;
        diwako_dui_main_toggled_off = true;
        [] execVM "USER\scripts\intro.sqf";
        cutText ["", "BLACK IN", 8];
    },time] call CBA_fnc_waitUntilAndExecute;

}] call CBA_fnc_addEventHandler;