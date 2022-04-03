INCLUDE inventory.ink
INCLUDE interactions.ink
INCLUDE API.ink

-> prologue

=== prologue
You are Augustin DuPont, the world-famous thief.
You find yourself aboard the <i>Imperial Limited</i>, where secret plans for an innovative airship are being transported to Vancouver under lock and key.
A secretive patron has promised to pay you handsomely for these plans.
* [Continue...]
  -> main_loop

=== main_loop
# MENU
// TODO List all possible object interactions here.
// Note: this should not be displayed to player, since we are in "menu mode"
//MAIN LOOP
//Can clean: {canCleanBlood()}
//Has incriminating evidence: {hasIncriminatingEvidence()}
{prettyPrintInventory()}
{prettyPrintObjectives()}
Pick an option:
+ [INTERACT("safe")] -> safe
+ [INTERACT("guard")] -> guard
+ [INTERACT("mechanic")] -> mechanic
+ [INTERACT("fireplace")] -> fireplace
+ [INTERACT("sink")] -> sink
+ [INTERACT("oven")] -> oven
+ [INTERACT("plant")] -> plant
+ [INTERACT("drawer")] -> drawer
-> main_loop


=== game_over ===
TODO INSERT SOME GAME OVER NARRATION / WIN CONDITION / LOSE CONDITION

-> END