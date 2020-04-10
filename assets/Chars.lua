local json = require("json")

local chars = {}

local path = system.pathForFile( "./assets/all.json", system.ResourceDirectory );
local file = io.open( path, "r" );
local data = file:read( "*a" ); --everything
io.close( file );
file = nil;

local dataRead = json.decode(data)

function chars.getFrames(name)
    local an_types = {"attack", "idle", "run"}
    local options = {frames={}}
    local frames = options.frames
    local seqData = {}

    for _, type in pairs(an_types) do
        local an_start = #frames + 1
        local animation = dataRead[name .. "_" .. type]

        for _, frame in pairs(animation.frames) do
            table.insert(frames, {x=frame.x, y=frame.y, width=frame.w, height=frame.h})
        end

        table.insert(seqData, {name = type, start=an_start, count=animation.length, time=animation.totalDuration})
    end
--[[
    print("Animation Data for: " .. name)
    print("Frame Data: ")
    print(json.encode(frames))

    print("SeqData: ")
    print(json.encode(seqData))
 ]]
    return options, seqData 
end

return chars;