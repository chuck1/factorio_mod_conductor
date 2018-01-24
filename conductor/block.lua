
-- a continuous section of rail that we want to make sure only one train
-- occupies at a time
Block = {
	entity = nil,

	stations = {}
}

function Block:notify(t_1, t_2)

	-- notify all stops that this block will be occupied from t_1 to t_2
	
	for stop_id, stop in pairs(self.stops) do
		stops.block_notify(self, t_1, t_2)
	end
end



