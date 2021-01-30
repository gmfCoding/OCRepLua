local debug = program.debug;
local world = program.world;
lcaol rep = program.te_rep;
local this = {}

local replication = {}
replication.patterns = {}
replication.repPos = {}
replication.patPos = {}
replication.patPos = {}

--local ie_hf = {"immersiveengineering:metal_decoration0", 5, 2}; 
--local te_f = {"thermalexpansion:frame", 0, 0};

local patterns = {}

function this.Init()
    replication.patPos = program.rep_main.RepApp.Conf.PatternPos
    replication.repPos = program.rep_main.RepApp.Conf.ReplicatorPos
    this.FindPatterns()

    print("Select the pattern to change to Replicator to")
    for i, d in pairs(patterns) do
        print(i.." > "..patterns[i][1]);
    end
    local sel = io.read()

    this.SetReplicator(patterns[tonumber(sel)])
end

function this.ClearPatterns()
    for k in pairs(patterns) do
        patterns[k] = nil
    end
end

function get_rep_nbt() return world.getTileNBT(replication.repPos[1], replication.repPos[2], replication.repPos[3]); end
function get_scan_nbt() return world.getTileNBT(replication.repPos, replication.patPos[2], replication.patPos[3]); end

function this.FindPatterns()
    this.ClearPatterns();
    local pnbt = world.getTileNBT(replication.patPos[1], replication.patPos[2], replication.patPos[3]);

    for i = 1,pnbt.value.patterns.value.n do
        val = pnbt.value.patterns.value[i].value
        tab = {val.id.value, val.Damage.value, i-1}
        print(tab[1])
        table.insert(patterns, 1, tab);
    end
end

function this.SetReplicator(pat)
    local nbt = world.getTileNBT(replication.repPos[1], replication.repPos[2], replication.repPos[3]);
    nbt.value.pattern.value.id.value = pat[1];
    nbt.value.pattern.value.Damage.value = pat[2]
    nbt.value.index.value = pat[3];
    world.setTileNBT(replication.repPos[1], replication.repPos[2], replication.repPos[3], nbt);
end


this.replication = replication;
this.patterns = patterns;
return this;