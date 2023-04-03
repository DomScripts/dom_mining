Config = {}

Config.Blip = {
    Toggle = true,
    Location = vec3(2707.3708, 2776.7751, 36.8780),
    Scale = 1.0,
    Color = 47,
}

Config.Drill = {
    {
        DrillModel = 'gr_prop_gr_speeddrill_01b',
        Location = vec3(1073.5166, -1988.4132, 29.9101),
        Time = 10000,
        Heading = (57.1677),
        Reward = {
            'ruby',
            'sapphire',
            'emerald',
            'diamond'
        },
    },
}

Config.Exchange = {
    {
        NPCModel = 's_m_y_construct_01',
        Location =  vec4(2707.3708, 2776.7751, 36.8780, 30.0116),
        RenderDistance = 60.0,
    }
}

Config.Process = {
    {
        ProcessLocation = vec3(2655.0359, 2811.4021, 34.4200),
        Time = 5000, -- Amount of time it takes to process
        GiveGemRock = 5, -- Every x dirt processed gives a gem rock
        Name = "Process Dirt",
        ItemToProcess = 'full_bucket',
        Input = {
            { 
                type = "select", 
                label = "Select a meterial to process", 
                options = {
                -- Value = item to give / Label = display name
                {value = 'copper', label = 'Copper'},
                {value = 'iron', label = 'Iron'},
                {value = 'gold', label = 'Gold'},
                }
            },
            { 
                type = "number", 
                label = "Amount", 
                placeholder = "123"
            },
        },
    }
}

Config.Zones = {
    {
        Location = {
            vec3(2943.863, 2773.906, 39.259-1.5),
            vec3(2940.451, 2783.27, 39.613-1.5),
            vec3(2944.974, 2789.283, 40.259-1.5),
            vec3(2935.218, 2790.404, 40.156-1.5),
            vec3(2942.249, 2797.15, 40.73-1.5),
            vec3(2955.274, 2778.396, 40.238-1.5),
            vec3(2955.117, 2787.838, 41.448-1.5)
        }
    }
}

Config.Mining = {
    {
        --Jackhammer
        Time = 5000,
        MinReward = 10,
        MaxReward = 15,
    },
    {
        --Pickaxe
        Time = 10000,
        MinReward = 5,
        MaxReward = 10,
    },
    {
        --Shovel
        Time = 15000,
        MinReward = 1,
        MaxReward = 5,
    },
    {
        RespawnTime = math.random(5000,15000), -- How long it takes for the rock to respawn
    }
}

Config.Notifications = {
    {
        -- Notification when you try to mine and don't have any tools
        MineNoTools = {
            title = 'Mining',
            description = 'You don\'t have any tools to use.',
            type = 'error',
            position = 'top-right'
        },
        -- Notification when you try to mine and don't have enough empty buckets
        MineNotEnoughBuckets = {
            title = 'Mining',
            description = 'You don\'t have enough buckets.',
            type = 'error',
            position = 'top-right'
        },
        --Notification when you try to mine and don't have enough space in inventory
        MineNotEnoughSpace = {
            title = 'Mining',
            description = 'You don\'t have enough space to mine.',
            type = 'error',
            position = 'top-right'
        },
        -- Notification when dirt process is successful
        ProcessSuccessReward = {
            title = 'Dirt Process',
            description = 'Successfully processed your dirt',
            type = 'success',
            position = 'top-right'
        },
        --Notification when you don't have any dirt to process
        ProcessNoDirt = {
            title = 'Dirt Process',
            description = 'You don\'t have enough dirt',
            type = 'error',
            position = 'top-right'
        },
        -- Notification when you successfully break open a gem
        GemBreakSuccess = {
            title = 'Gem Rock Drill',
            description = 'Successfully broken the rock apart',
            type = 'success',
            position = 'top-right'
        },
        --Notification when you try to open a rock and don't have enought space in inventory
        GemNotEnoughSpace = {
            title = 'Gem Rock Drill',
            description = 'Not enough room to carry gems',
            type = 'error',
            position = 'top-right'
        },
        -- Notification when you don't have a rock to break open but try
        GemNoRock = {
            title = 'Gem Rock Drill',
            description = 'You don\'t have any rocks to break open',
            type = 'error',
            position = 'top-right'
        }
    }
}