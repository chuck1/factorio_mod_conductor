
local conductorTrainStopItem = table.deepcopy(data.raw["item"]["train-stop"])
conductorTrainStopItem.order = "a[train-system]-cb[train-stop]"


local conductorTrainStop = table.deepcopy(data.raw["train-stop"]["train-stop"])
conductorTrainStop.name = "conductor-train-stop"

local recipe_train_stop = table.deepcopy(data.raw.recipe["train-stop"])
recipe_train_stop.name = "conductor-train-stop"
recipe_train_stop.enabled = true
recipe_train_stop.ingredients = {{"train-stop", 1}, {"processing-unit", 10}}
recipe_train_stop.result = "conductor-train-stop"

data:extend{conductorTrainStopItem, conductorTrainStop, recipe_train_stop}

--[[

local conductorStopCombinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
conductorStopCombinator.name = "conductor-stop-combinator"

local recipe_stop = table.deepcopy(data.raw.recipe["constant-combinator"])
recipe_stop.enabled = true
recipe_stop.ingredients = {{"constant-combinator", 1}, {"processing-unit", 5}}
recipe_stop.result = "conductor-stop-combinator"



local conductorStopBlockCombinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
conductorStopBlockCombinator.name = "conductor-stop-block-combinator"

local recipe_stop_block = table.deepcopy(data.raw.recipe["constant-combinator"])
recipe_stop_block.enabled = true
recipe_stop_block.ingredients = {{"constant-combinator", 1}, {"processing-unit", 5}}
recipe_stop_block.result = "conductor-stop-block-combinator"



local conductorBlockCombinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
conductorBlockCombinator.name = "conductor-block-combinator"

local recipe_block = table.deepcopy(data.raw.recipe["constant-combinator"])
recipe_block.enabled = true
recipe_block.ingredients = {{"constant-combinator", 1}, {"processing-unit", 5}}
recipe_block.result = "conductor-block-combinator"


data:extend{conductorStopCombinator, recipe_stop}
data:extend{conductorStopBlockCombinator, recipe_stop_block}
data:extend{conductorBlockCombinator, recipe_block}
]]--

