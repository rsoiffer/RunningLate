LIST characters = _guard, _mechanic, _magnate, _novelist, _student, _hunter, _inventor

// Possible status effects
VAR chloroformed = ()
VAR suspicious = ()
VAR panicked = ()
VAR groggy = ()
VAR eating = ()
VAR idle = (_mechanic)
VAR npc_hidden = (_guard)
=== function attentive() ===
 // i.e. list of characters who can potentially see you committing crimes.
 ~return LIST_INVERT(groggy + chloroformed + eating)

// Get id from list item
=== function get_npc_id(npc) ===
{npc:
 - _guard: ~return "guard"
 - _mechanic: ~return "mechanic"
 - _magnate: ~return "magnate"
 - _novelist: ~return "novelist"
 - _student: ~return "student"
 - _hunter: ~return "hunter"
 - _inventor: ~return "inventor"
}
// Get list item by id
=== function get_npc_by_id(npc) ===
{npc:
 - "guard": ~return _guard
 - "mechanic": ~return _mechanic
 - "magnate": ~return _magnate
 - "novelist": ~return _novelist
 - "student": ~return _student
 - "hunter": ~return _hunter
 - "inventor": ~return _inventor
}

// A bunch of utility functions ---------------------------------------------
// TODO many of these should be rolled into a single "header" function

=== check_chloroformed(character) ===
{chloroformed?character:
  It seems {name(character)} is unconscious.
  -> main_loop
}
->->

// Helper for groggy npcs.
=== check_groggy(display_name,npc) ===
{not (groggy?npc):->->}
{display_name}: You seem familiar. Have we met before?
+ You: I don't think so.
  {display_name}: Sorry, I'm feeling a bit groggy today.
  -> main_loop

=== check_eating(npc) ===
{not (eating?npc):->->}
It seems that {name(npc)} is too busy eating a Nanaimo bar to pay attention to you.
-> main_loop

// Helper for adding chloroform option to all npcs.
=== chloroform_options(npc_id,list_item,->divert) ===
  + [Use chloroform.]
    {chloroformWrapper(npc_id,list_item)}
    -> divert
  + [{exit}]
    -> main_loop
->DONE

// Helper for adding Nanaimo bar option to all npcs.
=== desert_option(display_name,npc_id) ===
  + {inventory has nanaimo_bar}You: Have you heard of a Nanaimo bar?
    {display_name}: No, what's that?
    You: It's a local desert.  Here, try one!
    {display_name}: Oh, thank you!
    ~inventory -= nanaimo_bar
    ~eating += npc_id
    -> main_loop

// Start of character dialogue definitions ---------------------------------

=== guard ===
-> check_chloroformed(_guard) ->
-> check_groggy("Guard",_guard) ->
-> check_eating(_guard) ->
{
- npc_hidden?_guard:
  -> main_loop
- panicked?_guard:
  Guard: You'll never get away with this, {shuffle:scoundrel|villain}!
  + [Use chloroform.]
    -> tutorialChloroformWrapper("guard",_guard) ->
    -> main_loop
  + [{exit}]
    -> main_loop
  <- chloroform_options("guard",_guard,->main_loop)
- else:
  Guard: You seem familiar. Have we met?
  + You: I don't think so.
    Guard: Sorry, I'm feeling a bit groggy today.
    -> main_loop
}


// Why did I give the mechanic a name ????
CONST mechanic_name =  "Jimmy"
=== mechanic ===
-> check_chloroformed(_mechanic) ->
-> check_groggy("Mechanic",_mechanic) ->
-> check_eating(_mechanic) ->
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
{plant_state == burning:
    ~ changeVisualState("plant","burnt")
    ~ plant_state = burnt
}
~ changeVisualState("oven","normal")
~ gas_leak = false
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
-> check_groggy("Inventor",_inventor) ->
-> check_eating(_inventor) ->
{
 - panicked?_inventor:
   Inventor: {shuffle: Did you seriously think you could outwit me?|You'll hang for this.}
   <- chloroform_options("inventor",_inventor,->main_loop)
   -> DONE
}
Inventor: {shuffle:Good day!|I hope you're enjoying the trip as much as I am!|Trains are fascinating, aren't they?}
 <- desert_option("Inventor",_inventor)
 * [Pickpocket him.]
   You pick the inventor's pockets and find the airship plans you came here for!
   ~ inventory += airship_plans
   Wait a second...
   This must mean that {name(_inventor)} was attempting to frame you for stealing his own plans.
   It takes more than that to outsmart you, though!
   -> main_loop
 + You: Goodbye.
   -> main_loop

=== hunter ===
-> check_chloroformed(_hunter) ->
-> check_groggy("Hunter",_hunter) ->
-> check_eating(_hunter) ->
Hunter: {I hunt the most dangerous game of all.-> conversation|British Columbia is teeming with beautiful animals to shoot.}
 * [Pickpocket him.]
   You pick {name(_hunter)}'s pockets and find a cigarette lighter.
   ~ inventory += lighter
   -> main_loop
+ You: Goodbye.
  -> main_loop
= conversation
+ You: That's terrible!
   Hunter: What are you talking about?
   Hunter: If I don't kill the velociraptors then who will?
   ** You: Sorry, I thought you meant... never mind.
   -> main_loop
-
-> main_loop

VAR magnate_stopped_train = false
=== magnate ===
-> check_chloroformed(_magnate) ->
-> check_groggy("Oil Magnate",_magnate) ->
-> check_eating(_magnate) ->
{
 - panicked?_magnate:
   Oil Magnate: I hope you can afford a good lawyer, criminal!
   <- chloroform_options("magnate",_magnate,->alert_inventor)
   -> DONE
}
//Oil Magnate: {shuffle:Good day!|I am extremely wealthy.|Maybe I should buy another house in Vancouver.|Just aquired some very promising mineral rights in northern Alberta.}
Oil Magnate: {Do you know how wealthy I am? -> how_wealthy|{suspicious?_magnate:What do you want now?|Hello again!}}
 * {not magnate_stopped_train}I don't believe you're as wealthy as you say you are.
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
// TODO If he already gave you his wallet, you need to threaten him to make him stop the train.
//  (Not a high priority, though).
{
 - suspicious?_magnate:
    Oil Magnate: I don't have to prove anything to you.
    -> main_loop
 - groggy?_magnate:
    Oil Magnate: {shuffle:Don't trains always make you sleepy?|I just had the strangest dream.}
}
Oil Magnate: Don't be silly.
Oil Magnate: {inventory has wallet:I already gave you my wallet, what more proof do you need?|I can buy anything I want, whenever I want.}
* You: I bet you couldn't make the conductor stop the train for you right now.
  Oil Magnate: CONDUCTOR! I will pay you $1000 dollars if you stop the train this instant.
  ~ delayTrain(60,"Enough of that. Let's get going again.")
  ~ magnate_stopped_train = true
  Conductor: Whatever you say, boss!
  Oil Magnate: How's that for you?
  ** You: Impressive.
  ** You: Wow, you sure showed me.
  --
  Oil Magnate: I know.
* ->
-
-> main_loop
= alert_inventor
{attentive()?_inventor:
  Inventor: I saw that! You maniac!
  ~ panicked += _inventor
}
-> main_loop



=== novelist ===
-> check_chloroformed(_novelist) ->
-> check_groggy("Novelist",_novelist) ->
-> check_eating(_novelist) ->
{
 - panicked?_novelist:
   Novelist: {shuffle:I know what you did!You're a terrifying criminal!}
   <- chloroform_options("novelist",_novelist,->main_loop)
   -> DONE
}
Novelist: {shuffle:This train would be a great setting for a murder mystery.|The scenery here is beautiful.|I should be writing right now.}
<- desert_option("Novelist",_novelist)
+ [Goodbye.]
-
-> main_loop



VAR made_bet = false
VAR debt_payed = false
=== student ===
-> check_chloroformed(_student) ->
-> check_groggy("Student",_student) ->
-> check_eating(_student) ->
{
 - made_bet and not debt_payed:
   -> ask_about_money

}
Student: {shuffle:I'm going to change the world some day!|I should be studying for the bar exam.|I had that dream about the unexpected final exam again.}
 * You: What do you study?
   Student: I'm studying law.
   Student: I've almost graduated, actually!
   ** You: So you're going to be a lawyer?
     Student: Yup!
     Student: Well, assuming I pass the bar exam.  Fingers crossed.
     *** You: I'm sure you'll do fine.
        Student: Probably! I'm top of my class.
        Student: I'm really good at lawyering.
        Student: They say I could talk anyone into anything.
        **** You: Oh, really?
            -> make_bet
     // Not sure about this one:
     //** You: A female lawyer? Seems unlikely.
     //   Student: What's wrong with you? It's 1932.
     //   Student: Women can be whatever they want to be.
 + [Goodbye.]
-
-> main_loop
= make_bet
You: I bet you couldn't convince the conductor to stop the train right now.
Student: How much you wanna bet?
* You: Let's say $200.
-
Student: You're on.
* [Wimp out.]
  You: Actually, on second thought, no.
  Student: Coward.
  -> main_loop
* [Shake on it.]
  ~ made_bet = true
  You shake on it.
  Student: Excellent. Now watch this.
  Student: HEY, CONDUCTOR! I've noticed that no one has inspected the axle bearings since we left Banff.
  Student: This violates section 132.43 of the <i>Railway Code</i>.  You'd better stop and inspect them real quick if you don't want to get sued.
  Conductor: By Jove, she's right!
  ~ delayTrain(60,"Conductor: Alright, that's that sorted.  Let's get going again.")
  Student: You owe me 200 bucks.
  ** You: Really?
  --
  Student: You entered a legally binding oral contract.
  ** {inventory has money}You: Ok, fine.
     ~ inventory -= money
     You hand over the money.
     Student: Pleasure doing business with you.
  ** You: I'll get you the money before we arrive.
     Student: You will if you know what's good for you.
-
-> main_loop
= ask_about_money  
Student: Do you have the money yet?
+ {inventory has money} You: Here, take it.
     ~ inventory -= money
     You hand over the money.
     Student: Pleasure doing business with you.
     ~ debt_payed = true
     -> main_loop
 + You: No, I'll get back to you.
   Student: You'd better.
   -> main_loop






