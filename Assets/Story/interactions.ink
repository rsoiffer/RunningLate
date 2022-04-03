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
CONST exit = "(go back)"

=== function chloroformWrapper(npc_id,npc_list_item) ===
    ~ chloroformNPC(npc_id)
    ~ chloroformed += npc_list_item
    ~ panicked -= npc_list_item
    ~ suspicious -= npc_list_item
    ~ return "You chloroform " + name(npc_list_item) + "." 

      
      




