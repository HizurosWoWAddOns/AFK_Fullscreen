
local addon, ns = ...
local L = setmetatable({},{
	__index=function(t,k)
		local n=tostring(k)
		rawset(t,k,n)
		return n
	end
})
ns.L = L

--[[
	-- on screen text
	L["AFK since"] = ""

	-- chatcommand answers
	L["Animation"] = ""
	L["Text"] = ""
	L["Sound"] = ""
	L["enabled"] = ""
	L["disabled"] = ""
	L["Usage: /afktoggle <anim||sound||text>"] = "Nutzung: /afktoggle <anim||sound||text>"
	L["Usage: /afkconfig <reset||open>"] = ""
	L["Default settings restored!"] = ""
	L["Current settings:"] = ""
	-- option panel
]]

if LOCALE_deDE then
	L["AFK since"] = "AFK seit"
	L["enabled"] = "aktiviert"
	L["disabled"] = "deaktiviert"
	L["Default settings restored!"] = "Standardeinstellungen wiederhergestellt!"
	L["Usage: /afktoggle <anim||sound||text>"] = "Nutzung: /afktoggle <anim||sound||text>"
	L["Usage: /afkconfig <reset||open>"] = "Nutzung: /afkconfig <reset||open>"
	L["Current settings:"] = "Aktuelle Einstellungen:"
end

--[[
if LOCALE_esES then
	L["AFK since"] = ""
end

if LOCALE_esMX then
	L["AFK since"] = ""
end

if LOCALE_frFR then
	L["AFK since"] = ""
end

if LOCALE_itIT then
	L["AFK since"] = ""
end

if LOCALE_koKR then
	L["AFK since"] = ""
end

if LOCALE_ptBR then
	L["AFK since"] = ""
end

if LOCALE_ruRU then
	L["AFK since"] = ""
end

if LOCALE_zhCN then
	L["AFK since"] = ""
end

if LOCALE_zhTW then
	L["AFK since"] = ""
end
]]
