FACTION.DBReady = false
FACTION.DefaultFaction = 1
FACTION.DefaultRank = 1
FACTION.ClearDBPassword = "apple" --TODO: Remove this

--DB SECTION--

function FACTION:Init()
	Msg("\n---Factions---\n[DB Init]\n")
	Msg("Checking Table 'factions'... ")
	if sql.TableExists( "factions" ) then
		Msg("Table Exists.\n")
		FACTION.DBReady = true
	else
		Msg("Creating Table... ")
		sql.Query( [[
			CREATE TABLE factions (
				id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
				uid BIGINT NOT NULL,
				cid INTEGER NOT NULL DEFAULT 1,
				factionid INTEGER NOT NULL,
				rankid INTEGER NOT NULL,
				timeOnServer BIGINT NOT NULL DEFAULT 0,
				timeInFaction BIGINT NOT NULL DEFAULT 0,
				timeAtRank BIGINT NOT NULL DEFAULT 0
			);
		]])
		if sql.TableExists("factions") then
			Msg("Table Created Successfully.\n")
			FACTION.DBReady = true
		else
			Msg("Failed to create table\nError: " .. sql.LastError() .. "\n")
		end
	end
	print( "Online: ", FACTION.DBReady )
	Msg("------END-----\n\n")
end
hook.Add( "Initialize", "FACTION:InitDB", FACTION.Init );

function FACTION:CharacterExists( uid, cid )
	if not FACTION.DBReady then print("[Factions] Tried to access to an uninitialized database!") return end
	local ret = sql.Query( [[SELECT id FROM factions WHERE uid = ]]..uid..[[ AND cid = ]]..cid..[[;]])
	if ret == nil then return false
	elseif ret == false then print("[Factions] DB Error: "..sql.LastError()) return false
	else return true end
end

function FACTION:CreateCharacterRow( uid, cid )
	if not FACTION.DBReady then print("[Factions] Tried to access to an uninitialized database!") return end
	if FACTION:CharacterExists( uid, cid ) then return true end
	local result = sql.Query([[INSERT INTO factions (uid, cid, factionid, rankid) VALUES(
		]]..uid..[[,
		]]..cid..[[,
		]]..FACTION.DefaultFaction..[[,
		]]..FACTION.DefaultRank..[[
		);
	]])
	if result == nil then return false
	elseif ret == false then print("[Factions] DB Error: "..sql.LastError()) return false
	else return true end
end

function FACTION:SaveCharacterData( uid, cid, data )
	if not FACTION:CharacterExists( uid, cid ) then FACTION:CreateCharacterRow( uid, cid ) end
	if not FACTION.DBReady then print("[Factions] Tried to access to an uninitialized database!") return end
	local ret = sql.Query( [[
		UPDATE factions SET
		factionid = ]]..data.factionid..[[,
		rankid = ]]..data.rankid..[[,
		timeOnServer = ]]..data.timeOnServer..[[,
		timeInFaction = ]]..data.timeInFaction..[[,
		timeAtRank = ]]..data.timeAtRank..[[
		WHERE uid = ]]..uid..[[ AND cid = ]]..cid..[[;
	]] )
	if ret == false then print("[Factions] DB Error: "..sql.LastError()) return false
	else return true end
end

function FACTION:LoadCharacterData( uid, cid )
	if not FACTION.DBReady then print("[Factions] Tried to access to an uninitialized database!") return end
	local ret = sql.QueryRow( [[SELECT factionid, rankid, timeOnServer, timeInFaction, timeAtRank FROM factions WHERE uid = ]]..uid..[[ AND cid = ]]..cid..[[;]])
	if ret == nil then return false
	elseif ret == false then print("[Factions] DB Error: "..sql.LastError()) return false
	else
		return ret
	end
end

function FACTION:CreateCharacterTable( factionid, rankid, tos, tif, tar )
	local t = {}
	t.factionid = factionid
	t.rankid = rankid
	t.timeOnServer = tos
	t.timeInFaction = tif
	t.timeAtRank = tar
	return t
end

function FACTION:DisplayCharacterData( ply, cmd, a )
	if a == nil then return end
	local args = string.Explode( " ", a )
	PrintTable( FACTION:LoadCharacterData( args[1], args[2] ) )
end
concommand.Add( "faction_dcd", FACTION.DisplayCharacterData )

function FACTION:SaveCharacterConsole( ply, cmd, a )
	if a == nil then return end
	local args = string.Explode( " ", a )
	FACTION:SaveCharacterData( args[1], args[2], FACTION:CreateCharacterTable( args[3], args[4], args[5], args[6], args[7] ) )
end
concommand.Add( "faction_scc", FACTION.SaveCharacterConsole )

function FACTION:DisplayAllCharacters( ply, cmd, a )
	if not FACTION.DBReady then print("[Factions] Tried to access to an uninitialized database!") return end
	local ret = sql.Query( "SELECT * FROM factions" )
	if ret == nil then return
	elseif ret == false then print("DB Error: " .. sql.LastError() )
	else PrintTable( ret ) end
end
concommand.Add( "faction_dispAll", FACTION.DisplayAllCharacters )

--TODO: Remove this
function FACTION:ResetDB( ply, cmd, a )
	if a == nil then return end
	local args = string.Explode( " ", a )
	if args[1] == FACTION.ClearDBPassword then
		print( "Dropping factions Table" )
		sql.Query( "DROP TABLE factions" )
		FACTION:Init()
	end
end
concommand.Add( "faction_drp", FACTION.ResetDB )

--CHARACTER VARIABLES

function FACTION:UpdatePlayerTime( ply )
	local delta = os.difftime( os.time(), ply.FactionData.lastTime )
	ply.FactionData.lastTime = os.time()
	local fd = ply.FactionData
	fd.timeOnServer = fd.timeOnServer + delta
	fd.timeInFaction = fd.timeInFaction + delta
	fd.timeAtRank = fd.timeAtRank + delta
end

function FACTION:UpdatePlayerTimes()
	for k, v in pairs(player.GetHumans()) do
		local ply = ents.GetByIndex( k )
		if ply.FactionData == nil then FACTION:LoadPlayerData( ply )
		else FACTION:UpdatePlayerTime( ply ) end
	end
end
timer.Create( "factions_update_time", 5, 0, FACTION.UpdatePlayerTimes )

function FACTION:LoadPlayerData( ply )
	local id = ply:UniqueID()
	local save = true
	local char = nil
	if FACTION:CharacterExists( id, 1 ) then
		char = FACTION:LoadCharacterData( id, 1 )
		if char == false then 
			print("[Factions] Couldn't load Faction Data for player "..ply:Nick()..", giving defaults 1") 
			char = FACTION:CreateCharacterTable( FACTION.DefaultFaction, FACTION.DefaultRank, 0, 0, 0 )
			save = false
		end
	else
		char = FACTION:CreateCharacterRow( id, 1 )
		if char == false then
			print("[Factions] Couldn't create Faction Data for player "..ply:Nick()..", giving defaults 2")
			char = FACTION:CreateCharacterTable( FACTION.DefaultFaction, FACTION.DefaultRank, 0, 0, 0 )
			save = false
		else
			char = FACTION:CreateCharacterTable( FACTION.DefaultFaction, FACTION.DefaultRank, 0, 0, 0 )
		end
	end
	ply.FactionData = char
	ply.FactionData.save = save
	ply.FactionData.lastTime = os.time()
	print( "[Factions] Loaded Faction Data for player "..ply:Nick() )
end

local function LoadPlayerData( ply, cmd, a )
	FACTION:LoadPlayerData( ply )
end
concommand.Add( "faction_load", LoadPlayerData )

function FACTION:SavePlayerData( ply )
	if save == false then return false end
	local id = ply:UniqueID()
	local ret = FACTION:SaveCharacterData( id, 1, ply.FactionData )
	if ret == false then print( "[Factions] Failed to save Faction Data for player"..ply:Nick()) end
end

local function SavePlayerData( ply, cmd, a )
	FACTION:SavePlayerData( ply )
end
concommand.Add( "faction_save", SavePlayerData )

local function PrintPlayerData( ply, cmd, a )
	PrintTable( ply.FactionData )
end
concommand.Add( "faction_print", PrintPlayerData )

--Rank Shiz
FACTION.RankBuffer = {}

function FACTION:AttemptSetRank( attemptPly, changePly, rank )
	local set = false
	local force = false
	if attemptPly:IsAdmin() and not changePly:IsAdmin() then
		set = true
		force = true
	elseif attemptPly:IsSuperAdmin() then
		set = true
		force = true
	elseif FACTION:GetSuperParent( attemptPly.FactionData.factionid ) == FACTION:GetSuperParent( changePly.FactionData.factionid ) or FACTION.Ranks[rank].public then
		if FACTION.Ranks[tonumber( attemptPly.FactionData.rankid )].controlLevel >= FACTION.Ranks[tonumber( rank )].level then
			if changePly.FactionData.timeAtRank >= FACTION.Ranks[rank].minTime or FACTION.Ranks[changePly.FactionData.rankid].level >= FACTION.Ranks[ran].level then
				if FACTION.Ranks[tonumber( rank )].level <= FACTION.Ranks[tonumber( changePly.FactionData.rankid )].level + 1 then
					set = true
				end
			end
		end
	end
	if set then
		if force then
			FACTION:SetRank( changePly, rank )
		else
			local key = math.random(0,65535)
			FACTION.RankBuffer[key] = rank
			print( "Set rank key: "..key )
			timer.Simple( 600, function(key) table.remove( FACTION.RankBuffer, key ) end, key )
		end
	end
end

local function AttemptSetRank( ply, cmd, args )
	FACTION:AttemptSetRank( ply, player.GetByUniqueID(args[1]), tonumber( args[2] ) )
end
concommand.Add( "faction_setrank", AttemptSetRank )

function FACTION:SetRank( ply, rank )
	ply.FactionData.rankid = rank
	FACTION:SavePlayerData( ply )
	print( ply:Nick().."'s rank is now a "..FACTION.Ranks[ply.FactionData.rankid].name )
end

local function ValidateRank( ply, cmd, args )
	if FACTION.RankBuffer[tonumber(args[1])] ~= nil then
		FACTION:SetRank( ply, FACTION.RankBuffer[tonumber(args[1])] )
		table.remove( FACTION.RankBuffer, tonumber(args[1]) )
	end
end
concommand.Add( "faction_validate", ValidateRank )