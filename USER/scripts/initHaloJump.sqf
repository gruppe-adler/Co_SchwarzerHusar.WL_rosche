if (isServer) then {

        {
                _x params ["_marker", "_identifier"];

                private _units = [];
                {
                   if (_x getVariable ["SH_LZ", ""] == _identifier) then {
                        _units pushBackUnique _x;
                   };
                } forEach allUnits;

                private _pos = getMarkerPos _marker;
                private _dir = markerDir _marker;
                private _height = 200;

                [_units, _pos, _dir, _height, 120, false, {
                    3 fadeSound 1;
                    // cutText ["", "BLACK IN", 2];

                    // hint "moved into plane";
                    [["14/07/1984 - 2:30", 2, 4, 2], ["After four hours flight", 3, 4, 2], ["near the LZ...", 4, 4, 2]] spawn BIS_fnc_EXP_camp_SITREP;
                    
                    [{
                        params ["_args", "_handle"];
                        if (player getVariable ["GRAD_drop_dropped", false]) exitWith {
                            [_handle] call CBA_fnc_removePerFrameHandler;
                            10 setfog [0,0,0];

                            // make night a bit brighter
                            [{
                                params ["_args", "_handle"];

                                if (sunOrMoon < 0.2) then {
                                    setAperture 4;
                                } else {
                                    setAperture -1;
                                    [_handle] call CBA_fnc_removePerFramehandler;
                                };
                                
                            }, 1, []] call CBA_fnc_addPerFrameHandler;
                        };
                        0 setfog [0.9,0,0];
                    }, 0, []] call CBA_fnc_addPerFrameHandler;

                }, {
                    enableCamShake false;
                    resetCamShake;

                    [{
                        player allowdamage true;
                    }, [], 15] call CBA_fnc_waitAndExecute;

                }, _identifier] call GRAD_drop_fnc_initHaloJump;

        } forEach [
            ["mrk_lz_north", "north"],
            ["mrk_lz_south", "south"],
            ["mrk_lz_command", "command"]
        ];

        sleep 3;
        setDate [1989, 7, 8, 1, 0];

        private _vector = [0,8];
        [ _vector, markerDir "mrk_lz_north"] call BIS_fnc_rotateVector2D;
        _vector params ["_windX", "_windY"];
        setWind [_windX, _windY, true];

};