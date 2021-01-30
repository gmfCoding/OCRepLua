

program = {}


function program.tprint (tbl)
    local indent = ""
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
      if type(v) == "table" then
        print(formatting)
        tprint(v, indent+1)
      elseif type(v) == 'boolean' then
        print(formatting .. tostring(v))      
      else
        print(formatting .. v)
      end
    end
end

local tsave = require("tableToFile"); 
local component = require("component");

local db = component.database;
local debug = component.debug;
local world = component.debug.getWorld();

program.tsave = tsave;
program.component = component;
program.db = db;
program.debug = debug;
program.world = world;

program.me_inv = component.inventory_controller
program.te_rep = component.ic2_replicator

local main = require("main")
program.main = main;
print("pre main test", main.conf.side)
main.Main();

return program;