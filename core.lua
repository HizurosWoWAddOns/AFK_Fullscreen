
-- saved variables
--afkfullscreenDB = {};
--local db = afkfullscreenDB;

-- local variables
local addon, ns = ...;
local L = ns.L;
local _print = print;
local media = "Interface\\AddOns\\"..addon.."\\media\\";
local modelKeys = {};
local index = 0;

local function print(...)
	_print("|cffff4444"..addon.."|r",...)
end

local function ClockModel_OnShow(self)
	self:SetModel("Spells\\Garrison_Shipment_Pending_State");
	self:SetModelScale(4);
	self:SetPosition(0,0,-2.18);
end

local function OnUpdate(self,elapse)
	self.elapsed = self.elapsed+elapse;
	if (self.elapsed<1) then return; end
	self.elapsed = 0;
	self.info.AFKText:SetText(L["AFK since"]);
	self.info.AFKTimer:SetText(SecondsToTime(GetTime()-self.timer));
	self.info.Date:SetText(date("%Y-%m-%d"));
	self.info.Time:SetText(date("%H:%M:%S"));
end

local function OnShow(self)
	self.FadeIn:Play();

	local t = self.Texture;
	t.style="pulse";
	t.AnimTexture1:SetTexture(media.."pulse_orange");
	t.AnimTexture1:SetAlpha(1);
	t[t.style]:Play();
	t:Show();

	self.timer=GetTime()-1;
	self.elapsed=1;
	self.info.Character:SetText(UnitName("player"));
	self.info.Realm:SetText(GetRealmName());
	self:SetScript("OnUpdate",OnUpdate);
end

local function OnHide(self)
	local t = self.Texture;
	if (t.style) and (t[t.style]) and (t[t.style]:IsPlaying()) then
		t[t.style]:Stop();
		t.AnimTexture1:SetAlpha(0);
	end
	self.info.AFKTimer:SetText("");
	self:SetScript("OnUpdate",nil);
end

local function OnEvent(self,event,arg1)
	if (event=="ADDON_LOADED") and (arg1==addon) then
	elseif (event=="PLAYER_ENTERING_WORLD" or event=="PLAYER_FLAGS_CHANGED") and (arg1=="player") then
		if ( UnitIsAFK(arg1) ) then
			self:Show();
		elseif (self:IsShown()) then
			self.FadeOut:Play();
		end
	end
end

function AFK_Fullscreen_OnLoad(self)
	-- InfoBar-ClockModel Setup
	local cm=self.info.ClockModel;
	Model_OnLoad(cm);
	cm:SetSequence(0);
	cm:SetCamera(0);
	cm:SetScript("OnShow",ClockModel_OnShow);

	-- Main frame Setup
	self:SetScript("OnShow",OnShow);
	self:SetScript("OnHide",OnHide);
	self:SetScript("OnEvent", OnEvent);
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_FLAGS_CHANGED");
end

