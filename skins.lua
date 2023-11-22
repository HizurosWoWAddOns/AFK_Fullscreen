
local addon, ns = ...;
local media = "Interface\\AddOns\\"..addon.."\\media\\";


ns.panelSkins = {}
	--[=[
ns.panelSkins["<SkinName>"] = {
		"<Background model>",
		"<Background layer1>",
		"<Background layer2>",
		"<Background layer3>",

		"<BorderEdge TopLeft>",
		"<BorderEdge TopRight>",
		"<BorderEdge BottomLeft>",
		"<BorderEdge BottomRight>",

		"<Border Top>",
		"<Border Bottom>",
		"<Border Left>",
		"<Border Right>",

		"<Overlay texture>",

		"<Shadow inset>",
		"<Shadow outset>",
	},
	--]=]

ns.panelSkins["Etherreal"] = {
	"nil","Texture:"..media.."UI-Background-Marble;HTile:true;VTile:true;Alpha:0.8;Scale:0.62","Color:0.302,0.102,0.204,0.5","Texture:"..media.."EtherealLines;HTile:true;VTile:true;Alpha:.8",
	"nil","nil","nil","nil",
	"Texture:"..media.."HorizontalTiles;Width:64;Height:23;Coords:0,1,0.015625,0.375;Y:23;HTile:true","Texture:"..media.."HorizontalTiles;Width:64;Height:23;Coords:0,1,0.40625,0.765625;Y:23;HTile:true",
	"nil","nil",
	"nil",
	"Show:true;H:16","Show:true;Y:12",
}
ns.panelSkins["SimpleBlack"] = {
	"nil","Texture:"..media.."UI-DialogBox-Background-Dark;Scale:1","nil","nil",
	"nil","nil","nil","nil",
	"nil","nil","nil","nil",
	"nil",
	"Show:false","Show:true;H:16;Y:2"
}
ns.panelSkins["Silvermoon Grass"] = {
	"nil","Texture:"..media.."BM_SLVRMN_GRASS01;Scale:.546875","nil","nil",
	"nil","nil","nil","nil",
	"nil","nil","nil","nil",
	"nil",
	"Show:true;H:16","Show:false"
}
ns.panelSkins["Parchment"] = {
	"nil","Texture:"..media.."FontStyleParchment;Scale:0.546875","nil","nil",
	"nil","nil","nil","nil",
	"nil","nil","nil","nil",
	"nil",
	"Show:false","Show:true;H:24"
}
ns.panelSkins["GuildBankFrameLike"] = {
	"nil","Texture:"..media.."UI-GuildBankFrame-Left-mod;Scale:1","nil","nil",
	"nil","nil","nil","nil",
	"nil","nil","nil","nil",
	"nil",
	"Show:false","Show:true;H:24"
}

if WOW_PROJECT_ID==WOW_PROJECT_MAINLINE then
	--[[
	-- unstable
	ns.panelSkins["Barbershop"] = {
		"nil","Texture:"..media.."Barbershop-mod;Scale:0.58091286307054;H:241","nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"Texture:"..media.."Barbershop-mod;Coords:0,0.1875,0.470703125,1;W:55.767634854772;H:157.42738589212",
		"Texture:"..media.."Barbershop-mod;Coords:0.220703125,0.408203125,0.470703125,1;W:96;H:271",
		"nil",
		"Show:false","Show:true;H:24"
	}
	--]]
	ns.panelSkins["GarrisonReport"] = { -- wod
		"nil","Atlas:GarrLanding-MiddleTile;HTile:false;Scale:1","nil","nil",
		"nil","nil","nil","nil",
		"Atlas:GarrLanding-Top;Y:9;Scale:1","Atlas:GarLanding-Bottom;Y:10",
		"nil","nil",
		"nil",
		"Show:false","Show:true;h:16;Y:-14"
	}
	ns.panelSkins["Dalaran Ornament"] = { -- woltk
		--"nil","Texture:world\\expansion06\\doodads\\dalaran\\dal2_mural;Scale:.25","nil","nil",
		"nil","Texture:1373396;Scale:.25","nil","nil",
		"nil","nil","nil","nil",
		"nil","nil","nil","nil",
		"nil",
		"Show:false","Show:true;H:24"
	}
	ns.panelSkins["Draktaron Wall 1"] = { -- woltk
		--"nil","Texture:World\\Expansion02\\Doodads\\ZULDRAK\\TrollRuins\\DRAK_WALL_DARK;Scale:.546875","nil","nil",
		"nil","Texture:196826;Scale:.546875","nil","nil",
		"nil","nil","nil","nil",
		"nil","nil","nil","nil",
		"nil",
		"Show:false","Show:true;H:24"
	}
	ns.panelSkins["Serpentine Bazaar 1"] = { -- bfa
		--"nil","Texture:world\\expansion07\\doodads\\serpentine\\8se_serpentine_bazaar_cloth01;Scale:.2","nil","nil",
		"nil","Texture:1596444;Scale:.2","nil","nil",
		"nil","nil","nil","nil",
		"nil","nil","nil","nil",
		"nil",
		"Show:false","Show:true;H:24"

	}
	ns.panelSkins["Serpentine Bazaar 2"] = { -- bfa
		--"nil","Texture:world\\expansion07\\doodads\\serpentine\\8se_serpentine_bazaar_cloth01b;Scale:.2","nil","nil",
		"nil","Texture:1601639;Scale:.2","nil","nil",
		"nil","nil","nil","nil",
		"nil","nil","nil","nil",
		"nil",
		"Show:false","Show:true;H:24"
	}
	ns.panelSkins["Suramar"] = { -- legion
		--"nil","Texture:World\\Expansion06\\Doodads\\Dungeon\\Doodads\\7NE_NightElf_Curb_Set03_Suramar2;Scale:.2734375","nil","nil",
		"nil","Texture:1408791;Scale:.2734375","nil","nil",
		"nil","nil","nil","nil",
		"nil","nil","nil","nil",
		"nil",
		"Show:false","Show:true;H:24"
	}
end
