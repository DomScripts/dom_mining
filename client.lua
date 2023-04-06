local Inventory = exports.ox_inventory
local Target = exports.ox_target
local Input = lib.inputDialog

local isBreakdown = false
local isMining = false
local isProcess = false 

if Config.Blip.Toggle then 
  local blip = AddBlipForCoord(Config.Blip.Location)
  SetBlipSprite(blip, 1)
  SetBlipDisplay(blip, 2)
  SetBlipScale(blip, Config.Blip.Scale)
  SetBlipColour(blip, Config.Blip.Color)
  AddTextEntry('MINING BLIP', 'Mining')
  BeginTextCommandSetBlipName('MINING BLIP')
  EndTextCommandSetBlipName(blip)
end 

function FetchModel(model)
  RequestModel(GetHashKey(model))
  while not HasModelLoaded(model) do 
    Wait(100)
  end
end 

local LocalNPCs = {}

function GetLocalNPC(index)
  return LocalNPCs[index]
end 

function CreateLocalNPC(index)
  if (LocalNPCs[index]) then 
    DestroyLocalNPC(index)
  end
    
  LocalNPCs[index] = {}
  local cfg = Config.Exchange[index]

  FetchModel(cfg.NPCModel)

  local npc = CreatePed(1, cfg.NPCModel, cfg.Location, false, true)
  FreezeEntityPosition(npc, true)
  SetEntityInvincible(npc, true)
  SetBlockingOfNonTemporaryEvents(npc, true)
  SetPedComponentVariation(npc,3,1,1,0) -- Shirt
  SetPedComponentVariation(npc,0,0,1,0) -- Hair
  SetPedComponentVariation(npc,9,0,1,0) -- Gloves
  SetPedComponentVariation(npc,8,0,1,0) -- vest
  LocalNPCs[index].npc = npc 
end 

function DestroyLocalNPC(index)
  if (LocalNPCs[index]) then 
    DeleteEntity(LocalNPCs[index].npc)
    LocalNPCs[index] = nill
  end 
end 

--! Drill spawn + target options
local drillcfg = Config.Drill[1]
local drillSpawn = CreateObject(drillcfg.DrillModel, drillcfg.Location, false)
SetEntityHeading(drillSpawn, drillcfg.Heading)
local drillOptions = {
  {
      name = 'ox:option1',
      icon = 'fa-regular fa-gem',
      label = 'Open Gemrock',
      onSelect = function()
        if isBreakdown then return end 
        isBreakdown = true
        TriggerServerEvent("mining:gemBreakdown")
      end 
  }
}
Target:addLocalEntity(drillSpawn, drillOptions)

RegisterNetEvent("mining:drillCircle", function()
  if lib.progressCircle({
    duration = Config.Drill[1].Time,
    label = 'Opening Gem Rock',
    disable = {move = true},
    position = 'bottom',
    anim = {
        dict = 'amb@prop_human_parking_meter@male@idle_a',
        clip = 'idle_a'
    },
    prop = {},
  }) 
  then 
    isBreakdown = false
    TriggerServerEvent("mining:gemReward")
    local cfg = Config.Notifications[1]
    lib.notify(cfg.GemBreakSuccess)
  end
end)

--! Process spawn + target options
local cfg = Config.Process[1]
Target:addSphereZone({
  coords = cfg.ProcessLocation,
  radius = 1,
  debug = drawZones,
  options = {
      {
        name = 'ox:option1',
        icon = 'fa-solid fa-mortar-pestle',
        label = 'Process Dirt',
        onSelect = function()
          local input = Input(cfg.Name, cfg.Input)

          if not input then
            return 
          else 
            if isProcess then return end 
            isProcess = true
            TriggerServerEvent("mining:Process", input)
          end 
         end
      }
  }
})

RegisterNetEvent("mining:processCircle", function(input, gemRocks)
  if lib.progressCircle({
    duration = Config.Process[1].Time,
    label = 'Cleaning Dirt',
    disable = {move = true},
    position = 'bottom',
    anim = {
      dict = 'anim@amb@business@coc@coc_unpack_cut@',
      clip = 'fullcut_cycle_v1_cokecutter'
    },
    prop = {},
  }) 
  then 
    isProcess = false
    TriggerServerEvent("mining:processReward", input, gemRocks)
    local cfg = Config.Notifications[1]
    lib.notify(cfg.ProcessSuccessReward)
  end
end)

--! Mining
function CreateRock(coords)
  local rock = CreateObject(GetHashKey('prop_rock_1_d'), coords, false)
  SetEntityHeading(rock, math.random(1,360) + 0.0)
  FreezeEntityPosition(rock, true)
end 

for i = 1, #(Config.Zones[1].Location) do
  coords = Config.Zones[1].Location[i]
  CreateRock(coords)
end 

local rockOptions = {{
  name = 'ox:option1',
  icon = 'fa-solid fa-hammer',
  label = 'Mine Rock',
  onSelect = function(data)
    if isMining then return end 
    isMining = true
    TriggerServerEvent("mining:mineRock", data)
  end 
}}
local rockNames = {'prop_rock_1_d'}
Target:addModel(rockNames, rockOptions)

RegisterNetEvent("mining:progressBar", function(time, reward, data, animation,props)
  if lib.progressCircle({
    duration = time,
    label = 'Mining Rock',
    disable = {move = true},
    position = 'bottom',
    anim = animation,
    prop = props,
  }) 
  then 
    isMining = false
    local coords = GetEntityCoords(data.entity)
    TriggerServerEvent("mining:Reward", reward)
    DeleteEntity(data.entity)
    Wait(Config.Mining[4].RespawnTime)
    CreateRock(coords) 
  end
end)

RegisterNetEvent('dom_mining:ResetisMining', function()
  isMining = false
end)

RegisterNetEvent('dom_mining:ResetisProcess', function()
  isProcess = false
end)

RegisterNetEvent('dom_mining:ResetisBreakdown', function()
  isBreakdown = false
end)

--! Distance check for NPC
Citizen.CreateThread(function()
  while true do
    local wait = 1000
    local ped = PlayerPedId() 
    local pcoords = GetEntityCoords(ped)
    for i=1, 1 do 
      local cfg = Config.Exchange[i]
      local coords = vector3(cfg.Location)
      local dist = #(pcoords - coords)
      local npc = GetLocalNPC(i)
      if dist < cfg.RenderDistance then 
        if (GetLocalNPC(i) == nill) then 
          CreateLocalNPC(i)
        end 
      else 
        DestroyLocalNPC(i)
      end 
    end
    Wait(wait)
  end
end)