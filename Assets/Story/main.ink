INCLUDE inventory.ink
INCLUDE interactions.ink

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
+ {nearby("mechanic")} [INTERACT("mechanic")]
    -> mechanic
+ {nearby("fireplace")} [INTERACT("fireplace")]
    -> fireplace
-> main_loop



-> END