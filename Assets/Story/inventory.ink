// List of all possible items
LIST items = knife, letter, strange_schematics, mop, cloth, handkerchief, matchbook, chloroform

=== function name(item) ===
  {item:
    - knife: ~return "knife"
    - letter: ~return "incriminating note"
    - strange_schematics: ~return "enigmatic schematics"
    - cloth: ~return "washcloth"
    - mop: ~return "mop"
    - matchbook: ~return "matchbook"
    - handkerchief: ~return "handkerchief"
    - chloroform: ~return "chloroform"
    // Same function also used for characters, terrible hack (sorry)
    - _guard: ~return "the guard"
    - _mechanic: ~return "the mechanic"
  }
  ~return ""

// Some possible properties of items
VAR incriminating = (knife, letter)
VAR can_clean = (mop, cloth, handkerchief) // Can also get bloody
VAR flammable = (letter, strange_schematics, mop, cloth)

// Currently in player inventory
VAR inventory = (handkerchief, chloroform)
VAR bloody = () // Nothing is bloody to start with

// Status effects?
VAR bloody_hands = true
VAR drunk = false

=== function listToStr(list,prefix,infix,suffix) ===
~ temp head = LIST_MIN(list)
{LIST_COUNT(list):
 - 0: ~ return ""
 - 1: ~ return prefix + name(LIST_MIN(head)) + suffix
 - else: ~ return prefix + name(LIST_MIN(head)) + suffix + infix + listToStr(list - LIST_MIN(head),prefix,infix,suffix)
}



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
 
=== function listObjectives() ===
 ~ return "Insert list of objectives."