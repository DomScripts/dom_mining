local Inventory = exports.ox_inventory

function BucketCheck(reward)
    local buckets = Inventory:GetItem(source, 'empty_bucket', nill, true)
    if buckets >= reward then 
        return true
    else 
        return false
    end 
end 

function NotEnoughBuckets()
    local cfg = Config.Notifications[1]
    lib.notify(source, cfg.MineNotEnoughBuckets)
end 

function NotEnoughSpace()
    local cfg = Config.Notifications[1]
    lib.notify(source, cfg.MineNotEnoughSpace)
end 

function NoTools()
    local cfg = Config.Notifications[1]
    lib.notify(source, cfg.MineNoTools)
end 

function ProcessCheck(input)
    local cfg = Config.Process[1]
    local sum = input[2]
    local buckets = Inventory:GetItem(source, 'full_bucket', nill, true)
    if buckets >= sum then 
        return true 
    else 
        return false 
    end 
end

function GemCheck() 
    local gems = Inventory:GetItem(source, 'gem_rock', nill, true)
        if gems >= 1 then 
            return true
        else 
            return false 
        end 
end 

local isBreakdown = false 
RegisterNetEvent("mining:gemBreakdown", function()
    if isBreakdown == false then 
        isBreakdown = true
        local cfg = Config.Notifications[1]
        if GemCheck() == true then 
        local success = Inventory:CanCarryItem(source, 'water', 1)
            if success then 
                TriggerClientEvent("mining:drillCircle", source)
            else 
                lib.notify(source, cfg.GemNotEnoughSpace)
            end 
        else
            lib.notify(source, cfg.GemNoRock)
        end 
        Wait(Config.Drill[1].Time)
        isBreakdown = false 
    end 
end)

function CanMine(reward)
    local bucketCheck = BucketCheck(reward)
    if bucketCheck then 
        local success = Inventory:CanCarryItem(source, 'full_bucket', reward)
        if success then 
            return true 
        else
            NotEnoughSpace()
        end 
    else 
        NotEnoughBuckets()
    end 
end 

local isMining = false 
RegisterNetEvent("mining:mineRock", function(data)
    if isMining == false then 
        isMining = true
        math.randomseed(os.time())
        local cfg = Config.Mining
        local jackhammer = Inventory:Search(source, 'count', 'jackhammer', false)
        local pickaxe = Inventory:Search(source, 'count', 'pickaxe', false)
        local shovel = Inventory:Search(source, 'count', 'shovel', false)

        if jackhammer >= 1 then 
            local time = cfg[1].Time
            local reward = math.random(cfg[1].MinReward, cfg[1].MaxReward)
            local animation = {
                dict = 'amb@world_human_const_drill@male@drill@base',
                clip = 'base'
            }
            local props = {
                model = 'prop_tool_jackham',
                bone = 28422,
                pos = vec3(0.05, 0.00, 0.00),
                rot = vec3(0.0, 0.0, 0.0)
            }
            if CanMine(reward) then 
                TriggerClientEvent("mining:progressBar", source, time, reward, data, animation, props)
                Wait(time)
            end
        elseif pickaxe >= 1 then 
            local time = cfg[2].Time
            local reward = math.random(cfg[2].MinReward, cfg[2].MaxReward)
            local animation = {
                dict = 'melee@large_wpn@streamed_core',
                clip = 'ground_attack_0'
            }
            local props = {
                model = 'prop_tool_pickaxe',
                bone = 28422,
                pos = vec3(0.05, 0.00, 0.00),
                rot = vec3(-70.0, 30.0, 0.0)
            }
            if CanMine(reward) then 
                TriggerClientEvent("mining:progressBar", source, time, reward, data, animation, props)
                Wait(time)
            end
        elseif shovel >= 1 then 
            local time = cfg[3].Time
            local reward = math.random(cfg[3].MinReward, cfg[3].MaxReward)
            local animation = {
                dict = 'amb@world_human_gardener_plant@male@base',
                clip = 'base'
            }
            local props = {
                model = 'prop_cs_trowel',
                bone = 28422,
                pos = vec3(0.00, 0.00, 0.00),
                rot = vec3(0.0, 0.0, -1.5)
            }
            if CanMine(reward) then 
                TriggerClientEvent("mining:progressBar", source, time, reward, data, animation, props)
                Wait(time)
            end
        else 
            NoTools()
        end 
        
        isMining = false
    end
end)

local isProcess = false 
RegisterNetEvent("mining:Process", function(input)
    if isProcess == false then 
        isProcess = true
        local cfg = Config.Notifications[1]
        local gemRocks = math.floor(input[2] / 5)
        if ProcessCheck(input) == true then 
            TriggerClientEvent("mining:processCircle", source, input, gemRocks)
        else 
            lib.notify(source, cfg.ProcessNoDirt)
        end 
        Wait(Config.Process[1].Time)
        isProcess = false 
    end
end)

RegisterNetEvent("mining:Reward", function(reward)
    Inventory:RemoveItem(source, 'empty_bucket', reward)
    Inventory:AddItem(source, 'full_bucket', reward)
end)

RegisterNetEvent("mining:processReward", function(input, gemRocks)
    local cfg = Config.Process[1]
    Inventory:RemoveItem(source, cfg.ItemToProcess, input[2])
    Inventory:AddItem(source, input[1], input[2])
    if gemRocks >= 1 then 
        Inventory:AddItem(source, 'gem_rock', gemRocks)
    end 
end)

RegisterNetEvent("mining:gemReward", function()
    local cfg = Config.Drill[1]
    local gems = Inventory:GetItem(source, 'gem_rock', nill, true)
    local amounts = {}
    
    for i = 1, gems do 
        local slot = math.random(1,#(cfg.Reward))

        if amounts[slot] == nill then 
            amounts[slot] = 0
        end 
        amounts[slot] = amounts[slot] + 1
    end 

    for i=1, #(cfg.Reward) do 
        Inventory:RemoveItem(source, 'gem_rock', gems)
        Inventory:AddItem(source, cfg.Reward[i], amounts[i])
    end 
end)
