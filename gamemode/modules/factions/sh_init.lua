FACTION = {}
FACTION.Factions = {}
FACTION.Ranks = {}

function FACTION:AddFaction( data )
	FACTION.Factions[data.id] = {}
	local f = FACTION.Factions[data["id"]]
	f.id = data.id
	f.name = data.name
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