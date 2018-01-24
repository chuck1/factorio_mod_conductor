


local conductorTrainStop = table.deepcopy(data.raw["train-stop"]["train-stop"])
conductorTrainStop.name = "conductor-train-stop"

local recipe_train_stop = table.deepcopy(data.raw.recipe["train-stop"])
recipe.enabled = true
recipe.ingredients = {{"train-stop", 1}, {"processing-unit", 10}}
recipe.result = "conductor-train-stop"



local conductorStopCombinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
conductorStopCombinator.name = "conductor-stop-combinator"

local recipe_stop = table.deepcopy(data.raw.recipe["constant-combinator"])
recipe.enabled = true
recipe.ingredients = {{"constant-combinator", 1}, {"processing-unit", 5}}
recipe.result = "conductor-stop-combinator"



local conductorStopBlockCombinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
conductorStopBlockCombinator.name = "conductor-stop-block-combinator"

local recipe_stop_block = table.deepcopy(data.raw.recipe["constant-combinator"])
recipe.enabled = true
recipe.ingredients = {{"constant-combinator", 1}, {"processing-unit", 5}}
recipe.result = "conductor-stop-block-combinator"



local conductorBlockCombinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
conductorBlockCombinator.name = "conductor-block-combinator"

local recipe_block = table.deepcopy(data.raw.recipe["constant-combinator"])
recipe.enabled = true
recipe.ingredients = {{"constant-combinator", 1}, {"processing-unit", 5}}
recipe.result = "conductor-block-combinator"


data:extend{conductorTrainStop, recipe_train_stop}
data:extend{conductorStopCombinator, recipe_stop}
data:extend{conductorStopBlockCombinator, recipe_stop_block}
data:extend{conductorBlockCombinator, recipe_block}


