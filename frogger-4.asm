#####################################################################
#
# CSC258H5S Winter 2022 Assembly Final Project
# University of Toronto, St. George
#
# Student: Rishibh Prakash, 1006717509
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features
# Hard:
# 1. 2 frogs: controlled via WASD and IJKL
# 2. Added snakes (in pink)
# Easy:
# 3. Display number of lives (white dots in bottom left)
# 4. Objects in different rows move at different speeds
# 5. 4 rows or road + 3 rows of water
# 
# Any additional information that the TA needs to know:
# - Use q to quit at any point
#
#####################################################################

.data
displayAddress: .word 0x10008000
carColour: .word 0x9e1919
waterColour: .word 0x73dafa
logColour: .word 0x7a6121
winColour: .word 0x1e4228	# colour of win 'stages'
snakeColour: .word 0xf783bd
numLives: .word 6
stagesRemaining: .word 5			

frogX: .word 30 		# relative to 256x256 board with (0, 0) in top left
frogY: .word 58

frog2X: .word 16
frog2Y: .word 58

vehicles: .space 24 	# 6 integer array for cars
logs: .space 32		# 8 element array for the logs

snakeSpeed: .word 1	
snakeNum: .word 1255	# snake1 start pos
snakeNum2: .word 1219	# snake2 start pos

.text
lw $t0, displayAddress # $t0 stores the base address for display

# add cars
la $t1, vehicles
li $t2, 3500		# row 0, car1 at (54, 44)
sw $t2, 0($t1)

li $t2,  3462		# row 0, car2 at (54, 6)
addi $t1, $t1, 4
sw $t2, 0($t1)

li $t2,  3216		# row 1, car1 at (50, 16)
addi $t1, $t1, 4
sw $t2, 0($t1)

li $t2,  3232		# row 1, car2 at (50, 32)
addi $t1, $t1, 4
sw $t2, 0($t1)

li $t2, 2988		# row 2, car1 at (46, 44)
addi $t1, $t1, 4
sw $t2, 0($t1)

li $t2, 2712		# row 3, car1 at (42, 24)
addi $t1, $t1, 4
sw $t2, 0($t1)

# add logs
la $t1, logs
li $t2, 2176
sw $t2, 0($t1)		# row 0, log1	item 0

addi $t1, $t1, 4
li $t2, 1955
sw $t2, 0($t1)		# row 1, log1	item 1

li $t2, 2216
addi $t1, $t1, 4
sw $t2, 0($t1)		# row0, log2	item 2

li $t2, 1934
addi $t1, $t1, 4
sw $t2, 0($t1)		# row 1, log2	item 3

li $t2, 1674		
addi $t1, $t1, 4
sw $t2, 0($t1)		# row 2, log1	item 4

li $t2, 1411
addi $t1, $t1, 4
sw $t2, 0($t1)		# row 3, log1	item 5

li $t2, 1697
addi $t1, $t1, 4
sw $t2, 0($t1)		# row 2, log2	item 6

li $t2, 1441
addi $t1, $t1, 4		# row 3, log2	item 7
sw $t2, 0($t1)

draw_top:
addi $a0, $zero, 0		# draw top safe, top-left corner = 0 = (0, 0)
addi $a1, $zero, 64		# width of top safe spot = 64
addi $a2, $zero, 18		# height of top safe spot = 18
addi $a3, $zero, 0x00ff00	# colour of top safe spot
jal drawRectangle

draw_win_stages:
addi $a0, $zero, 773		# draw win space 1, at (12, 5)
addi $a1, $zero, 6
addi $a2, $zero, 6
addi $a3, $zero, 0x1e4228
jal drawRectangle

addi $a0, $zero, 785		# draw win space 2, at (12, 17)	
jal drawRectangle

addi $a0, $zero, 797		# draw win space 3, at (12, 29)
jal drawRectangle

addi $a0, $zero, 809		# draw win space 4, at (12, 41)
jal drawRectangle

addi $a0, $zero, 821		# draw win space 4, at (12, 53)
jal drawRectangle

### main loop starts ###
main:				# game loop
lw $t1, numLives	
lw $t2, stagesRemaining				
beq $t1, $zero, Exit		# if number of lives = 0, quit game
beq $t2, $zero, Exit

drawing_lives:
lw $t4, numLives
addi $t6, $zero, 3970		# set $t2 = i to be iterating variable
sll $t7, $t4, 1			# $t3 = 2 * $t1
add $t7, $t6, $t7		# $t3 = max pixel num we need to go to

drawing_lives_loop:
beq $t6, $t7, after_drawing_lives
add $a0, $zero, $t6
addi $a1, $zero, 1
addi $a2, $zero, 1
addi $a3, $zero, 0xffffff
jal drawRectangle

addi $t6, $t6, 2
j drawing_lives_loop

after_drawing_lives:


# temp spot
addi $a0, $zero, 1152		# to be replaced with water
addi $a1, $zero, 64
addi $a2, $zero, 8
addi $a3, $zero, 0x00ff00
jal drawRectangle

draw_water:
addi $a0, $zero, 1664		# draw water, top-left corner = 1152 (later) = (18, 0) (in row, col format)
addi $a1, $zero, 64
addi $a2, $zero, 12		# height of water = 20 (width = 64 as before)
addi $a3, $zero, 0x73dafa	# colour of water
jal drawRectangle

draw_mid_safe:
addi $a0, $zero, 2432		# draw middle safe spot, top-left corner = 2432 = (38, 0)
addi $a2, $zero, 4		# height of spot = height of frog = 4
addi $a3, $zero, 0xdecb6d	# colour of safe area
jal drawRectangle


draw_road:
addi $a0, $zero, 2688		# draw road, top-left corner = 2688 = (42, 0)
addi $a2, $zero, 16		# height of road = 16 = 4 lanes
addi $a3, $zero, 0x332f2f	# colour of road
jal drawRectangle		# call drawRectangle


draw_bottom:
addi $a0, $zero, 3712		# draw bottom, top-left corner = (58, 0)
addi $a2, $zero, 6		# height of bottom = 6 
addi $a3, $zero, 0x00ff00	# colour of bottom
jal drawRectangle		# call drawRectangle


draw_snake1:
lw $a0, snakeNum
addi $a1, $zero, 2
addi $a2, $zero, 1
addi $a3, $zero, 0xf783bd
jal drawRectangle

addi $t1, $zero, 1276		# $t1 = upper threshold
addi $t2, $zero, 1255		# lower threshold

la $t5, snakeSpeed		# $t5 = snakeSpeed address
lw $t9, 0($t5)			# $t9 = snakeSpeed
bge $a0, $t1, move_left		# if snakeNum too big, make velocity negative
ble $a0, $t2, move_right		# if snakeNum too small, make velocity positive
j snake_speed_set
move_left:
addi $t9, $zero, -1
j snake_speed_set

move_right:
addi $t9, $zero, 1

snake_speed_set:
sw $t9, 0($t5)
la $t4, snakeNum
lw $t3, 0($t4)
add $t3, $t3, $t9		# snakeNum = snakeNum + snakeSpeed
sw $t3, 0($t4)	

draw_snake2:
lw $a0, snakeNum2
addi $a1, $zero, 2
addi $a2, $zero, 1
addi $a3, $zero, 0xf783bd
jal drawRectangle

addi $t1, $zero, 1240		# $t1 = upper threshold
addi $t2, $zero, 1219		# lower threshold

la $t5, snakeSpeed		# $t5 = snakeSpeed address
lw $t9, 0($t5)			# $t9 = snakeSpeed
bge $a0, $t1, move_left2		# if snakeNum past upper threshold, make velocity negative 
ble $a0, $t2, move_right2	# if snakeNum past lower threshold, make velocity positive
j snake_speed_set2

move_left2:
addi $t9, $zero, -1
j snake_speed_set2

move_right2:
addi $t9, $zero, 1

snake_speed_set2:
sw $t9, 0($t5)
la $t4, snakeNum2
lw $t3, 0($t4)
add $t3, $t3, $t9		# snakeNum = snakeNum + snakeSpeed
sw $t3, 0($t4)		


draw_logs:
# $s0 = address of logs array element
# $s1 = max address we need to go to
# $t9 = log velocity in each iteration
la $s0, logs
addi $s1, $s0, 20
addi $t9, $zero, 1		# $t9 = log velocity

draw_log_loop:
beq $s0, $s1, end_log_loop	# while s0 < s1
lw $a0, 0($s0)			# set a0 to log position
addi $a1, $zero, 10		# log width = 5
addi $a2, $zero, 4		# log height = 4
addi $a3, $zero, 0x7a6121	# log colour, brown
jal drawRectangle		# draw log at given position, function call

# update log positions
add $t1, $a0, $t9		# $t9 = log velocity
addi $t8, $zero, 1		# used to check if velocity = $t9 was 1

beq $t9, $t8, odd_num_log	
addi $t9, $zero, 1		# if log velocity =/= 1, set to 1
j after_log_vel_update
odd_num_log:
addi $t9, $zero, 2		# else set log velocity to 2 for next odd num log

after_log_vel_update:		# check that log is in correct row, correct if necessary
srl $t2, $a0, 6			# $t2 = a0 // 64 = original row
srl $t3, $t1, 6			# $t3 = $t1 // 64 = new row
beq $t2, $t3, no_log_correction 	# if rows are equal, no correction needed
sll $t1, $t2, 6			# if rows unequal, we reset new row to beginning of new row

no_log_correction:
sw $t1, 0($s0)			# save new log position into memory

addi $s0, $s0, 4			# increase address by 4 to look at next element of array
j draw_log_loop

end_log_loop:			# update frog position if frog on log
beq $s7, $zero, frog_not_on_log	# if frog on log, increase frogX val
# frog is on log, need to determine speed of log/frog


frog_not_on_log:

draw_cars:
la $s0, vehicles			# load address of vehicles array
addi $s1, $s0, 24		# find max address we need to go to

draw_car_loop:
beq $s0, $s1, end_car_loop	# keep going until we reach end of the array
lw $a0, 0($s0)			# set a0 to car position
addi $a1, $zero, 7		# car width = 7
addi $a2, $zero, 4		# car height = 4
addi $a3, $zero, 0x9e1919	# car colour, maroon
jal drawRectangle		# draw car at given position, function call

# update car positions
addi $t1, $a0, -1		# move cars left

srl $t2, $a0, 6			# $t2 = a0 // 64 = original row
srl $t3, $t1, 6			# $t3 = $t1 // 64 = new row
beq $t2, $t3, no_car_correction 
addi $t1, $a0, 63

no_car_correction:
sw $t1, 0($s0)
addi $s0, $s0, 4			# increase address by 4 to go to next entry in array
j draw_car_loop			# end of loop

end_car_loop:


la $a0, frogX
la $a1, frogY
jal drawFrog		# frog needs to be the last object drawn for object collision

la $a0, frog2X
la $a1, frog2Y
jal drawFrog		# draw frog2

### end of drawing ###

lw $t8, 0xffff0000
beq $t8, 1, keyboard_input	# check if a key was pressed
j no_keyboard
keyboard_input:
lw $a1, 0xffff0004		
jal keyboardInputHandler

no_keyboard:
li $v0, 32
li $a0, 20
syscall

j main
# j Exit

######## main ends ########
# everything below is helper functions

keyboardInputHandler:
beq $a1, 0x71, qKeyPress
beq $a1, 0x77, wKeyPress
beq $a1, 0x61, aKeyPress
beq $a1, 0x73, sKeyPress
beq $a1, 0x64, dKeyPress

beq $a1, 0x69, iKeyPress
beq $a1, 0x6a, jKeyPress
beq $a1, 0x6b, kKeyPress
beq $a1, 0x6c, lKeyPress
jr $ra				# if key pressed isn't one of q, w, a, s, d, go back

qKeyPress:
j Exit				# quit game

wKeyPress:
la $t1, frogY
lw $t2, 0($t1)
addi $t2, $t2, -4		# decrease frogY value by 4 (moving up)
sw $t2, 0($t1)
jr $ra

aKeyPress:
la $t1, frogX
lw $t2, 0($t1)
addi $t2, $t2, -4		# decrease frogX value by 4 (moving left)
sw $t2, 0($t1)
jr $ra

sKeyPress:
la $t1, frogY
lw $t2, 0($t1)
addi $t2, $t2, +4		# increase frogY value by 4 (moving down)
sw $t2, 0($t1)
jr $ra

dKeyPress:
la $t1, frogX
lw $t2, 0($t1)
addi $t2, $t2, +4		# increase frogX value by 4 (moving right)
sw $t2, 0($t1)
jr $ra

iKeyPress:
la $t1, frog2Y
lw $t2, 0($t1)
addi $t2, $t2, -4		# decrease frog2Y value by 4 (moving up)
sw $t2, 0($t1)
jr $ra

jKeyPress:
la $t1, frog2X
lw $t2, 0($t1)
addi $t2, $t2, -4		# decrease frogX value by 4 (moving left)
sw $t2, 0($t1)
jr $ra

kKeyPress:
la $t1, frog2Y
lw $t2, 0($t1)
addi $t2, $t2, +4		# increase frogY value by 4 (moving down)
sw $t2, 0($t1)
jr $ra

lKeyPress:
la $t1, frog2X
lw $t2, 0($t1)
addi $t2, $t2, +4		# increase frogX value by 4 (moving right)
sw $t2, 0($t1)
jr $ra

drawRectangle:
# $a0 = pixel num of top left corner
# $a1 = width of rectangle
# $a2 = height of rectangle
# $a3 = colour

# $t2 = iterating variable for height
# $t3 = iterative variable for width
# $t5 = data for current pixel = pixel at that point of iteration

# set width to be min(width, 64 - width)
sll $t1, $a0, 26
srl $t1, $t1, 26			# do mod 64 to find x coord
addi $t1, $t1, -64		# t1 = x_coord - 64
sub $t1, $zero, $t1		# $t1 = 64 - x_coord = how much space available to the right
ble $a1, $t1, given_width_smaller
add $a1, $zero, $t1		# if width > available width, set width to what's available

given_width_smaller:
addi $t2, $zero, 0		# initialise iterating variable $t2 for height

draw_rect_loop:
beq $t2, $a2, end_rect_loop	# keeping going until $t2 = height
addi $t3, $zero, 0 		# initial iterating variable $t3 for each line

draw_line_loop:
beq $t3, $a1, end_draw_line	# draw consecutive pixels width times
sll $t5, $t2, 6			# find height * 64
add $t5, $t5, $t3		# current height * 64 + current width gives offset from given pixel
add $t5, $t5, $a0		# offset from given pixel + given pixel = offset from top left corner of canvas
sll $t5, $t5, 2			# $t5 = offset in number of bytes
add $t5, $t5, $t0		# $t5 = address of current pixel
sw $a3, 0($t5)			# save colour onto pixel address

addi $t3, $t3, 1			# increment $t3
j draw_line_loop

end_draw_line:
addi $t2, $t2, 1			# increment $t2 = i
j draw_rect_loop			# jump back

end_rect_loop:
jr $ra				# end function


drawFrog:
# $a0 = address of frog x coord
# $a1 = adresss of frog y coord
# draws frog based on values of frogX and frogY
# $v1 = whether or not frog is on a log

# $t7 = frog colour
# $t1 = frogX
# $t2 = frogY
addi $t7, $zero, 0x39941e

# lw $t1, frogX
# lw $t2, frogY

lw $t1, 0($a0)
lw $t2, 0($a1)

not_winning:
addi $t3, $zero, 16	# $t3 = num iterations
addi $t4, $zero, 0	# $t4 = i = iterating variable

draw_frog_loop:
beq $t3, $t4, end_frog_loop	# while i < 16

sll $t5, $t4, 30
srl $t5, $t5, 30		# t5 = i mod 4 = offset in x direction 
srl $t6, $t4, 2		# t6 = i // 4 = offset in y direction

add $t5, $t5, $t1	# x = x + offset_x
add $t6, $t6, $t2	# y = y + offset_y

sll $t6, $t6, 6
add $t6, $t6, $t5	# $t6 = current pixel num
sll $t6, $t6, 2		# offset of current pixel from (0, 0) in number of bytes
add $t6, $t6, $t0	# address of current pixel

lw $t5, 0($t6)		# $t5 = colour of pixel before updating it
lw $s0, carColour
lw $s1, waterColour
lw $s2, logColour
lw $s3, winColour
lw $s4, snakeColour

beq $t5, $s0, collision	# frog pixel to be written on part of water
beq $t5, $s1, collision	# frog pixel to be written on water
beq $t5, $s4, collision	# collision with snake
beq $t5, $s2, log_collision
add $s7, $zero, $zero	# make $s7 0 if no collision
beq $t5, $s3, win_collision

no_collision:
sw $t7, 0($t6)		# no collisions detected, paint onto pixel
addi $t4, $t4, 1		# i = i + 1, move to next pixel
j draw_frog_loop

collision:

la $t1, frogX
la $t2, frog2X

beq $t1, $a0, frogX_collision
addi $t3, $zero, 16
addi $t4, $zero, 58
j coords_set
frogX_collision:
addi $t3, $zero, 30
addi $t4, $zero, 58

coords_set:
sw $t3, 0($a0)		# if collision, set frogX to 30
sw $t4, 0($a1)		#               set frogY to 58

la $t5, numLives
lw $t6, 0($t5)
addi $t6, $t6, -1
sw $t6, 0($t5) 		# decrement numLives if a collision has occurred
j end_frog_loop

log_collision:
add $s6, $zero, $a0	# set $s6 to frogX for appropriate frog
add $s7, $zero, $a1	# set $s7 to frogY
j no_collision

win_collision:
la $t5, stagesRemaining		# mark stage as filled
lw $t6, 0($t5)
addi $t6, $t6, -1
sw $t6, 0($t5)

la $t5, numLives
lw $t6, 0($t5)
addi $t6, $t6, 1			# increment numLives by 1, to be immediately decremented by collision
sw $t6, 0($t5) 

addi $sp, $sp, -4
sw $a0, 0($sp)			# save frogX onto stack
addi $sp, $sp, -4
sw $a1, 0($sp)			# save frogY onto stack
addi $sp, $sp, -4
sw $ra, 0($sp)			# calling another function so pushing $ra onto stack

sll $t2, $t2, 6
add $t2, $t2, $t1		# $t2 = pixel num of frog 
add  $a0, $zero, $t2
addi $a1, $zero, 4
addi $a2, $zero, 4
add  $a3, $zero, $t7
jal drawRectangle

lw $ra, 0($sp)			
addi $sp, $sp, 4			# restore stack pointer
lw $a1, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
j collision

end_frog_loop:
beq $s7, $zero, dont_update_frog_pos
lw $t8, 0($a1)			# speed of frog determined by column
sll $t8, $t8, 29			# we want to find column mod 8
srl $t8, $t8, 29			# result is either 2 (even num rows in my naming) or 6 (odd num rows)
		
addi $t5, $zero, 2		# set $t5 = 2
beq $t8, $t5, water_row_num_even	 
addi $t9, $zero, 2		# velocity is 2 on odd rows
j velocity_set

water_row_num_even:
addi $t9, $zero, 1		# velocity is 1 on even rows

velocity_set:
lw $t6, 0($s6)			# $t6 = value of frogX

add $t6, $t6, $t9		# increase frogX by appropriate amount
sw $t6, 0($s6)			# save new value into same adress


dont_update_frog_pos:
jr $ra



Exit:
li $v0, 10 # terminate the program gracefully
syscall
