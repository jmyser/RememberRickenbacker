# Remember Rickenbacker
**Jay Myser**

**MVNU GPS**

*5.3.2017*

## 1. Introduction 
### 1.1 System Overview

The purpose of my project is to design a game for the iOS mobile system.  This will be a project designed to gain familiarity with the system and tools for iOS development as well as the specific hardware capabilities available for mobile devices.

Hopefully this will develop into a full-featured game that will attract a larger audience.  However, at the beginning the user and stakeholder will be myself as I seek to learn and develop skills.


### 1.2 Human Resources
I will utilize my professors' expertise and various online experts and tutorials to develop this game

### 1.3 Business Context
At this time, there is no business context.  Perhaps if this project develops into a more mature product, business context will have to be developed.


## 2. User Requirements (written for customers) 
### 2.1 User Objectives
This iOS game will be an overhead space shooter game.  The unique element that will be possible thanks to mobile hardware is that ship controls will be done via tilting the device, using the hardware accelerometers to dictate ship direction and movement.  There will be thumb buttons for various types of weapons to be used.

There will be a set map or board with enemy targets scattered throughout.  Using the controls, you will maneuver around the map trying to eliminate all the enemies without getting shot down.  Play ends when all the enemies are cleared off the board.  I haven’t decided if you will have a constant movement speed or if there will be an independent speed control.  This will probably depend on other factors moving forward.

This project will be focused on the iOS platform, but I hope to develop the system in a modular fashion that would facilitate porting to other platforms in the future (namely Android).

I feel like this style of project will also let me use some of my artistic skills as I develop graphics for the game.


### 2.2 Similar System Information
This is a stand alone system developed for the iOS platform.  Apart from dependancies on the operating system and other iOS game libraries, there is no other packages that it will interface with.

### 2.3 User Characteristics
This is an iOS game and as such it will have a very wide audience.  Gameplay should be simple and intuitive so there should be a very low barrier to entry. 

## 3. Functional Requirements 

### 3.1. Flight Control 
+ Description
   The user should be able to control the movement of the spacecraft using the tilt sensors built into their device.
+ Inputs
   Device accelerometers
+ Outputs
   Based on angle and degree of tilt, ship will change course and speed.
+ Criticality
   This is *the* central feature of the game.
+ Risks
   This may present an increased technical challenge over other forms of input and will need to be researched thoroughly.
+ Dependencies with other requirements
   This will depend on taking input from the device's hardware so it is dependant on hooking into that.

### 3.2. Weapon Systems 
+ Description
   The user will be able to fire a variety of weapons to eliminate enemy ships.
+ Inputs
   There will be a fire button and another button to select different weapons
+ Outputs
   Based on the selected weapon, the fire button will fire the weapon.
+ Criticality
   This will be very important to the functionality of the game.
+ Risks
   This feature should be fiarly straightforward to implement and I have found several resources already to help.
+ Dependencies with other requirements
   This will depend on taking input from the device's hardware so it is dependant on hooking into that.

### 3.3. Enemy Spacecraft
+ Description
   The game field will be populated with a number of enemy space craft that will need to be eliminated.
+ Inputs
   Enemies are spawned automatically when the game loads.
+ Outputs
   Once spawned, the enemies will fly randomly and *possibly* fire at the player ship.
+ Criticality
   This will be very important to the functionality of the game.
+ Risks
   This feature should be fiarly straightforward to implement and I have found several resources already to help.
+ Dependencies with other requirements
   This will depend on taking input from the device's hardware so it is dependant on hooking into that.
   
### 3.3. Scoreboard
+ Description
   The user will score points for every enemy destroyed.
+ Inputs
   Every enemy destroyed
+ Outputs
   Increment score
+ Criticality
   Not a critical feature at this time, but may become one in the future.
+ Risks
   Low risk at this time.
+ Dependencies with other requirements
   This will depend on interactions between the player and enemy ships.

## 4. Interface Requirements 
The game will be a full screen iOS game.  It will use device accelerometers for movement and on screen buttons for fire control.

### 4.1 User Interfaces
This will use a GUI game interface and the device's screen.

### 4.2 Hardware Interfaces
The game will utilize touch and accelerometer sensors built into an iOS device.

### 4.3 Communications Interfaces
*n/a*

### 4.4 Software Interfaces
The only library/API determined to be needed so far at this point is the Xcode Sprite Kit.  This is a game development platform created by Apple for simple 2d based games.


## 5. Non-Functional Requirements 

### 5.1 Hardware Constraints
This will only run on later model iOS devices at this time to ensure functionality.  There is a future possiblity of lowering device hardware specifications or porting to another platform but they will be outside of the scope of this document at this time.

### 5.2 Performance Requirements
Given that this will be a relatively simple game and that I will develop targeting more modern devices, I don't forsee there being a performance bottleneck

### 5.3 System Environment Constraints
*n/a*

### 5.4 Security Requirements 
*n/a*

### 5.5 Reliability 
There won't be any systems depending on this game, so outside of being stable for it's own sake, there isn't any reliability concerns.

### 5.6 Maintenance
*n/a*

### 5.7 Portability
Modern iOS devices

### 5.8 Extensibility
iOS projects are set up to target certain minimum versions of iOS so there shouldn't be any issues with compatibility beyond system requirements.

### 5.9 Development Process Constraints
This will be developed on an Apple Mac computer using Xcode and specifically the Sprite Kit package.  It is technically possible to develop iOS applications on other platforms, but at this time I am already using those tools so it will be a seamless project on this front.


## 6. System Models

### Operational Scenarios 
When the application opens the player will be presented with a splash screen with basic instructions and game play will begin when this is dismissed.  Player will contorl their space craft around the game board an try to eliminate all the enemy space craft.  Game play ends when all the enemy craft have been destroyed or the player is killed.

### System Architecture Diagrams
![Basic Sad Diagram](https://github.com/jermyser/RememberRickenbacker/blob/master/sadDiag.jpg "Basic Sad Diagram")

## 8. Appendices 
Specifies other useful information for understanding the requirements. Most requirements should include at least the following two appendices: 

### Definitions, Acronyms, Abbreviations
**iOS** - This is the name of Apple's mobile operating system.  It is the truncated form of iPhone(and later iPad) Operating System.

### References

[Apple Developer Website](https://developer.apple.com/)

[Sprite Kit for iOS Development](https://developer.apple.com/spritekit/)
