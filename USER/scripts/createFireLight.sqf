params ["_fire", "_pos"];

private _brightness    = 1.0;
private _color        = [1,0.85,0.6];
private _ambient    = [1,0.3,0];
private _intensity    = 1600;
private _attenuation    = [0,0,0,1.6];

private _pos   = [_pos select 0,_pos select 1,(_pos select 2)+1];
private _light = createVehicle ["#lightpoint", _pos, [], 0, "CAN_COLLIDE"];
//_light setPosATL _pos;
_light attachto [_fire, [0,0,-1]];
_light setLightBrightness _brightness;
_light setLightColor _color;
_light setLightAmbient _ambient;
_light setLightIntensity _intensity;
_light setLightAttenuation _attenuation;
_light setLightDayLight false;

[{
    params ["_fire", "_light"];
    isNull _fire
},{
    params ["_fire","_light"];
    deleteVehicle _light;
}, [_fire, _light]] call CBA_fnc_waitUntilAndExecute;