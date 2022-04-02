// States (should be disjoint)
LIST states = idle, suspicious, panicked, seek_target, distracted

// Individual character states
//  Character id is equal to everything before _state
VAR conductor_state = (idle)
VAR mechanic_state = (idle)

// Object states
// TODO Tbh, this should just be a boolean
LIST fire_states = (burning), cold
VAR fireplace_state = (burning)
VAR items_in_fireplace = () // items being burned in fireplace

// External functions to check whether an item is nearby
//  Each object/npc should be addressed by a string
EXTERNAL nearby(obj_id)
=== function nearby(obj_id) ===
    // Standby for testing in standalone ink
    ~ return true

// External function to add time to timer, e.g.
//  when delaying train or adding evidence to fireplace
EXTERNAL addTime(timer_id,seconds)
=== function addTime(timer_id,seconds) ===
 ~ return


// Characters ---------------------------------------------------------------
// Note: each character *may* have walk_away and awkward_silence stitch
// TODO Probably should be in a separate file
=== mechanic ===
# DIALOGUE
{
 - mechanic_state?idle: -> mechanic.idle_dialogue
 - mechanic_state?distracted: -> mechanic.distracted_dialogue
 - else: -> mechanic.other
}
= idle_dialogue
  Mechanic: What are you up to?
  + Nothing suspicious.
    Mechanic: That's an odd thing to say.
    ~mechanic_state = (suspicious)
  + Never mind.
  + {inventory has wireless_schematics}Have you heard about Marconi's wireless telegraph?
    Mechanic: No, what's that?
    ++ Never mind, I bet you wouldn't understand anyways.
      Mechanic: What do you take me for, some sort of rube?
      Mechanic: I'll have you know I'm a highly educated guy.
      +++ Well, then, what do you make of these schematics?
          Mechanic: Hm, give me a second to take a look at that.
          ~mechanic_state = (distracted)
    ++ It's a telegraph that works without a wire.  Uses invisible light or something.
      Mechanic: Sounds like nonsense.
-
-> main_loop
= distracted_dialogue
Mechanic: Give me a sec, these schematics are fascinating.
-> main_loop
= other
 Mechanic: I've got my eye on you, scoundrel.
-> main_loop
      
      
      
// Objects ---------------------------------------------------------
// TODO Probably should be in a separate file

=== fireplace
// Design decisions/simplifying assumptions
//  - can burn an arbitrary amount of (flammable) evidence
//  - each item of evidence increases timer by a set amount
# INTERACT
The fireplace is {fireplace_state?burning:crackling merrily|cold and dark}.
<- toggle_fire_state
<- burn_options(flammableItems())
+ Exit -> main_loop
-> DONE

= toggle_fire_state
+ {fireplace_state?burning} [Put out the fire.]
  ~ fireplace_state = cold
  -> fireplace
+ {fireplace_state?cold} [Light the fire.]
  ~ fireplace_state = burning
  -> fireplace
-> DONE

= burn_options(flammables)
// Produce list of options for burning items, if applicable
{fireplace_state?cold: -> DONE}
{LIST_MIN(flammables):
 ~ temp item_to_burn = LIST_MIN(flammables)
 <- burn_options(flammables - item_to_burn)
 + [Burn {item_to_burn}]
   -> burn_item(item_to_burn)
 -> DONE
-else:
 -> DONE
}

= burn_item(item_to_burn)
The fire crackles as you toss in the {item_to_burn}.
~burnEvidence(item_to_burn)
-> fireplace





