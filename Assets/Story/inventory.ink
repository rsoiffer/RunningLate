// List of all possible items
LIST items = knife, letter, wireless_schematics, mop, cloth, handkerchief
// Some possible properties of items
VAR incriminating = (knife, letter)
VAR can_clean = (mop, cloth, handkerchief) // Can also get bloody
VAR flammable = (letter, wireless_schematics, mop, cloth)

// Currently in player inventory
VAR inventory = (knife, letter, wireless_schematics, handkerchief)
VAR bloody = () // Nothing is bloody to start with

// Status effects?
VAR bloody_hands = true
VAR drunk = false


// Cleaning-related stuff ---------------------------------------------
=== function canCleanBlood() ===
// Return true if the player is able to clean blood at the moment
~ return (LIST_COUNT(can_clean ^ inventory) > 0)

=== function cleanBlood() ===
// Use first available cleaning item, and make it bloody if
//  it isn't already.
// Return true if any cleaning actually happens, false otherwise.
{canCleanBlood():
  ~ bloody += LIST_MIN(can_clean ^ inventory)
  ~ return true
-else:
  ~ return false
}

// Evidence-related stuff --------------------------------------------
=== function hasIncriminatingEvidence() ===
// Return true if player has any incriminating evidence on them.
 ~ return LIST_COUNT(inventory ^ (incriminating + bloody)) > 0

=== function flammableItems() ===
// List of all flammable & incriminating evidence in inventory
 ~ return inventory ^ flammable

=== function burnEvidence(item) ===
// Burn a piece of evidence
 ~ inventory -= item
 ~ items_in_fireplace += item
 ~ addTime("fireplace",60)