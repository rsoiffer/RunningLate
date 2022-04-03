// List of all possible items
LIST items = knife, letter, strange_schematics, mop, cloth, handkerchief, matchbook, chloroform, airship_plans, lighter, nanaimo_bar

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
    - airship_plans: ~return "the airship schematics"
    - lighter: ~return "cigarette lighter"
    - nanaimo_bar: ~return "Nanaimo bar"
    // Same function also used for characters, terrible hack (sorry)
    - _guard: ~return "the guard"
    - _mechanic: ~return "the mechanic"
    - _inventor: ~return "the inventor"
    - _hunter: ~return "the big hame hunter"
    - _novelist: ~return "the novelist"
    - _student: ~return "the law student"
    - _magnate: ~return "the oil magnate"
  }
  ~return ""

// Some possible properties of items
VAR incriminating = (letter)
VAR can_clean = (mop, cloth, handkerchief) // Can also get bloody
VAR flammable = (letter, matchbook, strange_schematics, mop, cloth)
VAR firestarters = (matchbook,lighter)

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

=== function canStartFire() ===
// Return true if player currently has the ability to start a fire.
 ~ return LIST_COUNT(inventory ^ firestarters) > 0

=== function flammableItems() ===
// List of all flammable & incriminating evidence in inventory
 ~ return inventory ^ flammable

=== function burnEvidence(item) ===
// Burn a piece of evidence
 ~ inventory -= item
 ~ items_in_fireplace += item
 