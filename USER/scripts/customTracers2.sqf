params ["_position"];



if (isserver) then {

    if (typeName _position == "OBJECT") then {
        _position = getPos _position;
    };  

    private _dummy = "Land_HelipadEmpty_F" createVehicle _position;

    private _sideID = (_dummy getvariable ["Side","0"]) call BIS_fnc_parseNumberSafe;
    private _side = _sideID call bis_fnc_sideType;
    private _min = (_dummy getvariable ["Min","10"]) call BIS_fnc_parseNumberSafe;
    private _max = (_dummy getvariable ["Max","20"]) call BIS_fnc_parseNumberSafe;
    private _max = _max - _min;

    private _weapon = (_dummy getVariable ["Weapon",""]);
    private _magazine = toLower (_dummy getVariable ["Magazine",""]);
    private _target = call compile (_dummy getVariable ["Target",""]);

    if(isNil "_target")then{_target = objNull};

    if(_weapon != "" )then
    {
        // Validate weapon
        private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
        if(!isClass _weaponCfg)exitWith
        {
            if (_weapon != "") then {["'%1' not found in CfgWeapons",_weapon] call bis_fnc_error;};
        };
        private _compatibileMagazine = [_weapon] call bis_fnc_compatibleMagazines;
        // Automatically add first compatibile magazine
        if(_magazine == "")then
        {
            if(_compatibileMagazine isEqualTo [])exitWith
            {
                if (_weapon != "") then {["'%1' doesn't have any valid magazines",_weapon] call bis_fnc_error;};
            };
            _magazine = _compatibileMagazine # 0;
        }else
        {
            // Validate magazine manually selected magazine
            if(! (_magazine in _compatibileMagazine) )exitWith
            {
                if (_magazine != "") then {["'%1' is not compatible with '%2'",_magazine,_weapon] call bis_fnc_error;};
            };
        };
    }else
    {
        _weapon = "FakeWeapon_moduleTracers_F";
        _magazine = (["200Rnd_65x39_belt_Tracer_Green","200Rnd_65x39_belt_Tracer_Red","200Rnd_65x39_belt_Tracer_Yellow"] select _sideID);
    };
    _gunner = createagent ["b_soldier_f",position _dummy,[],0,"none"];
    _gunner attachto [_dummy];
    _gunner setcaptive true;
    _gunner hideobjectGlobal true;
    _gunner allowDamage false;
    _gunner switchmove "amovpercmstpsraswrfldnon";
    _gunner disableai "anim";
    _gunner disableai "move";
    _gunner disableai "target";
    _gunner disableai "autotarget";
    _gunner setbehaviour "careless";
    _gunner setcombatmode "blue";
    removeallweapons _gunner;
    _gunner addmagazine _magazine;
    _gunner addweapon _weapon;
    _gunner selectweapon _weapon;
    _dummy setvariable ["bis_fnc_moduleTracers_gunner",_gunner,true];
    _gunner setVariable ["acex_headless_blacklist", true, true];

    private _vectorToTarget = [0,0,0];
    private _targetPos      = [0,0,0];
    private _dummyPos       = getPosASLVisual _dummy;
    private _dir            = 0;
    private _pitch          = 0;

    while {!isnull _gunner && !isnull _dummy} do {
            _delay = 0.05 + random 0.1;

            private _target = call compile (_dummy getVariable ["Target","objNull"]);
            if(isNil "_target")then{_target = objNull};

            // Sets vector to the target if it's specified
            if(!(_target isEqualTo objNull))then{
                // Refresh target
                if(_target isEqualType objNull)then
                {
                    _targetPos = getPosASLVisual _target;
                }else
                {
                    _targetPos = _target;
                };
                _vectorToTarget = _dummyPos vectorFromTo _targetPos;

                // Vector randomization
                _vectorToTarget = _vectorToTarget vectorAdd [random[-0.05,0,0.05],random[-0.05,0,0.05],random[-0.05,0,0.05]];
                _dummy setVectorDirAndUp [_vectorToTarget,_vectorToTarget vectorCrossProduct [-(_vectorToTarget # 1), _vectorToTarget # 0, 0]];
            }else
            {
                // Random firing (old behavior)
                _dir = -5 + random 10;
                _pitch = 30 + random 60;
                _gunner setdir (random 360);
                [_gunner,_pitch,0] call bis_fnc_setpitchbank;
            };

            sleep 0.1;
            _time = time + 0.1 + random 0.9;
            while {time < _time} do {
                // Restore ammo
                _gunner setAmmo [_weapon,999];
                [_gunner,_weapon] call BIS_fnc_fire;
                sleep _delay;

                if(!(_target isEqualTo objNull))then{
                    _vectorToTarget = _vectorToTarget vectorAdd [random[-0.05,0,0.05],random[-0.05,0,0.05],random[-0.05,0,0.05]];
                    _dummy setVectorDirAndUp [_vectorToTarget,_vectorToTarget vectorCrossProduct [-(_vectorToTarget # 1), _vectorToTarget # 0, 0]];
                }else{
                    _gunner setdir (direction _gunner + _dir);
                    [_gunner,_pitch,0] call bis_fnc_setpitchbank;
                };

                if (random 1 > 0.95) then {sleep (2 * _delay)};
            };
        sleep (_min + random _max);
    };
    deletevehicle _gunner;
    diag_log format ["deleted tracers at %1", _dummyPos];
};