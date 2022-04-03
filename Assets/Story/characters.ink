LIST characters = _guard, _mechanic, _magnate, _novelist, _student, _hunter, _inventor

// Possible status effects
VAR chloroformed = ()
VAR suspicious = ()
VAR panicked = ()
VAR busy = ()
VAR idle = (_mechanic)
VAR npc_hidden = (_guard)


=== guard ===
{
- npc_hidden?_guard:
  -> main_loop
- chloroformed?_guard:
  The guard is unconscious. -> main_loop
- panicked?_guard:
  Guard: You'll never get away with this, scoundrel!
  * [Chloroform him!]
    {chloroformWrapper("guard",_guard)}
    When he wakes up he won't remember a thing.
    However, if he's still unconscious when the train arrives you'll have a major problem on your hands.
    You'll have to delay the train somehow.
    -> main_loop
- else:
  Guard: You seem familiar. Have we met?
  + You: I don't think so.
    Guard: Sorry, I'm feeling a bit groggy today.
    -> main_loop
}



CONST mechanic_name =  "Jimmy"
=== mechanic ===
# DIALOGUE
{
 - chloroformed?_mechanic:
   The mechanic is unconscious.
 - panicked?_mechanic:
   Mechanic: {shuffle: You're a menace to everyone on this train.|They'll put you away for a long time.|You picked the wrong train to screw with, buddy.}
 - idle?_mechanic: -> mechanic.idle_dialogue ->
 - else: -> mechanic.other ->
}
-> main_loop
= idle_dialogue
  Mechanic: {suspicious?_mechanic:{shuffle: I'm not sure what your deal is, but I'm keeping an eye on you!|Just what are you up to, exactly? Don't answer that.|Why do you keep bothering me?}|{I hope you're enjoying the trip.|Oh, you again.|What is it this time?}}
  + You: Who are you, if you don't mind me asking?
    Mechanic: {I'm {mechanic_name}, the mechanic.  I'm here to keep the train running safely.->long_discussion|I'm {mechanic_name}, the mechanic. I told you this already.->->|I feel like we've been over this already.->->|You have the memory of a goldfish.->->}
  * {gas_leak} You: I think there's a gas leak in the galley.
    Mechanic: Oh shit, that's not good.
    Mechanic: {trainIsMoving():STOP THE TRAIN IMMEDIATELY.|We're gonna be delayed a while longer.}
    -> handle_accident ->
  * {plant_state == burning} You: I think there's a fire on board the train.
    Mechanic: Oh dear. There is, isn't there.
    Mechanic: STOP THE TRAIN.
    -> handle_accident ->
  + You: Goodbye.
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
           Mechanic: So what do you do?
           **** You: I can't exactly say.
                Mechanic: What are you going on about?
                Mechanic: Never mind, don't answer that.
                ~suspicious += _mechanic
           **** You: I'm a world-famous thief.
                Mechanic: Sure you are.  Quit wasting my time. 
       *** You: I guess so.
         Mechanic: Then how did you afford a ticket?
         **** You: To be honest, I rarely have to worry about how much things cost.
              Mechanic: Oh, I see.  You were born into money. You're a leech.
              ***** You: That's not what I meant.
                    Mechanic: What exactly did you mean, then?
                    ****** You: You know what, forget it.
                           Mechanic: Whatever you say, weirdo.
                           ~suspicious += _mechanic
              ***** You: Close enough, I guess.
                    ****** Mechanic: I'll never understand your sort.
    ** You: I'm a businessman.
       Mechanic: What kind of business?
       *** You: None of yours.
           Mechanic: Fair enough.
-
->->
= handle_accident
{delayTrain(60,"Conductor: Everything seems to be under control. Let's get moving again.")}
{handle_accident > 1:
 {suspicious?_mechanic:
  Mechanic: You expect me to believe that a shady guy like you just happened to come across two unrelated accidents?
  Mechanic: On MY train?
  Mechanic: You're behind this, I know it!
  ~panicked += _mechanic
 -else:
  Mechanic: It's weird that this keeps happening to you specifically, right?
  ~suspicious += _mechanic
 }
}
->->
= other
 Mechanic: Enjoy your trip.
->->

=== inventor ===
Inventor: {shuffle:Good day!|I hope you're enjoying the trip as much as I am!|Trains are fascinating, aren't they?}
 * [Pick pockets]
   You pick the inventor's pockets...
   ...and find the airship plans you were looking for!
   Maybe this job is salvageable after all.
   -> main_loop
 + You: Goodbye.
   -> main_loop

=== hunter ===
Hunter: {I hunt the most dangerous game of all.-> conversation|British Columbia is teeming with beautiful animals to shoot.}
+ You: Goodbye.
  -> main_loop
= conversation
 * You: That's terrible!
   Hunter: What are you talking about?
   Hunter: If I don't kill the MegaRhinos then who will?
   ** You: Sorry, I thought you meant... never mind.
   -> main_loop
-> main_loop

=== magnate ===
Oil Magnate: {shuffle:Good day!|I am extremely wealthy.|Maybe I should buy another house in Vancouver.|Just aquired some very promising mineral rights in northern Alberta.}
-> main_loop

=== novelist ===
Novelist: {shuffle:This train would be a great setting for a murder mystery.|The scenery here is beautiful.}
-> main_loop

=== student ===
Student: {shuffle:I'm going to change the world some day!|I should be studying for the bar exam.|I had that dream about the unexpected final exam again.}
-> main_loop






