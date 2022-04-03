// States (should be disjoint)
//LIST states = idle, suspicious, panicked, seek_target, distracted

LIST AI_flags = distracted, suspicious, panicked, seek_target, busy, idle

// Individual character states
//  Character id is equal to everything before _state
VAR conductor_flags = (idle)
VAR mechanic_state = (idle)


VAR guard_state = ()
=== guard ===
// Visual states are: "invisible" (default), "visible"
Guard: You'll never get away with this, scoundrel!
* [Chloroform him!]
  {chloroformNPC("guard")}
  When he wakes up he won't remember a thing.
  However, if he's still unconscious when the train arrives you'll have a major problem on your hands.
  You'll have to delay the train somehow.
-> main_loop





CONST mechanic_name =  "Tim"
=== mechanic ===
# DIALOGUE
{
 - LIST_COUNT(mechanic_state)==0: -> mechanic.idle_dialogue ->
 - mechanic_state?distracted: -> mechanic.distracted_dialogue ->
 - mechanic_state?suspicious: -> mechanic.suspicious_dialogue ->
 - else: -> mechanic.other ->
}
-> main_loop
= idle_dialogue
  Mechanic: {I hope you're enjoying the trip.|Oh, you again.|What is it this time?}
  + You: Who are you, if you don't mind me asking?
    Mechanic: {I'm {mechanic_name}, the mechanic.  I'm here to keep the train running safely.->long_discussion|I'm {mechanic_name}, the mechanic. I told you this already.->->|I feel like we've been over this already.->->|You must have the memory of a goldfish.->->}
  + You: {inventory has strange_schematics}Have you heard about Marconi's wireless telegraph?
    Mechanic: No, what's that?
    -> attempt_to_distract
  + You: Never mind, sorry to bother you.
-
->->

= long_discussion
* You: Seems like a hard job.
    Mechanic: For other people, maybe, but not for ol' {mechanic_name}.  Trust me, I know how this train works inside and out.
* You: Seems easy.
    Mechanic: Pff, sure.  What do you do, again?
    ** Oh, you know, a bit of this, a bit of that.
       Mechanic: So you're unemployed.
       *** You: No!
       *** You: I guess.
         Then how did you afford a ticket
    ** You: I'm a businessman.
       Mechanic: What kind of business?
-
->->

= attempt_to_distract
+ You: Never mind, I bet you wouldn't understand anyways.
  Mechanic: What do you take me for, some sort of rube?
  Mechanic: I'll have you know I'm a highly educated guy.
  ++ You: Well, then, what do you make of these schematics?
    Mechanic: Hm, give me a second to take a look at that.
    ~mechanic_state = (distracted)
+ You: It's a telegraph that works without a wire.  Uses invisible light or something.
  Mechanic: Sounds like nonsense.
-
->->
= distracted_dialogue
Mechanic: Give me a sec, these schematics are fascinating.
->->
= suspicious_dialogue
 Mechanic: {shuffle: I'm not sure what your deal is, but I'm keeping an eye on you!|Just what are you up to, exactly? Don't answer that.|Why do you keep bothering me?}
->->
= other
 Mechanic: Enjoy your trip.
->->