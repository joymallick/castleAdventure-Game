/* Setting to dynamic otherwise cannot be changed when static */
:- dynamic at/1, go/1, whereAmI/0, item/2 ,connections/2.
:- retractall(at(_)),retractall(go(_)),retractall(whereAmI).


:- initialization introduction.
/* this is the starting location at the start of the game    */
at(entrance).

/* Here are all the connections between each room and they are made both ways */
connections(entrance,atrium).
connections(atrium,entrance).
connections(atrium,greatHall).
connections(atrium,staircase).
/* fails the game if enters dungeon without sword */
connections(atrium,dungeon):- item(sword,greatHall),
                              write("Opps!You failed the game."),
						                  nl,
					                    halt.
/* end the game as a victory when the user has the sword when reached dungeon */
connections(atrium,dungeon):- item(sword,with_me),
						                	write("-----You win!"),nl,
                              write("--- what a journey it has been"),nl,
						                	halt.     

connections(greatHall,atrium).
connections(staircase,atrium).
connections(dungeon,atrium).
connections(staircase,masterBedroom).
connections(masterBedroom,staircase).
/* it shows this connection only when the user has the amulet with him */
connections(staircase,dungeon):- item(amulet,with_me).

/* the two items to be used in the games*/
item(amulet,masterBedroom).
item(sword,greatHall).  

/* this helps to move through each location by retracting the old one and adding  the new one */
go(Newlocation):- at(Currentlocation),
            connections(Currentlocation,Newlocation),
            retract(at(Currentlocation)),
						asserta(at(Newlocation)),
						write("You have moved to "),write(Newlocation),
						!.

/* if user writes names of locations other than the one present this message will be shown */              
go(_):- write('Sorry it is not possible to go there').

       						
/*Through this query the user can know the current location */
whereAmI:- at(Currentlocation),
           write("Your current location is at the "),write(Currentlocation).

/*This helps to show the location that are attached to the current location the user is at */
lookAround:- at(Currentlocation),
             connections(Currentlocation,Nextloc),
						 write(Nextloc),write(" the nearest location around you"),nl,
						 item(Obj,Currentlocation),
						 write(Obj),nl,
						 fail.


/* if the user is already holding the item then this messageis printed*/
pickup(Obj) :-
        item(Obj, with_me),
        write(' already holding the item!'),
        nl, !.

/* helps to pickup an item and prints a confirmation about which item was picked */
pickup(Obj) :-
        at(Currentlocation),
        item(Obj, Currentlocation),
        retract(item(Obj, Currentlocation)),
        assert(item(Obj, with_me)),
        write('Picked up '),write(Obj),
        nl,
				!.

pickup(_) :-
        write(' the item cannot be seen here try looking it at another location .'),
        nl,
				!.

instructions :-
        nl,
				nl,
        nl,
        write('Here are the following commands.'), nl,
        write('Dont forget to put a fullstop after the commands !!!'), nl,
        write('pickup(Item).            --- picks up an item.'), nl,
        write('drop(Item).              --- drops the item.'), nl,
        write('lookAround.              --- looks at connected locations and any items around'), nl,
        write('instructions.            --- will show this informations again when needed.'), nl,
        write('go(Location).            --- to move to desired location. '), nl,
				write('whereAmI.                --- help you check the current location.'),nl,
        nl.

introduction:- write("--------------------------------------------"),nl,
               write("-------Welcome to the game"),nl,
							 write("-------Your goal is to reach the dungeon by collecting a sword inorder to defeat a monster."),nl,
               write("-------look around and you shall find the item to complete your mission."),nl,
               write("-------To know more info type instructions."),nl,
							 write("--------------------------------------------"),
							 nl.
               
             
/*extra functionality  which drops the item*/
drop(Obj) :-
        item(Obj, with_me),
        at(Place),
        retract(item(Obj, with_me)),
        assert(item(Obj, Place)),
        write('Dropped the '),write(Obj),
        nl,
				!.

drop(_) :-
        write('You are not holding it!'),
        nl,
				!.    