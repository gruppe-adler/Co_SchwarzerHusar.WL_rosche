params ["_plane", "_selectionposition"];

private _position = _plane modelToWorld _selectionposition;
private _positionBehindPlane = _plane getRelPos [500, 180];


"Sign_Arrow_Pink_F" createVehicle _position;
"Sign_Arrow_Yellow_F" createVehicle _positionBehindPlane;


private _vector = _positionBehindPlane vectordiff _position;
_vector vectorMultiply 10;

private _source = "#particlesource" createVehicleLocal [0, 0, 0];  
_source setPos _position;  
_source setParticleCircle [0, [0, 0, 0]];  
_source setParticleRandom [0, [0.1, 0.1, 0], [0, 0, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];  
_source setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02", 8, 3, 1], "", "Billboard", 1, 4, [0, 0, 0], _vector, 0, 0.1, 0, 0.5, [2, 2.5, 3], [[0.1, 0.1, 0.1, 0.5], [1, 1, 1, 0], [1, 1, 1, 0]], [0.125], 1, 0, "", "", _plane];

_source setDropInterval 0.005;

_source