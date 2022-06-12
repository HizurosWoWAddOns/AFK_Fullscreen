
local addon,ns = ...;
local L=ns.L;
local AC = LibStub("AceConfig-3.0");
local ACD = LibStub("AceConfigDialog-3.0");
local LDBI = LibStub("LibDBIcon-1.0", true);
local soundSources = {file=L["File"],lsm="LibSharedMedia"};
local faction = UnitFactionGroup("player")
ns.soundChannels = {};
ns.soundFiles = {customfile=L["Use custom file"]};
local fullscreen_textures = {
	["none"] = ADDON_DISABLED,
	["flat"] = L["Flat"],
	["border1"] = L["Border blizzard like"],
	["gradient-vertical"] = L["Gradient centered vertical"],
	["gradient-horizontal"] = L["Gradient centered horizontal"],
}
local infopanelVertPosition = {
	top = L["Top"],
	middle = L["Middle"],
	bottom = L["Bottom"]
};
local sound_channels = {
	master = "Master",
	sfx = "SFX"
};
local dbDefaults = {
	hide_ui = true,
	show_addonloaded = true,
	viewport_support = true,

	--[[ fullscreenwarning entries ]]
	fullscreenwarning_texture = "border1",
	fullscreenwarning_color = {1,.5,0,1},

	fullscreenwarning_factionlogo = true,
	--fullscreenwarning_factionlogo_color = nil, -- per character

	--[[ infopanel entries ]]
	infopanel_position = "middle",

	infopanel_playermodel = true,
	infopanel_playernamerealm = true,
	infopanel_clockmodel = true,
	infopanel_timedate = true,
	infopanel_textcolor = {1.0,0.82,0},

	infopanel_skin = "Etherreal",

	--[[ alertsound entries ]]
	sound_enabled = false,
	sound_channel = "SFX",
	sound_file = "",
};

local dbDefaultsChar = {
	fullscreenwarning_factionlogo_color = nil, -- filled by function with faction color
}

local function presetSelect(info,...)
end

local function soundOption(info,value)
end

local function listSkins(info)
	local list = {};
	for k,v in pairs(ns.panelSkins) do
		list[k] = k;
	end
	return list;
end

local function optionsFunc(info,...)
	local key, value, value2 = info[#info], ...;
	if key == "minimap" then
		if value~=nil then
			afkfullscreenDB.Minimap.hide = not value;
			LDBI:Refresh(addon);
		end
		return not afkfullscreenDB.Minimap.hide;
	elseif value~=nil then
		if value2~=nil then
			value = {...}; -- color table
		end
		afkfullscreenDB[key] = value;
		if AFKFullscreenDemoFrame:IsShown() then
			AFKFullscreenDemoFrame:Hide();
			C_Timer.After(0.2,function()
				AFKFullscreenDemoFrame:Show();
			end);
		end
		if key=="viewport_support" then
			ns.UpdateViewport();
		end
		return;
	elseif type(afkfullscreenDB[key])=="table" then
		return unpack(afkfullscreenDB[key]); -- color table
	end
	return afkfullscreenDB[key];
end

local function openSubTree()
	ACD:SelectGroup(addon,"infopanel");
	ACD:SelectGroup(addon,"general");
	ns.options.args.general.args.minimap.disabled = nil;
end

local options = {
	type = "group",
	name = L[addon],
	get = optionsFunc,
	set = optionsFunc,
	args = {
		minimap = {
			type = "toggle", order = 1,
			name = L["MinimapButton"], desc = L["MimimapButtonDesc"]
		},

		show_addonloaded = {
			type = "toggle", order = 2,
			name = L["AddOnLoaded"], desc = L["AddOnLoadedDesc"].."|n|n|cff44ff44"..L["AddOnLoadedDescAlt"].."|r"
		},

		viewport_support = {
			type = "toggle", order = 3,
			name = L["ViewportSupport"], desc = L["ViewportSupportDesc"]
		},

		demo = {
			type = "execute", order = 4,
			name = L["ShowDemo"], desc = L["ShowDemoDesc"],
			func = function() AFKFullscreenDemoFrame:SetShown(not AFKFullscreenDemoFrame:IsShown()); end
		},

		fullscreen = {
			type = "group", order = 20, inline = true,
			name = L["FullscreenOptions"],
			args = {
				hide_ui = {
					type = "toggle", order = 1, width = "double",
					name = L["HideUI"], desc = L["HideUIDesc"]
				},

				header_border = {
					type = "header", order = 10,
					name = L["FullscreenBorder"]
				},

				desc_border = {
					type = "description", order = 11, fontSize = "medium", hidden=true,
					name = L["FullscreenBorderDesc"]
				},

				fullscreenwarning_texture = {
					type = "select", order = 12,
					name = APPEARANCE_LABEL,
					values = fullscreen_textures
				},

				fullscreenwarning_color = {
					type = "color", order = 13,
					name = COLOR,
				},

				fullscreenwarning_color_reset = {
					type = "execute", order = 14,
					name = L["ColorReset"],
					func = function() afkfullscreenDB.fullscreenwarning_color = dbDefaults.fullscreenwarning_color; end
				},

				header_logo = {
					type = "header", order = 20,
					name = L["FullscreenFactionLogo"],
				},

				logo_neutral = {
					type = "description", order = 21, fontSize = "medium",
					name = L["FullscreenFactionLogoNeutralInfo"],
					hidden = function() return faction~="Neutral"; end
				},

				logo_faction = {
					type = "group", order = 21, inline=true,
					name = "", hidden = function() return faction=="Neutral"; end,
					args = {
						desc_logo = {
							type = "description", order = 21, fontSize = "medium",
							name = L["FullscreenFactionLogoDesc"]
						},

						fullscreenwarning_factionlogo = {
							type = "toggle", order = 22,
							name = ENABLE,
						},

						fullscreenwarning_factionlogo_color = {
							type = "color", order = 23,
							name = COLOR,
							get = function() return unpack(afkfullscreenCharDB.fullscreenwarning_factionlogo_color); end,
							set = function(_,...) afkfullscreenCharDB.fullscreenwarning_factionlogo_color = {...}; end,
						},

						fullscreenwarning_factionlogo_color_reset = {
							type = "execute", order = 24,
							name = L["ColorReset"],
							func = function() afkfullscreenCharDB.fullscreenwarning_factionlogo_color = dbDefaultsChar.fullscreenwarning_factionlogo_color; end
						}
					}
				}
			}
		},

		skins = {
			type = "group", order = 60, inline = true,
			name = L["InfoPanelAppearance"],
			args = {
				infopanel_skin = {
					type = "select", order = 1,
					name = L["InfoPanelSkin"], -- Select a skin
					values = listSkins,
				},
				infopanel_position = {
					type = "select", order = 2,
					name = L["InfoPanelPosition"], -- Panel position
					values = infopanelVertPosition,
				},

				elements = {
					type = "header", order = 10,
					name = L["InfoPanelElements"], -- Info panel elements
				},

				infopanel_playermodel = {
					type = "toggle", order = 11,
					name = L["InfoPanelElementsPortrait"], -- Player portrait
					desc = L["InfoPanelElementsPortraitDesc"]
				},

				infopanel_clockmodel = {
					type = "toggle", order = 12, width = "double",
					name = TIMEMANAGER_TITLE,
					desc = L["InfoPanelElementsClockDesc" .. (WOW_PROJECT_ID==WOW_PROJECT_MAINLINE and "Retail" or "Classic")]
				},

				infopanel_playernamerealm = {
					type = "toggle", order = 13,
					name = L["InfoPanelElementsNameAndRealm"] -- Player name & realm
				},

				infopanel_timedate = {
					type = "toggle", order = 14, width = "double",
					name = L["InfoPanelElementsTimeAndDate"] -- Time & date
				},

				infopanel_textcolor = {
					type = "color", order = 15,
					name = L["InfoPanelElementsTextColor"] -- Text color
				},

				infopanel_resetcolor = {
					type = "execute", order = 16,
					name = L["ColorReset"],
					func = function() afkfullscreenDB.infopanel_textcolor = dbDefaults.infopanel_textcolor; end
				}
			}
		},

		sound = {
			type = "group", order = 100, inline = true, hidden = true, -- coming soon
			name = L["Alert sound options"],
			args = {
				sound_enabled = {
					type = "toggle", order = 1,
					name = L["Enable alert sound"]
				},
				sound_channel = {
					type = "select", order = 2,
					name = L["Select output channel"],
					values=ns.soundChannels
				},
				sound_file = {
					type = "select", order = 3, width = "double",
					name = L["Select alert sound"],
					values=ns.soundFiles,
				}
			}
		},

		credits = {
			type = "group", order = 200, inline = true,
			name = L["Credits"],
			args = {}
		},
	}
};


function ns.dbIntegrityCheck()
	if afkfullscreenDB==nil then
		afkfullscreenDB = {};
	end
	if afkfullscreenCharDB==nil then
		afkfullscreenCharDB = {};
	end

	if faction~="Neutral" then
		dbDefaultsChar.fullscreenwarning_factionlogo_color = {PLAYER_FACTION_COLORS[faction=="Alliance" and 1 or 0]:GetRGB()};
	end

	for i,v in pairs(dbDefaults)do
		if afkfullscreenDB[i] == nil then
			afkfullscreenDB[i] = v;
		end
	end

	for i,v in pairs(dbDefaultsChar)do
		if afkfullscreenCharDB[i] == nil then
			afkfullscreenCharDB[i] = v;
		end
	end

	-- deprecated options
	if afkfullscreenDB.show_fullscreenwarning~=nil then
		afkfullscreenDB.show_fullscreenwarning = nil;
	end
end

function ns.toggleOptions()
	if ACD.OpenFrames[addon]~=nil then
		ACD:Close(addon);
	else
		ACD:Open(addon);
		ACD.OpenFrames[addon]:SetStatusText(GAME_VERSION_LABEL..CHAT_HEADER_SUFFIX.."@project-version@");
	end
end

function ns.registerOptions()
	AC:RegisterOptionsTable(addon, options);
	ACD:AddToBlizOptions(addon);
	ns.AddCredits(options.args.credits.args);
end

function ns.registerSlashCommand()
	SLASH_AFKFSW1 = "/afkfsw"
	SlashCmdList["AFKFSW"] = function(msg)
		ns.toggleOptions();
	end
end
