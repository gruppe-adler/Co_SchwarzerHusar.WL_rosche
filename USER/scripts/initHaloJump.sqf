"mrk_lz_south" setMarkerAlphaLocal 0;
"mrk_lz_north" setMarkerAlphaLocal 0;

if (isServer) then {

        private _units = [];


        {
           if (_x getVariable ["SH_LZ", ""] == "north") then {
                _units pushBackUnique _x;
           };
        } forEach allUnits;

        private _dir = markerDir "mrk_lz_north";
        private _height = 300;


        setDate [1989, 7, 8, 1, 0];


        [_units, "mrk_lz_north", _dir, _height, 5, false, {
            
            // hint "moved into plane";
            [["17/04/1984 - 2:30", 2, 4, 2], ["After four hours flight", 3, 4, 2], ["somewhere over Germany...", 4, 4, 2]] spawn BIS_fnc_EXP_camp_SITREP;
            
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


        private _vector = [0,5];
        [ _vector, _dir ] call BIS_fnc_rotateVector2D;
        _vector params ["_windX", "_windY"];
        setWind [_windX, _windY, true];

};