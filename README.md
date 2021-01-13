# Akkuschrauber - Assembly project to simulate an electric screwdriver on a Lucas Nülle 8051 MCLS-Modular board
----
### About this project
This assembly project "Akkuschrauber" (German for "cordless electric screwdriver") was a graded project that a friend of mine and I needed to develop for a subject called microprocessors that we had in our university studies programme. In this subject we learned a lot about the internals of the 8051 microprocessor family and we also learned how to develop small programs in assembly for this specific microprocessor. As a final project, which would be graded and count as one third of our final grade, we needed to make use of the microcontroller, some buttons and a stepping motor, while needing to run the motor in half and full steps, including backward and forward rotation. Other than those constraints, we were free to choose what project we would envisage. After some thinking, my friend and I came to the conclusion that simulating a cordless electric screwdriver would perfectly fit the requirements, so we decided to go with this idea.

### How does it work?
* The basic principle of operation is that we have have four buttons, a stepping motor and a four digit (seven segment) display connected to different ports of the microprocessor, with each button corresponding to a different operating mode of the screwdriver. The three first buttons offer a clockwise rotation of the motor with a revolution speed of 20, 40 and 60 RPM (full steps) while the last button offers a counter-clockwise rotation with 20 RPM (half steps). This means that we have three different speeds to screw in the screw and one to screw it out. While one of the buttons is pressed, the stepping motor begins to operate at the programmed speed and direction, while displaying the rotation speed and direction on the four digit (seven segment) display. The text reads 20tr (20 RPM), 40tr(40 RPM), 60tr(60 RPM) and -20t(negative 20 RPM), with "tr" meaning "tours (par minute)" (French for "rounds (per minute)"), depending on the selected mode of operation.
* In case several buttons are pressed, the motor goes into failsafe mode and stops immediately.
* As soon as the button is released, the motor also stops immediately as a safety measure.
* While nothing is done, the display shows "OFF".

### Hardware
Lucas Nülle MCLS-Modular 8051 development board, including:
* a stepper motor, with 192 half steps equalling a full revolution
* a 4 digit display (seven segment display)
* 8 buttons, of which 4 were used
* connection cables

Other hardware used:
* a DC-power generator
* a probe to test HIGH/LOW signals
* Windows 10 PC running Windows XP in a VM with the MCLS-Modular IDE
* Serial port cable to connect the board to the PC

### Port pin assignment
![](https://github.com/Grima04/Akkuschrauber/blob/main/Port-pin-assignment.png)

### Flow chart (in German)

### The project in action
![](https://github.com/Grima04/Akkuschrauber/blob/main/Akkuschrauber_in_Aktion.gif)

### Gallery
Full setup in the lab:
![](https://github.com/Grima04/Akkuschrauber/blob/main/full-setup.jpg)
MCLS-Modular board setup closeup:
![](https://github.com/Grima04/Akkuschrauber/blob/main/board-closeup.jpg)
Stepper motor closeup:
![](https://github.com/Grima04/Akkuschrauber/blob/main/motor-closeup.jpg)
