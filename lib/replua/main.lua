local world = program.rep_world
local db = program.rep_db
local meinv = program.me_inv;
local rep = program.te_rep;
local repBlockNames = {}
local repnames = {}
local proxyNames = nil
local sidesapi = require("sides");

repnames.ic2rep = "ic2:replicator";
repnames.ic2pat = "ic2:pattern_storage";

local main = {}


main.isSafe = false;
main.init = false;
main.alive = true;
main.conf = {}
main.conf.repPos = nil
main.conf.scanPos = nil
main.conf.patPos = nil
main.conf.UUInv = nil
main.conf.side = -1
main.conf.patternNames = {}
-- program.iostate: 0 listen,2 read,3 queue, 0 listen...

main.process_slots = {}
main.queue = {}
main.isCounting = false

function main.Main()

    for i, k in pairs(rep.getPatterns()) do 
        table.insert(main.conf.patternNames, i)
    end

    print("Test", main.conf.side)
    main.conf.side = program.tsave.load("side.cfg")

    -- Foreach side check if there is a valid inventory
    if main.conf.side == -1 then
        for i in ipairs(sidesapi) do
            if meinv.getInventorySize(i - 1) ~= nil then
                main.conf.side = i - 1;
                break;
            end
        end
    end
    print("Side loaded", main.conf.side)
    print("")
    print("Welcome to the Replicator Interface ;)\n")

    print("proc -- setup alt: use the attached database (first 9 slots only) to load positions")
    print("setup -- you will need to setup the position of the machines before anything else.")
    print("exec -- run the main program.")
    print("show -- prints the configs")
    print("show -- prints the configs")
    while main.alive == true do
        io.write("rep>")
        local ui = io.read();
        if ui == "setup" then main.Setup();
        elseif ui == "proc" then main.Process();
        elseif ui == "exec" then program.rep.Init()
        elseif ui == "quit" then main.alive = false
        end
    end
end

function main.Setup()
    proxyNames = program.tsave.load("proxy")
    main.Enqueue()
    main.Process()
end

function main.TestQueue(value, amt, slots)
    if main.queue[value] == nil then
        main.queue[value] = {}
        main.queue[value].count = 0
        main.queue[value].slots = {}
    end
    main.queue[value].count = main.queue[value].count + amt;
    main.queue[value].slots = slots
end

function main.Enqueue()
    -- get the front side of the inventory
    local size = meinv.getInventorySize(main.conf.side)

    for i=1,size,1 do
        if main.has_value(main.process_slots, i) == false then
            local stack = meinv.getStackInSlot(main.conf.side, i)
            if stack ~= nil and stack.name == "minecraft:paper" and stack.label ~= "Paper" then
                local done = false;
                for index, value in pairs(proxyNames) do
                    if index == stack.label  main.conf.patternNames[value] ~= nil then
                        if main.queue[value] == nil then
                            main.queue[value] = {}
                            main.queue[value].count = 0
                            main.queue[value].slots = {}
                        end
                        
                        main.queue[value].count = main.queue[value].count + stack.size;
                        table.insert(main.queue[value].slots, i)
                        table.insert(main.process_slots, i)
                        print("Finished item:", stack.label)
                        done = true;
                        break;
                    end
                end

                -- main.has_element(main.conf.patternNames, "item.thermalexpansion.frame.frameMachine")
                if done == false and  main.conf.patternNames[stack.label] ~= nil then
                    print("Queued item:", stack.label)
                    if main.queue[stack.label] == nil then
                        main.queue[stack.label] = {}
                        main.queue[stack.label].count = 0
                        main.queue[stack.label].slots = {}
                    end
                    main.queue[stack.label].count = main.queue[stack.label].count + stack.size;
                    table.insert(main.queue[stack.label].slots, i)
                    table.insert(main.process_slots, i)
                    print("Finished item:", stack.label)
                end
            elseif stack ~= nil then
                print("Unknown item:", stack.label, " / ", stack.name)
            end
        end
    end
    print("final:")
    main.tprint(main.queue)
end

function main.Process()
    for i,k in pairs(main.queue) do
        print(i .. ":".. tostring(main.queue[i]))
        rep.setPatternNamed(k);
        local prev = 1
        for i,k in main.queue[i].count, 1 do
            prev = rep.setMode(1)
            while rep.getMode() ~= 0 do
                local i = 0
            end
        end
    end
end

function main.has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function main.has_element (tab, val)
    for index, value in pairs(tab) do
        if index == val then
            return true
        end
    end
    return false
end

function main.tablelength(T)
    local count = 0
    for _ in pairs(T) do 
        count = count + 1 
    end
    return count
end

function main.tprint (tbl)
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

print("Test", main.conf.side)
return main;