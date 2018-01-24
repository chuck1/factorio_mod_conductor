
-- data to initialize
--   Block.stops
--   Stop.blocks

-- A combinator will be copied to create an entity for
--   block
--   stop
--     used to send a signal to the train stop to send a train
--
-- These will be used to define associations using circuit networks and uniquely identify.
-- I will use the API to determine which entities are connected to determine which stops, stations, and blocks
-- are connected.
--
-- Circuit networks:
--   stop circuit network
--     connects stop combinators and stop block combinators
--   block circuit network
--     connects stop block combinators, block combinators, and gates
--


Window = {
	new = function(self, t_1, t_2)
		self.t_1 = t_1
		self.t_2 = t_2
	end
}


