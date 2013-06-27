FACTION:AddFaction({
	id = 1,
	name = "Example",
	parent = 0
})

FACTION:AddRank({
	id = 1,
	name = "Example",
	public = true,
	level = 1,
	controlLevel = 1,
	job = AddExtraTeam("Example team", {
        color = Color(255, 255, 255, 255),
        model = {
                "models/player/Group03/Female_01.mdl",
                "models/player/Group03/Female_02.mdl"
                },
        description = [[This text will serve as the description of
                this team.]],
        weapons = {"weapon_p2282"},
        command = "example",
        max = 3,
        salary = 45,
        admin = 0,
        vote = false,
        hasLicense = false,
        NeedToChangeFrom = nil,
        help = "You are an example. Walk around and be exemplary.",
        customCheck = function(ply) return true end,
        CustomCheckFailMsg = "",
        modelScale = 1.2,
        maxpocket = 20,
        maps = {"rp_downtown_v2", "gm_construct"},
        candemote = false,

        CanPlayerSuicide = function(ply) return true end,
        PlayerCanPickupWeapon = function(ply, weapon) return true end,
        PlayerDeath = function(ply, weapon, killer) end,
        PlayerLoadout = function(ply) return true end,
        PlayerSelectSpawn = function(ply, spawn) end,
        PlayerSetModel = function(ply) return "models/player/Group03/Female_02.mdl" end,
        PlayerSpawn = function(ply) end,
        PlayerSpawnProp = function(ply, model) end,
        RequiresVote = function(ply, job) for k,v in pairs(player.GetAll()) do if IsValid(v) and v:IsAdmin() then return false end end return true end, -- People need to make a vote when there is no admin around
        ShowSpare1 = function(ply) end,
        ShowSpare2 = function(ply) end
	}),
	minTime = 0,
	faction = 1
})


FACTION:AddRank({
	id = 2,
	name = "Example",
	public = true,
	level = 1,
	controlLevel = 1,
	job = AddExtraTeam("Example team", {
        color = Color(255, 255, 255, 255),
        model = {
                "models/player/Group03/Male_01.mdl",
                "models/player/Group03/Male_02.mdl"
                },
        description = [[This text will serve as the description of
                this team.]],
        weapons = {"weapon_p2282"},
        command = "example",
        max = 3,
        salary = 45,
        admin = 0,
        vote = false,
        hasLicense = false,
        NeedToChangeFrom = nil,
        help = "You are an example. Walk around and be exemplary.",
        customCheck = function(ply) return true end,
        CustomCheckFailMsg = "",
        modelScale = 1.2,
        maxpocket = 20,
        maps = {"rp_downtown_v2", "gm_construct"},
        candemote = false,

        CanPlayerSuicide = function(ply) return true end,
        PlayerCanPickupWeapon = function(ply, weapon) return true end,
        PlayerDeath = function(ply, weapon, killer) end,
        PlayerLoadout = function(ply) return true end,
        PlayerSelectSpawn = function(ply, spawn) end,
        PlayerSetModel = function(ply) return "models/player/Group03/Female_02.mdl" end,
        PlayerSpawn = function(ply) end,
        PlayerSpawnProp = function(ply, model) end,
        RequiresVote = function(ply, job) for k,v in pairs(player.GetAll()) do if IsValid(v) and v:IsAdmin() then return false end end return true end, -- People need to make a vote when there is no admin around
        ShowSpare1 = function(ply) end,
        ShowSpare2 = function(ply) end
	}),
	minTime = 0,
	faction = 1
})