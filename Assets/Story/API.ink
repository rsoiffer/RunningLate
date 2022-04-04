// Engine calls to ink ------------------------------------------------

=== function prettyPrintInventory() ===
 ~ return listToStr(inventory,"",";","")
 
=== function prettyPrintObjectives() ===
{not safe_opened: 
 ~ return "Steal the airship plans."
- else:
 ~ temp objectives = ""
 {made_bet and not debt_payed:
  ~ objectives += "Pay the law student her winnings."
 }
 ~ objectives += ";" + listToStr(inventory ^ incriminating,"Burn the ",";",".")
 ~ objectives += ";" + listToStr(chloroformed,"Delay the train until ",";"," wakes up.")
 ~ objectives += ";" + listToStr(panicked,"Chloroform ",";",".")
 // TODO Also include list of suspicious people
 ~ return objectives
}
 

=== function characterAwakes(npc_id) ===
// No return value, just sets state in Ink
~temp npc = get_npc_by_id(npc_id)
{not (chloroformed?npc):
 ~return
}
~chloroformed -= npc 
~groggy += npc
{npc_id==_guard:
  // I knew this inconsistency would come back to bite me.
  ~changeVisualState(npc_id,"visible")
-else:
  ~changeVisualState(npc_id,"normal")
}

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
 
EXTERNAL restartGame()
=== function restartGame() ===
 ~ return

// Not yet discussed, but would be useful for me.
EXTERNAL trainIsMoving()
=== function trainIsMoving() ===
 ~ return true