function love.load()
	love.window.setTitle( "Danger Pong" )

	--	GAME INITIAL STATE --
	left_paddle_initial_center_x = love.graphics.getWidth() / 10
	left_paddle_initial_center_y = love.graphics.getHeight() / 2

	left_paddle_initial_width = 20
	left_paddle_initial_height = 120

	right_paddle_initial_center_x = love.graphics.getWidth() * 9 / 10
	right_paddle_initial_center_y = love.graphics.getHeight() / 2

	right_paddle_initial_width = 20
	right_paddle_initial_height = 120

	ball_initial_center_x = love.graphics.getWidth() / 2
	ball_initial_center_y = love.graphics.getHeight() / 2

	ball_initial_width = 20
	ball_initial_height = 20

	left_player_initial_score_x = love.graphics.getWidth() * 2 / 10
	left_player_initial_score_y = love.graphics.getHeight() * 2 / 10

	right_player_initial_score_x = love.graphics.getWidth() * 8 / 10
	right_player_initial_score_y = love.graphics.getHeight() * 2 / 10

	ball_initial_dx = 10
	ball_initial_dy = 10

	ball_initial_ddx = 10
	ball_initial_ddy = 10

	initial_ball_launch_speed_x = 200
	initial_ball_launch_speed_y = 100

	initial_ball_launch_speed_increase_per_round_x = 10
	initial_ball_launch_speed_increase_per_round_y = 10

	left_paddle_initial_dy = 300
	right_paddle_initial_dy = 300

	isNewRound_initial_state = false

	initial_score_font_size = 20

	--	GAME STATE --
	left_paddle_center_x = left_paddle_initial_center_x
	left_paddle_center_y = left_paddle_initial_center_y

	right_paddle_center_x = right_paddle_initial_center_x
	right_paddle_center_y = right_paddle_initial_center_y

	ball_center_x = ball_initial_center_x
	ball_center_y = ball_initial_center_y

	ball_launch_speed_x = initial_ball_launch_speed_x
	ball_launch_speed_y = initial_ball_launch_speed_y

	ball_launch_speed_increase_per_round_x = initial_ball_launch_speed_increase_per_round_x
	ball_launch_speed_increase_per_round_y = initial_ball_launch_speed_increase_per_round_y

	left_paddle_height = left_paddle_initial_height
	left_paddle_width = left_paddle_initial_width

	right_paddle_height = right_paddle_initial_height
	right_paddle_width = right_paddle_initial_width

	ball_width = ball_initial_width
	ball_height = ball_initial_height

	left_player_score_x = left_player_initial_score_x
	left_player_score_y = left_player_initial_score_y

	right_player_score_x = right_player_initial_score_x
	right_player_score_y = right_player_initial_score_y

	left_player_score = 0
	right_player_score = 0

	left_paddle_dy = left_paddle_initial_dy
	right_paddle_dy = right_paddle_initial_dy

	ceiling_y = 0 + 50
	floor_y = love.graphics.getHeight() - 50

	isNewRound = isNewRound_initial_state
	pointScored = pointScored_initial_state
	gameWon = gameWon_initial_state	

	round_number = 0

	score_font_size = initial_score_font_size

	--	PHYSICS INIT	--
	love.physics.setMeter( 64 )
	world = love.physics.newWorld(0, 0 * 64, true)
	world:setCallbacks( beginContact, endContact, preSolve, postSolve )

	objects = {}

	wall_thickness = 50

	paddle_repel_force_modifier = 10

	--	make bouncable floor	--
	objects.floor = {}
	objects.floor.body = love.physics.newBody( world, love.graphics.getWidth() / 2, love.graphics.getHeight(), "static" )
	objects.floor.shape = love.physics.newRectangleShape( love.graphics.getWidth(), wall_thickness )
	objects.floor.fixture = love.physics.newFixture( objects.floor.body, objects.floor.shape )
	objects.floor.fixture:setUserData( "floor" )

	--	make bouncable ceiling	--
	objects.ceiling = {}
	objects.ceiling.body = love.physics.newBody( world, love.graphics.getWidth() / 2, 0, "static" )
	objects.ceiling.shape = love.physics.newRectangleShape( love.graphics.getWidth(), wall_thickness )
	objects.ceiling.fixture = love.physics.newFixture( objects.ceiling.body, objects.ceiling.shape )
	objects.ceiling.fixture:setUserData( "ceiling" )

	--	make bouncable left_goal	--
	objects.left_goal = {}
	objects.left_goal.body = love.physics.newBody( world, 0, love.graphics.getHeight() / 2, "static" )
	objects.left_goal.shape = love.physics.newRectangleShape( wall_thickness, love.graphics.getHeight() - wall_thickness )
	objects.left_goal.fixture = love.physics.newFixture( objects.left_goal.body, objects.left_goal.shape )
	objects.left_goal.fixture:setUserData( "left_goal" )

	--	make bouncable right_goal	--
	objects.right_goal = {}
	objects.right_goal.body = love.physics.newBody( world, love.graphics.getWidth(), love.graphics.getHeight() / 2 )
	objects.right_goal.shape = love.physics.newRectangleShape( wall_thickness, love.graphics.getHeight() - wall_thickness )
	objects.right_goal.fixture = love.physics.newFixture( objects.right_goal.body, objects.right_goal.shape )
	objects.right_goal.fixture:setUserData( "right_goal" )

	--	make a ball 	--
	objects.ball = {}
	objects.ball.body = love.physics.newBody( world, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "dynamic")
	objects.ball.shape = love.physics.newRectangleShape( ball_width, ball_height )
	objects.ball.fixture = love.physics.newFixture( objects.ball.body, objects.ball.shape, 1)
	objects.ball.fixture:setRestitution( 1.0 )
	objects.ball.fixture:setUserData("ball")

	--	make the left paddle 	--
	objects.left_paddle = {}
	objects.left_paddle.body = love.physics.newBody( world, left_paddle_center_x, left_paddle_center_y, "dynamic")
	objects.left_paddle.shape = love.physics.newRectangleShape( left_paddle_initial_width, left_paddle_initial_height )
	objects.left_paddle.fixture = love.physics.newFixture( objects.left_paddle.body, objects.left_paddle.shape, 1 )
	objects.left_paddle.fixture:setRestitution( 0.8 )
	objects.left_paddle.fixture:setUserData( "left_paddle")

	--	make the right paddle 	--
	objects.right_paddle = {}
	objects.right_paddle.body = love.physics.newBody( world, right_paddle_center_x, right_paddle_center_y, "dynamic")
	objects.right_paddle.shape = love.physics.newRectangleShape( right_paddle_initial_width, right_paddle_initial_height )
	objects.right_paddle.fixture = love.physics.newFixture( objects.right_paddle.body, objects.right_paddle.shape, 1 )
	objects.right_paddle.fixture:setRestitution( 0.8 )
	objects.right_paddle.fixture:setUserData( "right_paddle" )

	--	make new font for scores 	--
	score_font = love.graphics.newFont( "/Resources/Fonts/8bw.ttf", score_font_size )

	--	make left player text object 	--
	left_player_score = 0
	left_player_score_text = love.graphics.newText( score_font, tostring( 0 ) )

	left_player_point_value = 1

	--	make right player text object 	--
	right_player_score = 0
	right_player_score_text = love.graphics.newText( score_font, tostring( 0 ) )

	right_player_point_value = 1

	--	make round time text object 	--
	roundTimeRemaining = 0
	showRoundTime = false
	round_time_text_x = love.graphics.getWidth() / 2
	round_time_text_y = love.graphics.getHeight() * 1 / 10
	round_time_text = love.graphics.newText( score_font, tostring( roundTimeRemaining ) )

	--	make main menu button press text object 	--
	title_prefixes = {}
	table.insert( title_prefixes, "Regular" )
	table.insert( title_prefixes, "Inconspicuous" )
	table.insert( title_prefixes, "Normal" )
	table.insert( title_prefixes, "" )
	table.insert( title_prefixes, "Danger" )
	table.insert( title_prefixes, "Plain old" )
	table.insert( title_prefixes, "Insubordinate" )
	table.insert( title_prefixes, "Hazard" )
	table.insert( title_prefixes, "Unfortunate" )

	title_prefix = ""
	title_postfix = " Pong"

	--	make title prefix text object 	--
	title_prefix_text = love.graphics.newText( score_font, title_prefix )
	title_prefix_text_x = love.graphics.getWidth() *  3 / 10
	title_prefix_text_y = love.graphics.getHeight() * 2 / 10

	--	make title postfix text object 	--
	title_postfix_text = love.graphics.newText( score_font, title_postfix )
	title_postfix_text_x = love.graphics.getWidth() *  4 / 10
	title_postfix_text_y = love.graphics.getHeight() * 2 / 10 + score_font_size

		--	make main menu text object 	--
	main_menu_button_press_text = love.graphics.newText( score_font, "press return" )
	main_menu_button_press_text_x = love.graphics.getWidth() *  4 / 10
	main_menu_button_press_text_y = love.graphics.getHeight() * 7 / 10

		--	make game begin player text object 	--
	game_intro_text = love.graphics.newText( score_font, "GameBEGIN" )
	game_intro_text_x = love.graphics.getWidth() *  3 / 10
	game_intro_text_y = love.graphics.getHeight() * 2 / 10

		--	make round number text object 	--
	round_intro_text = love.graphics.newText( score_font, "Round " .. tostring( round_number ) )
	round_intro_text_x = love.graphics.getWidth() *  3 / 10
	round_intro_text_y = love.graphics.getHeight() * 2 / 10

	--	make game outro text 	--
	winner_text = love.graphics.newText( score_font, "" )
	loser_text = love.graphics.newText( score_font, "" )

	winner_text_color_r = 0
	winner_text_color_g = 0
	winner_text_color_b = 0

	loser_text_color_r = 0
	loser_text_color_g = 0
	loser_text_color_b = 0

	inMainMenu = true
	isStartOfNewGame = false
	isNewRound = false
	gameWon = false

	gameIntroTime = 1
	gameOutroTime = 1
	roundIntroTime = 1
	roundTime = 60


	gameIntroTimeRemaining = 0
	roundIntroTimeRemaining = 0
	roundTimeRemaining = 0
	gameOutroTimeRemaining = 0

	gameIntroTimerStarted = false
	roundIntroTimerStarted = false
	roundTimerStarted = false
	gameOutroTimerStarted = false

	collision_text = ""
	persisting = 0

end

function love.update( dt )
	world:update( dt )
	checkKeypresses( dt )

	if inMainMenu then
		showMainMenu = true
		if cleanedUp == false then
			resetAll()
			cleanedUp = true
		end
	end
	if isStartOfNewGame then
		showGameIntro = true
		if gameIntroTimerStarted == false then
			gameIntroTimerStarted = true
			gameIntroTimeRemaining = gameIntroTime
		end
		roundTimeRemaining = 0
		roundTimerStarted = false
		showGameElements = true
		gameIntroTimeRemaining = gameIntroTimeRemaining - dt
		if gameIntroTimeRemaining <= 0 then
			isStartOfNewGame = false
			showGameIntro = false
			roundInProgress = true
			showRoundIntro = false
			resetPaddlesAndBall()
			launchBall()
		end
	end
	if roundInProgress then
		if roundTimerStarted == false then
			roundTimerStarted = true
			roundTimeRemaining = roundTime
			showRoundTime = true
		end
		roundTimeRemaining = roundTimeRemaining - dt
		round_time_text:set( tostring( math.floor( roundTimeRemaining ) ) )
		if roundTimeRemaining <= 0 then
			roundInProgress = false
			determineWinner()
			isEndOfGame = true
		end
	end
	if isEndOfGame then
		prepareGameOutro()
		showGameOutro = true
		if gameOutroTimerStarted == false then
			gameOutroTimerStarted = true
			gameOutroTimeRemaining = gameOutroTime
		end
		gameOutroTimeRemaining = gameOutroTimeRemaining - dt
		if gameOutroTimeRemaining <= 0 then
			isEndOfGame = false
			showGameOutro = false
			cleanedUp = false
			inMainMenu = true
		end
		inGame = false
		showRoundTimer = false
		showGameElements = false
	end

	if string.len( collision_text ) > love.graphics.getHeight() then
        collision_text = ""
    end
end

function love.draw()
	love.graphics.setColor( 100, 100, 100, 100 )
	love.graphics.print(collision_text, 10, 10)

	if showGameElements then
		drawLeftPaddle()
		drawRightPaddle()
		drawBall()
		drawFloorAndCeiling()
		drawGoals()
		drawLeftPlayerScore()
		drawRightPlayerScore()
		drawRoundTimeText()
	end
	if showMainMenu then
		drawMainMenu()
	end
	if showGameIntro then
		drawGameIntro()
	end
	if showGameOutro then
		drawGameOutro()
	end
	if showRoundIntro then
		drawRoundIntro()
	end
end

function checkKeypresses( dt )
	--	let player controls 	--
	if love.keyboard.isDown( "down" ) then
		moveRightPaddle( right_paddle_dy )
	end
	if love.keyboard.isDown( "up" ) then
		moveRightPaddle( -right_paddle_dy )
	end

	--	right player controls 	--
	if love.keyboard.isDown( "s" ) then
		moveLeftPaddle( left_paddle_dy )
	end
	if love.keyboard.isDown( "w" ) then
		moveLeftPaddle( -left_paddle_dy )
	end
end

function love.keyreleased( key )
	--	left player controls 	--
	if( key == "down" ) then
		moveRightPaddle( right_paddle_dy )
	end
	if( key == "up" ) then
		moveRightPaddle( -right_paddle_dy )
	end

	-- right player controls 	--
	if( key == "s" ) then
		moveLeftPaddle( left_paddle_dy )
	end
	if( key == "w" ) then
		moveLeftPaddle( -left_paddle_dy )
	end
end

function love.keypressed( key )
	if ( key == "return" ) then
		if inMainMenu then
			inMainMenu = false
			showMainMenu = false
			isStartOfNewGame = true
		end
	end
end

function resetAll()
	gameIntroTimeRemaining = 0
	roundIntroTimeRemaining = 0
	roundTimeRemaining = 0
	gameOutroTimeRemaining = 0

	resetPaddlesAndBall()
	resetScore()

	gameOutroTimerStarted = false
	showGameElements = false

	randomizeName()
end

function drawMainMenu()
	love.graphics.setColor( 255, 0, 0 )
	love.graphics.draw( title_prefix_text, title_prefix_text_x, title_prefix_text_y )
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.draw( title_postfix_text, title_postfix_text_x, title_postfix_text_y )
	love.graphics.setColor( 100, 100, 100 )
	love.graphics.draw( main_menu_button_press_text, main_menu_button_press_text_x, main_menu_button_press_text_y )
end

function resetScore()
	left_player_score = 0
	right_player_score = 0
	left_player_score_text:set( tostring(0) )
	right_player_score_text:set( tostring(0) )
end

function moveLeftPaddle( in_left_paddle_dy )
	local dx, dy = objects.left_paddle.body:getLinearVelocity()
	objects.left_paddle.body:setLinearVelocity( dx, in_left_paddle_dy )
end

function moveRightPaddle( in_right_paddle_dy )
	local dx, dy = objects.right_paddle.body:getLinearVelocity()
	objects.right_paddle.body:setLinearVelocity( dx, in_right_paddle_dy )
end

function drawFloorAndCeiling()
	love.graphics.setColor( 255, 255, 255 )
 	love.graphics.polygon("fill", objects.floor.body:getWorldPoints( objects.floor.shape:getPoints() ) )
 	love.graphics.polygon("fill", objects.ceiling.body:getWorldPoints( objects.ceiling.shape:getPoints() ) )
end

function drawGoals()
	love.graphics.setColor( 255, 0, 0 )
	love.graphics.polygon( "fill", objects.left_goal.body:getWorldPoints( objects.left_goal.shape:getPoints() ) )
	love.graphics.setColor( 0, 0, 255 )
	love.graphics.polygon( "fill", objects.right_goal.body:getWorldPoints( objects.right_goal.shape:getPoints() ) )
end

function drawBall()
	love.graphics.setColor( 0, 255, 0 )
	love.graphics.polygon( "fill", objects.ball.body:getWorldPoints( objects.ball.shape:getPoints() ) )
end

function drawRoundTimeText()
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.draw( round_time_text, round_time_text_x, round_time_text_y )
end
function drawLeftPaddle()
	love.graphics.setColor( 255, 0, 0 )
 	love.graphics.polygon( "fill", objects.left_paddle.body:getWorldPoints( objects.left_paddle.shape:getPoints() ) )
end

function drawRightPaddle()
	love.graphics.setColor( 0, 0, 255 )
 	love.graphics.polygon( "fill", objects.right_paddle.body:getWorldPoints( objects.right_paddle.shape:getPoints() ) )
end

function drawLeftPlayerScore()
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.draw( left_player_score_text, left_player_score_x, left_player_score_y )
end

function drawRightPlayerScore()
	love.graphics.setColor( 255, 255, 255 )
	love.graphics.draw( right_player_score_text, right_player_score_x, right_player_score_y )
end

function resetPaddlesAndBall()
	--	reset left_paddle position, and velocity 	--
	objects.left_paddle.body:setPosition( left_paddle_initial_center_x, left_paddle_initial_center_y )
	objects.left_paddle.body:setAngle( 0 )
	objects.left_paddle.body:setLinearVelocity( 0, 0 )
	objects.left_paddle.body:setAngularVelocity( 0 )

	--	reset right_paddle position, and velocity
	objects.right_paddle.body:setPosition( right_paddle_initial_center_x, right_paddle_initial_center_y )
	objects.right_paddle.body:setAngle( 0 )
	objects.right_paddle.body:setLinearVelocity( 0, 0 )
	objects.right_paddle.body:setAngularVelocity( 0 )

	--	reset ball position, and velocity 	--
	objects.ball.body:setPosition( ball_initial_center_x, ball_initial_center_y )
	objects.ball.body:setAngle( 0 )
	objects.ball.body:setLinearVelocity( 0, 0 )
	objects.ball.body:setAngularVelocity( 0 )
end

function launchBall()

	--	decide what direction to launch the ball 	--
	math.randomseed(os.time())
	math.random(); math.random(); math.random()

	local x_direction = 0
	local y_direction = 0

	while ( x_direction == 0 ) or ( y_direction == 0 ) do
		x_direction = math.random( -1, 1 )
		y_direction = math.random( -1, 1 )
	end

	ball_launch_speed_x = ball_launch_speed_x * x_direction
	ball_launch_speed_y = ball_launch_speed_y * y_direction

	--	launch the ball 	--
	objects.ball.body:setLinearVelocity( ball_launch_speed_x, ball_launch_speed_y )
end

function drawGameIntro()
	love.graphics.draw( game_intro_text, game_intro_text_x, game_intro_text_y )
end

function drawRoundIntro()
	love.graphics.draw( round_intro_text, round_intro_text_x, round_intro_text_y )
end

function prepareGameOutro()
	winner_text:set( string.upper( winner ) .. " WINS" )
	loser_text:set( string.upper( loser ) .. " SUCKS" )

	winner_text_color_r = 0
	winner_text_color_g = 0
	winner_text_color_b = 0

	loser_text_color_r = 0
	loser_text_color_g = 0
	loser_text_color_b = 0

	if winner == "red" then
		winner_text_x, winner_text_y = objects.left_paddle.body:getWorldCenter()
		winner_text_y = winner_text_y

		winner_text_color_r = 255
		winner_text_color_g = 0
		winner_text_color_b = 0
	elseif winner == "blue" then
		winner_text_x, winner_text_y = objects.right_paddle.body:getWorldCenter()
		winner_text_y = winner_text_y

		winner_text_color_r = 0
		winner_text_color_g = 0
		winner_text_color_b = 255
	elseif winner == "nobody" then
		winner_text_x = love.graphics.getWidth() / 2
		winner_text_y = love.graphics.getHeight() * 4 / 10

		winner_text_color_r = 255
		winner_text_color_g = 255
		winner_text_color_b = 255
	end

	if loser == "red" then
		loser_text_x, loser_text_y = objects.left_paddle.body:getWorldCenter()
		loser_text_y = loser_text_y

		loser_text_color_r = 255
		loser_text_color_g = 0
		loser_text_color_b = 0
	elseif loser == "blue" then
		loser_text_x, loser_text_y = objects.right_paddle.body:getWorldCenter()
		loser_text_y = loser_text_y

		loser_text_color_r = 0
		loser_text_color_g = 0
		loser_text_color_b = 255
	elseif loser == "everyone" then
		loser_text_x = love.graphics.getWidth() / 2
		loser_text_y = love.graphics.getHeight() * 7 / 10

		loser_text_color_r = 255
		loser_text_color_g = 0
		loser_text_color_b = 255
	end

end

function drawGameOutro()
	--	draw winner message	--
	love.graphics.setColor( winner_text_color_r, winner_text_color_g, winner_text_color_b )
	love.graphics.draw( winner_text, winner_text_x, winner_text_y )

	--	draw loser message 	--
	love.graphics.setColor( loser_text_color_r, loser_text_color_g, loser_text_color_b )
	love.graphics.draw( loser_text, loser_text_x, loser_text_y )
end

function determineWinner()
	if( left_player_score > right_player_score ) then
		winner = "red"
		loser = "blue"
	elseif ( right_player_score > left_player_score ) then
		winner = "blue"
		loser = "red"
	elseif ( right_player_score == left_player_score ) then
		winner = "nobody"
		loser = "everyone"
	end
end

function beginContact(a, b, coll)
    local x, y = coll:getNormal()
    collision_text = collision_text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y

    --	check for ball and goal collisions 	--
    checkForRightPlayerScore( a, b, coll )
    checkForLeftPlayerScore( a, b, coll )

    --	check for left_paddle in a goal 	--
    --	checkForLeftPaddleInAGoal( a, b, coll )

    --	check for right_paddle in a goal 	--
    --	checkForLeftPaddleInAGoal( a, b, coll )
end
 
function endContact(a, b, coll)
    persisting = 0
    collision_text = collision_text.."\n"..a:getUserData().." uncolliding with "..b:getUserData()
end
 
function preSolve(a, b, coll)
    if persisting == 0 then    -- only say when they first start touching
        collision_text = collision_text.."\n"..a:getUserData().." touching "..b:getUserData()
    elseif persisting < 20 then    -- then just start counting
        collision_text = collision_text.." "..persisting
    end
    persisting = persisting + 1    -- keep track of how many updates they've been touching for
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end

function checkForRightPlayerScore( a, b, coll )
	if( ( a:getUserData() == "ball" ) and ( b:getUserData() == "left_goal" ) ) then
    	rightPlayerScored()
    elseif ( ( a:getUserData() == "left_goal" ) and ( b:getUserData() == "ball" ) ) then
    	rightPlayerScored()
    end
end

function checkForLeftPlayerScore( a, b, coll )
	if( ( a:getUserData() == "ball" ) and ( b:getUserData() == "right_goal" ) ) then
    	leftPlayerScored()
    elseif ( ( a:getUserData() == "right_goal" ) and ( b:getUserData() == "ball" ) ) then
    	leftPlayerScored()
    end
end

function checkForLeftPaddleInAGoal( a, b, coll )
	local normal_x, normal_y = coll:getNormal()

	--	check for collision with own goal 	--
	if( ( a:getUserData() == "left_paddle" ) and ( b:getUserData() == "left_goal" ) ) then
    	repelPaddle( a, normal_x, normal_y )
    elseif ( ( a:getUserData() == "left_goal" ) and ( b:getUserData() == "left_paddle" ) ) then
    	repelPaddle( b, -normal_x, -normal_y )
    end
    --	check for collision with enemy goal 	--
  	if( ( a:getUserData() == "left_paddle" ) and ( b:getUserData() == "right_goal" ) ) then
    	repelPaddle( a, -normal_x, -normal_y )
    elseif ( ( a:getUserData() == "right_goal" ) and ( b:getUserData() == "left_paddle" ) ) then
    	repelPaddle( b, normal_x, normal_y )
    end
end

function checkForRightPaddleInAGoal( a, b, coll )
	local normal_x, normal_y = coll:getNormal()

	--	check for collision with own goal 	--
	if( ( a:getUserData() == "right_paddle" ) and ( b:getUserData() == "left_goal" ) ) then
    	repelPaddle( a, -normal_x, -normal_y )
    elseif ( ( a:getUserData() == "left_goal" ) and ( b:getUserData() == "right_paddle" ) ) then
    	repelPaddle( b, normal_x, normal_y )
    end
    --	check for collision with enemy goal 	--
  	if( ( a:getUserData() == "right_paddle" ) and ( b:getUserData() == "right_goal" ) ) then
    	repelPaddle( a, -normal_x, -normal_y )
    elseif ( ( a:getUserData() == "right_goal" ) and ( b:getUserData() == "right_paddle" ) ) then
    	repelPaddle( b, normal_x, normal_y )
    end
end

function repelPaddle( paddle, direction_x, direction_y )
	local x_impulse = direction_x * paddle_repel_force_modifier
	local y_impulse = direction_y * paddle_repel_force_modifier


	paddle:getBody():applyLinearImpulse( x_impulse, y_impulse )
end

function rightPlayerScored()
	right_player_score = right_player_score + right_player_point_value
	right_player_score_text:set( tostring( right_player_score ) )
end

function leftPlayerScored()
    left_player_score = left_player_score + left_player_point_value
    left_player_score_text:set( tostring( left_player_score ) )
end

function randomizeName()
	--	select a prefix at random 	--
	math.randomseed(os.time())
	math.random(); math.random(); math.random()

	title_prefix = title_prefixes[ math.random( 1, #title_prefixes ) ]

	title_postfix = " Pong"
	--	small chance of Dong instead of pong 	--
	if( love.math.random() <= 0.1 ) then
		title_postfix = " Dong"
	end

	title_prefix_text:set( title_prefix )
	title_postfix_text:set( title_postfix )
end