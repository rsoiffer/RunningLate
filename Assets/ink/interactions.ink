// States (should be disjoint)
LIST states = idle, suspicious, panicked, seek_target, distracted

// Individual character states
//  Character id is equal to everything before _state
VAR conductor_state = (idle)
VAR mechanic_state = (idle)

// Object states
LIST fire_states = (burning), cold
VAR fireplace_state = (burning)

// External functions to check whether an item is nearby
//  Each object/npc should be addressed by a string
EXTERNAL nearby(obj_id)
=== function nearby(obj_id) ===
    // Standby for testing in standalone ink
    ~ return true

// Characters ---------------------------------------------------------------
// TODO Probably should be in a separate file
=== mechanic ===
# DIALOGUE
{
 - mechanic_state?idle: -> mechanic.idle_dialogue
 - mechanic_state?distracted: -> mechanic.distracted_dialogue
- else: -> mechanic.other
}
-
-> main_loop
= idle_dialogue
  Mechanic: What are you up to?
  + Nothing suspicious.
    Mechanic: That's an odd thing to say.
    ~mechanic_state = (suspicious)
  + Never mind.
  + {has_wireless_schematics}Have you heard about Marconi's wireless telegraph?
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
      
      
      
// Objects ------------------------------------------------------------------
// TODO Probably should be in a separate file

=== fireplace
# INTERACT
The fireplace is {fireplace_state?burning:lit|unlit}.
+ {fireplace_state?burning} [Put out the fire.]
  ~ fireplace_state = (cold)
  -> fireplace
+ {fireplace_state?cold} [Light the fire.]
  ~ fireplace_state = (burning)
  -> fireplace
+ Exit -> main_loop
- -> fireplace




