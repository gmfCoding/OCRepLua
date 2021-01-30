local world = program.rep_world
local db = program.rep_db
local meinv = program.me_inv;
local rep = program.rep;
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

    for i,k in pairs(rep.getPatterns()) do 
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

function main.Enqueue()
    -- get the front side of the inventory
    local size = meinv.getInventorySize(main.conf.side)

    for i=1,size,1 do
        if has_value(main.process_slots, i) == false then
            local stack = meinv.getStackInSlot(main.conf.side, i)
            if stack ~= nil and stack.name == "minecraft:paper" and stack.label ~= "Paper" then
                local done = false;
                for index, value in pairs(proxyNames) do
                    if index == stack.label and has_element(main.conf.patternNames, index) then
                        if main.queue[value] == nil then
                            main.queue[value] = {}
                        end
                        main.queue[value].count = main.queue[value].count + stack.size;
                        table.insert(main.queue[value].slots, i)
                        table.insert(main.process_slots, i)
                        done = true;
                        break;
                    end
                end

                
                if done == false and has_element(main.queue, label) and has_element(main.conf.patternNames, main.label) then
                    if main.queue[value] == nil then
                        main.queue[value] = {}
                    end
                    main.queue[label].count = main.queue[label].count + stack.size;
                    table.insert(main.queue[label].slots, i - 1)
                    table.insert(main.process_slots, i - 1)
                end
            elseif stack ~= nil then
                print("Unknown item:", stack.label, " / ", stack.name)
            end
        end
    end
end

function main.Process()
    for i,k in pairs(queue) do
        print(i .. ":".. tostring(queue.s))
        rep.setPatternNamed(k);
        local prev = 1
        for i,k in queue[i].count, 1 do
            prev = rep.setMode(1)
            while rep.getMode() == prev do
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

print("Test", main.conf.side)
return main;