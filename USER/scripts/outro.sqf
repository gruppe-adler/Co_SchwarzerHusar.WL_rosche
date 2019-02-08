cutText ["", "BLACK IN", 8];

_filmgrain = ppEffectCreate ["FilmGrain",2000];  
_filmgrain ppEffectEnable true;  
_filmgrain ppEffectAdjust [0.3,0.3,0.12,0.12,0.12,true];  
_filmgrain ppEffectCommit 0;


_camera = "camera" camCreate (position camOutroPos0);
_camera camSetPos (position camOutroPos0);
_camera camCommand "inertia off";
_camera camSetTarget camOutroTarget0;
_camera cameraEffect ["internal","back"];
_camera camSetFov 0.6;
_camera camCommit 0;
_camera camSetPos (position camOutroPos1);
_camera camSetTarget camOutroTarget1;
_camera camCommit 5;
sleep 5;
["BlackAndWhite", 30, false] call BIS_fnc_setPPeffectTemplate;
_camera camSetTarget camOutroTarget2;
_camera camCommit 2;
_camera camSetPos (position camOutroPos2);
_camera camSetFov 0.3;
_camera camCommit 20;
sleep 20;
_camera camSetPos (position camOutroPos3);
_camera camSetTarget camOutroTarget3;
_camera camSetFov 0.7;
_camera camCommit 10;
sleep 10;
cutText ["", "BLACK OUT", 10];
sleep 13;
["END1", true, 0, false, true] spawn BIS_fnc_endMission;