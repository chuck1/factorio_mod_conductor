
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
stop_entity_1 = {
	unit_number = 4,
	name = "conductor-stop-combinator",
}
stop_entity_2 = {
	unit_number = 5,
	name = "conductor-stop-combinator",
}
stop_entity_3 = {
	unit_number = 6,
	name = "conductor-stop-combinator",
}
block_entity_a = {
	unit_number = 7,
	name = "conductor-block-combinator",
}
stop_block_entity_a1 = {
	unit_number = 8,
	name = "conductor-stop-block-combinator",
}

train_stop_entity_1.circuit_connected_entities = {green={stop_entity_1},red={}}
train_stop_entity_2.circuit_connected_entities = {greeg={stop_entity_2},red={}}
train_stop_entity_3.circuit_connected_entities = {green={stop_entity_3},red={}}

stop_entity_1.circuit_connected_entities = {
	green={train_stop_entity_1},
	red={stop_block_entity_a1}
}
stop_entity_2.circuit_connected_entities = {
	green={train_stop_entity_2},
	red={stop_block_entity_a1}
}
stop_entity_3.circuit_connected_entities = {
	green={train_stop_entity_3},
	red={stop_block_entity_a1}
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
	red = {}
}

on_tick({tick=0})

on_built_entity({
	tick = 1,
	created_entity = {name = "green-wire",
	circuit_connected_entities = {
		green = {train_stop_entity_1, stop_entity_1},
		red = {}
	}
}
})

on_train_changed_state({
	tick = 2,
	train = {
		station = train_stop_entity_1,
		state = defines.train_state.wait_station,
	},
})

print_connections()
print_state()

on_tick({tick=3})

print_state()


