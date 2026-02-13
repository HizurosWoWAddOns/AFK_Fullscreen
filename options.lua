
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
	alarms = {},
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
		elseif type(value)=="string" then
			-- remove whitespaces
			local v = nil;
			v = tonumber(value);
			if not v then
				v = strtrim(value);
			end
			value = v;
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
			type = "group", order = 50,
			name = L["AlertSoundOptions"],
			childGroups = "tree",
			args = {} -- Will be populated dynamically in registerOptions
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

	-- Migration: Convert old single alarm structure to new multi-alarm array
	if afkfullscreenDB.sound_enabled~=nil or afkfullscreenDB.sound_interval~=nil then
		-- Old structure detected, migrate to new format
		local oldAlarm = {
			enabled = afkfullscreenDB.sound_enabled or false,
			sound_source = afkfullscreenDB.sound_source or "file",
			sound_value = nil,
			delay = afkfullscreenDB.sound_delay or 0,
			repeat_count = 0, -- old system was infinite
			repeat_interval = afkfullscreenDB.sound_interval or 2,
			channel = afkfullscreenDB.sound_channel or "1:SFX",
		};

		-- Get the sound value from the appropriate source
		if oldAlarm.sound_source == "file" then
			oldAlarm.sound_value = afkfullscreenDB.sound_file or 1129275;
		elseif oldAlarm.sound_source == "sk" then
			oldAlarm.sound_value = afkfullscreenDB.sound_sk or "";
		elseif oldAlarm.sound_source == "sm" then
			oldAlarm.sound_value = afkfullscreenDB.sound_sm or "";
		end

		-- Add as first alarm
		afkfullscreenDB.alarms = {oldAlarm};

		-- Clean up old settings
		afkfullscreenDB.sound_enabled = nil;
		afkfullscreenDB.sound_interval = nil;
		afkfullscreenDB.sound_delay = nil;
		afkfullscreenDB.sound_source = nil;
		afkfullscreenDB.sound_file = nil;
		afkfullscreenDB.sound_sk = nil;
		afkfullscreenDB.sound_sm = nil;
		afkfullscreenDB.sound_list = nil;
		-- Keep sound_channel as it might be used elsewhere
	end

	-- Ensure alarms table exists and is an array
	if type(afkfullscreenDB.alarms) ~= "table" then
		afkfullscreenDB.alarms = {};
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
	-- Build dynamic alarm options
	local function buildAlarmOptions()
		local args = {
			info = {
				type = "description", fontSize="medium", order = 1,
				name = L["AlertSoundDesc"]
			},
			add_alarm = {
				type = "execute", order = 2,
				name = L["AddAlarm"],
				func = function()
					local newAlarm = {
						enabled = true,
						sound_source = "file",
						sound_value = 1129275,
						delay = 0,
						repeat_count = 0,
						repeat_interval = 2,
						channel = "1:SFX",
					};
					tinsert(afkfullscreenDB.alarms, newAlarm);
					-- Rebuild options
					buildAlarmOptions();
					AC:RegisterOptionsTable(addon, options);
					-- Refresh UI if open
					if ACD.OpenFrames[addon] then
						ACD:SelectGroup(addon, "alertsound");
					end
				end
			},
			no_alarms = {
				type = "description", fontSize="large", order = 3,
				name = L["NoAlarmsConfigured"],
				hidden = function() return #afkfullscreenDB.alarms > 0 end
			}
		};

		-- Generate options for each alarm
		for i = 1, #afkfullscreenDB.alarms do
			local alarmKey = "alarm_" .. i;
			args[alarmKey] = {
				type = "group",
				order = 10 + i,
				name = L["Alarm"] .. " " .. i,
				args = {
					enabled = {
						type = "toggle", order = 1,
						name = ENABLE,
						get = function() return afkfullscreenDB.alarms[i].enabled end,
						set = function(_, value) afkfullscreenDB.alarms[i].enabled = value end
					},
					remove = {
						type = "execute", order = 2,
						name = L["RemoveAlarm"],
						confirm = true,
						func = function()
							-- Stop the alarm if it's running
							if ns.AlertSoundStopForAlarm then
								ns.AlertSoundStopForAlarm(i);
							end
							-- Remove from array
							tremove(afkfullscreenDB.alarms, i);
							-- Rebuild options
							buildAlarmOptions();
							AC:RegisterOptionsTable(addon, options);
							-- Refresh UI
							if ACD.OpenFrames[addon] then
								ACD:SelectGroup(addon, "alertsound");
							end
						end
					},
					channel = {
						type = "select", order = 10, width = "double",
						name = L["AlertSoundChannel"],
						desc = L["AlertSoundChannelDesc"],
						values = {
							["0:Master"] = MASTER_VOLUME,
							["1:SFX"] = ENABLE_SOUNDFX,
							["5:Music"] = MUSIC_VOLUME,
							["6:Ambience"] = ENABLE_AMBIENCE,
						},
						get = function() return afkfullscreenDB.alarms[i].channel end,
						set = function(_, value) afkfullscreenDB.alarms[i].channel = value end
					},
					sound_source = {
						type = "select", order = 20, width = "double",
						name = L["AlertSoundSource"],
						desc = L["AlertSoundSourceDesc"],
						values = {
							file = L["AlertSoundByFile"],
							sk = L["AlertSoundBySK"],
							sm = L["AlertSoundBySM"],
						},
						get = function() return afkfullscreenDB.alarms[i].sound_source end,
						set = function(_, value) afkfullscreenDB.alarms[i].sound_source = value end
					},
					sound_value_file = {
						type = "input", order = 21, width = "double",
						name = L["AlertSoundFile"],
						desc = L["AlertSoundFileDesc"],
						get = function() return tostring(afkfullscreenDB.alarms[i].sound_value or "") end,
						set = function(_, value)
							local v = tonumber(value) or strtrim(value);
							afkfullscreenDB.alarms[i].sound_value = v;
						end,
						hidden = function() return afkfullscreenDB.alarms[i].sound_source ~= "file" end
					},
					sound_file_url1 = {
						type = "input", order = 22, width="double",
						name = L["AlertSoundURL1"],
						desc = L["AlertSoundURL1Desc"],
						get = function() return "https://www.wowhead.com/sounds" end,
						set = function() end,
						hidden = function() return afkfullscreenDB.alarms[i].sound_source ~= "file" end
					},
					sound_value_sk = {
						type = "select", order = 21, width = "double",
						name = L["AlertSoundSK"],
						desc = L["AlertSoundSKDesc"],
						values = ns.GetSoundsFromSK,
						get = function() return afkfullscreenDB.alarms[i].sound_value end,
						set = function(_, value) afkfullscreenDB.alarms[i].sound_value = value end,
						hidden = function() return afkfullscreenDB.alarms[i].sound_source ~= "sk" end
					},
					sound_value_sm = {
						type = "select", order = 21, width = "double",
						name = L["AlertSoundSM"],
						desc = L["AlertSoundSMDesc"],
						values = ns.GetSoundsFromSM,
						get = function() return afkfullscreenDB.alarms[i].sound_value end,
						set = function(_, value) afkfullscreenDB.alarms[i].sound_value = value end,
						hidden = function() return afkfullscreenDB.alarms[i].sound_source ~= "sm" end
					},
					test = {
						type = "execute", order = 30,
						name = TEST_STRING_IGNORE_1 or TEST_BUILD or "Test",
						func = function() ns.AlertSoundStart(i) end
					},
					delay = {
						type = "range", order = 40, width = "full",
						name = L["AlertSoundDelay"],
						desc = L["AlertSoundDelayDesc"],
						min = 0, max = 1800, step = 1,
						get = function() return afkfullscreenDB.alarms[i].delay end,
						set = function(_, value) afkfullscreenDB.alarms[i].delay = value end
					},
					repeat_count = {
						type = "input", order = 50,
						name = L["RepeatCount"],
						desc = L["RepeatCountDesc"],
						get = function() return tostring(afkfullscreenDB.alarms[i].repeat_count or 0) end,
						set = function(_, value)
							local v = tonumber(value) or 0;
							if v < 0 then v = 0 end
							afkfullscreenDB.alarms[i].repeat_count = v;
						end
					},
					repeat_interval = {
						type = "range", order = 51, width = "full",
						name = L["RepeatInterval"],
						desc = L["RepeatIntervalDesc"],
						min = 0.1, max = 300, step = 0.1,
						get = function() return afkfullscreenDB.alarms[i].repeat_interval end,
						set = function(_, value) afkfullscreenDB.alarms[i].repeat_interval = value end
					},
					test_info = {
						type = "description", order = 100, fontSize="large", width="double",
						name = L["AlertSoundNotFound"],
						hidden = function() return not ns.AlertSound404 end
					}
				}
			};
		end

		options.args.alertsound.args = args;
	end

	-- Build the options
	buildAlarmOptions();

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
