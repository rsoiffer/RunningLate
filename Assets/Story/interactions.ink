INCLUDE furniture.ink
INCLUDE characters.ink






// External functions to check whether an item is nearby
//  Each object/npc should be addressed by a string
//  Not actually planning on using this anymore...
EXTERNAL nearby(obj_id)
=== function nearby(obj_id) ===
    // Standby for testing in standalone ink
    ~ return true

// External function to add time to timer, e.g.
//  when delaying train or adding evidence to fireplace
EXTERNAL addTime(timer_id,seconds)
=== function addTime(timer_id,seconds) ===
 ~ return

// External function to tell NPC to move to particular location
EXTERNAL setDestination(agent_id,destination_id)
=== function setDestination(agent_id,destination_id) ===
 ~ return
 


// Consistent text for "exit" option, where relevant.
CONST exit = "(go back)"



      
      




