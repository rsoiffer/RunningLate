// Object states
LIST fire_states = normal, (burning), burnt

VAR fireplace_state = burning
VAR items_in_fireplace = () // items being burned in fireplace
VAR gas_leak = false
VAR plant_state = normal

VAR safe_opened = false
=== safe
 You're confident this safe should contain the airship plans you're looking for.
  * [{exit}] -> main_loop
  * [Crack the safe.]
    ~ safe_opened = true
    The safe immediately clicks open, but you don't find the expected schematics inside.
    Instead, there's a note resembling your own handwriting.
    ~inventory += letter
    // TODO Sprite overlay
    "Cower, simpletons! Your plans have been stolen by the great Augustin DuPont."
    "The world will know and fear me!"
    You didn't write this; someone is trying to set you up!
    As you read the note, a guard wanders into the room.
    {changeVisualState("guard","visible")}
    ~ panicked += _guard
    Guard: You won't get away with this, scoundrel!
    ->main_loop


=== fireplace
// Design decisions/simplifying assumptions
//  - can burn an arbitrary amount of (flammable) evidence
//  - each item of evidence increases timer by a set amount
# INTERACT
The fireplace is {fireplace_state?burning:crackling merrily|cold and dark}.
<- toggle_fire_state
<- burn_options(flammableItems())
+ [{exit}] -> main_loop

= toggle_fire_state
+ {fireplace_state == burning} [Put out the fire.]
  ~ fireplace_state = normal
  -> fireplace
+ {fireplace_state == normal} [Light the fire.]
  ~ fireplace_state = burning
  -> fireplace
-> DONE
= burn_options(flammables)
// Produce list of options for burning items, if applicable
{fireplace_state?normal: -> DONE}
{LIST_MIN(flammables):
 ~ temp item_to_burn = LIST_MIN(flammables)
 <- burn_options(flammables - item_to_burn)
 + [Burn the {name(item_to_burn)}]
   -> burn_item(item_to_burn)
 -> DONE
-else:
 -> DONE
}
= burn_item(item_to_burn)
The fire crackles as you toss in the {name(item_to_burn)}.
~burnEvidence(item_to_burn)
-> fireplace


=== sink
// TODO Also able to sabotage the sink?
You are looking at a small sink.
+ [Wash hands.]
  Your hands are now clean (literally, though not metaphorically).
  ~bloody_hands = false
  -> main_loop
+ [{exit}] -> main_loop
= observed
-> main_loop

=== oven
{not gas_leak:
This appears to be a small gas oven.
* [Sabotage it!]
  ~ gas_leak = true
  You sabotage the oven, creating a gas leak.  You'd better let the conductor know before something goes horribly wrong!!
  -> main_loop
+ [{exit}] -> main_loop
- else:
The oven has been sabotaged.  You smell natural gas. -> main_loop
}

=== plant
//A decorative plant to set on fire, I guess?
{plant_state:
- normal: 
  This is a decorative plant of some sort.  You could probably set it on fire{inventory has matchbook:.|, if you had a match.}
  + {inventory has matchbook}[Set it on fire.]
    The plant catches fire easily.
    ~ plant_state = burning
    -> main_loop
  + [{exit}] -> main_loop
- burning: The plant is on fire. -> main_loop
- burnt: You already burned this plant to a crisp. -> main_loop
}

=== drawer
// Probably going to be placed in a sleeper car room, maybe?
// TODO Generalize to allow multiple drawers without copy-pasting.
{drawer == 1:  // First time checking this drawer
  You open the {shuffle:mahogony|blackwood|oaken} drawer and find a half-full book of matches.
  ~ inventory += matchbook
-else:
  The drawer is empty.
}
-> main_loop






