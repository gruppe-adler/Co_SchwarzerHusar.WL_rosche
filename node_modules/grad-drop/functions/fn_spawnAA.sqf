params ["_position", "_delay", "_strength", "_plane"];

if (player getVariable ["GRAD_drop_dropstart", false]) exitWith {};
if (player distance _plane > 60) exitWith {};

resetCamShake;
"SmallSecondary" createVehicleLocal _position;
addCamShake [_strength, _delay, 25];