#
# spiral.rb - a small code to generate locations scanning spirally on grids
#
# Copyright 2012 zunda <zunda at freeshell.org>
#
# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#

class Spiral
	attr_reader :step, :x, :y

	def initialize
		@step = 0
		@x = 0
		@y = 0

		@leg_length = 1
		@leg_count = 0
		@direction = 0
		@turnned = false
	end

	def step_forward
		@step += 1
		if @leg_count == @leg_length
			if @turnned
				@leg_length += 1
				@turnned = false
			else
				@turnned = true
			end
			_turn(+1)
		end
		_advance(+1)
	end

	def step_back
		return if @step < 1
		@step -= 1
		if @leg_count == 0
			if @turnned
				@turnned = false
			else
				@leg_length -= 1
				@turnned = true
			end
			_turn(-1)
			@leg_count = @leg_length
		end
		_advance(-1)
	end

	def _turn(forward_or_back)	# forward_or_back: +1 or -1
		@direction = (@direction + forward_or_back) % 4
		@leg_count = 0
	end
	private :_turn

	def _advance(forward_or_back)	# forward_or_back: +1 or -1
		case @direction
		when 0	# right
			@x += forward_or_back
		when 1	# up
			@y += forward_or_back
		when 2	# left
			@x -= forward_or_back
		when 3	# down
			@y -= forward_or_back
		end
		@leg_count += forward_or_back
	end
	private :_advance

	def to_s
		return "#{@x},#{@y}"
	end
end

if __FILE__ == $0
	require 'test/unit'
	Spiral_move = [[0,0], [1,0], [1,1], [0,1], [-1,1], [-1,0],
		[-1,-1], [0,-1], [1,-1], [2,-1], [2,0], [2,1]]

	class SpiralTest < Test::Unit::TestCase
		def test_step_forward
			spiral = Spiral.new
			Spiral_move.each do |pos|
				assert_equal(pos, [spiral.x, spiral.y])
				spiral.step_forward
			end
		end

		def test_step_back
			spiral = Spiral.new
			Spiral_move.size.times do
				spiral.step_forward
			end
			Spiral_move.reverse.each do |pos|
				spiral.step_back
				assert_equal(pos, [spiral.x, spiral.y])
			end
		end
	end
end
