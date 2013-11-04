#!/usr/bin/ruby1.9.1

class Snake
	@@record = 0
	@@no_games = 0
	@@average = 0
	@@score_sum = 0

	def initialize(mat_dim)
		@mat_dim = mat_dim
		@mat = Array.new(@mat_dim) {Array.new(@mat_dim) {0}}
		@tail = 0
		@score = 0
		@@no_games += 1
		set_snake
		set_food
		system('setterm -cursor off')
	end
	
	def set_snake
		@snake = []
		
		(0..@mat_dim/2).each do |i|
			@snake << [0, i]
		end
	end
	
	def set_food
		while true do
			i = Random.rand(@mat_dim)
			j = Random.rand(@mat_dim)
			if @mat[i][j] == 0
				@food = [i, j]
				return;
			end
		end
	end
	
	def play
		while true do
			build_mat
			print_stats
			make_a_step
			sleep 0.1
		end
	end
	
	def build_mat
		(0...@tail).each do |i|
			@mat [@snake[i][0]] [@snake[i][1]] = 0 # blank space
		end
		
		@mat [@snake[@tail][0]] [@snake[@tail][1]] = 1 # tail
		
		(@tail+1..@snake.size - 2).each do |i|
			@mat [@snake[i][0]] [@snake[i][1]] = 2 # body
		end
		
		@mat [@snake[@snake.size-1][0]] [@snake[@snake.size-1][1]] = 3 # head
		
		@mat [@food[0]] [@food[1]] = 4 # food
	end
	
	def print_stats
		system("clear")
		puts "RECORD:  " + @@record.to_s
		puts "AVERAGE: " + "%.2f" %@@average.to_s
		puts
		print_mat
		puts
		puts "\tSCORE:   " + @score.to_s
	end
	
	def print_mat
		(0...@mat_dim).each do |i|
			print "\t"
			(0...@mat_dim).each do |j|
				if @mat[i][j] == 0 # blank space
					print "  " 
				elsif @mat[i][j] == 1 # tail
					print ". "
				elsif @mat[i][j] == 2 # body
					print "o "
				elsif @mat[i][j] == 3 # head
					print "* "
				elsif @mat[i][j] == 4 # food
					print "# "
				end
			end
			puts
		end
	end
	
	def make_a_step
		head = @snake[@snake.size - 1]
		prev_head = @snake[@snake.size - 2]
		
		if head[1] == prev_head[1] # try to go down/up first
		
			if head[0] < @mat_dim - 1 && @food[0] > head[0] && prev_head[0] != head[0] + 1 # down
				new_head = [head[0]+1, head[1]]
			elsif head[0] > 0 && @food[0] < head[0] && prev_head[0] != head[0] - 1 # up
				new_head = [head[0]-1, head[1]]
			elsif head[1] < @mat_dim - 1 && @food[1] > head[1] && prev_head[1] != head[1] + 1 # right
				new_head = [head[0], head[1] + 1]
			elsif head[1] > 0 && @food[1] < head[1] && prev_head[1] != head[1] - 1 # left
				new_head = [head[0], head[1] - 1]
				
			elsif @food[0] == head[0]
				if head[0] < @mat_dim - 1
					new_head = [head[0]+1, head[1]] # down
				elsif head[0] > 0 
					new_head = [head[0]-1, head[1]] # up
				end
			elsif @food[1] == head[1]
				if head[1] < @mat_dim - 1
					new_head = [head[0], head[1] + 1] # right
				elsif head[1] > 0
					new_head = [head[0], head[1] - 1] # left
				end
			end
			
		elsif head[0] == prev_head[0] # try to go right/left first
		
			if head[1] < @mat_dim - 1 && @food[1] > head[1] && prev_head[1] != head[1] + 1 # right
				new_head = [head[0], head[1] + 1]
			elsif head[1] > 0 && @food[1] < head[1] && prev_head[1] != head[1] - 1 # left
				new_head = [head[0], head[1] - 1]
			elsif head[0] < @mat_dim - 1 && @food[0] > head[0] && prev_head[0] != head[0] + 1 # down
				new_head = [head[0]+1, head[1]]
			elsif head[0] > 0 && @food[0] < head[0] && prev_head[0] != head[0] - 1 # up
				new_head = [head[0]-1, head[1]]
				
			elsif @food[0] == head[0]
				if head[0] < @mat_dim - 1
					new_head = [head[0]+1, head[1]] # down
				elsif head[0] > 0 
					new_head = [head[0]-1, head[1]] # up
				end
			elsif @food[1] == head[1]
				if head[1] < @mat_dim - 1
					new_head = [head[0], head[1] + 1] # right
				elsif head[1] > 0
					new_head = [head[0], head[1] - 1] # left
				end
			end
			
		end
		
		@snake << new_head
		
		game_over if @mat [new_head[0]] [new_head[1]] == 2 # oops
		
		if @food == new_head # got_food
			@score += 1
			set_food
		else
			@tail += 1
		end
	end
	
	def game_over
		@@record = @score if @@record < @score
		@@score_sum += @score 
		@@average = @@score_sum.to_f / @@no_games
		build_mat
		6.times do |i|
			print_stats
			puts
			puts "\tGAME OVER" if i%2 == 0
			sleep 0.4
		end
		system("clear")
		initialize(@mat_dim)
		play
	end

end

snake_game = Snake.new 16
snake_game.play
