
local addon,ns = ...;
local L=ns.L;
local AC = LibStub("AceConfig-3.0");
local ACD = LibStub("AceConfigDialog-3.0");
local LDBI = LibStub("LibDBIcon-1.0", true);
local C = WrapTextInColorCode
local Mage = RAID_CLASS_COLORS.MAGE.colorStr;
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
	hide_ui = false,
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
	alarm_overlap = false,
};
local alarm_defaults = {
	sound_enabled = false,
	sound_channel = "1:SFX",
	sound_delay = 0, -- not for the first sound
	sound_source = "file",
	-- values splitted by source to avoid collision in option panel;
	-- it should make it possible to switch between sources without losing the settings for the other sources.
	sound_sm = "", -- LibSharedMedia value
	sound_sk = "", -- SoundKit value
	sound_sk_group = "UI", --SoundKit group value
	sound_file = "1129275", -- file value
	-- sound_list = "", maybe sooner...
	repeat_interval = 2,
	repeat_count = "0",
}
if WOW_PROJECT_ID~=WOW_PROJECT_MAINLINE then
	alarm_defaults.sound_file = "567027"; -- https://www.wowhead.com/classic/sound=7294
	alarm_defaults.repeat_interval = 10;
end
local dbDefaultsChar = {
	fullscreenwarning_factionlogo_color = nil, -- filled by function with faction color
}
local hiddenBySoundSource
do
	local soundObjectKey = {
		sound_sk="sk",
		sound_sk_desc = "sk",
		sound_sk_group = "sk",

		sound_sm="sm",
		sound_sm_desc = "sm",

		sound_file="file",
		sound_file_desc="file",
		sound_file_url1="file",
		sound_file_url1_desc="file",

		--sound_list_group="list",
		--sound_list="list",
		--sound_list_desc="list"
	}
	function hiddenBySoundSource(info)
		local index = tonumber((info[#info-1]:gsub("^alarm::","")));
		local key = soundObjectKey[info[#info]];
		return key and afkfullscreenDB.alarms[index].sound_source and afkfullscreenDB.alarms[index].sound_source~=key;
	end
end
local sound_channels = {
	["0:Master"] = MASTER_VOLUME,
	["1:SFX"] = ENABLE_SOUNDFX,
	--["2:Error"] = ENABLE_ERROR_SPEECH,
	--["3:Emote"] = ENABLE_EMOTE_SOUNDS,
	--["4:Pet"] = ENABLE_PET_SOUNDS,
	["5:Music"] = MUSIC_VOLUME,
	["6:Ambience"] = ENABLE_AMBIENCE,
}
local sound_channels_enabled = {
	["0:Master"] = "Sound_EnableAllSound",
	["1:SFX"] = "Sound_EnableSFX",
	["2:Error"] = "Sound_EnableErrorSpeech",
	["3:Emote"] = "Sound_EnableEmoteSounds",
	["4:Pet"] = "Sound_EnablePetSounds",
	["5:Music"] = "Sound_EnableMusic",
	["6:Ambience"] = "Sound_EnableAmbience",
}
local sound_sources = {
	--list = L["AlertSoundbyList"],
	file = L["AlertSoundByFile"],
	sk = L["AlertSoundBySK"],
	sm = L["AlertSoundBySM"],
}

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
			args = {} -- filled by function
		}
	}
};


local function isSoundDelayDisabled(info)
	return info[#info-1]=="sound1"; -- first sound has no delay
end

local alarms_tpl = {
	info = {
		type = "description", fontSize="medium", order = 1,
		name = L["AlertSoundDesc"]
	},
	alarm_add = {
		type = "execute", order = 2,
		name = ADD or L["AddAlarm"],
		func = function(info)
			-- Create new db entry
			tinsert(afkfullscreenDB.alarms, CopyTable(alarm_defaults));

			-- Refresh UI if open
			if ACD.OpenFrames[addon] then
				ACD:SelectGroup(addon, "alertsound");
			end
		end
	},
	alarm_overlap = {
		type = "toggle", order = 3,
		name = L["AlertSoundAlarmsOverlap"], desc = L["AlertSoundAlarmsOverlap"],
		hidden = function(info)
			return #afkfullscreenDB.alarms<=1;
		end
	}
}

local alarm_tpl = {
	type = "group", order=0, inline = false,
	name = "", -- filled by function
	get = function(info,value)
		local alarmIndex, key = tonumber((info[#info-1]:gsub("^alarm::",""))),info[#info];
		if not alarmIndex then
			alarmIndex = tonumber((info[#info-2]:gsub("^alarm::","")));
		end
		if not (alarmIndex and afkfullscreenDB.alarms[alarmIndex]) then
			return
		end
		if value~=nil then
			afkfullscreenDB.alarms[alarmIndex][key] = value;
			return
		end
		return afkfullscreenDB.alarms[alarmIndex][key];
	end,
	-- set = get
	args = {
		sound_enabled = {
			type = "toggle", order = 1,
			name=ENABLE
		},
		sound_delete = {
			type = "execute", order = 2,
			name=DELETE,
			func = function()
				-- Stop the alarm if it's running
				if ns.AlertSoundStopForAlarm then
					ns.AlertSoundStopForAlarm(index);
				end

				-- Remove from array
				tremove(afkfullscreenDB.alarms, index);

				-- Refresh UI
				if ACD.OpenFrames[addon] then
					ACD:SelectGroup(addon, "alertsound");
				end
			end
		},

		lb1 = {
			type="header",order = 10,
			name=""
		},

		-- output
		sound_channel = {
			type = "select", order = 11,
			name=L["AlertSoundChannel"], desc=L["AlertSoundChannelDesc"],
			values=sound_channels
		},
		ph1 = { type = "description", order=12, name=""},
		sound_delay = {
			type = "range", order = 13, width = "double",
			name=L["AlertSoundDelay"], desc=L["AlertSoundDelayDesc"],
			min=0, max=1800, step=1,
			disabled=isSoundDelayDisabled
		},
		repeat_interval = {
			type = "range", order = 14, width = "double",
			name=L["AlertSoundInterval"], desc=L["AlertSoundIntervalDesc"],
			min=.1, max=300, step=.1,
		},
		repeat_count = {
			type = "input", order = 15, width = "normal",
			name = L["AlertSoundCount"], desc = L["AlertSoundCountDesc"]
		},

		lb2 = {
			type="header",order = 20,
			name=""
		},

		-- source
		sound_source = {
			type = "select", order = 21, --width = "double",
			name = L["AlertSoundSource"], desc = L["AlertSoundSourceDesc"],
			--name = L["AlertSoundChooseFrom"], desc = L["AlertSoundChooseFromDesc"],
			values = sound_sources
		},

		-- LibSharedMedia
		sound_sm = {
			type = "select", order = 22, width = "double",
			name = L["AlertSoundSM"],
			descStyle = "inline",
			values = ns.GetSoundsFromSM,
			hidden = hiddenBySoundSource
		},
		sound_sm_desc = {
			type = "description", order=23, fontSize="medium",
			name = L["AlertSoundSMDesc"],
			hidden = hiddenBySoundSource
		},

		-- SoundKit
		sound_sk_group = {
			type = "select", order = 22, --width = "double",
			name = L["AlertSoundSKGroup"], desc = L["AlertSoundSKGroupDesc"],
			values = ns.GetSoundsFromSK,
			hidden = hiddenBySoundSource
		},
		sound_sk = {
			type = "select", order = 23, width = "double",
			name = L["AlertSoundSK"], --desc = L["AlertSoundSKDesc"],
			values = ns.GetSoundsFromSK,
			hidden = hiddenBySoundSource
		},
		sound_sk_desc = {
			type = "description", order=24, fontSize="medium",
			name = L["AlertSoundSKDesc"],
			hidden = hiddenBySoundSource
		},

		-- File / FileID
		sound_file = {
			type = "input", order = 22, width = "double",
			name = L["AlertSoundFile"],
			hidden = hiddenBySoundSource
		},
		sound_file_desc = {
			type = "description", order=23, fontSize="medium",
			name = L["AlertSoundFileDesc"],
			hidden = hiddenBySoundSource
		},
		sound_file_url1 = {
			type = "input", order = 24, width="double",
			name = L["AlertSoundURL1"],
			get = function() return "https://www.wowhead.com/sounds" end,
			set = function() end,
			hidden = hiddenBySoundSource
		},
		sound_file_url1_desc = {
			type = "description", order = 25, fontSize="medium",
			name = L["AlertSoundURL1Desc"],
			hidden = hiddenBySoundSource
		},

		-- Testing
		sound_test = {
			type = "execute", order = 99,
			name = TEST_STRING_IGNORE_1 or TEST_BUILD or "Test",
			func = function(info)
				local index = tonumber((info[#info-1]:gsub("^alarm::","")))
				ns.AlertSoundStart(index)
			end
		},
		sound_test_info = {
			type = "description", order = 100, fontSize="large", width="double",
			name = function(info)
				local index = tonumber((info[#info-1]:gsub("^alarm::","")));
				local x = {}
				for k,v in pairs(afkfullscreenDB.alarms[index]) do
					tinsert(x,k.."="..tostring(v));
				end
				local master = C_CVar.GetCVar(sound_channels_enabled["0:Master"])=="1";
				local current = C_CVar.GetCVar(sound_channels_enabled[afkfullscreenDB.alarms[index].sound_channel])=="1";
				if not master or not current then
					return L["AlertSoundDisabled"]
				end
				return L["AlertSoundNotFound"];
			end,
			hidden = function()
				return not ns.AlertSoundError;
			end
		},
		--@do-not-package@
		--[=[
		sound_list_group = {
			type = "select", order = 31,
			name = L["AlertSoundSelectGroup"], --desc = L[""],
			values = ns.GetSoundsFromList,
			hidden = hiddenBySoundSource
		},
		sound_list = {
			type = "select", order = 32, --width = "double",
			name = L["AlertSoundSelect"], --desc = L[""],
			values = ns.GetSoundsFromList,
			hidden = hiddenBySoundSource
		},
		--]=]
		--@end-do-not-package@
	}
}
alarm_tpl.set = alarm_tpl.get

function options.args.alertsound.hidden(info)
	if info[#info]~="alertsound" then return end
	options.args.alertsound.args = CopyTable(alarms_tpl);
	local lst = options.args.alertsound.args;

	for index in pairs(afkfullscreenDB.alarms) do
		local k = "alarm::"..index;
		lst[k] = CopyTable(alarm_tpl);
		lst[k].name = L["Alarm"].." "..index;
		lst[k].order = tonumber(index)+10;
	end

	-- switch to tree if more than 7 alarms exists
	options.args.alertsound.childGroups = #afkfullscreenDB.alarms>7 and "tree" or "tab";
end

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

	if type(afkfullscreenDB.alarms)~="table" then
		afkfullscreenDB.alarms = {};
	end

	-- alert sound migration
	if afkfullscreenDB.sound_enabled~=nil and afkfullscreenDB.alarms[1]==nil then
		local t,add = {},false;
		for curKey in pairs(alarm_defaults)do
			local oldKey = curKey=="repeat_interval" and "sound_interval" or curKey;
			if oldKey=="sound_channel" and afkfullscreenDB.sound_channel then
				local a,b = strsplit(":",afkfullscreenDB.sound_channel);
				if a and not b then
					for k in pairs(sound_channels)do
						if k:match(a) then
							afkfullscreenDB.sound_channel = k;
							break;
						end
					end
				end
			end
			if oldKey and curKey then
				t[curKey] = afkfullscreenDB[oldKey] or alarm_defaults[curKey];
				afkfullscreenDB[oldKey] = nil;
				add=true;
			end
		end
		if add then
			afkfullscreenDB.alarms[1] = t;
		end
	end

	-- value check for alarms
	for i=1, #afkfullscreenDB.alarms do
		for key in pairs(alarm_defaults)do
			if afkfullscreenDB.alarms[i][key] == nil then
				afkfullscreenDB.alarms[i][key] = alarm_defaults[key]
			end
		end
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
