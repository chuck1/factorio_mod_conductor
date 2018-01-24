
-- data to initialize
-- Line.crossings
-- Station.stops
-- Block.lines
--

-- A combinator will be copied to create an entity for
--   line
--   station
--   stop
--
-- These will be used to define associations and uniquely identify.
-- I will need to figure out how to have in and out circuit network connections on an entity
--
-- I will use the API to determine which entities are connected to determine which stops, stations, and blocks
-- are connected


Window = {
	new = function(self, t_1, t_2)
		self.t_1 = t_1
		self.t_2 = t_2
	end
}


