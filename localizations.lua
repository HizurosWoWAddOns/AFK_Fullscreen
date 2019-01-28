
local addon, ns = ...
local L = setmetatable({},{
	__index=function(t,k)
		local n=tostring(k);
		rawset(t,k,n);
		return n;
	end
});

ns.L = L;

-- Do you want to help localize this addon?
-- https://wow.curseforge.com/projects/farmhud/localization

L["Color"] = COLOR; -- Color
L["Custom"] = VIDEO_QUALITY_LABEL6; -- Custom
L[addon] = "AFK Fullscreen Warning";

-- @localization(locale="enUS", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@

if LOCALE_deDE then
--@do-not-package@
	L["AFK since"] = "AFK seit" -- AFK_fullscreen.lua
	L["Alert sound options"] = "Alarmton Optionen"; -- options.lua
	L["Border blizzard like"] = "Umrandung Blizzard ähnlich"; -- options.lua
	L["Bottom"] = "Unten"; -- options.lua
	L["Choose texture for fullscreen warning"] = ""; -- options.lua
	L["Click"] = "Klick"; -- AFK_fullscreen.lua
	L["Clock animation"] = "Uhranimation"; -- options.lua
	L["Dancing"] = "Tanzend"; -- options.lua
	L["Display a little demo frame to show a selected skin"] = "Zeigt ein kleines Demofenster zu anzeigen des gewählten Skin"; -- options.lua
	L["Do nothing"] = "Tue nichts"; -- options.lua
	L["Enable alert sound"] = "Aktiviere Alarmton"; -- options.lua
	L["File"] = "Datei"; -- options.lua
	L["Flat"] = "Flach"; -- options.lua
	L["Fullscreen options"] = "Vollbild Optionen"; -- options.lua
	L["Fullscreen texture"] = "Vollbild Grafik"; -- options.lua
	L["Fullscreen warning"] = "Vollbildwarnung"; -- options.lua
	L["Gradient centered horizontal"] = "Verlauf zentriert Honrizontal"; -- options.lua
	L["Gradient centered vertical"] = "Verlauf zentriert Vertikal"; -- options.lua
	L["Hide UI"] = "Verstecke UI"; -- options.lua
	L["Hide user interface on AFK"] = "Verstecke die Benutzeroberfläche bei AFK"; -- options.lua
	L["Info panel elements"] = "Infopanel Elemente"; -- options.lua
	L["Info panel skins"] = "Infopanel Aussehen"; -- options.lua
	L["Left click"] = "Links Klick"; -- AFK_fullscreen.lua
	L["Left"] = "Links"; -- options.lua
	L["Middle"] = "Mitte"; -- options.lua
	L["Minimap button"] = "Minikarten Button"; -- options.lua
	L["Panel position"] = "Panel Position"; -- options.lua
	L["Player name & realm"] = "Spielername & Realm"; -- options.lua
	L["Player portrait"] = "Spielerportrait"; -- options.lua
	L["Random"] = "Zufall"; -- options.lua
	L["Reset color"] = "Farbe zurücksetzen"; -- options.lua
	L["Right"] = "Rechts"; -- options.lua
	L["Select alert sound"] = "Wähle Alarmton"; -- options.lua
	L["Select a skin"] = "Wähle ein Aussehen"; -- options.lua
	L["Select output channel"] = "Wähle Ausgabekanal"; -- options.lua
	L["Show demo"] = "Zeige Demo"; -- options.lua
	L["Time & date"] = "Uhrzeit & Datum"; -- options.lua
	L["to open config"] = "zum öffnen der Einstellungen"; -- AFK_fullscreen.lua
	L["Top"] = "Oben"; -- options.lua
	L["Use custom file"] = "Nutze eigene Datei"; -- options.lua
--@end-do-not-package@
--@localization(locale="deDE", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_esES then
--@localization(locale="esES", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_esMX then
--@localization(locale="esMX", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_frFR then
--@localization(locale="frFR", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_itIT then
--@localization(locale="itIT", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_koKR then
--@localization(locale="koKR", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_ptBR or LOCALE_ptPT then
--@localization(locale="ptBR", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_ruRU then
--@localization(locale="ruRU", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_zhCN then
--@localization(locale="zhCN", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end

if LOCALE_zhTW then
--@localization(locale="zhTW", format="lua_additive_table", handle-subnamespaces="none", handle-unlocalized="ignore")@
end
