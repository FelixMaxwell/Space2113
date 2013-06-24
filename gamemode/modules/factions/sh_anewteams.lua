FACTION:AddFaction({
	id = 1,
	name = "Test1",
	tag = "T1",
	parent = 0
})

FACTION:AddFaction({
	id = 2,
	name = "Test2",
	tag = "T2",
	parent = 0
})

FACTION:AddRank({
	id = 1,
	name = "Example",
	public = true,
	level = 1,
	controlLevel = 1,
	job = AddExtraTeam("Example", {
		color = Color( 255, 0, 0, 255 ),
		model = { "models/player/Group03/Female01.mdl" },
		description = [[ Testing ]],
		weapon = {"weapon_p2282"},
		command = "",
		max = 3,
		salary = 45,
		NeedToChangeFrom = nil,
		help = "HELP AND SHIT",
		customCheck = function(ply) return true end,
		CustomCheckFailMsg = "Hi",
		modelScale = 1.2,
		maxpocket = 20,
		maps = nil,
		candemote = false,
		
		CanPlayerSuicide = function(ply) return false end,
        PlayerCanPickupWeapon = function(ply, weapon) return true end,
        PlayerDeath = function(ply, weapon, killer) end,
        PlayerLoadout = function(ply) return true end,
        PlayerSelectSpawn = function(ply, spawn) end,
        PlayerSetModel = function(ply) return "models/player/Group03/Female_02.mdl" end,
        PlayerSpawn = function(ply) end,
        PlayerSpawnProp = function(ply, model) end,
        RequiresVote = function(ply, job) for k,v in pairs(player.GetAll()) do if IsValid(v) and v:IsAdmin() then return false end end return true end,
        ShowSpare1 = function(ply) end,
        ShowSpare2 = function(ply) end
	}),
	minTime = 0,
	faction = 1
})

FACTION:AddRank({
	id = 2,
	name = "Example2",
	public = true,
	level = 1,
	controlLevel = 1,
	job = AddExtraTeam("Example2", {
		color = Color( 255, 0, 0, 255 ),
		model = { "models/player/Group03/Female02.mdl" },
		description = [[ Testing ]],
		weapon = {"weapon_p2282"},
		command = "",
		max = 3,
		salary = 45,
		NeedToChangeFrom = nil,
		help = "HELP AND SHIT",
		customCheck = function(ply) return true end,
		CustomCheckFailMsg = "Hi",
		modelScale = 1.2,
		maxpocket = 20,
		maps = nil,
		candemote = false,
		
		CanPlayerSuicide = function(ply) return false end,
        PlayerCanPickupWeapon = function(ply, weapon) return true end,
        PlayerDeath = function(ply, weapon, killer) end,
        PlayerLoadout = function(ply) return true end,
        PlayerSelectSpawn = function(ply, spawn) end,
        PlayerSetModel = function(ply) return "models/player/Group03/Female_02.mdl" end,
        PlayerSpawn = function(ply) end,
        PlayerSpawnProp = function(ply, model) end,
        RequiresVote = function(ply, job) for k,v in pairs(player.GetAll()) do if IsValid(v) and v:IsAdmin() then return false end end return true end,
        ShowSpare1 = function(ply) end,
        ShowSpare2 = function(ply) end
	}),
	minTime = 0,
	faction = 1
})

FACTION:AddRank({
	id = 3,
	name = "Example3",
	public = true,
	level = 1,
	controlLevel = 1,
	job = AddExtraTeam("Example3", {
		color = Color( 255, 0, 0, 255 ),
		model = { "models/player/Group03/Female01.mdl" },
		description = [[ Testing ]],
		weapon = {"weapon_p2282"},
		command = "",
		max = 3,
		salary = 45,
		NeedToChangeFrom = nil,
		help = "HELP AND SHIT",
		customCheck = function(ply) return true end,
		CustomCheckFailMsg = "Hi",
		modelScale = 1.2,
		maxpocket = 20,
		maps = nil,
		candemote = false,
		
		CanPlayerSuicide = function(ply) return false end,
        PlayerCanPickupWeapon = function(ply, weapon) return true end,
        PlayerDeath = function(ply, weapon, killer) end,
        PlayerLoadout = function(ply) return true end,
        PlayerSelectSpawn = function(ply, spawn) end,
        PlayerSetModel = function(ply) return "models/player/Group03/Female_02.mdl" end,
        PlayerSpawn = function(ply) end,
        PlayerSpawnProp = function(ply, model) end,
        RequiresVote = function(ply, job) for k,v in pairs(player.GetAll()) do if IsValid(v) and v:IsAdmin() then return false end end return true end,
        ShowSpare1 = function(ply) end,
        ShowSpare2 = function(ply) end
	}),
	minTime = 0,
	faction = 2
})