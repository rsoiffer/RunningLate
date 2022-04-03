INCLUDE inventory.ink
INCLUDE interactions.ink
INCLUDE API.ink

-> prologue

=== prologue
#DIALOGUE
INSERT PROLOGUE TEXT OF SOME SORT.
* [Continue...]
  -> main_loop

=== main_loop
# MENU
// TODO List all possible object interactions here.
// Note: this should not be displayed to player, since we are in "menu mode"
MAIN LOOP
Can clean: {canCleanBlood()}
Has incriminating evidence: {hasIncriminatingEvidence()}
Pick an option:
+ [INTERACT("mechanic")] -> mechanic
+ [INTERACT("fireplace")] -> fireplace
+ [INTERACT("sink")] -> sink
+ [INTERACT("oven")] -> oven
+ [INTERACT("plant")] -> plant
+ [INTERACT("drawer")] -> drawer
-> main_loop



-> END