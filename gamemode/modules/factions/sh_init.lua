FACTION = {}
FACTION.Factions = {}
FACTION.Ranks = {}

function FACTION:AddFaction( data )
	FACTION.Factions[data.id] = {}
	local f = FACTION.Factions[data["id"]]
	f.id = data.id
	f.name = data.name
	f.startRank = data.startRank
	f.recruit = data.recruit
	f.parent = data.parent
	f.ranks = {}
end

function FACTION:AddRank( data )
	FACTION.Ranks[data["id"]] = {}
	local r = FACTION.Ranks[data["id"]]
	r.id = data.id
	r.name = data.name
	r.public = data.public
	r.level = data.level
	r.controlLevel = data.controlLevel
	r.job = data.job
	r.minTime = data.minTime
	r.faction = data.faction
	table.insert(FACTION.Factions[r.faction].ranks, r.id)
end

function FACTION:GetFactionChain( id )
	local curID = id
	Msg("[Factions] Chain for "..FACTION.Factions[id].name..": ")
	while FACTION.Factions[curID].parent ~= 0 do
		Msg( FACTION.Factions[curID].name.."-" )
		curID = FACTION.Factions[curID].parent
	end
	Msg( FACTION.Factions[curID].name.."\n" )
end

function FACTION:GetSuperParent( id )
	local curID = tonumber( id )
	while FACTION.Factions[curID].parent ~= 0 do
		curID = FACTION.Factions[curID].parent
	end
	return curID
end

FACTION:AddFaction({ 
	id = 1, 
	name = "Civilians", 
	startRank = 1, 
	public = true, 
	parent = 2 
})
FACTION.Factions.Civilians = FACTION.Factions[1]

FACTION:AddFaction({
	id = 2,
	name = "Police",
	startRank = 1,
	public = false,
	parent = 3
})
FACTION.Factions.Police = FACTION.Factions[2]

FACTION:AddFaction({
	id = 3,
	name = "Alliance",
	startRank = 1,
	public = false,
	parent = 0
})
FACTION.Factions.Alliance = FACTION.Factions[3]

FACTION:AddFaction({
	id = 4,
	name = "Conglomerate",
	startRank = 1,
	public = false,
	parent = 0
})
FACTION.Factions.Conglomerate = FACTION.Factions[4]

FACTION:AddFaction({
	id = 5,
	name = "Federation",
	startRank = 1, 
	public = false,
	parent = 0
})
FACTION.Factions.Federation = FACTION.Factions[5]

local j = AddExtraTeam("Example team", {
        color = Color(255, 255, 255, 255),
        model = "models/player/Group03/Female_01.mdl",
        description = [[This text will serve as the description of
                this team.]],
        weapons = {"weapon_p2282"},
        command = "example",
        max = 3,
        salary = 45,
        admin = 0,
        vote = false,
        hasLicense = false,
        NeedToChangeFrom = TEAM_CITIZEN,
        help = "You are an example. Walk around and be exemplary.",
        customCheck = function(ply) return ply.DarkRPVars.money > 10000 end,
        CustomCheckFailMsg = "You don't have enough money!",
        modelScale = 1.2,
        maxpocket = 20,
        maps = {"rp_downtown_v2", "gm_construct"},
        candemote = false,

        CanPlayerSuicide = function(ply) return false end,
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
})

FACTION:AddRank({
	id = 1,
	name = "Citizen",
	public = true,
	level = 1,
	controlLevel = 1,
	job = j,
	minTime = 0,
	faction = 1
})

FACTION:AddRank({
	id = 2,
	name = "Police",
	public = false,
	level = 1,
	controlLevel = 1,
	job = j,
	minTime = 120,
	faction = 2
})