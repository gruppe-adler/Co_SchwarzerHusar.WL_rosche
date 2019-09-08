diwako_dui_main_toggled_off = true;

["BlackAndWhite", 0, false] call BIS_fnc_setPPeffectTemplate;

userTexture1 setObjectTexture [0, "data\intro1.paa"];
userTexture2 setObjectTexture [0, "data\intro2.paa"];
userTexture3 setObjectTexture [0, "data\intro3.paa"];

playMusic "LeadTrack02_F_Tank";

cutText ["", "BLACK IN", 8];

[player, "amovpercmstpslowwrfldnon"] remoteExec ["switchMove", 0];

_filmgrain = ppEffectCreate ["FilmGrain",2000];  
_filmgrain ppEffectEnable true;  
_filmgrain ppEffectAdjust [0.3,0.3,0.12,0.12,0.12,true];  
_filmgrain ppEffectCommit 0;


_camera = "camera" camCreate (position camPos0);
_camera camSetPos (position camPos0);
_camera camCommand "inertia on";
_camera camSetTarget camTarget0;
_camera cameraEffect ["internal","back"];
_camera camSetFov 0.15;
_camera camCommit 0;
_camera camSetPos (position camPos1);
_camera camSetTarget camTarget1;
_camera camCommit 20;
sleep 20;
_camera camSetPos (position camPos2);
_camera camSetTarget camTarget2;
_camera camCommit 10;
sleep 10;
_camera camSetPos (position camPos3);
_camera camSetTarget camTarget3;
_camera camCommit 10;
["Default", 18, false] call BIS_fnc_setPPeffectTemplate;
sleep 15;
_camera camCommand "inertia on";
_camera camSetTarget player;
_camera camCommit 3;
sleep 1;
_camera camSetPos [getPos player select 0, getPos player select 1, 1.7];
_camera camCommit 5;
sleep 3;
cutText ["", "BLACK OUT", 1];
sleep 1;
_filmgrain ppEffectEnable false;   
ppEffectDestroy _filmgrain; 
_camera cameraEffect ["terminate","back"];
camDestroy _camera;
sleep 1;
cutText ["", "BLACK IN", 1];


cutText ["","BLACK FADED",999];
sleep 3;

userTexture1 setObjectTexture [0, ""];
userTexture2 setObjectTexture [0, ""];
userTexture3 setObjectTexture [0, ""];

cutText ["", "BLACK IN", 10];

sleep 5;

7 fadeMusic 0.25;
STHud_UIMode = 1;
[player, "amovpercmstpslowwrfldnon"] remoteExec ["switchMove", 0];
diwako_dui_main_toggled_off = false;