ADDING NEW TEAMS
Add new teams to the sh_newteams.lua file
New factions will be added like this
FACTION:AddFaction({
	id = 4, --Keep this unique
	name = "Conglomerate", --Name of faction
	tag = "CON", --Soon this will be shown in front of your name
	parent = 0 --ID of faction that controls this faction, 0 for none
})

New ranks:
FACTION:AddRank({
	id = 2, --Unique again
	name = "Police", --Name
	public = false, --Can anyone join this rank or does someone need to set you to it?
	level = 1, --How far up the ladder this rank it
	controlLevel = 1, --Basicly the highest level this rank can promote other people to, ignored for admins
	job = j, --A dark rp job, added in the normal way
	minTime = 120, --The minimum time you must have been at your last rank to rankup
	faction = 2 --The faction this rank is a part of
})

Using:
Everything should be semi-automatic, but if anyone tries to rank someone else up and they are not admin, it won't work for the moment... working on validation step