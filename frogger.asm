#####################################################################
#
# CSC258H5S Winter 2022 Assembly Final Project
# University of Toronto, St. George
#
# Student: Kobi Schmalenberg
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 5 Easy + 1 Hard
# 1. (Game Over Screen) = Easy
# 2. (Start Menu Screen) = Easy
# 3. (Pause Screen) = Easy
# 4. (Random Size Vehicles/Logs) = Easy
# 5. (Sound Effects) = Easy
# 6. (2 Player Mode Option) = Hard
# ... (add more if necessary)
#####################################################################
.data
displayAddress: .word 0x10008000
frogXY: .word 3840
frogTwoXY: .word 3960
vehicleRow: .word 0x606060:160 #allocate space for 1 vehicle row(32*5)
vehicleRowTwo: .word 0x606060:160
logRow: .word 0x0000ff:160
logRowTwo: .word 0x0000ff:160
i: .word 0
size: .word 160
goalRow: .word 0x00ff00:64 #allocate sapce for the goal region(32*2)
goalOne: .word 284 #set position of the first goal
goalTwo: .word 316 #set position of the second goal
goalThree: .word 348 #set position of the third goal

.text
lw $s0, displayAddress # $t0 stores the base address for display
li $a2, 0xff00ff #set goalOne colour to purple
li $a3, 0xff00ff #set goalTwo colour to purple

#----------------------------------------------------------------------------
jal loadVehiclesFunc
jal loadLogsFunc
jal loadGoalOneFunc
jal loadGoalTwoFunc
lw $k1, frogXY
lw $s7, frogTwoXY
lw $t2, goalOne
lw $s4, goalTwo

startMenu:
lw $s0, displayAddress
li $t8, 0 #reset $t8 to 0
li $t9, 4092 #set $t9 to 4092
li $t2, 0x000000 #change our current colour to black
jal box320 #jump to func box320 and link to next line
jal drawSinglePlayer
jal drawDivider
jal drawTwoPlayer
j startMenuHelper

drawDivider:
move $t1, $ra
li $t2, 0xffffff #change our current colour to white
lw $s0, displayAddress
addi $s0, $s0, 2048
li $t8, 0 #reset $t8 to 0
li $t9, 32 #set $t9 to 32
jal drawHorizontal
move $ra, $t1
j boxEnd

drawSinglePlayer:
#draw 1
move $t1, $ra
li $t2, 0xffffff #change our current colour to white
lw $s0, displayAddress
addi $s0, $s0, 432
li $t8, 0 #reset $t8 to 0
li $t9, 10 #set $t9 to 32
jal drawVertical
#next is to draw the P
lw $s0, displayAddress
addi $s0, $s0, 452
li $t8, 0 #reset $t8 to 0
li $t9, 10 #set $t9 to 32
jal drawVertical
lw $s0, displayAddress
addi $s0, $s0, 452
li $t8, 0 #reset $t8 to 0
li $t9, 5 #set $t9 to 32
jal drawHorizontal
lw $s0, displayAddress
addi $s0, $s0, 472
li $t8, 0 #reset $t8 to 0
li $t9, 6 #set $t9 to 32
jal drawVertical
lw $s0, displayAddress
addi $s0, $s0, 1092
li $t8, 0 #reset $t8 to 0
li $t9, 5 #set $t9 to 32
jal drawHorizontal
move $ra, $t1
j boxEnd

drawTwoPlayer:
#draw 2
move $t1, $ra
li $t2, 0xffffff #change our current colour to white
lw $s0, displayAddress
addi $s0, $s0, 2460
li $t8, 0 #reset $t8 to 0
li $t9, 5 #set $t9 to 32
jal drawHorizontal
li $t8, 0 #reset $t8 to 0
li $t9, 6 #set $t9 to 32
jal drawVertical
addi $s0, $s0, -148
li $t8, 0 #reset $t8 to 0
li $t9, 5 #set $t9 to 32
jal drawHorizontal
addi $s0, $s0, -20
li $t8, 0 #reset $t8 to 0
li $t9, 4 #set $t9 to 32
jal drawVertical
li $t8, 0 #reset $t8 to 0
li $t9, 6 #set $t9 to 32
jal drawHorizontal
#next is to draw the P
lw $s0, displayAddress
addi $s0, $s0, 2500
li $t8, 0 #reset $t8 to 0
li $t9, 10 #set $t9 to 32
jal drawVertical
lw $s0, displayAddress
addi $s0, $s0, 2500
li $t8, 0 #reset $t8 to 0
li $t9, 5 #set $t9 to 32
jal drawHorizontal
lw $s0, displayAddress
addi $s0, $s0, 2520
li $t8, 0 #reset $t8 to 0
li $t9, 6 #set $t9 to 32
jal drawVertical
lw $s0, displayAddress
addi $s0, $s0, 3140
li $t8, 0 #reset $t8 to 0
li $t9, 5 #set $t9 to 32
jal drawHorizontal
move $ra, $t1
j boxEnd

startMenuHelper:
lw $t8, 0xffff0000 #obtains value of the element in the memory location where keystroke events are noted(value = 1 if keystroke occured)
beq $t8, 1, startMenuItems
j startMenuHelper

startMenuItems:
lw $s0, displayAddress
lw $k1, frogXY
lw $s7, frogTwoXY
lw $t2, 0xffff0004 #obtains value of the element in the memory location next to where Oxffff0000 is
beq $t2, 0x31, RunGameFunc #checks if $t2 = 1 and jumps to singleplayer mode
beq $t2, 0x32, RunGameFuncTwo #checks if $t2 = 2 and jumps to twoplayer mode
beq $t2, 0x71, respondToQ
j startMenuItems

RunGameFunc:
lw $s0, displayAddress
la $k0, RunGameFunc
add $t8, $zero, $zero #add $t8, set to zero
add $t9, $zero, 128 #add $t9, set to 128
li $t2, 0x00ff00 # $t2 stores the green colour code, start/end colour
jal box128 #jump to func box128 and link the next line

li $t8, 0 #reset $t8 to 0
li $t9, 320 #set $t9 to 320
li $t2, 0x0000ff #change our current colour to blue
jal box320 #jump to func box320 and link to next line

li $t8, 0 #reset $t8 to 0
li $t9, 128 #set $t9 to 128
li $t2, 0xffff00 #change our current colour to yellow
jal box128 #jump to func box128 and link to next line

li $t8, 0 #reset $t8 to 0
li $t9, 320 #set $t9 to 320
li $t2, 0x606060 #change our current colour to grey
jal box320 #jump to func box320 and link to next line

li $t8, 0 #reset $t8 to 0
li $t9, 128 #set $t9 to 128
li $t2, 0x00ff00 #change our current colour to green
jal box128 #jump to func box128 and link to next line

la $t6, goalRow
lw $s0, displayAddress
li, $t1, 64
addi $s0, $s0, 256
lw $t4, i
jal paintVehiclesInit

la $t6, vehicleRow
lw $t4, i
lw $t1, size
li $t0, 0
lw $s0, displayAddress
addi $s0, $s0, 2304
jal paintVehiclesInit
lw $s0, displayAddress
addi $s0, $s0, 2944
lw $t4, i
la $t6 vehicleRowTwo
jal paintVehiclesInit

la $t6, logRow
lw $s0, displayAddress
addi $s0, $s0, 512
lw $t4, i
jal paintVehiclesInit
la $t6, logRowTwo
lw $s0, displayAddress
addi $s0, $s0, 1152
lw $t4, i
jal paintVehiclesInit

li $t8, 0 #reset $t8 to 0
li $t9, 2 #set $t9 to 2
li $t2, 0xfffffff #change our current colour to white
lw $s0, displayAddress
add $s0, $s0, $k1
jal drawFrog

lw $t9, size
li $t8, 0
la $t3, vehicleRow
lw $t3, 0($t3)
li $t7, 0
jal shifter
la $t3, vehicleRowTwo
lw $t3, 0($t3)
li $t7, 636
jal shifterLeft
la $t3, logRow
lw $t3, 0($t3)
li $t7, 0
jal logShifter
la $t3, logRowTwo
lw $t3, 0($t3)
li $t7, 636
jal logShifterLeft
#sleep code
li $v0, 32
li $a0, 100
syscall
#sleep code end
jal checkInput
jal carCollisionCheck
jal waterCollisionCheck
jal goalCollisionCheck

j RunGameFunc

RunGameFuncTwo:
lw $s0, displayAddress
la $k0, RunGameFuncTwo
add $t8, $zero, $zero #add $t8, set to zero
add $t9, $zero, 128 #add $t9, set to 128
li $t2, 0x00ff00 # $t2 stores the green colour code, start/end colour
jal box128 #jump to func box128 and link the next line

li $t8, 0 #reset $t8 to 0
li $t9, 320 #set $t9 to 320
li $t2, 0x0000ff #change our current colour to blue
jal box320 #jump to func box320 and link to next line

li $t8, 0 #reset $t8 to 0
li $t9, 128 #set $t9 to 128
li $t2, 0xffff00 #change our current colour to yellow
jal box128 #jump to func box128 and link to next line

li $t8, 0 #reset $t8 to 0
li $t9, 320 #set $t9 to 320
li $t2, 0x606060 #change our current colour to grey
jal box320 #jump to func box320 and link to next line

li $t8, 0 #reset $t8 to 0
li $t9, 128 #set $t9 to 128
li $t2, 0x00ff00 #change our current colour to green
jal box128 #jump to func box128 and link to next line

la $t6, goalRow
lw $s0, displayAddress
li, $t1, 64
addi $s0, $s0, 256
lw $t4, i
jal paintVehiclesInit

la $t6, vehicleRow
lw $t4, i
lw $t1, size
li $t0, 0
lw $s0, displayAddress
addi $s0, $s0, 2304
jal paintVehiclesInit
lw $s0, displayAddress
addi $s0, $s0, 2944
lw $t4, i
la $t6 vehicleRowTwo
jal paintVehiclesInit

la $t6, logRow
lw $s0, displayAddress
addi $s0, $s0, 512
lw $t4, i
jal paintVehiclesInit
la $t6, logRowTwo
lw $s0, displayAddress
addi $s0, $s0, 1152
lw $t4, i
jal paintVehiclesInit

li $t8, 0 #reset $t8 to 0
li $t9, 2 #set $t9 to 2
li $t2, 0xfffffff #change our current colour to white
lw $s0, displayAddress
add $s0, $s0, $k1
jal drawFrog
li $t8, 0 #reset $t8 to 0
li $t9, 2 #set $t9 to 2
li $t2, 0xfffffff #change our current colour to white
lw $s0, displayAddress
add $s0, $s0, $s7
jal drawFrogTwo

lw $t9, size
li $t8, 0
la $t3, vehicleRow
lw $t3, 0($t3)
li $t7, 0
jal shifter
la $t3, vehicleRowTwo
lw $t3, 0($t3)
li $t7, 636
jal shifterLeft
la $t3, logRow
lw $t3, 0($t3)
li $t7, 0
jal logShifter
la $t3, logRowTwo
lw $t3, 0($t3)
li $t7, 636
jal logShifterLeft
#sleep code
li $v0, 32
li $a0, 100
syscall
#sleep code end
jal checkInput
jal carCollisionCheck
jal waterCollisionCheck
jal goalCollisionCheck
jal carCollisionCheckTwo
jal waterCollisionCheckTwo
jal goalCollisionCheckTwo

j RunGameFuncTwo

loadLogsFunc:
move $s3, $ra
li $v0, 42
li $a0, 0
li $a1, 10
syscall
li $s1, 3
ble $a0, $s1, loadLogsFunc
li $t8, 0 #reset $t8 to 0
move $t9, $a0 #set $t9 to 5
add $t7, $zero, $zero #add $t7, set to zero, used for vehicle array index
li $t3, 0x964b00 #set $t3 to log colour
jal loadLogs
li $t8, 0 #reset $t8 to 0
addi $t7, $t7, 44
jal loadLogs
move $ra, $s3
j boxEnd


loadLogs:
beq $t8, $t9, boxEnd
sll $t0, $t7, 2 #make current i = 4*i
sw $t3, logRow($t7) #store colour red in current index of array
sw $t3, logRowTwo($t7)
addi $t7, $t7, 128
sw $t3, logRow($t7)
sw $t3, logRowTwo($t7)
addi $t7, $t7, 128
sw $t3, logRow($t7)
sw $t3, logRowTwo($t7)
addi $t7, $t7, 128
sw $t3, logRow($t7)
sw $t3, logRowTwo($t7)
addi $t7, $t7, 128
sw $t3, logRow($t7)
sw $t3, logRowTwo($t7)
addi $t7, $t7, -512
addi, $t8, $t8, 1
addi, $t7, $t7, 4
j loadLogs

loadVehiclesFunc:
move $s3, $ra
li $v0, 42
li $a0, 0
li $a1, 10
syscall
li $s1, 3
ble $a0, $s1, loadVehiclesFunc
li $t8, 0 #reset $t8 to 0
move $t9, $a0 #set $t9 to $a0
add $t7, $zero, $zero #add $t7, set to zero, used for vehicle array index
li $t3, 0xff0000 #set $t3 to car colour
jal loadVehicles
li $t8, 0 #reset $t8 to 0
addi $t7, $t7, 44
jal loadVehicles
move $ra, $s3
j boxEnd


loadVehicles:
beq $t8, $t9, boxEnd
sll $t0, $t7, 2 #make current i = 4*i
sw $t3, vehicleRow($t7) #store colour red in current index of array
sw $t3, vehicleRowTwo($t7) #store colour red in current index of array
addi $t7, $t7, 128
sw $t3, vehicleRow($t7)
sw $t3, vehicleRowTwo($t7)
addi $t7, $t7, 128
sw $t3, vehicleRow($t7)
sw $t3, vehicleRowTwo($t7)
addi $t7, $t7, 128
sw $t3, vehicleRow($t7)
sw $t3, vehicleRowTwo($t7)
addi $t7, $t7, 128
sw $t3, vehicleRow($t7)
sw $t3, vehicleRowTwo($t7)
addi $t7, $t7, -512
addi, $t8, $t8, 1
addi, $t7, $t7, 4
j loadVehicles

paintVehiclesInit:
beq $t4, $t1, boxEnd
sll $t0, $t4, 2
addu $t0, $t0, $t6 #4i = 4i + memory location of array
lw $s2, 0($t0)
sw $s2, 0($s0)
addi $t4, $t4, 1
addi $s0, $s0, 4
j paintVehiclesInit

loadGoalOneFunc:
move $s3, $ra
li $t8, 0 #reset $t8 to 0
li $t9, 4 #set $t9 to 2
add $t7, $zero, $zero #add $t7, set to zero, used for vehicle array index
addi $t7, $t7, 28
jal loadGoalOne
#li $t8, 0 #reset $t8 to 0
#addi $t7, $t7, 24
#jal loadGoalOne
#li $t8, 0 #reset $t8 to 0
#addi $t7, $t7, 24
#jal loadGoalOne
#li $t8, 0 #reset $t8 to 0
move $ra, $s3
j boxEnd

loadGoalTwoFunc:
move $s3, $ra
li $t8, 0 #reset $t8 to 0
li $t9, 4 #set $t9 to 2
add $t7, $zero, $zero #add $t7, set to zero, used for vehicle array index
addi $t7, $t7, 84
jal loadGoalTwo
#li $t8, 0 #reset $t8 to 0
#addi $t7, $t7, 24
#jal loadGoalTwo
#li $t8, 0 #reset $t8 to 0
#addi $t7, $t7, 24
#jal loadGoalTwo
#li $t8, 0 #reset $t8 to 0
move $ra, $s3
j boxEnd


loadGoalOne:
beq $t8, $t9, boxEnd
sll $t0, $t7, 2 #make current i = 4*i
sw $a2, goalRow($t7) #store colour purple in current index of array
addi $t7, $t7, 128
sw $a2, goalRow($t7)
addi $t7, $t7, -128
addi, $t8, $t8, 1
addi, $t7, $t7, 4
j loadGoalOne

loadGoalTwo:
beq $t8, $t9, boxEnd
sll $t0, $t7, 2 #make current i = 4*i
sw $a3, goalRow($t7) #store colour purple in current index of array
addi $t7, $t7, 128
sw $a3, goalRow($t7)
addi $t7, $t7, -128
addi, $t8, $t8, 1
addi, $t7, $t7, 4
j loadGoalTwo

box128: #function for drawing 4*32 rectangles
beq $t8, $t9, boxEnd
sw $t2, 0($s0)
addi $s0, $s0, 4
addi $t8, $t8, 1
j box128

box320: #function for drawing 10*32 rectangles
beq $t8, $t9, boxEnd
sw $t2, 0($s0)
addi $s0, $s0, 4
addi $t8, $t8, 1
j box320

drawFrog: #function for drawing the frog
beq $t8, $t9, boxEnd
sw $t2, 0($s0) #see if drawing at $k1 makes a difference
addi $s0, $s0, 128
sw $t2, 0($s0)
addi $s0, $s0, -124
addi $t8, $t8, 1
j drawFrog

drawFrogTwo:
beq $t8, $t9, boxEnd
sw $t2, 0($s0) #see if drawing at $k1 makes a difference
addi $s0, $s0, 128
sw $t2, 0($s0)
addi $s0, $s0, -124
addi $t8, $t8, 1
j drawFrogTwo

boxEnd:
jr $ra


shifter:
beq $t8, $t9, loopEnd #break loop once we reach end of the array
sll $t0, $t7, 2 #make current i = 4*i
lw $t6, vehicleRow($t7) #load next index element so that it isn't lost
sw $t3, vehicleRow($t7) #store current index element in next index element
move $t3, $t6
addi, $t8, $t8, 1
addi, $t7, $t7, 4
j shifter

loopEnd:
li $t8, 0
li $t7, 0
sw $t3, vehicleRow($t7)
j boxEnd

shifterLeft: #for moving the second row of vehicles the other direction
beq $t8, $t9, loopEnd2 #break loop once we reach end of the array
srl $t0, $t7, 2 #make current i = 4*i
lw $t6, vehicleRowTwo($t7) #load next index element so that it isn't lost
sw $t3, vehicleRowTwo($t7) #store current index element in next index element
move $t3, $t6
addi, $t8, $t8, 1
addi, $t7, $t7, -4
j shifterLeft

logShifter:
beq $t8, $t9, logLoopEnd #break loop once we reach end of the array
sll $t0, $t7, 2 #make current i = 4*i
lw $t6, logRow($t7) #load next index element so that it isn't lost
sw $t3, logRow($t7) #store current index element in next index element
move $t3, $t6
addi, $t8, $t8, 1
addi, $t7, $t7, 4
j logShifter

logLoopEnd:
li $t8, 0
li $t7, 0
sw $t3, logRow($t7)
j boxEnd

logShifterLeft: #for moving the second row of vehicles the other direction
beq $t8, $t9, logLoopEnd2 #break loop once we reach end of the array
srl $t0, $t7, 2 #make current i = 4*i
lw $t6, logRowTwo($t7) #load next index element so that it isn't lost
sw $t3, logRowTwo($t7) #store current index element in next index element
move $t3, $t6
addi, $t8, $t8, 1
addi, $t7, $t7, -4
j logShifterLeft

loopEnd2:
li $t8, 0
li $t7, 636
sw $t3, vehicleRowTwo($t7)
j boxEnd

logLoopEnd2:
li $t8, 0
li $t7, 636
sw $t3, logRowTwo($t7)
j boxEnd


checkInput:
lw $t8, 0xffff0000 #obtains value of the element in the memory location where keystroke events are noted(value = 1 if keystroke occured)
beq $t8, 1, keyboardInput
beq $t8, 0, regularFrog

regularFrog:
li $t8, 0 #reset $t8 to 0
li $t9, 2 #set $t9 to 2
li $t2, 0xfffffff #change our current colour to white
lw $s0, displayAddress
j boxEnd

keyboardInput:
lw $t2, 0xffff0004 #obtains value of the element in the memory location next to where Oxffff0000 is
beq $t2, 0x61, respondToA #checks if $t2 is = to hex value of lowercase a
beq $t2, 0x73, respondToS #checks if $t2 is = to hex value of lowercase s
beq $t2, 0x64, respondToD #checks if $t2 is = to hex value of lowercase d
beq $t2, 0x77, respondToW #checks if $t2 is = to hex value of lowercase w
beq $t2, 0x71, startMenu #checks if $t2 is = to hex value of lowercase q
beq $t2, 0x70, respondToP #checks if $t2 is = to hex value of lowercase p
beq $t2, 0x72, respondToR #checks if $t2 is = to hex value of lowercase r
beq $t2, 0x6a, respondToJ #checks if $t2 is = to hex value of lowercase j
beq $t2, 0x6c, respondToL #checks if $t2 is = to hex value of lowercase L
beq $t2, 0x6b, respondToK #checks if $t2 is = to hex value of lowercase k
beq $t2, 0x69, respondToI #checks if $t2 is = to hex value of lowercase I
j boxEnd

respondToA: #moves frog left
li $v0, 31 #select $v0 value to play sounds
li $a0, 72 #pitch = C
li $a2, 5 #piano instrument
li $a3, 20 #volume
syscall
addi $k1, $k1, -8
j boxEnd

respondToJ: #moves 2nd frog left
li $v0, 31 #select $v0 value to play sounds
li $a0, 72 #pitch = C
li $a2, 5 #piano instrument
li $a3, 20 #volume
syscall
addi $s7, $s7, -8
j boxEnd

respondToS: #moves frog backwards
li $v0, 31 #select $v0 value to play sounds
li $a0, 72 #pitch = C
li $a2, 5 #piano instrument
li $a3, 20 #volume
syscall
addi $k1, $k1, 256
j boxEnd

respondToK: #moves 2nd frog backwards
li $v0, 31 #select $v0 value to play sounds
li $a0, 72 #pitch = C
li $a2, 5 #piano instrument
li $a3, 20 #volume
syscall
addi $s7, $s7, 256
j boxEnd

respondToD: #moves frog right
li $v0, 31 #select $v0 value to play sounds
li $a0, 72 #pitch = C
li $a2, 5 #piano instrument
li $a3, 20 #volume
syscall
addi $k1, $k1, 8
j boxEnd

respondToL: #moves 2nd frog right
li $v0, 31 #select $v0 value to play sounds
li $a0, 72 #pitch = C
li $a2, 5 #piano instrument
li $a3, 20 #volume
syscall
addi $s7, $s7, 8
j boxEnd

respondToW: #moves frog forwards
li $v0, 31 #select $v0 value to play sounds
li $a0, 72 #pitch = C
li $a2, 5 #piano instrument
li $a3, 20 #volume
syscall
addi $k1, $k1, -256
j boxEnd

respondToI: #moves 2nd frog forwards
li $v0, 31 #select $v0 value to play sounds
li $a0, 72 #pitch = C
li $a2, 5 #piano instrument
li $a3, 20 #volume
syscall
addi $s7, $s7, -256
j boxEnd

respondToQ: #quits the game
lw $s0, displayAddress
li $t8, 0 #reset $t8 to 0
li $t9, 4092 #set $t9 to 4092
li $t2, 0x000000 #change our current colour to black
jal box320 #jump to func box320 and link to next line
j Exit

respondToLose:
lw $s0, displayAddress
li $t8, 0 #reset $t8 to 0
li $t9, 4092 #set $t9 to 4092
li $t2, 0x000000 #change our current colour to black
jal box320 #jump to func box320 and link to next line
lw $s0, displayAddress
addi $s0, $s0, 540 
li $t8, 0 #reset $t8 to 0
li $t9, 20 #set $t9 to 32
li $t2, 0xffffff #change our current colour to white
jal drawVertical #draws L on the screen to represent the user losing
lw $s0, displayAddress
addi $s0, $s0, 3100 
li $t8, 0 #reset $t8 to 0
li $t9, 20 #set $t9 to 32
jal drawHorizontal
li $v0, 33 #select $v0 value to play sounds in their entirety
li $a0, 63 #pitch = Eb
li $a1, 2000 #duration of the sound in milliseconds
li $a2, 16 #organ instrument
li $a3, 50 #volume
syscall
j loseMenu

loseMenu:
lw $t8, 0xffff0000 #obtains value of the element in the memory location where keystroke events are noted(value = 1 if keystroke occured)
beq $t8, 1, MenuSettings
j loseMenu

MenuSettings:
lw $t2, 0xffff0004 #obtains value of the element in the memory location next to where Oxffff0000 is
beq $t2, 0x71, startMenu
beq $t2, 0x72, respondToR
beq $t2, 0x70, RunGameFunc #checks if $t2 is = to hex value of lowercase p and returns to game loop
j MenuSettings

respondToP:
#pause game
lw $s0, displayAddress
li $t8, 0 #reset $t8 to 0
li $t9, 4092 #set $t9 to 4092
li $t2, 0x000000 #change our current colour to black
jal box320 #jump to func box320 and link to next line
jal drawP
j loseMenu

drawP:
move $t1, $ra
li $t2, 0xffffff #change our current colour to white
lw $s0, displayAddress
addi $s0, $s0, 540
li $t8, 0 #reset $t8 to 0
li $t9, 20 #set $t9 to 32
jal drawVertical #draws the first line of P(using the same function as when I draw L to save energy)
lw $s0, displayAddress
addi $s0, $s0, 540
li $t8, 0 #reset $t8 to 0
li $t9, 10 #set $t9 to 32
jal drawHorizontal
lw $s0, displayAddress
addi $s0, $s0, 1820
li $t8, 0 #reset $t8 to 0
li $t9, 10 #set $t9 to 32
jal drawHorizontal
lw $s0, displayAddress
addi $s0, $s0, 580
li $t8, 0 #reset $t8 to 0
li $t9, 11 #set $t9 to 32
jal drawVertical
move $ra, $t1
j boxEnd

drawVertical:
beq $t8, $t9, boxEnd
sw $t2, 0($s0)
addi $s0, $s0, 128
addi $t8, $t8, 1
j drawVertical

drawHorizontal:
beq $t8, $t9, boxEnd
sw $t2, 0($s0)
addi $s0, $s0, 4
addi $t8, $t8, 1
j drawHorizontal

pauseScreenHelper:
lw $t8, 0xffff0000 #obtains value of the element in the memory location where keystroke events are noted(value = 1 if keystroke occured)
beq $t8, 1, MenuSettings
j pauseScreenHelper

respondToR: #restarts the game
lw $s0, displayAddress
li $t8, 0 #reset $t8 to 0
li $t9, 4092 #set $t9 to 4092
li $t2, 0x000000 #change our current colour to black
jal box320 #jump to func box320 and link to next line
lw, $k1, frogXY
lw, $s7, frogTwoXY
li $v0, 32
li $a0, 1000
syscall
jr $k0

carCollisionCheck:
#store value of i, x, whereby i and x are the current values of frogXY($k1)
la $t6, vehicleRow
move $t4, $k1
addi $k1, $k1, -2304
add $k1, $k1, $t6
lw $t5, 0($k1)
li $a1, 0xff0000
beq $t5, $a1, collisionSound # if value = red, restart game
move $k1, $t4
j boxEnd

carCollisionCheckTwo:
#store value of i, x, whereby i and x are the current values of frogXY($k1)
la $t6, vehicleRow
move $t4, $s7
addi $s7, $s7, -2304
add $s7, $s7, $t6
lw $t5, 0($s7)
li $a1, 0xff0000
beq $t5, $a1, collisionSound # if value = red, restart game
move $s7, $t4
j boxEnd

waterCollisionCheck:
la $t6, logRow
move $t4, $k1
addi $k1, $k1, -512
add $k1, $k1, $t6
lw $t5, 0($k1)
li $a1, 0x0000ff
beq $t5, $a1, collisionSound #if value = blue, restart game
move $k1, $t4
j boxEnd

waterCollisionCheckTwo:
la $t6, logRow
move $t4, $s7
addi $s7, $s7, -512
add $s7, $s7, $t6
lw $t5, 0($s7)
li $a1, 0x0000ff
beq $t5, $a1, collisionSound #if value = blue, restart game
move $s7, $t4
j boxEnd

goalCollisionCheck:
la $t6, goalRow
move $t4, $k1
addi $k1, $k1, -256
add $k1, $k1, $t6
lw $t5, 0($k1)
li, $t1, 0xff00ff
beq $t5, $t1, goalCollisionSound #if goalOne is reached, restart game
move $k1, $t4
j boxEnd

goalCollisionCheckTwo:
la $t6, goalRow
move $t4, $s7
addi $s7, $s7, -256
add $s7, $s7, $t6
lw $t5, 0($s7)
li, $t1, 0xff00ff
beq $t5, $t1, goalCollisionSoundTwo #if goalOne is reached, restart game
move $s7, $t4
j boxEnd


goalCollisionSound:
li $v0, 33 #select $v0 value to play sounds in their entirety
li $a0, 69 #pitch = A
li $a1, 1000 #duration of the sound in milliseconds
li $a2, 56 #synth effects instrument
li $a3, 50 #volume
syscall
j goalFinder

goalCollisionSoundTwo:
li $v0, 33 #select $v0 value to play sounds in their entirety
li $a0, 69 #pitch = A
li $a1, 1000 #duration of the sound in milliseconds
li $a2, 56 #synth effects instrument
li $a3, 50 #volume
syscall
j goalFinderTwo

goalFinder:
beq $k1, $t2, goalColourChangerOne
beq $k1, $s4, goalColourChangerTwo
j boxEnd

goalFinderTwo:
beq $s7, $t2, goalColourChangerOne
beq $s7, $s4, goalColourChangerTwo
j boxEnd

goalColourChangerOne:
li $a2, 0x00ff00
lw $s0, displayAddress
j boxEnd

goalColourChangerTwo:
li $a3, 0x00ff00
lw $s0, displayAddress
j boxEnd

collisionSound:
li $v0, 33 #select $v0 value to play sounds in their entirety
li $a0, 63 #pitch = Eb
li $a1, 1000 #duration of the sound in milliseconds
li $a2, 96 #synth effects instrument
li $a3, 50 #volume
syscall
j respondToLose

Exit:
li $v0, 10 # terminate the program gracefully
syscall
