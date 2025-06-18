
-- saved variables
afkfullscreenDB = {};

-- local variables
local addon, ns = ...;
local L = ns.L;
ns.debugMode = "@project-version@"=="@".."project-version".."@";
LibStub("HizurosSharedTools").RegisterPrint(ns,addon,"AFK");

local media,ticker,demoticker = "Interface\\AddOns\\"..addon.."\\media\\";
local PlayerPositionFix = {
	{0,0.00,-0.08}, -- unknown
	{0,0.05,-0.10}, -- male
	{0,0.00,-0.10}, -- female
};
local demoKeys, keys = {},{};
local default = "SimpleBlack";
local ACD = LibStub("AceConfigDialog-3.0");
local LDB_Object,LDB = nil,LibStub("LibDataBroker-1.1");
local LDBI = LibStub("LibDBIcon-1.0", true);
local faction = UnitFactionGroup("player")
local LT = LibStub("LibTime-1.0");
ns.LSM = LibStub("LibSharedMedia-3.0")
local soundHandle,alertSoundTicker


-------------------------------------------------
-- misc local functions
-------------------------------------------------

local function IsCinematic()
	return IsInCinematicScene() or InCinematic() or CinematicFrame:IsVisible() or MovieFrame:IsVisible();
end

local function UnpackSkin(obj,isDemo)
	local t,k = {},keys;
	if isDemo then
		k=demoKeys;
	end

	if type(obj)=="string" then
		obj = {strsplit("|",obj)};
	end
	for i,v in ipairs(obj)do
		t[k[i][1]]={k[i][2],false};
		if v:find(HEADER_COLON) then
			local T={};
			for _,s in ipairs({strsplit(";",v)})do
				local K,V = strsplit(HEADER_COLON,s); T[K]=V;
			end
			t[k[i][1]] = {k[i][2],T};
		elseif v=="true" then
			t[k[i][1]] = {k[i][2],true};
		end
	end
	return t;
end

local function UpdatePointY(obj1,...)
	local y,p,P,rP,x = 0,obj1:GetPoint()
	for i,v in ipairs({...}) do
		if v:IsShown() then
			y = y + v:GetHeight();
		end
	end
	obj1:SetPoint(p,P,rP,x,y/2)
end

function ns.UpdateViewport()
	AFKFullscreenFrame:ClearAllPoints();
	if afkfullscreenDB.viewport_support then
		AFKFullscreenFrame:SetPoint("TOPLEFT",WorldFrame);
		AFKFullscreenFrame:SetPoint("BOTTOMRIGHT",WorldFrame);
	else
		AFKFullscreenFrame:SetAllPoints();
	end
end

function ns.SetBackgroundModel(obj)
	local tObj = type(obj);
	if tObj~="table" then
		ns.SetBackgroundModel(AFKFullscreenFrame.PanelBackgroundModel);
		ns.SetBackgroundModel(AFKFullscreenDemoFrame.Child.PanelBackgroundModel);
		return;
	end
	if tObj=="table" and obj.GetObjectType and obj:GetObjectType()=="PlayerModel" then
		local modelData = ns.models[ns.modelIndex];
		obj:SetScale(1);
		obj:SetModelScale(1);
		obj:SetModel(modelData.id);
		C_Timer.After(0.05, function()
			obj:SetModelScale(modelData.scale);
			if type(modelData.pos)=="table" then
				obj:SetPosition(unpack(modelData.pos))
			end
		end);
	end
end

local function SetPanelSkin(frame,name,isDemo)
	if not ns.panelSkins[name] then
		name = default;
	end
	if frame.currentSkin~=name then
		frame.currentSkin = name;
		local skin,show = UnpackSkin(ns.panelSkins[name],isDemo);
		for i,v in pairs(skin)do
			if v[2]~=false then
				local obj, v = unpack(v);
				show=false;
				if i~="BackgroundModel" and (i:find("^Background") or i:find("Border")) then
					if v.Texture or v.Atlas then
						if v.Atlas then
							local atlasinfo = C_Texture.GetAtlasInfo(v.Atlas);
							if atlasinfo then
								v.Texture, v.Width, v.Height = atlasinfo.filename or atlasinfo.file,atlasinfo.width, atlasinfo.height;
								if v.HTile==nil then v.HTile = atlasinfo.tilesHorizontally; end
								if v.VTile==nil then v.VTile = atlasinfo.tilesVertically; end
								v.Coords = {atlasinfo.leftTexCoord, atlasinfo.rightTexCoord, atlasinfo.topTexCoord, atlasinfo.bottomTexCoord};
							end
						end

						obj:SetTexture("Interface\\buttons\\white8x8",false);

						obj:SetTexture(v.Texture,true);

						v.Width = tonumber(v.Width or v.W);
						v.Height = tonumber(v.Height or v.H);
						if v.Width then obj:SetWidth(v.Width); end
						if v.Height then obj:SetHeight(v.Height); end

						if type(v.Coords)=="string" or type(v.Coords)=="table" then
							local t = {};
							if type(v.Coords)=="string" then
								for n,c in ipairs({strsplit(",",v.Coords)})do
									tinsert(t,tonumber(c));
								end
							else
								t=v.Coords;
							end
							obj:SetTexCoord(unpack(t));
						end

						if v.HTile~=nil then
							obj:SetHorizTile(v.HTile=="true" or v.HTile==true);
						end

						if v.VTile~=nil then
							obj:SetVertTile(v.VTile=="true" or v.VTile==true);
						end

						v.Scale = tonumber(v.Scale);
						if v.Scale and i:find("^Background") then
							obj:GetParent():SetScale(v.Scale);
						end

						if v.Color then
							local t = {};
							for n,c in ipairs({strsplit(",",v.Color)})do
								tinsert(t,tonumber(c));
							end
							obj:SetVertexColor(unpack(t));
						else
							obj:SetAlpha( tonumber(v.Alpha) or 1 );
						end

						if obj.point then
							for I=1, obj:GetNumPoints() do
								local point={obj:GetPoint(I)};
								if point[1]==obj.point then
									point[4] = tonumber(v.X) or obj.pointDefaultX;
									point[5] = tonumber(v.Y) or obj.pointDefaultY;
									if obj.point=="RIGHT" then
										point[4] = -point[4];
									end
									if obj.point=="BOTTOM" then
										point[5] = -point[5];
									end
									obj:SetPoint(unpack(point));
								end
							end
						end

						show=true;
					elseif v.Color then
						local t = {};
						for n,c in ipairs({strsplit(",",v.Color)})do
							tinsert(t,tonumber(c));
						end
						obj:SetTexture("Interface\\Buttons\\White8x8");
						obj:SetVertexColor(unpack(t));
						show=true;
					end
				elseif i=="BackgroundModel" then
					obj:ClearModel();
					ns.SetBackgroundModel();
					obj.SetToShow=true;
				elseif i=="InsetShadow" or i=="OutsetShadow" then
					v.Y = tonumber(v.Y);
					v.H = tonumber(v.H);
					if v.Y==nil then v.Y = 0; end
					obj[1]:SetHeight(v.H or obj[1].defaultHeight);
					obj[2]:SetHeight(v.H or obj[2].defaultHeight);
					obj[1]:SetShown(v.Show=="true");
					obj[2]:SetShown(v.Show=="true");
					if i=="InsetShadow" then
						obj[1]:SetPoint("TOP",frame.PanelHolder, 0, v.Y );
						obj[2]:SetPoint("BOTTOM",frame.PanelHolder, 0,  - v.Y );
					else
						obj[1]:SetPoint("BOTTOM",frame.PanelHolder,"TOP", 0, v.Y );
						obj[2]:SetPoint("TOP",frame.PanelHolder,"BOTTOM", 0, - v.Y );
					end
				end
				if obj.SetShown then
					obj:SetShown(show);
				end
			else
				v[1]:Hide();
			end
		end
	end
end

local function TickerFunc(_,demoFrame)
	local self = demoFrame or AFKFullscreenFrame
	if self:IsShown() then
		self.PanelInfos.AFKTimer:SetText(SecondsToTime(time()-self.timer));
		self.PanelInfos.Date:SetText(_G["WEEKDAY_"..date("%A"):upper()]..", "..date("%Y-%m-%d"));
		self.PanelInfos.Time:SetText( afkfullscreenDB.infopanel_time=="s" and LT.GetTimeString("GameTime",true,true) or date("%H:%M:%S"));
		if afkfullscreenDB.infopanel_time2~="-" then
			self.PanelInfos.Time2:SetText( afkfullscreenDB.infopanel_time2=="s" and LT.GetTimeString("GameTime",true,true) or date("%H:%M:%S"));
		end
	end
end

local function DemoTickerFunc()
	local standalonePanel = ACD.OpenFrames and ACD.OpenFrames[addon] and ACD.OpenFrames[addon].frame:IsVisible();
	local blizzPanel = ACD.BlizOptions and ACD.BlizOptions[addon] and ACD.BlizOptions[addon][addon].frame:IsVisible();
	if not (standalonePanel or blizzPanel) then
		AFKFullscreenDemoFrame:Hide();  -- hide demo frame after closed option panel
	else
		TickerFunc(nil,AFKFullscreenDemoFrame.Child);
	end
end

local function CheckAFK(self,PEW)
	local isAFK = UnitIsAFK("player");
	if isAFK and not self:IsShown() then
		self:Show();
		if PEW then
			self:Hide();
			C_Timer.After(0.5,function()
				self:Show();
			end);
		end
		if not InCombatLockdown() and afkfullscreenDB.hide_ui then
			securecall("SetUIVisibility",false); -- hide ui
		end
	elseif not isAFK and self:IsShown() then
		self.FadeOut:Play();
		if not UIParent:IsVisible() then
			securecall("SetUIVisibility",true); -- unhide ui
		end
	end
end

local function DataBrokerInit()
	LDB_Object = LDB:NewDataObject(addon,{
		type	= "launcher",
		icon	= media.."Ability_Foundryraid_Dormant",
		label	= L[addon],
		text	= L[addon],
		OnTooltipShow = function(tt)
			local line = "|cff69ccf0%s|r |cffffffff|||r |cfff0a55f%s|r";
			tt:AddLine(L[addon]);
			tt:AddLine(line:format(L["Click"],L["to open config"]));
		end,
		OnClick = function(_, button)
			ns.toggleOptions();
		end
	});

	if LDBI and LDB_Object then
		if afkfullscreenDB.Minimap==nil then
			afkfullscreenDB.Minimap={hide=false};
		end
		LDBI:Register(addon, LDB_Object, afkfullscreenDB.Minimap);
	end
end

local function SetTimer(self)
	local t,prev = time(),afkfullscreenCharDB.LoggedOutWhileAFK;
	if type(prev)=="table" and t-prev[1]<=20 then -- 20 sec for a reload? should be enough!?
		self.timer = prev[2]; -- add old value saved before reload
		return;
	end
	self.timer = t-1;
end


-------------------------------------------------
-- alert sound functions
-------------------------------------------------

local function AlertSoundExecute(sound,isSoundKit)
	local soundType,willPlay = type(sound),nil;

	if isSoundKit then
		willPlay, soundHandle = PlaySound(sound,afkfullscreenDB.sound_channel)
	elseif (soundType=="string" and sound~="") or (soundType=="number" and sound>0) then
		willPlay, soundHandle = PlaySoundFile(sound,afkfullscreenDB.sound_channel)
	end

	return willPlay;
end

local function AlertSoundStart(one_time)
	if not afkfullscreenDB.sound_enabled then return end

	local soundSource = afkfullscreenDB.sound_source;
	local soundObject = afkfullscreenDB["sound_"..soundSource];
	local soundPathOrFileID,soundKitId,willPlay = nil,nil,nil;

	ns:debug("<AlertSound>",soundSource,soundObject)

	if soundSource=="file" and soundObject then
		soundPathOrFileID = tonumber(soundObject);
		if soundPathOrFileID==nil and type(soundObject)=="string" and soundObject~="" then
			soundPathOrFileID = soundObject;
		end
--@do-not-package@
	--elseif soundSource=="list" then
		--soundPathOrFileID =
--@end-do-not-package@
	elseif soundSource=="sk" then
		local id = SOUNDKIT[soundObject] or tonumber(soundObject) or nil;
		if id and (GetSoundEntryCount(id) or 0)>0 then
			soundKitId = id;
--@do-not-package@
		else
			ns:debugPrint("<AlertSound>","<Error>","invalid id, no sound entries found",soundObject)
--@end-do-not-package@
		end
	elseif soundSource=="sm" then
		local path = ns.LSM:Fetch("sound",soundObject)
		if path then
			soundPathOrFileID = path;
		end
	end

	if (soundKitId or soundPathOrFileID) and AlertSoundExecute(soundKitId or soundPathOrFileID,soundKitId~=nil)  then
		if not alertSoundTicker and not one_time then
			alertSoundTicker = C_Timer.NewTicker(afkfullscreenDB.sound_interval,function()
				AlertSoundExecute(soundKitId or soundPathOrFileID,soundKitId~=nil)
			end)
		end
		willPlay = true;
	end

--@do-not-package@
	if (soundKitId or soundPathOrFileID) then
		ns:debugPrint("<AlertSound>",not willPlay and "<Error>wont play afk sound" or "is playing",soundSource,soundObject,soundKitId or soundPathOrFileID)
	end
--@end-do-not-package@
	return willPlay
end

local function AlertSoundStop()
	if alertSoundTicker then
		alertSoundTicker:Cancel();
		alertSoundTicker=nil;
	end
end

ns.AlertSound404 = false;
function ns.AlertSoundStart() -- for options
	ns.AlertSound404 = not AlertSoundStart(true);
	ns:debugPrint("AlertSound",ns.AlertSound404)
end

-------------------------------------------------
-- model mixin functions
-------------------------------------------------
AFKFullscreenModelMixin = {};

function AFKFullscreenModelMixin:PlayerOnShow()
	self:ClearModel();
	self:SetUnit("player");
	self:SetPortraitZoom(0.7);
	self:SetRotation(0.5);
	self:SetPosition(unpack(PlayerPositionFix[UnitSex("player")]));
	self:RefreshCamera();
end

function AFKFullscreenModelMixin:ClockOnShow()
	self:ClearModel();
	self:SetModel(1087509);
	self:SetPortraitZoom(1);
	self:SetRotation(0.5);
	self:SetPosition(2.8,0,.71);
	self:RefreshCamera();
end

function AFKFullscreenModelMixin:BackgroundOnShow()
	self:RefreshCamera();
end

function AFKFullscreenModelMixin:FullscreenOnShow()
	self:RefreshCamera();
end

function AFKFullscreenModelMixin:OnEvent()
	self:RefreshCamera();
end

function AFKFullscreenModelMixin:OnLoad()
	self:RefreshCamera();
	self:RegisterEvent("UI_SCALE_CHANGED");
	self:RegisterEvent("DISPLAY_SIZE_CHANGED");
end


-------------------------------------------------
-- flasher mixin functions
-------------------------------------------------
AFKFullscreenFlasherMixin = {};
function AFKFullscreenFlasherMixin:OnShow()
	self.style = false;
	if afkfullscreenDB.fullscreenwarning_texture~="none" then
		self.AnimTexture1:SetTexture(media.."fullscreen-"..afkfullscreenDB.fullscreenwarning_texture);
		self.AnimTexture1:SetVertexColor(unpack(afkfullscreenDB.fullscreenwarning_color));
		self.AnimTexture1:Show();
		self.style = "pulse";
	end
	if afkfullscreenDB.fullscreenwarning_factionlogo and faction~="Neutral" then
		local w,size
		if self:GetParent()==AFKFullscreenFrame then
			w,size = UIParent:GetSize();
		else
			w,size = AFKFullscreenDemoFrame:GetSize();
		end
		if w<size then
			size = w; -- for player with vertical screens ;-)
		end
		self.AnimTexture2:SetTexture(media.."fullscreen-"..faction);
		self.AnimTexture2:SetDesaturated(true);
		self.AnimTexture2:SetVertexColor(unpack(afkfullscreenCharDB.fullscreenwarning_factionlogo_color));
		self.AnimTexture2:SetSize(size,size);
		self.AnimTexture2:Show();
		self.style = "pulse";
	end
	if self.style and self[self.style] then
		self[self.style]:Play();
	end
end

function AFKFullscreenFlasherMixin:OnHide()
	if self.style and self[self.style] then
		self[self.style]:Stop();
	end
	self.AnimTexture1:Hide();
	self.AnimTexture2:Hide();
end


-------------------------------------------------
-- Demo frame mixin functions
-------------------------------------------------
AFKFullscreenDemoFrameMixin = {};

function AFKFullscreenDemoFrameMixin:OnLoad()
	self.border = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate");
	self.border:SetPoint("TOPLEFT",-11,11);
	self.border:SetPoint("BOTTOMRIGHT",10,-10);
	self.border:SetBackdrop({
		edgeFile=[[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize=32, tile=true
	});
	demoKeys = {
		{"BackgroundModel",   self.Child.PanelBackgroundModel},
		{"BackgroundLayer1",  self.Child.PanelBackground.Layer1},
		{"BackgroundLayer2",  self.Child.PanelBackground.Layer2},
		{"BackgroundLayer3",  self.Child.PanelBackground.Layer3},
		{"BorderTopLeft",     self.Child.PanelBorderEdge.TopLeft},
		{"BorderTopRight",    self.Child.PanelBorderEdge.TopRight},
		{"BorderBottomLeft",  self.Child.PanelBorderEdge.BottomLeft},
		{"BorderBottomRight", self.Child.PanelBorderEdge.BottomRight},
		{"BorderTop",         self.Child.PanelBorder.Top},
		{"BorderBottom",      self.Child.PanelBorder.Bottom},
		{"BorderLeft",        self.Child.PanelBorder.Left},
		{"BorderRight",       self.Child.PanelBorder.Right},
		{"Overlay",           self.Child.PanelOverlay.Texture},
		{"InsetShadow",       {self.Child.PanelShadow.InsetTop,self.Child.PanelShadow.InsetBottom}},
		{"OutsetShadow",      {self.Child.PanelShadow.OutsetTop,self.Child.PanelShadow.OutsetBottom}}
	};
end

function AFKFullscreenDemoFrameMixin:OnShow()
	SetPanelSkin(self.Child,afkfullscreenDB.infopanel_skin,true);

	self.Child.PanelInfos.Character:Hide();
	self.Child.PanelInfos.Realm:Hide();
	self.Child.PanelInfos.Guild:Hide();
	self.Child.PanelInfos.Time:Hide();
	self.Child.PanelInfos.Time2:Hide();
	self.Child.PanelInfos.Date:Hide();

	self.Child.PanelInfos.AFKText:SetText(L["AFK since"]);
	self.Child.PanelInfos.AFKText:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));
	self.Child.PanelInfos.AFKTimer:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));

	self.Child.FadeIn:Play();
	if afkfullscreenDB.fullscreenwarning_texture or afkfullscreenDB.fullscreenwarning_factionlogo then
		self.Child.FullScreenWarning:Show();
	end

	self.Child.timer=time()-1;
	self.Child.elapse=1;
	if self.Child.PanelBackgroundModel.SetToShow then
		self.Child.PanelBackgroundModel:Show();
		self.ModelControl:Show();
	end

	if not demoticker then
		demoticker = C_Timer.NewTicker(1,DemoTickerFunc);
		demoticker.startAFK = time();
		DemoTickerFunc();
	end
end

function AFKFullscreenDemoFrameMixin:OnHide()
	self.Child.PanelInfos.AFKTimer:SetText("");
	self.Child.FullScreenWarning:Hide();
	self.Child.PanelPlayerModel:Hide();
	if WOW_PROJECT_ID~=WOW_PROJECT_MAINLINE then
		self.Child.PanelClockImage:Hide();
	else
		self.Child.PanelClockModel:Hide();
	end
	self.Child.PanelBackgroundModel:Hide();
	if demoticker then
		demoticker:Cancel();
		demoticker = nil;
	end
end


-------------------------------------------------
-- Main frame functions
-------------------------------------------------
AFKFullscreenFrameMixin = {};

local function updatePanelPosition(cinematicEnds)
	local pos,ph = afkfullscreenDB.infopanel_position,AFKFullscreenFrame.PanelHolder;
	local isCinematic = IsCinematic();
	local showFullscreen = afkfullscreenDB.fullscreenwarning_texture or afkfullscreenDB.fullscreenwarning_factionlogo;
	ph:ClearAllPoints();
	if cinematicEnds then
		AFKFullscreenFrame.PanelHolder:SetAlpha(1);
	end
	if pos=="top" or isCinematic then
		ph:SetPoint("TOPLEFT");
		ph:SetPoint("TOPRIGHT");
		if isCinematic then
			AFKFullscreenFrame.FullScreenWarning:Hide();
			AFKFullscreenFrame.PanelHolder:SetAlpha(0);
		end
	elseif pos=="bottom" then
		ph:SetPoint("BOTTOMLEFT");
		ph:SetPoint("BOTTOMRIGHT");
		AFKFullscreenFrame.FullScreenWarning:SetShown(showFullscreen);
	else -- middle
		ph:SetPoint("LEFT");
		ph:SetPoint("RIGHT");
		AFKFullscreenFrame.FullScreenWarning:SetShown(showFullscreen);
	end
end

function AFKFullscreenFrameMixin:OnLoad()
	keys = {
		{"BackgroundModel",   self.PanelBackgroundModel},
		{"BackgroundLayer1",  self.PanelBackground.Layer1},
		{"BackgroundLayer2",  self.PanelBackground.Layer2},
		{"BackgroundLayer3",  self.PanelBackground.Layer3},
		{"BorderTopLeft",     self.PanelBorderEdge.TopLeft},
		{"BorderTopRight",    self.PanelBorderEdge.TopRight},
		{"BorderBottomLeft",  self.PanelBorderEdge.BottomLeft},
		{"BorderBottomRight", self.PanelBorderEdge.BottomRight},
		{"BorderTop",         self.PanelBorder.Top},
		{"BorderBottom",      self.PanelBorder.Bottom},
		{"BorderLeft",        self.PanelBorder.Left},
		{"BorderRight",       self.PanelBorder.Right},
		{"Overlay",           self.PanelOverlay.Texture},
		{"InsetShadow",       {self.PanelShadow.InsetTop,self.PanelShadow.InsetBottom}},
		{"OutsetShadow",      {self.PanelShadow.OutsetTop,self.PanelShadow.OutsetBottom}}
	};
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_FLAGS_CHANGED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_LOGOUT");
	self:RegisterEvent("CINEMATIC_START");
	self:RegisterEvent("CINEMATIC_STOP");
	self:RegisterEvent("PLAY_MOVIE");
end

function AFKFullscreenFrameMixin:OnShow()
	local showFullscreen = afkfullscreenDB.fullscreenwarning_texture or afkfullscreenDB.fullscreenwarning_factionlogo;

	updatePanelPosition();

	self:SetScale(UIParent:GetEffectiveScale());

	SetPanelSkin(self,afkfullscreenDB.infopanel_skin);

	self.FadeIn:Play();

	if IsCinematic() then
		self.FullScreenWarning:Hide();
	else
		self.FullScreenWarning:SetShown(showFullscreen);
	end

	SetTimer(self)

	self.elapse=1;
	self.PanelPlayerModel:Show();
	if WOW_PROJECT_ID~=WOW_PROJECT_MAINLINE then
		self.PanelClockImage:Show();
	else
		self.PanelClockModel:Show();
	end
	self.PanelInfos.Realm:Show();
	self.PanelInfos.Realm:SetShown(afkfullscreenDB.infopanel_playerguild);
	self.PanelInfos.Date:Show();

	self.PanelInfos.Character:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));
	self.PanelInfos.Realm:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));
	self.PanelInfos.Time:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));
	self.PanelInfos.Time2:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));
	self.PanelInfos.Date:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));
	self.PanelInfos.AFKText:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));
	self.PanelInfos.AFKTimer:SetTextColor(unpack(afkfullscreenDB.infopanel_textcolor));

	self.PanelPlayerModel:SetShown(afkfullscreenDB.infopanel_playermodel);
	if WOW_PROJECT_ID~=WOW_PROJECT_MAINLINE then
		self.PanelClockImage:SetShown(afkfullscreenDB.infopanel_clockmodel);
	else
		self.PanelClockModel:SetShown(afkfullscreenDB.infopanel_clockmodel);
	end

	self.PanelInfos.Character:SetShown(afkfullscreenDB.infopanel_playernamerealm);
	self.PanelInfos.Realm:SetShown(afkfullscreenDB.infopanel_playernamerealm);

	local showGuild = afkfullscreenDB.infopanel_playernamerealm and IsGuildMember("player") and afkfullscreenDB.infopanel_playerguild;
	self.PanelInfos.Guild:SetShown(showGuild);
	if showGuild then
		local guildname = GetGuildInfo("player");
		self.PanelInfos.Guild:SetText(guildname)
	end
	self.PanelInfos.AFKText:SetText(L["AFK since"]);

	self.PanelInfos.Time:SetShown(afkfullscreenDB.infopanel_timedate);
	self.PanelInfos.Date:SetShown(afkfullscreenDB.infopanel_timedate);
	self.PanelInfos.Time2:SetShown(afkfullscreenDB.infopanel_timedate and afkfullscreenDB.infopanel_time2~="-");

	UpdatePointY(self.PanelInfos.Character,self.PanelInfos.Realm,self.PanelInfos.Guild)
	UpdatePointY(self.PanelInfos.Time,self.PanelInfos.Date,self.PanelInfos.Time2)

	self.PanelBackgroundModel:SetShown(self.PanelBackgroundModel.SetToShow);

	--ns:debugPrint("AFK>AlertSound.Play")
	AlertSoundStart()

	if not ticker then
		ticker = C_Timer.NewTicker(1,TickerFunc);
		TickerFunc(ticker);
	end
end

function AFKFullscreenFrameMixin:OnHide()
	self.PanelInfos.AFKTimer:SetText("");
	self.FullScreenWarning:Hide();
	self.PanelPlayerModel:Hide();
	if WOW_PROJECT_ID~=WOW_PROJECT_MAINLINE then
		self.PanelClockImage:Hide();
	else
		self.PanelClockModel:Hide();
	end
	self.PanelBackgroundModel:Hide();
	AlertSoundStop();
	if ticker then
		ticker:Cancel();
		ticker = nil;
	end
	self.timer = nil;
end

function AFKFullscreenFrameMixin:OnEvent(event, ...)
	if event=="ADDON_LOADED" and addon==... then
		ns.dbIntegrityCheck(); -- defined in options.lua

		ns.registerOptions(); -- defined in options.lua

		ns.registerSlashCommand();

		DataBrokerInit();

		self.PanelInfos.Character:SetText(UnitName("player"));
		self.PanelInfos.Realm:SetText(GetRealmName());

		MovieFrame:HookScript("OnHide",function() updatePanelPosition(true) end);

		ns.UpdateViewport();

		if afkfullscreenDB.show_addonloaded or IsShiftKeyDown() then
			ns:print(L["AddOnLoaded"]);
		end
		self:UnregisterEvent(event);
	elseif event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_FLAGS_CHANGED" then
		C_Timer.After(0.314159,function()
			if not UnitIsAFK("player") then
				afkfullscreenCharDB.LoggedOutWhileAFK = nil;
			end
			CheckAFK(self,event=="PLAYER_ENTERING_WORLD");
		end);
	elseif event=="PLAYER_REGEN_DISABLED" then
		securecall("SetUIVisibility",true);
	elseif self:IsVisible() and (event=="CINEMATIC_START" or event=="CINEMATIC_STOP" or event=="PLAY_MOVIE") then
		updatePanelPosition();
	elseif event=="PLAYER_LOGOUT" and UnitIsAFK("player") then
		afkfullscreenCharDB.LoggedOutWhileAFK = {(time()), self.timer};
	end
end

