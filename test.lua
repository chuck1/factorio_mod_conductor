
script = {
	on_event = function(self, event_list, func)
	end
}

defines = {
	events = {
		on_built_entity = nil,
		on_tick = nil,
		on_train_changed_state = nil,
	},
	train_state = {
		wait_station = 1
	}
}

require "control"
require "conductor/stop"
require "conductor/stop_block"
require "conductor/block"

ConstantCombinatorControlBehavior = {
	new = function(self)
		o = {}
		setmetatable(o, self)
		self.__index = self
		return o
	end,
	set_signal = function(self)
	end,
}

StopEntity = {
	new = function(self, unit_number)
		o = {
			unit_number = unit_number,
			name = "conductor-stop-combinator",
		}
		setmetatable(o, self)
		self.__index = self
		return o
	end,
	get_control_behavior = function(self)
		return ConstantCombinatorControlBehavior:new()
	end
}

GateEntity = {
	new = function(self, unit_number)
		o = {
			unit_number = unit_number,
			name = "gate",
			_is_opening = false,
			_is_closing = false,
		}
		setmetatable(o, self)
		self.__index = self
		return o
	end,
	is_opening = function(self)
		return self._is_opening
	end,
	is_closing = function(self)
		return self._is_closing
	end,
}

-- 000000000000000000000000000000000000000000000000000000

train_stop_entity_1 = {
	unit_number = 1,
	name = "conductor-train-stop",
}
train_stop_entity_2 = {
	unit_number = 2,
	name = "conductor-train-stop",
}
train_stop_entity_3 = {
	unit_number = 3,
	name = "conductor-train-stop",
}


stop_entity_1 = StopEntity:new(4)
stop_entity_2 = StopEntity:new(5)
stop_entity_3 = StopEntity:new(6)

block_entity_a = {
	unit_number = 7,
	name = "conductor-block-combinator",
}

stop_block_entity_a1 = {
	unit_number = 8,
	name = "conductor-stop-block-combinator",
}

gate_a_1 = GateEntity:new(9)
gate_a_2 = GateEntity:new(10)
gate_a_3 = GateEntity:new(11)
gate_a_exit = GateEntity:new(12)

-- 000000000000000000000000000000000000000000000000000000

train_stop_entity_1.circuit_connected_entities = {
	green = {stop_entity_1},
	red = {}
}

train_stop_entity_2.circuit_connected_entities = {
	green = {stop_entity_2},
	red = {}
}

train_stop_entity_3.circuit_connected_entities = {
	green = {stop_entity_3},
	red = {}
}


stop_entity_1.circuit_connected_entities = {
	green = {train_stop_entity_1},
	red = {stop_block_entity_a1}
}

stop_entity_2.circuit_connected_entities = {
	green = {train_stop_entity_2},
	red = {stop_block_entity_a1}
}

stop_entity_3.circuit_connected_entities = {
	green = {train_stop_entity_3},
	red = {stop_block_entity_a1}
}

stop_block_entity_a1.circuit_connected_entities = {
	green = {
		block_entity_a,
	},
	red = {
		stop_entity_1,
		stop_entity_2,
		stop_entity_3,
	}
}

block_entity_a.circuit_connected_entities = {
	green = {
		stop_block_entity_a1,
	},
	red = {
		gate_a_1,
		gate_a_2,
		gate_a_3,
		gate_a_exit,
	}
}

-- 000000000000000000000000000000000000000000000000000000

on_tick({tick=0})

on_built_entity({
	tick = 1,
	created_entity = {
		name = "green-wire",
		circuit_connected_entities = {
			green = {train_stop_entity_1, stop_entity_1},
			red = {}
		}
	}
})

print_connections()

train_1 = {
	station = train_stop_entity_1,
	state = defines.train_state.wait_station,
}

on_train_changed_state({
	tick = 2,
	train = train_1,
})


--print_state()

on_tick({tick=3})

-- train_1 leaves station

train_1.state = defines.train_state.on_the_path
train_1.station = nil

on_train_changed_state({
	tick = 3,
	train = train_1,
})

on_train_changed_state({
	tick = 3,
	train = {
		station = train_stop_entity_2,
		state = defines.train_state.wait_station,
	},
})

on_tick({tick=4})

on_train_changed_state({
	tick = 4,
	train = {
		station = train_stop_entity_3,
		state = defines.train_state.wait_station,
	},
})

--print_state()



gate_a_1._is_opening = true

on_tick({tick=10})

gate_a_1._is_opening = false



gate_a_1._is_closing = true

on_tick({tick=11})

gate_a_1._is_closing = false



gate_a_2._is_opening = true

on_tick({tick=20})

gate_a_2._is_opening = false



gate_a_2._is_closing = true

on_tick({tick=21})

gate_a_2._is_closing = false



on_tick({tick=22})
on_tick({tick=23})
on_tick({tick=24})

print_state()




