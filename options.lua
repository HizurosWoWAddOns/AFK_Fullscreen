
local addon,ns = ...;
local L=ns.L;
local AC = LibStub("AceConfig-3.0");
local ACD = LibStub("AceConfigDialog-3.0");
local LDBI = LibStub("LibDBIcon-1.0", true);
local soundSources = {file=L["File"],lsm="LibSharedMedia"};
ns.soundChannels = {};
ns.soundFiles = {customfile=L["Use custom file"]};
local fullscreen_textures = {
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
local dbDefaults = {
	hide_ui = true,
	show_addonloaded = true,

	--[[ fullscreenwarning entries ]]
	show_fullscreenwarning = true,
	fullscreenwarning_color = {1,.5,0,1},
	fullscreenwarning_texture = "border1",

	--[[ infopanel entries ]]
	infopanel_position = "middle",

	infopanel_playermodel = true,
	infopanel_playernamerealm = true,
	infopanel_clockmodel = true,
	infopanel_timedate = true,

	infopanel_skin = "Etherreal",

	--[[ alertsound entries ]]
	sound_enabled = false,
	sound_channel = "master",
	sound_file = "",
};

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
	local key, value = info[#info], ...;
	if key == "minimap" then
		if value~=nil then
			afkfullscreenDB.Minimap.hide = not value;
			LDBI:Refresh(addon);
		end
		return not afkfullscreenDB.Minimap.hide;
	elseif key:match("_color$") then
		if value~=nil then
			afkfullscreenDB[key] = {...};
		else
			return unpack(afkfullscreenDB[key] or {});
		end
	else
		if value~=nil then
			afkfullscreenDB[key] = value;
		end
		return afkfullscreenDB[key];
	end
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
			name = L["Minimap button"]
		},

		show_addonloaded = {
			type = "toggle", order = 2,
			name = L["AddOn loaded..."], desc = L["Show 'AddOn loaded...' message on login"]
		},

		demo = {
			type = "execute", order = 3,
			name = L["Show demo"], desc = L["Display a little demo frame to show a selected skin"],
			func = function() AFKFullscreenDemoFrame:SetShown(not AFKFullscreenDemoFrame:IsShown()); end
		},

		fullscreen = {
			type = "group", order = 20, inline = true,
			name = L["Fullscreen options"],
			args = {
				hide_ui = {
					type = "toggle", order = 1, width = "full",
					name = L["Hide UI"], desc = L["Hide user interface on AFK"]
				},

				show_fullscreenwarning = {
					type = "toggle", order = 2,
					name = L["Fullscreen warning"]
				},

				fullscreenwarning_texture = {
					type = "select", order = 3, width = "double",
					name = L["Fullscreen texture"], desc = L["Choose texture for fullscreen warning"],
					values = fullscreen_textures
				},

				fullscreenwarning_color = {
					type = "color", order = 4,
					name = L["Color"],
				},

				fullscreenwarning_color_reset = {
					type = "execute", order = 5,
					name = L["Reset color"],
					func = function() afkfullscreenDB.fullscreenwarning_color = dbDefaults.fullscreenwarning_color; end
				}
			}
		},

		elements = {
			type = "group", order = 40, inline = true,
			name = L["Info panel elements"],
			args = {
				infopanel_playermodel = {
					type = "toggle", order = 1,
					name = L["Player portrait"]
				},

				infopanel_playernamerealm = {
					type = "toggle", order = 2, width = "double",
					name = L["Player name & realm"]
				},

				infopanel_clockmodel = {
					type = "toggle", order = 3,
					name = L["Clock animation"]
				},

				infopanel_timedate = {
					type = "toggle", order = 4, width = "double",
					name = L["Time & date"]
				},
			}
		},

		skins = {
			type = "group", order = 60, inline = true,
			name = L["Info panel skins"],
			args = {
				infopanel_skin = {
					type = "select", order = 1,
					name = L["Select a skin"],
					values = listSkins,
					get = function() return afkfullscreenDB.infopanel_skin; end,
					set = function(_,v)
						afkfullscreenDB.infopanel_skin=v;
						if AFKFullscreenDemoFrame:IsShown() then
							AFKFullscreenDemoFrame:Hide();
							C_Timer.After(0.2,function()
								AFKFullscreenDemoFrame:Show();
							end);
						end
					end
				},
				infopanel_position = {
					type = "select", order = 2,
					name = L["Panel position"],
					values = infopanelVertPosition,
				},
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
		}
	}
};


function ns.dbIntegrityCheck()
	if afkfullscreenDB==nil then
		afkfullscreenDB = {};
	end

	-- migration
	if afkfullscreenDB.select_skin~=nil then
		afkfullscreenDB.infopanel_skin = afkfullscreenDB.select_skin;
		afkfullscreenDB.select_skin = nil;
	end
	-- /migration

	for i,v in pairs(dbDefaults)do
		if afkfullscreenDB[i] == nil then
			afkfullscreenDB[i] = v;
		end
	end
end

function ns.toggleOptions()
	if ACD.OpenFrames[addon]~=nil then
		ACD:Close(addon);
	else
		ACD:Open(addon);
		ACD.OpenFrames[addon]:SetStatusText(GAME_VERSION_LABEL..": "..GetAddOnMetadata(addon,"Version"));
	end
end

function ns.registerOptions()
	AC:RegisterOptionsTable(addon, options);
	ACD:AddToBlizOptions(addon);
end

function ns.registerSlashCommand()
	SLASH_AFKFSW1 = "/afkfsw"
	SlashCmdList["AFKFSW"] = function(msg)
		ns.toggleOptions();
	end
end
