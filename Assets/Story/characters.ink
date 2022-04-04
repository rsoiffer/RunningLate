LIST characters = _guard, _mechanic, _magnate, _novelist, _student, _hunter, _inventor

// Possible status effects
VAR chloroformed = ()
VAR suspicious = ()
VAR panicked = (_novelist)
VAR busy = ()
VAR idle = (_mechanic)
VAR npc_hidden = (_guard)

// Helper for adding chloroform option to all npcs.
=== chloroform_options(npc_id,list_item,->divert) ===
  + [Use chloroform.]
    {chloroformWrapper(npc_id,list_item)}
    -> divert
  + [{exit}]
    -> main_loop
->DONE


=== guard ===
-> check_chloroformed(_guard) ->
{
- npc_hidden?_guard:
  -> main_loop
- panicked?_guard:
  Guard: You'll never get away with this, {shuffle:scoundrel|villain}!
  <- chloroform_options("guard",_guard,->main_loop)
- else:
  Guard: You seem familiar. Have we met?
  + You: I don't think so.
    Guard: Sorry, I'm feeling a bit groggy today.
    -> main_loop
}



CONST mechanic_name =  "Jimmy"
=== mechanic ===
-> check_chloroformed(_mechanic) ->
# DIALOGUE
{
 - panicked?_mechanic:
   Mechanic: {shuffle: You're a menace to everyone on this train.|They'll put you away for a long time.|You picked the wrong train to screw with, buddy.}
   <- chloroform_options("mechanic",_mechanic,->main_loop)
   -> DONE
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
    Mechanic: {trainIsMoving():STOP THE TRAIN IMMEDIATELY.|We're gonna be delayed a while longer while we sort this out.}
    -> handle_accident ->
  * {plant_state == burning} You: I think there's a fire on board the train.
    Mechanic: Oh dear. There is, isn't there.
    Mechanic: {trainIsMoving():STOP THE TRAIN.|We're gonna be delayed a while longer while we sort this out.}
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
~delayTrain(60,"Conductor: Everything seems to be under control. Let's get moving again.")
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
-> check_chloroformed(_inventor) ->
{
 - panicked?_inventor:
   Inventor: {shuffle: Did you seriously think you could outwit me?|You'll hang for this.}
   <- chloroform_options("inventor",_inventor,->main_loop)
   -> DONE
}
Inventor: {shuffle:Good day!|I hope you're enjoying the trip as much as I am!|Trains are fascinating, aren't they?}
 * [Pick pockets]
   You pick the inventor's pockets...
   ...and find the airship plans you were looking for!
   Maybe this job is salvageable after all.
   -> main_loop
 + You: Goodbye.
   -> main_loop

=== hunter ===
-> check_chloroformed(_hunter) ->
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
-> check_chloroformed(_magnate) ->
{
 - panicked?_magnate:
   Oil Magnate: I hope you can afford a good lawyer, criminal!
   <- chloroform_options("magnate",_magnate,->alert_inventor)
   -> DONE
}
//Oil Magnate: {shuffle:Good day!|I am extremely wealthy.|Maybe I should buy another house in Vancouver.|Just aquired some very promising mineral rights in northern Alberta.}
Oil Magnate: {Do you know how wealthy I am? -> how_wealthy|{suspicious?_magnate:What do you want now?|Hello again!}}
 * I don't believe you're as wealthy as you say you are.
   -> challenge_him
 + [Goodbye.]
-
-> main_loop
= how_wealthy
* You: Why would I know that?
  Oil Magnate: I'm one of the wealthiest men in Canada!
  Oil Magnate: Anyone who's anyone knows who I am.
  ** I don't believe it.
     -> challenge_him
* You: I wouldn't flaunt my wealth if I were you.  There could be thieves around.
  Oil Magnate: I'm not worried about that.
  Oil Magnate: To be honest, money means so little to me at this point that I wouldn't even mind losing my wallet.
  ** You: Why not hand it over to me, then?
     Oil Magnate: Bold.  But no, what would I stand to gain from that?
     *** You: The satisfaction of a generous act?
         Oil Magnate: Haha.  You're quite the joker.
     *** You: Stop making excuses.  I bet you're not even that wealthy.
         Oil Magnate: Why, you little...
         Oil Magnate: Fine. Take it! See if I care.
         ~inventory += money
         ~inventory += wallet
         The oil magnate hands you a fine leather wallet containing $200.
     *** You: Well, you might not like the alternative.
         Oil Magnate: Are you threatening me?
         **** You: Yes.
              Oil Magnate: Oh. I see how it is.
              ~inventory += money
              ~inventory += wallet
              The oil magnate hands you a fine leather wallet containing $200.
              Oil Magnate: You won't get away with this, you know!
              ~panicked += _magnate
         **** You: No, of course not.
              Oil Magnate: Damn straight.
              Oil Magnate: I don't like the cut of your jib.
              ~suspicious += _magnate
  ** You: If you say so.
-
-> main_loop
= challenge_him
{suspicious?_magnate:
    Oil Magnate: I don't have to prove anything to you.
    -> main_loop
}
Oil Magnate: Don't be silly.
Oil Magnate: {inventory has wallet:I already gave you my wallet, what more proof do you need?|I can buy anything I want, whenever I want.}
* You: I bet you couldn't make the conductor stop the train for you right now.
  Oil Magnate: CONDUCTOR! I will pay you $1000 dollars if you stop the train this instant.
  ~ delayTrain(60,"Enough of that. Let's get going again.")
  Oil Magnate: How's that for you?
  ** You: Impressive.
  ** You: Wow, you sure showed me.
  --
  Oil Magnate: I know.
-> main_loop
= alert_inventor
{not (chloroformed?_inventor):
  Inventor: I saw that! You maniac!
  ~ panicked += _inventor
}
-> main_loop

=== novelist ===
-> check_chloroformed(_novelist) ->
Novelist: {shuffle:This train would be a great setting for a murder mystery.|The scenery here is beautiful.}
-> main_loop

=== student ===
-> check_chloroformed(_student) ->
Student: {shuffle:I'm going to change the world some day!|I should be studying for the bar exam.|I had that dream about the unexpected final exam again.}
-> main_loop

=== check_chloroformed(character) ===
{chloroformed?character:
  It seems {name(character)} is unconscious.
  -> main_loop
}
->->




