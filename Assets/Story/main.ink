INCLUDE inventory.ink
INCLUDE interactions.ink
INCLUDE API.ink

CONST player_name = "Augustin du Pont"

-> prologue

=== prologue
~changeVisualState("fireplace","unlit") // Slight hack, sorry.
You are {player_name}, the world-famous thief.
In the winter of 1932 you find yourself traveling in luxury aboard <i>The Imperial Limited</i>, where proprietary plans for an innovative hydrogen airship are being transported to Vancouver under lock and key.
A secretive patron has promised to pay you handsomely for these plans.
* [Continue...]
  -> main_loop

=== main_loop
# MENU
// Note: this should not be displayed to player, since we are in "menu mode"
menu
//{"Inventory: " + prettyPrintInventory()}
{"Objectives: " + prettyPrintObjectives()}
//Available interactions:
+ [INTERACT("safe")] -> safe
+ [INTERACT("guard")] -> guard
+ [INTERACT("mechanic")] -> mechanic
+ [INTERACT("inventor")] -> inventor
+ [INTERACT("hunter")] -> hunter
+ [INTERACT("magnate")] -> magnate
+ [INTERACT("novelist")] -> novelist
+ [INTERACT("student")] -> student

+ [INTERACT("fireplace")] -> fireplace
+ [INTERACT("sink")] -> sink
+ [INTERACT("oven")] -> oven
+ [INTERACT("plant")] -> plant
+ [INTERACT("drawer")] -> drawer
+ [INTERACT("table")] -> table
+ [GAME_OVER] -> game_over
+ [WAKE_ALL]
  ~characterAwakes("guard")
  ~characterAwakes("mechanic")
  ~characterAwakes("magnate")
  ~characterAwakes("inventor")
  ~characterAwakes("novelist")
-> main_loop


=== game_over ===
The whistle sounds as <i>The Imperial Limited</i> pull into Waterfront station.
{
 - not safe_opened:
  You disembark safely with the other passengers.
  Alas, you were not able to obtain the coveted airship designs.
 - inventory has letter:
   -> letter_confrontation
 - LIST_COUNT(panicked) > 0:
   ~ temp snitch = LIST_MIN(panicked)
     Almost immediately {name(snitch)} reports your crime to the police.
     You are lead away in handcuffs, and so ends the illustrious career of {player_name}.
 - LIST_COUNT(chloroformed) > 0:
   ~ temp body_found = LIST_MIN(chloroformed)
   As the other passengers get up and begin to disembark, someone finds the unconscious body of {name(body_found)}.
   The police encircle the train to find the culprit.
   While taking your fingerprints they recognize you as the notorious criminal {player_name}.
   You are led away in handcuffs - a disappointing end to an illustrious career.
 - made_bet and not debt_payed:
   You step off the train safely and disappear into the crowds of Gastown.
   Two days later you are served with a summons to small claims court.
   The law student is suing you for the money you owe pursuant to your bet.
   ** [Settle the case for $300.]
      You decide to settle for $300, substantially more than the initial bet.
      -> END
   ** [Fight it in court.]
      You attempt to defend yourself.
      In the process, subpoenad documents reveal your identity as the notorious criminal {player_name}, and you are promptly arrested.
      What a disappointing end to your career!
      Also, the student wins her lawsuit, recovering her original $200 plus $1000 in attorney fees.
      // TODO Alternate ending: maybe she passes the bar, offers to represent
      //  you in court for a hefty fee, and gets you off on a technicality?
      -> END
 - inventory has airship_plans:
   You step off the train safely and disappear into the crowds of Gastown, with the airship plans securely in hand.
   Another successful heist for {player_name}, despite the attempted framing!
 - else:
   You step off the train safely and disappear into the crowds of Gastown.
   Unfortunately, you never did find out what happened to those airship plans.
}
-> END

= letter_confrontation
Stepping off the train, the fake calling-card note slips from your pocket.
Before you can react, {name(_inventor)} spots it.
Inventor: What's this?
Inventor: Aha! You're the one who stole my airship plans!
* You: What are you talking about?
  Inventor: Don't play dumb with me, thief!
  Inventor: POLICE! Arrest this rapscallion!
* You: No, you don't understand!
  Inventor: What don't I understand?
  ** You: I'm being framed!
    Inventor: By who?
    *** You: Probably a rival thief.
        Inventor: So you admit you're a thief.
        Inventor: POLICE! Arrest this scoundrel!
  ** You: I found that note in the safe.
    You: It was planted before I got there!
    Inventor: Why were you opening my safe?
    Inventor: POLICE! Arrest this incompetent criminal!
-
The police drag you away, not heeding your pathetic protestations.
This is the end for {player_name}.
-> END


