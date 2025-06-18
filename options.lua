
local addon,ns = ...;
local L=ns.L;
local AC = LibStub("AceConfig-3.0");
local ACD = LibStub("AceConfigDialog-3.0");
local LDBI = LibStub("LibDBIcon-1.0", true);
local C = WrapTextInColorCode
local Mage = RAID_CLASS_COLORS.MAGE.colorStr;
local soundSources = {file=L["File"],lsm="LibSharedMedia"};
local faction = UnitFactionGroup("player")
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
	infopanel_playerguild = true,
	infopanel_clockmodel = true,
	infopanel_timedate = true,
	infopanel_time = "h",
	infopanel_time2 = "s",
	infopanel_textcolor = {1.0,0.82,0},

	infopanel_skin = "Etherreal",

	--[[ alertsound entries ]]
	sound_enabled = false,
	sound_channel = "SFX",
	sound_interval = 2,
	sound_source = "file",
	sound_sm = "",
	sound_sk = "",
	sound_file = 1129275,
	sound_list = "",
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

local soundObjectKey = {
	sound_sk="sk",
	sound_sk_desc = "sk",

	sound_sm="sm",
	sound_sm_desc = "sm",

	sound_file="file",
	sound_file_desc="file",
	sound_file_url1="file",
	sound_file_url1_desc="file",
}
local function isAlertSoundDisabled()
	return not afkfullscreenDB.sound_enabled;
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

local function hiddenBySoundSource(info)
	local key = soundObjectKey[info[#info]];
	return key and afkfullscreenDB.sound_source and afkfullscreenDB.sound_source~=key;
end

local options = {
	type = "group",
	name = L[addon],
	get = optionsFunc,
	set = optionsFunc,
	childGroups = "tab",
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
			type = "group", order = 20, --inline = true,
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
			type = "group", order = 30, --inline = true,
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

				desc1 = {
					type = "description", order = 11, fontSize = "medium", width="full",
					name = C(L["Graphical Elements"],Mage)
				},

				infopanel_playermodel = {
					type = "toggle", order = 12,
					name = L["InfoPanelElementsPortrait"], -- Player portrait
					desc = L["InfoPanelElementsPortraitDesc"]
				},

				infopanel_clockmodel = {
					type = "toggle", order = 13, width = "double",
					name = TIMEMANAGER_TITLE,
					desc = L["InfoPanelElementsClockDesc" .. (WOW_PROJECT_ID==WOW_PROJECT_MAINLINE and "Retail" or "Classic")]
				},

				desc2 = {
					type = "description", order = 20, fontSize = "medium", width="full",
					name = "|n"..C(L["Text elements on left side"],Mage)
				},

				infopanel_playernamerealm = {
					type = "toggle", order = 22,
					name = L["InfoPanelElementsNameAndRealm"] -- Player name & realm
				},

				infopanel_playerguild = {
					type = "toggle", order = 23,
					name = GUILD, -- Player guild
					disabled = function() return not afkfullscreenDB.infopanel_playernamerealm end
				},

				desc2r = {
					type = "description", order = 24, fontSize = "medium", width="full",
					name = "|n"..C(L["Text elements on right side"],Mage)
				},

				infopanel_timedate = {
					type = "toggle", order = 25, width = "full",
					name = L["InfoPanelElementsTimeAndDate"] -- Time & date
				},

				infopanel_time = {
					type = "select", order = 26,
					name = L["InfoPanelElementsTimeType"], desc = L["InfoPanelElementsTimeTypeDesc"],
					values = {
						--["-"] = NONE,
						["h"] = L["LocalTime"],
						["s"] = L["ServerTime"]
					},
					disabled = function() return not afkfullscreenDB.infopanel_timedate end
				},

				infopanel_time2 = {
					type = "select", order = 27,
					name = L["InfoPanelElementsTime2Type"], desc = L["InfoPanelElementsTimeTypeDesc"].."\n\n"..L["InfoPanelElementsTime2TypeDesc"],
					values = {
						["-"] = NONE,
						["h"] = L["LocalTime"],
						["s"] = L["ServerTime"]
					},
					disabled = function() return not afkfullscreenDB.infopanel_timedate end
				},

				desc3 = {
					type = "description", order = 30, fontSize = "medium", width="full",
					name = "|n"..C(L["Text coloring"],Mage)
				},

				infopanel_textcolor = {
					type = "color", order = 31,
					name = L["InfoPanelElementsTextColor"] -- Text color
				},

				infopanel_resetcolor = {
					type = "execute", order = 32,
					name = L["ColorReset"],
					func = function() afkfullscreenDB.infopanel_textcolor = dbDefaults.infopanel_textcolor; end
				}
			}
		},
		alertsound = {
			type = "group", order = 50, --inline = true, -- coming soon
			name = L["AlertSoundOptions"],
			args = {
				info = {
					type = "description", fontSize="medium", order = 1,
					name = L["AlertSoundDesc"]
				},
				sound_enabled = {
					type = "toggle", order = 2,
					name = ENABLE
				},
				sound_channel = {
					type = "select", order = 3, --width = "double",
					name = L["AlertSoundChannel"], desc = L["AlertSoundChannelDesc"],
					values={
						["0:Master"] = MASTER_VOLUME,
						["1:SFX"] = ENABLE_SOUNDFX,
						--["2:Error"] = ENABLE_ERROR_SPEECH,
						--["3:Emote"] = ENABLE_EMOTE_SOUNDS,
						--["4:Pet"] = ENABLE_PET_SOUNDS,
						["5:Music"] = MUSIC_VOLUME,
						["6:Ambience"] = ENABLE_AMBIENCE,
					},
					disabled = isAlertSoundDisabled,
				},
				sound_interval = {
					type = "range", order = 4, width = "full",
					name = L["AlertSoundInterval"], desc = L["AlertSoundIntervalDesc"],
					min = 0.1, max=300, step=0.02,
					disabled = isAlertSoundDisabled,
				},
				sound_options = {
					type = "group", order = 20, inline = true,
					name = L["AlertSoundChoose"],
					disabled = isAlertSoundDisabled,
					args = {
						sound_source = {
							type = "select", order = 20, --width = "double",
							name = L["AlertSoundSource"], desc = L["AlertSoundSourceDesc"],
							--name = L["AlertSoundChooseFrom"], desc = L["AlertSoundChooseFromDesc"],
							values = {
								--list = L["AlertSoundbyList"],
								file = L["AlertSoundByFile"],
								sk = L["AlertSoundBySK"],
								sm = L["AlertSoundBySM"],
							}
						},

						sound_sm = {
							type = "select", order = 21, width = "double",
							name = L["AlertSoundSM"],
							descStyle = "inline",
							values = ns.GetSoundsFromSM,
							hidden = hiddenBySoundSource
						},
						sound_sm_desc = {
							type = "description", order=22, fontSize="medium",
							name = L["AlertSoundSMDesc"],
							hidden = hiddenBySoundSource
						},

						sound_sk = {
							type = "select", order = 21, width = "double",
							name = L["AlertSoundSK"], desc = L["AlertSoundSK"],
							values = ns.GetSoundsFromSK,
							hidden = hiddenBySoundSource
						},
						sound_sk_desc = {
							type = "description", order=22, fontSize="medium",
							name = L["AlertSoundSKDesc"],
							hidden = hiddenBySoundSource
						},

						sound_file = {
							type = "input", order = 21, width = "double",
							name = L["AlertSoundFile"],
							hidden = hiddenBySoundSource
						},
						sound_file_desc = {
							type = "description", order=22, fontSize="medium",
							name = L["AlertSoundFileDesc"],
							hidden = hiddenBySoundSource
						},
						sound_file_url1 = {
							type = "input", order = 23, width="double",
							name = L["AlertSoundURL1"],
							get = function() return "https://www.wowhead.com/sounds" end,
							set = function() end,
							hidden = hiddenBySoundSource
						},
						sound_file_url1_desc = {
							type = "description", order = 24, fontSize="medium",
							name = L["AlertSoundURL1Desc"],
							hidden = hiddenBySoundSource
						},

						sound_test = {
							type = "execute", order = 99,
							name = TEST_STRING_IGNORE_1,
							func = ns.AlertSoundStart
						},
						sound_test_info = {
							type = "description", order = 100, fontSize="large", width="double",
							name = L["AlertSoundNotFound"],
							hidden = function()
								return not ns.AlertSound404;
							end
						},
--@do-not-package@
						--[[
						sound_list_group = {
							type = "select", order = 21,
							name = L["AlertSoundSelectGroup"], --desc = L[""],
							values = ns.GetSoundsFromList,
							hidden = hiddenBySoundSource
						},
						sound_list = {
							type = "select", order = 22, --width = "double",
							name = L["AlertSoundSelect"], --desc = L[""],
							values = ns.GetSoundsFromList,
							hidden = hiddenBySoundSource
						},
						--]]
--@end-do-not-package@
					}
				}
			}
		}
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
	local opts = ACD:AddToBlizOptions(addon);
	LibStub("HizurosSharedTools").BlizzOptions_ExpandOnShow(opts);
	LibStub("HizurosSharedTools").AddCredit(addon);
end

function ns.registerSlashCommand()
	SLASH_AFKFSW1 = "/afkfsw"
	SlashCmdList["AFKFSW"] = function(msg)
		ns.toggleOptions();
	end
end
