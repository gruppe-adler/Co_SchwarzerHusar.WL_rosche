2 fadeSound 0;
cutText ["", "BLACK OUT", 2];
sleep 2;


if (isServer) then {

        setDate [1989, 7, 8, 1, 0];


        {
                _x params ["_marker", "_identifier"];

                private _units = [];
                {
                   if (_x getVariable ["SH_LZ", ""] == _identifier) then {
                        _units pushBackUnique _x;
                   };
                } forEach allUnits;

                private _dir = markerDir _marker;
                private _height = 160;

                [_units, _marker, _dir, _height, 5, false, {
                    2 fadeSound 1;
                    // cutText ["", "BLACK IN", 2];

                    // hint "moved into plane";
                    [["17/04/1984 - 2:30", 2, 4, 2], ["After four hours flight", 3, 4, 2], ["near the LZ...", 4, 4, 2]] spawn BIS_fnc_EXP_camp_SITREP;
                    
                    [{
                        params ["_args", "_handle"];
                        if (player getVariable ["GRAD_drop_dropped", false]) exitWith {
                            [_handle] call CBA_fnc_removePerFrameHandler;
                            10 setfog [0,0,0];
                        };
                        0 setfog [0.9,0,0];
                    }, 0, []] call CBA_fnc_addPerFrameHandler;

                }, {
                    // hint "landed";
                }] call GRAD_drop_fnc_initHaloJump;

        } forEach [
            ["mrk_lz_north", "north"],
            ["mrk_lz_south", "south"],
            ["mrk_lz_command", "command"]
        ];

        private _vector = [0,2];
        [ _vector, markerDir "mrk_lz_north"] call BIS_fnc_rotateVector2D;
        _vector params ["_windX", "_windY"];
        setWind [_windX, _windY, true];

};