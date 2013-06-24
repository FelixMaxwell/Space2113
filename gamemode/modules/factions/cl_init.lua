FACTION.FactionHelpText = {"Factions are the governing bodies of this world",
"Each faction has a tab for its ranks",
"Some factions are controled by other factions",
"When you first start you are part of the civilian faction",
"You can change to any other faction's ranks that are public",
"You can also change amongst ranks that are at the same level as yours is",
"However, you cannot change to higher ranks on your own",
"In order to rank up you must have someone of a higher rank than you rank you up",
"Some ranks have a minimum time that you must have been at your last rank before they allow you to rank up",
"When you select a rank, you will be given a list of players",
"Any player you select will be given a request to change their rank, if all the conditions have been met",
"Do not spam other players with rank requests",
"Admins can set your rank without asking",
"Ask Felix if you have any other questions"}

function FACTION:InitPlayer()
	LocalPlayer():ConCommand( "faction_load" )
end
hook.Add( "InitPostEntity", "FACTION:InitPlayer", FACTION.InitPlayer );

timer.Create( "factions_save_player_data", 60, 0, function() LocalPlayer():ConCommand( "faction_save" ) print( "[Factions] Saved!" ) end )

function FACTION:CreateFactionTab( faction )
	local hordiv = vgui.Create("DHorizontalDivider")
	hordiv:SetLeftWidth(390)
	function hordiv.m_DragBar:OnMousePressed() end
	hordiv.m_DragBar:SetCursor("none")
	local Panel
	local Information
	function hordiv:Update()
		if Panel and Panel:IsValid() then
			Panel:Remove()
		end
		Panel = vgui.Create("DPanelList")
		Panel:SetSize(390, 540)
		Panel:EnableHorizontal( true )
		Panel:EnableVerticalScrollbar( true )
		Panel:SetSkin(GAMEMODE.Config.DarkRPSkin)


		local Info = {}
		local model
		local modelpanel
		local function UpdateInfo(a)
			if Information and Information:IsValid() then
				Information:Remove()
			end
			Information = vgui.Create("DPanelList")
			Information:SetPos(378,0)
			Information:SetSize(370, 540)
			Information:SetSpacing(10)
			Information:EnableHorizontal( false )
			Information:EnableVerticalScrollbar( true )
			Information:SetSkin(GAMEMODE.Config.DarkRPSkin)
			function Information:Rebuild() -- YES IM OVERRIDING IT AND CHANGING ONLY ONE LINE BUT I HAVE A FUCKING GOOD REASON TO DO IT!
				local Offset = 0
				if ( self.Horizontal ) then
					local x, y = self.Padding, self.Padding;
					for k, panel in pairs( self.Items ) do
						local w = panel:GetWide()
						local h = panel:GetTall()
						if ( x + w  > self:GetWide() ) then
							x = self.Padding
							y = y + h + self.Spacing
						end
						panel:SetPos( x, y )
						x = x + w + self.Spacing
						Offset = y + h + self.Spacing
					end
				else
					for k, panel in pairs( self.Items ) do
						if not panel:IsValid() then return end
						panel:SetSize( self:GetCanvas():GetWide() - self.Padding * 2, panel:GetTall() )
						panel:SetPos( self.Padding, self.Padding + Offset )
						panel:InvalidateLayout( true )
						Offset = Offset + panel:GetTall() + self.Spacing
					end
					Offset = Offset + self.Padding
				end
				self:GetCanvas():SetTall( Offset + (self.Padding) - self.Spacing )
			end

			if type(Info) == "table" and #Info > 0 then
				for k,v in ipairs(Info) do
					local label = vgui.Create("DLabel")
					label:SetText(v)
					label:SizeToContents()
					if label:IsValid() then
						Information:AddItem(label)
					end
				end
			end

			if model and type(model) == "string" and a ~= false then
				modelpanel = vgui.Create("DModelPanel")
				modelpanel:SetModel(model)
				modelpanel:SetSize(90,230)
				modelpanel:SetAnimated(true)
				modelpanel:SetFOV(90)
				modelpanel:SetAnimSpeed(1)
				if modelpanel:IsValid() then
					Information:AddItem(modelpanel)
				end
			end
			hordiv:SetLeft(Panel)
			hordiv:SetRight(Information)
		end
		UpdateInfo()
		local function AddRankToMenu( Model, name, description, Weapons, command, otherInfo )
			local icon = vgui.Create("SpawnIcon")
			local IconModel = Model[1]
			icon:SetModel(IconModel)

			icon:SetSize(128, 128)
			icon:SetToolTip()
			icon.OnCursorEntered = function()
				icon.PaintOverOld = icon.PaintOver
				icon.PaintOver = icon.PaintOverHovered
				Info[1] = name
				Info[2] = description
				if Weapons ~= nil then 
					for k, v in pairs( Weapons ) do
						table.insert( Info, v )
					end
				end
				if otherInfo ~= nil then
					for k, v in pairs( otherInfo ) do
						table.insert( Info, v )
					end
				end
				model = IconModel
				UpdateInfo()
			end
			icon.OnCursorExited = function()
				if ( icon.PaintOver == icon.PaintOverHovered ) then
					icon.PaintOver = icon.PaintOverOld
				end
				Info = {}
				if modelpanel and modelpanel:IsValid() and icon:IsValid() then
					modelpanel:Remove()
					UpdateInfo(false)
				end
			end

			icon.DoClick = function()
				hordiv:GetParent():GetParent():GetParent():Close()
				local target = vgui.Create( "DFrame" )
				target:SetTitle( "Select a target" )
				target:SetVisible( true )
				target:SetPos( ScrW()/2-100, ScrH()/2-50 )
				target:SetSize( 200, 100 ) 
				target:SetSkin(GAMEMODE.Config.DarkRPSkin)
				target:MakePopup()
				
				local playerBox = vgui.Create( "DComboBox", target )
				playerBox:SetPos( 50, 40 )
				playerBox:SetSize( 100, 20 )
				local playerID = {}
				for k, v in pairs( player.GetHumans() ) do
					playerBox:AddChoice( v:Nick() )
					playerID[v:Nick()] = v
				end
				
				local selectButton = vgui.Create( "DButton", target )
				selectButton:SetText( "Select" )
				selectButton:SetSize( 100, 20 )
				selectButton:SetPos( 50, 70 )
				selectButton.DoClick = function ()
					LocalPlayer():ConCommand( "faction_setrank 1 "..command )
					target:Close()
				end
			end

			if icon:IsValid() then
				Panel:AddItem(icon)
			end
		end
		
		for k, v in pairs(FACTION.Factions[faction].ranks) do
			local rank = FACTION.Ranks[v]
			local job = RPExtraTeams[rank.job]
			local extraText = {}
			extraText[1] = "Minimum time: " .. rank.minTime
			if rank then extraText[2] = "Public: True" else extraText[2] = "Public: False" end
			extraText[3] = "Level: " .. rank.level
			AddRankToMenu( job.model, rank.name, job.description, job.weapons, rank.id, extraText )
		end
	end
	hordiv:Update()
	return hordiv
end

function FACTION:CreateFactionMenu()
	local root = vgui.Create( "DPropertySheet" )
	root:SetPos( 5, 30 )
	root:SetSize( 390, 540 )
	
	for k, v in pairs(FACTION.Factions) do
		root:AddSheet( v.name, FACTION:CreateFactionTab( v.id ), "gui/silkicons/user", false, false, v.name )
	end
	
	local help = vgui.Create( "DPanelList" )
	help:SetSpacing( 10 )
	help:EnableHorizontal( false )
	help:EnableVerticalScrollbar( true )
	help:SetSkin( GAMEMODE.Config.DarkRPSkin )
	for k, v in pairs( FACTION.FactionHelpText ) do
		local label = vgui.Create( "DLabel" )
		label:SetText( v )
		label:SizeToContents()
		if label:IsValid() then
			help:AddItem( label )
		end
	end
	root:AddSheet( "Help", help, "gui/silkicons/help", false, false, "Help for the Faction system" )
	
	return root
end

hook.Add( "F4MenuTabs", "factions_menutab", function()
	local tab = GAMEMODE:addF4MenuTab("Faction Menu", FACTION:CreateFactionMenu(), "icon16/user_suit.png")
	GAMEMODE:removeTab( 2 )
	GAMEMODE:switchTabOrder( tab, 2 )
end )

function FACTION:ValidateMenu( setPly, rank, key )
	local root = vgui.Create( "DFrame" )
	root:SetTitle( "Rank Change" )
	root:SetVisible( true )
	root:SetPos( ScrW()/2-300, 20 )
	root:SetSize( 600, 100 ) 
	root:SetSkin(GAMEMODE.Config.DarkRPSkin)
	root:MakePopup()
	
	local panel = vgui.Create( "DPanelList", root )
	panel:SetPos( 10, 30 )
	panel:SetSize( 580, 60 )
	
	local label = vgui.Create( "DLabel" )
	label:SetText( setPly:Name() .. " wants to set your rank to " .. FACTION.Ranks[rank].name .. ", allow?" )
	label:SizeToContents()
	panel:AddItem( label )
	
	local yes = vgui.Create( "DButton" )
	yes:SetText( "Yes" )
	yes.DoClick = function ()
		LocalPlayer():ConCommand( "faction_validate " .. key )
		root:Close()
	end
	panel:AddItem( yes )
	
	local no = vgui.Create( "DButton" )
	no:SetText( "No" )
	no.DoClick = function ()
		root:Close()
	end
	panel:AddItem( no )
end
net.Receive( "faction_validate", function( len, pl )
	local t = net.ReadTable()
	FACTION:ValidateMenu( t["player"], t["rank"], t["key"] )
end)