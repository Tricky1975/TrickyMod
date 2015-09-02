# Known issue: Conflicts with MaxGUI4GALE module

It is an known issue that the modified version of MaxLua, one of the key elements of GALE can show trouble when compiling due to conflicts with the original MaxLua.
Don't go erase the original MaxLua. If this happens, make sure you include the "-a" option when you compile from the command line or when you do it from the IDE choose "Rebuild _all_ modules".

This will (unfortunately) rebuild _all_ modules within BlitzMax and therefore take a lot more time, but it will rebuild the module without any trouble.

Any bug reports in the issue tracker regarding this matter will be closed immediately (and when you persist I've no choice but to ban you from my repositories), UNLESS you have a proper solution to deal with this matter, making sure it will belong to the past.
