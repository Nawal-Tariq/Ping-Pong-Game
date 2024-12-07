# Ping-Pong-Game
Introduction
The Ping Pong Game project is a classic two-player game implemented in assembly language. The game's concept revolves around controlling paddles to hit a ball back and forth across the screen. The primary objective is to score points by making the ball pass the opponent's paddle. The game continues until one of the players reaches a pre-set number of points, which is defined as the winning score.

Implementation Details
Key Code Structures
Data Segment:

Variables:
start_x, start_y: Starting position of the ball.
dir_x, dir_y: Direction of the ball's movement.
paddle1_y, paddle2_y: Positions of the left and right paddles.
score1, score2: Scores for player 1 and player 2.
win_score: Pre-set number of points to win.
is_paused: Pause flag.
Strings:
right_player, left_player: Strings to print at the top.
string1, string2: Strings to print at the bottom.
Main Loop:

The main loop initializes the game, updates the ball's position, checks for collisions, updates the score, and checks for the win condition.
Subroutines:

clrscr: Clears the screen.
print, print1, print2, print3: Print strings at different positions on the screen.
draw_paddles, erase_paddles: Draw and erase the paddles.
draw_paddle_segment, erase_paddle_segment: Draw and erase individual paddle segments.
check_keys: Checks for key presses to move the paddles.
move_paddle1_up, move_paddle1_down, move_paddle2_up, move_paddle2_down: Move the paddles up and down.
toggle_pause: Toggles the pause state.
draw_char, erase_char: Draw and erase the ball.
update_pos: Updates the ball's position and checks for collisions.
update_score: Updates the scores when the ball crosses the boundaries.
display_score: Displays the scores at the top of the screen.
check_win: Checks if either player has won.
print_win_message: Prints the win message.
end_game: Ends the game and waits for user input to restart or exit.
restart_game: Resets the game state and restarts the main loop.
delay: Adds a delay to control the game's speed.
print_bottom_strings, print_top_strings: Print strings at the bottom and top of the screen.
print_string, printstring: Print strings with specific attributes.
Logic Flow
Initialization:

The game initializes by clearing the screen and printing the initial strings.
The paddles and ball are drawn at their starting positions.
Main Loop:

The main loop updates the ball's position, checks for collisions, updates the score, and checks for the win condition.
The ball's position is updated based on its direction.
Collisions with the screen boundaries and paddles are checked, and the ball's direction is reversed if necessary.
The score is updated if the ball crosses the left or right boundary.
The win condition is checked, and the game ends if either player reaches the winning score.
User Input:

The game checks for key presses to move the paddles up and down.
The pause state can be toggled by pressing the 'P' key.
End Game:

The game ends when one of the players reaches the winning score.
The win message is displayed, and the game waits for user input to restart or exit.
Additional Features
Pause Functionality: The game can be paused and resumed by pressing the 'P' key.
Win Message: A win message is displayed when one of the players reaches the winning score.
Restart Game: The game can be restarted by pressing the 'R' key after the win message is displayed.
Challenges and Solutions
Challenges
Repeated Scoring:

The ball's position was not reset after scoring, leading to repeated scoring and premature game termination.
Score Display:

The score display logic did not handle scores greater than 9 correctly.
Win Condition Check:

The win condition was not checked correctly, leading to incorrect behavior.
Solutions
Prevent Repeated Scoring:

Introduced a flag to track whether a score has been incremented in the current iteration.
Ensured that the score is incremented only once per boundary crossing.
Score Display Logic:

Updated the score display logic to handle scores greater than 9 correctly.
Win Condition Check:

Ensured that the win condition is checked correctly and that the game ends only when a player reaches the winning score.
By implementing these solutions, the game now correctly updates and displays the scores, and the win condition is checked accurately.
