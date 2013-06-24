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
					if type(v) == "table" then
						for k1,v1 in pairs(v) do
							local label = vgui.Create("DLabel")
							label:SetText(v1)
							label:SizeToContents()
							if label:IsValid() then
								Information:AddItem(label)
							end
						end
					else
						local label = vgui.Create("DLabel")
						label:SetText(v)
						label:SizeToContents()
						if label:IsValid() then
							Information:AddItem(label)
						end
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
		local function AddRankToMenu( Model, name, description, Weapons, command )
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
				Info[3] = Weapons
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
			AddRankToMenu( job.model, rank.name, job.description, job.weapons, rank.id )
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
	
	local help = vgui.Create( "DPanel" )
	root:AddSheet( "Help", help, "gui/silkicons/help", false, false, "Help for the Faction system" )
	
	return root
end

hook.Add( "F4MenuTabs", "factions_menutab", function()
	local tab = GAMEMODE:addF4MenuTab("Faction Menu", FACTION:CreateFactionMenu(), "icon16/user_suit.png")
	GAMEMODE:removeTab( 2 )
	GAMEMODE:switchTabOrder( tab, 2 )
end )