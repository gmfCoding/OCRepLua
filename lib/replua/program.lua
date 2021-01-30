program = {}

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

program.me_inv = require("inventory_controller")
program.te_rep = require("ic2_replicator")

local main = require("main")
program.main = main;

local rep = require("replicator")
program.rep = rep;

main.Main();

return program;