INCLUDE furniture.ink
INCLUDE characters.ink






// External functions to check whether an item is nearby
//  Each object/npc should be addressed by a string
//  Not actually planning on using this anymore...
EXTERNAL nearby(obj_id)
=== function nearby(obj_id) ===
    // Standby for testing in standalone ink
    ~ return true


// Consistent text for "exit" option, where relevant.
CONST exit = "Walk away."

=== function chloroformWrapper(npc_id,npc_list_item) ===
    ~ chloroformNPC(npc_id)
    ~ chloroformed += npc_list_item
    ~ panicked -= npc_list_item
    ~ suspicious -= npc_list_item
    ~ groggy += npc_list_item
    ~ changeVisualState(npc_id,"unconscious")
    ~ return "You knock out " + name(npc_list_item) + " with chloroform." 

      
=== tutorialChloroformWrapper(npc_id,npc_list_item) ===
    // This is super hacky, sorry.
    ~ chloroformNPC(npc_id)
    ~ chloroformed += npc_list_item
    ~ panicked -= npc_list_item
    ~ suspicious -= npc_list_item
    ~ groggy += npc_list_item
    ~ changeVisualState(npc_id,"unconscious")
    You knock out the guard with chloroform.
    When he wakes up he won't remember a thing.
    However, if the train arrives at the station before he wakes up you'll have a major problem on your hands!
    You need to find some way to delay the train.
    ->->


