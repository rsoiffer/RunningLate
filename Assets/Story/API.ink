// Engine calls to ink ------------------------------------------------

=== function prettyPrintInventory() ===
// TODO Implement
 ~ return "semicolon;separated;list;of;items"
 
=== function prettyPrintObjectives() ===
 ~ return "semicolon;separated;list;of;objectives"

=== function characterAwakes(npc_id) ===
// No return value, just sets state in Ink
 ~ return

// Ink calls to Engine ------------------------------------------------

// Delay train for `seconds` seconds, display `message` when time expires.
EXTERNAL delayTrain(seconds, message)
=== function delayTrain(seconds,message) ===
 ~ return

EXTERNAL chloroformNPC(npc_id)
=== function chloroformNPC(npc_id)
 ~ return

// state_id is a string, specific meanings for to individual objects TBD
EXTERNAL changeVisualState(obj_id, state_id)
=== function changeVisualState(obj_id, state_id) ===
 ~ return