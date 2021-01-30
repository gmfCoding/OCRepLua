local world = program.rep_world
local db = program.rep_db
local meinv = program.me_inv;
local rep = program.rep;
local repBlockNames = {}
local repnames = {}
local proxyNames = nil
local sidesapi = require("sides");
local invside = -1;

repnames.ic2rep = "ic2:replicator";
repnames.ic2pat = "ic2:pattern_storage";

main = {}

main.isSafe = false;
main.init = false;
main.alive = true;
main.conf = {}
main.conf.repPos = nil
main.conf.scanPos = nil
main.conf.patPos = nil
main.conf.UUInv = nil

-- program.iostate: 0 listen,2 read,3 queue, 0 listen...

main.process_slots = {}
main.queue = {}
main.isCounting = false

function main.Main()
    invside = program.tsave.load("config")
    -- Foreach side check if there is a valid inventory
    if invside == -1 then
        for i in ipairs(sidesapi) do
            if meinv.getInventorySize(invside) ~= nil
                invside = i;
                break;
        end
    end
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
        if ui == "proc" then main.Process();
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
    local size = meinv.getInventorySize(invside)

    for i, size do
        if has_value(main.process_slots, i-1) == false then
            local stack = meinv.getStackInInternalSlot(i - 1)
            if stack.name == "minecraft:paper" and stack.label ~= "Paper" then
                local done = false;
                for index, value in pairs(proxyNames) do
                    if index == stack.label then
                        main.queue[value].count = main.queue[value].count + stack.size;
                        table.insert(main.queue[value].slots, i - 1)
                        table.insert(main.process_slots, i - 1)
                        done = true;
                        break;
                    end
                end
                if done == false and has_element(main.queue, label) then
                    main.queue[label].count = main.queue[label].count + stack.size;
                    table.insert(main.queue[label].slots, i - 1)
                    table.insert(main.process_slots, i - 1)
                end
            else
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
        for i, queue[i].count, 1 then
            prev = rep.setMode(1)
            while rep.getMode() == prev do
            end
        end
    end
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function has_element (tab, val)
    for index, value in pairs(tab) do
        if index == val then
            return true
        end
    end
    return false
end

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do 
        count = count + 1 
    end
    return count
end
return main;