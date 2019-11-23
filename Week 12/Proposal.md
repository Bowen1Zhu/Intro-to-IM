### Project Description
A driving game in which the player controls a car using steering wheel (direction) and pedals (speed). The player can collect gas, coins, and extra lives during the drive and meanwhile should avoid bumping into another car, hit the curb, or running out of gas in order to keep the game going.
### List of parts I need that are not in my kit
Pieces of wood, cardboard, large potentiometer and pushbuttons.
### Description of the Arduino program
Use analogRead() to read the potentiometer, which measures the angle of the steering wheel; use digitalRead() to read the pushbuttons, which measure the state of the pedals. Constantly send the data to the Processing program.
### Description of the Processing program
After the game starts, make the player’s car move horizontally according to the data from the Arduino program; meanwhile, randomize the positions of all other elements (other cars, gas, etc.) and let them move downwards to create the induced upward movement of the player’s car. In addition, check if the car collides with any other elements and then trigger events accordingly. Keep a score based on the distance travelled and coins collected and update the scoreboard after the game.
### Things I need to learn
How to produce the shapes with Adobe Illustrator, and then how to install the potentiometer into the steering wheel; how to build the pedals.
### Areas of greatest concern
The physical part of the project—if the steering wheel and pedals turn out to be infeasible, I may have to turn to other control methods, such as distance sensor or joystick.
