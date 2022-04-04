INCLUDE inventory.ink
INCLUDE interactions.ink
INCLUDE API.ink

-> prologue

=== prologue
You are Augustin DuPont, the world-famous thief.
In the winter of 1932 you find yourself traveling in luxury aboard <i>The Imperial Limited</i>, where proprietary plans for an innovative hydrogen airship are being transported to Vancouver under lock and key.
A secretive patron has promised to pay you handsomely for these plans.
* [Continue...]
  -> main_loop

=== main_loop
# MENU
// Note: this should not be displayed to player, since we are in "menu mode"
menu
//{"Inventory: " + prettyPrintInventory()}
{"Objectives: " + prettyPrintObjectives()}
Available interactions:
+ [INTERACT("safe")] -> safe
+ [INTERACT("guard")] -> guard
+ [INTERACT("mechanic")] -> mechanic
+ [INTERACT("inventor")] -> inventor
+ [INTERACT("hunter")] -> hunter
+ [INTERACT("magnate")] -> magnate
+ [INTERACT("novelist")] -> novelist
+ [INTERACT("student")] -> student

+ [INTERACT("fireplace")] -> fireplace
+ [INTERACT("sink")] -> sink
+ [INTERACT("oven")] -> oven
+ [INTERACT("plant")] -> plant
+ [INTERACT("drawer")] -> drawer
+ [INTERACT("table")] -> table
-> main_loop


=== game_over ===
TODO INSERT SOME GAME OVER NARRATION / WIN CONDITION / LOSE CONDITION

-> END