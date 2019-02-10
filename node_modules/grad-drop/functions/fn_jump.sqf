#include "..\component.hpp"

params ["_units"];

if (!hasInterface) exitWith {};
if !(player in _units) exitWith {};

player allowdamage false;


[{(toLower animationState player) in ["halofreefall_non","halofreefall_f","halofreefall_b"]}, {
    
    

    _this spawn {
        params ["_units","_plane","_onLanding"];
        _v1 = (random 20) + 70;
        _v1 = (getDir _plane) + (round (random 20) - 10);

        player setVariable ["GRAD_drop_dropstart", true];
        resetCamShake;
        player setVelocity [_v1 * (sin _v1), _v1 * (cos _v1), -15 ];
        addCamShake [50, 25, 10];
        playSound "grad_drop_wind1";
        addCamShake [20, 10, 10];
        addCamShake [10, 20,  5];

        sleep 2;
        private _chute = createVehicle ['rhs_d6_Parachute', position Player,[],0,'Fly'];
        _chute setPos position player;
        player moveIndriver _chute; 
        _chute allowDamage false;

        hideObject _plane;       

        player setVariable ["GRAD_drop_dropped", true];
        resetCamShake;
        playSound "grad_drop_openChute1";
        34 cutText ["", "BLACK IN", 2];
        addCamShake [75, 5, 5];

        playSound "grad_drop_grunt";
        playSound "grad_drop_openChute2";

        addCamShake [5,  5,  2];

        setAperture 0.05;
        setAperture -1;
        "DynamicBlur" ppEffectEnable true;
        "DynamicBlur" ppEffectAdjust [8.0];
        "DynamicBlur" ppEffectCommit 0.01;

        sleep 1;

        "DynamicBlur" ppEffectAdjust [0.0];
        "DynamicBlur" ppEffectCommit 3;

        sleep 3;

        "DynamicBlur" ppEffectEnable false;
        "RadialBlur" ppEffectAdjust [0.0, 0.0, 0.0, 0.0];
        "RadialBlur" ppEffectCommit 1.0;
        "RadialBlur" ppEffectEnable false;

        playSound "grad_drop_heartbeat";


        while {(getPos player select 2) > 8} do {
            playSound "grad_drop_paraPilot";
            addCamShake [2, 3.5, 1];
            sleep 4;
        };

        playSound "grad_drop_openChute1";
        resetCamShake;

        call _onLanding;
       
    };
}, _this,900,{player allowDamage true}] call CBA_fnc_waitUntilAndExecute;
