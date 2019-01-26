# GRAD Drop

## Dependencies
* [CBA_A3](https://github.com/CBATeam/CBA_A3)
* [CUP Terrains Core (or Complete)](http://www.armaholic.com/page.php?id=30044)

## Installation
### Manually
1. Create a folder in your mission root folder and name it `modules`. Then create one inside there and call it `grad-drop`.
2. Download the contents of this repository ( there's a download link at the side ) and put it into the directory you just created.
3. Append the following lines of code to the `description.ext`:

```sqf
class CfgFunctions {
    #include "modules\grad-drop\cfgFunctions.hpp"
};

class CfgSounds {
	sounds[] = {};
    #include "modules\grad-drop\cfgSounds.hpp"
};
```

### Via `npm`
_for details about what npm is and how to use it, look it up on [npmjs.com](https://www.npmjs.com/)_

1. Install package `grad-drop` : `npm install --save grad-drop`
2. Prepend your mission's `description.ext` with `#define MODULES_DIRECTORY node_modules`
3. Append the following lines of code to the `description.ext`:

```sqf
class CfgFunctions {
    #include "node_modules\grad-drop\cfgFunctions.hpp"
};

class CfgSounds {
	sounds[] = {};
    #include "node_modules\grad-drop\cfgSounds.hpp"
};
```
