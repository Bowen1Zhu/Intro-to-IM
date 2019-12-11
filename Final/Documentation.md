### Overall project concept and description
I created a driving game in which the player selects a car on the screen and controls the car using a physical steering wheel and pedals. The player can collect elements such as gas, coins, and extra lives in the game and meanwhile should avoid bumping into another car, hit the curb, or running out of gas in order to keep the game going. After the game, his/her score is calculated and a scoreboard is presented. The player (or another player) can restart the game and keep playing.
### Overall pictures
Hardware: the pedals (right) are connected to the steering wheel; the steering wheel (middle) is connected to the Arduino; the Arduino (left) is connected to the laptop.

![](https://github.com/Bowen1Zhu/Intro-to-IM/blob/master/Final/Documentation_Pictures/overall%20picture.jpg)

During the game:
![during the game](https://github.com/Bowen1Zhu/Intro-to-IM/blob/master/Final/Documentation_Pictures/game%20picture%201.png)

After the game:
![score](https://github.com/Bowen1Zhu/Intro-to-IM/blob/master/Final/Documentation_Pictures/game%20picture%202.png)<br/>score

![scoreboard](https://github.com/Bowen1Zhu/Intro-to-IM/blob/master/Final/Documentation_Pictures/game%20picture%203.png)<br/>scoreboard
### List of important parts
Pedals, steering wheel, Arduino board, and laptop.
### System diagram
![](https://github.com/Bowen1Zhu/Intro-to-IM/blob/master/Final/Documentation_Pictures/system%20diagram.jpg)
### Picture inside the steering wheel
The wires from the pedals are connected to the steering wheel, so I only need to solder wires inside the steering wheel.

![](https://github.com/Bowen1Zhu/Intro-to-IM/blob/master/Final/Documentation_Pictures/steering%20wheel.jpg)
### Code
[Processing](Final_Processing/Final_Processing.pde)

[Arduino](Final_Arduino/Final_Arduino.ino)
### How my project works and how I built it
For the hardware part, professor helped me cracked the steering wheel and the pedal to see how the wires are connected inside. Then, with professor's help, I cut those wires and soldered new wires to connect the potentiometer behind the steering wheel and the pedals to the Arduino board so that the change in their resistance can be measured.

For the software part, the Arduino program uses analogRead() to read the data from the physical system and maps them and then sends them to the Processing program. The Processing program constantly reads the data from the serial port and uses the data to move the car accordingly; meanwhile, it constantly updates (moves positions, checks collision, draws images, etc.) all other elements (other cars, things to be collected, background, etc.) and figures (gas amount, speed, distance, money, etc.) until the player loses the game. After that, the player's score and the scoreboard are shown and the Processing program detects any key press which can enter the player's name or restart the game. (There are some other functions that the Processing program needs to take care of, such as turning on/off the headlights when key is pressed and producing car emissions when the gas pedal is pushed.)
### Problems I ran into and how I resolved them
Overall, the game was produced smoothly enough, but I realized that the player might not actually play the game in the way I had expected. For example, initially, because all other cars in the game were initialized in front of the player's car (above the screen), if the player drives slowly enough, he/she could fall behind and thus avoid driving among the other cars. To urge the player to drive fast enough, I decided to add some backup cars which will appear behind the player if he/she is driving too slowly. Thus the player has to speed up so as to avoid being bumped by them. It turned out that it's more sophisticated to implement than I thought, because these cars can't go faster than other cars otherwise they will bump into each other (which is also why I can't assign each car a different speed when a test driver suggested so); to prevent these cars from falling behind, they also need to be deactivated once the player reaches a certain speed and reactivated behind the player when he/she slows down again.
### Feedback I received during user testing and what changes I made
I did lots of [user testing](https://drive.google.com/file/d/1ghy1Q2UwGgTk7e6LFAdPfeSmYc2YOOe4/view?usp=sharing) and most people said the game is more exciting than they expected (one of my friend even broke my steering wheel during a game). Through the feedback from many users, I was able to adjust the sensitivity of the device as some felt that the steering wheel was too sensitive while some told me the pedals were too sensitive as well.

Another change I made is to add friction to the drive which will reduce the speed slowly if the player does not push the gas—previously, I didn't think of friction so the speed of the car was fixed if the player doesn't control the pedals (like an automatic cruise control). I totally agree with it when my first player raised this suggestion, as she said it looks more real, and it also prompts the player to control the speed constantly. I also set the friction to be proportional to the speed so that it feels more natural.

One of the players likes to drift the car—driving at a relatively slow speed but with sharp turns. He made me realize that I should also constrain the range of the direction as the speed of the cars is dependent on the direction (otherwise the speed might become negative in extreme situations).

Other changes are relatively minor. For example, I made the background a bit lighter so that the canvas seems less dizzy and more user-friendly.

There are other suggestions that I didn't accept. For example, a player said that, when he flashed the headlights, he wanted the car in front of him to change lanes so that he could overtake it. However, it would be hard to implement this since changing the lane of a car may result in its collision with another car.
