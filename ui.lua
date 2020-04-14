--[[
	Sling Hoops
]]--

ui = {}

ui.Registry = {}
ui.Panels = {}

ui.Override = {
		Press = false,
		AmPressed = false,
		CurrentlyPressed = false
	}


function ui.PanelExists(typ)
	return ui.Registry[typ] and true or false;
end

function ui.Register(name, pnl)
	local reg = {}
	if name ~= "Base" then
		for k, v in pairs(ui.Registry["Base"]) do
			reg[k] = v;
		end
	end
	for k, v in pairs(pnl) do
		reg[k] = v;
	end
	ui.Registry[name]  = reg;
end

function ui.CreatePanel(name, parent)
	if( ui.PanelExists(name) ) then
		local pnl = {}
		for k, v in pairs(ui.Registry[name]) do
			pnl[k] = v;
		end
		pnl:Init();
		if parent then
			pnl.Parent = parent;
			pnl.Visible = parent.Visible;
			table.insert(parent.Children, pnl);
		end
		if not parent then
			table.insert(ui.Panels, pnl);
		end
		return pnl;
	end
end

function ui.RemovePanel(pnl)
	for i = 1, #ui.Panels do
		if( ui.Panels[i] == pnl ) then
			table.remove(ui.Panels, i);
		end
	end
end

function ui.Update(dt)
	for i = 1, #ui.Panels do
		if( ui.Panels[i].Visible ) then
			ui.Panels[i]:Think(dt)
			ui.Panels[i]:_Think(dt)
		end
	end
end

function ui.Draw()
	for i = 1, #ui.Panels do
		if( ui.Panels[i].Visible ) then
			ui.Panels[i]:Draw();
			ui.Panels[i]:_Draw();
		end
	end
end

function ui.Pressed(x, y, button, istouch, presses)
	if not( ui.Override.AmPressed ) then
		local innerPanel = false;
		for i = 1, #ui.Panels do
			if(	ui.Panels[i]:IsInside(x, y) and ui.Panels[i].Visible ) then
				innerPanel = ui.Panels[i]:GetInsidePanelRecurring(x, y);
			end
		end
		if( innerPanel ) then
			ui.Override.Press = true;
			ui.Override.AmPressed = true;
			ui.Override.CurrentlyPressed = innerPanel;
			innerPanel:OnPress()
		end
	end
end
	

function ui.Released( x, y, button, istouch, presses )
	if( ui.Override.AmPressed ) then
		local innerPanel = false;
		for i = 1, #ui.Panels do
			if(	ui.Panels[i]:IsInside(x, y) and ui.Panels[i].Visible ) then
				innerPanel = ui.Panels[i]:GetInsidePanelRecurring(x, y);
			end
		end

		if( innerPanel and innerPanel == ui.Override.CurrentlyPressed ) then
			innerPanel:OnRelease();
			ui.Override.CurrentlyPressed = false;
		elseif( ui.Override.CurrentlyPressed ) then
			ui.Override.CurrentlyPressed:OnReleaseNoFunction();
			ui.Override.CurrentlyPressed = false;
		end
		ui.Override.Press = false;
		ui.Override.AmPressed = false;
	--[[	if( innerPanel ) then
			ui.Override.Press = false;
			ui.Override.AmPressed = false;
			if( innerPanel == ui.Override.CurrentlyPressed ) then
				innerPanel:OnRelease()
				ui.Override.CurrentlyPressed = false;
			else
				ui.Override.CurrentlyPressed:OnReleaseNoFunction()
				ui.Override.CurrentlyPressed = false;
			end
		else
			ui.Override.Press = false;
			ui.Override.AmPressed = false;
			if( ui.Override.CurrentlyPressed ) then
				ui.Override.CurrentlyPressed:OnReleaseNoFunction()
				ui.Override.CurrentlyPressed = false;
			end
		end--]]
	end
end
