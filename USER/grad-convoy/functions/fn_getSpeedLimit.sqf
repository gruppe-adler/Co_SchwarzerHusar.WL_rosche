params ["_thisVeh", ["_distFront", -1], ["_distBack",-1]];

private _speed = 0;
// _thisVeh setFuel 1;

if (_distFront >= 0) then {
    if (_distFront < DISTANCE_EMERGENCY_BREAK) then {
        _speed = SPEED_HOLD;
        // _thisVeh setFuel 0;
    } else {
        if (_distFront < DISTANCE_BREAK_HEAVY) then {
            _speed = SPEED_BREAK_HEAVY;
        } else {
            if (_distFront < DISTANCE_BREAK_LIGHT) then {
                _speed = SPEED_BREAK_LIGHT;
            } else {
                if (_distFront > DISTANCE_MIN) then {
                    if (_distFront < DISTANCE_MAX) then {
                            _speed = SPEED_STEADY;
                        } else {
                            _speed = SPEED_GET_CLOSER;
                        }
                } else {
                    _speed = SPEED_INCREASE_DISTANCE;
                };
            };
        };
    };   
};

if (_distBack >= 0 && (_distFront == -1)) then {
    if (_distBack > DISTANCE_MIN*2) then {
        if (_distBack < DISTANCE_MAX*2) then {
                _speed = DISTANCE_BREAK_LIGHT;
            } else {
                _speed = SPEED_HOLD;
            }
    } else {
        _speed = SPEED_STEADY;
    };
};

_thisVeh setVariable ["GRAD_convoy_vehicleThinks", _speed];
_thisVeh setVariable ["GRAD_convoy_vehicleDistanceFront", _distFront];


_speed