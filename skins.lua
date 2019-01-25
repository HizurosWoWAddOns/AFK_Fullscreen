
local addon, ns = ...;

ns.fullscreenModels = {
	["Sky3"] = "Model:ENVIRONMENTS\\STARS\\DalaranSkyBox.m2",
	["Sky6"] = "Model:environments\\stars\\general_legionskybox01.m2",
	["Sky7"] = "Model:environments\\stars\\legion_invasionskybox01.m2",
	["Sky8"] = "Model:environments\\stars\\legionnexus_volcanoskybox01.m2", -- good sky...
	["Sky9"] = "Model:Environments\\Stars\\LostIsleVocanoSkyBox.M2", -- gray\orange
};

ns.panelSkins = {
	--[=[
	["<SkinName>"] = {
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
	["GarrisonReport"] = {
		"nil","Atlas:GarrLanding-MiddleTile;HTile:false;Scale:1","nil","nil",
		"nil","nil",
		"nil","nil",
		"Atlas:GarrLanding-Top;Y:9;Scale:1","Atlas:GarLanding-Bottom;Y:10",
		"nil","nil",
		"nil",
		"Show:false","Show:true;h:16;Y:-14"
	},
	["Etherreal"] = {
		"nil","Texture:Interface\\FrameGeneral\\UI-Background-Marble;HTile:true;VTile:true;Alpha:0.8;Scale:0.62","Color:0.302,0.102,0.204,0.5","Texture:Interface\\Transmogrify\\EtherealLines;HTile:true;VTile:true;Alpha:.8",
		"nil","nil",
		"nil","nil",
		"Texture:Interface\\Transmogrify\\HorizontalTiles;Width:64;Height:23;Coords:0,1,0.015625,0.375;Y:23;HTile:true","Texture:Interface\\Transmogrify\\HorizontalTiles;Width:64;Height:23;Coords:0,1,0.40625,0.765625;Y:23;HTile:true",
		"nil","nil",
		"nil",
		"Show:true;H:16","Show:true;Y:12",
	},
	["SimpleBlack"] = {
		"nil","Texture:Interface\\DialogFrame\\UI-DialogBox-Background-Dark;Scale:1","nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil",
		"Show:false","Show:true;H:16;Y:2"
	},
	["Draktaron Wall 1"] = {
		"nil","Texture:World\\Expansion02\\Doodads\\ZULDRAK\\TrollRuins\\DRAK_WALL_DARK;Scale:.546875","nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil",
		"Show:false","Show:true;H:24"
	},
	--[[
	["Books1"] = {
		"nil","Texture:World\\ENVIRONMENT\\DOODAD\\DALARAN\\INSCRIPTIONSHOP\\INSCRIPTIONBOOKSHELVES01;Scale:.546875","nil","nil",
		"nil","nil",
		"nil","nil",
		"Texture:Interface\\vehicles\\UI-Vehicles-Elements-Nature;Coords:0,1,.6484375,1;H:24;HTile:true;Y:23","Texture:Interface\\vehicles\\UI-Vehicles-Elements-Nature;Coords:0,1,.6484375,1;H:24;HTile:true;Y:23",
		"nil","nil",
		"nil",
		"Show:true;H:24","Show:true;H:24;Y:23"
	},
	--]]
	["Silvermoon Grass"] = {
		"nil","Texture:Dungeons\\TEXTURES\\SILVERMOONCITY\\BM_SLVRMN_GRASS01;Scale:.546875","nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil",
		"Show:true;H:16","Show:false"
	},

	-- ["?"] = "nil|Texture:World\\Expansion06\\Doodads\\Dungeon\\Doodads\\7NE_NightElf_Curb_Set03_Suramar2;Scale:.2734375|nil|nil|nil|nil|nil|nil|Texture:World\\Expansion02\\Doodads\\Nexus\\NEXUS_DRAGONORB;Coords:0,1,0.2421875,0.4921875;H:64;HTile:true;Y:64;Scale:.375|Texture:World\\Expansion02\\Doodads\\Nexus\\NEXUS_DRAGONORB;Coords:0,1,0.2421875,0.4921875;H:64;HTile:true;Y:64;|nil|nil|nil|Show:false|Show:true;H:16;Y:2",


	-- Interface\\vehicles\\UI-Vehicles-Elements-Nature
	-- Dungeons\\TEXTURES\\FLOOR\\KG_KZN_TRANSITION_FLOOR
	-- Dungeons\\TEXTURES\\SILVERMOONCITY\\BM_SLVRMN_GRASS01

	-- ["BlackMarket"] = ""
	["Suramar"] = {
		"nil","Texture:World\\Expansion06\\Doodads\\Dungeon\\Doodads\\7NE_NightElf_Curb_Set03_Suramar2;Scale:.2734375","nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil",
		"Show:false","Show:true;H:24"
	},

	["Serpentine Bazaar 1"] = {
		"nil","Texture:world\\expansion07\\doodads\\serpentine\\8se_serpentine_bazaar_cloth01;Scale:.2","nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil",
		"Show:false","Show:true;H:24"

	},

	["Serpentine Bazaar 2"] = {
		"nil","Texture:world\\expansion07\\doodads\\serpentine\\8se_serpentine_bazaar_cloth01b;Scale:.2","nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil",
		"Show:false","Show:true;H:24"
	},

	["Dalaran Ornament"] = {
		"nil","Texture:world\\expansion06\\doodads\\dalaran\\dal2_mural;Scale:.25","nil","nil",
		-- 1024/560
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil","nil",
		"nil",
		"Show:false","Show:true;H:24"
	},
};

--[=[

	xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2
	256;256;0;166;


	Interface\\vehicles\\UI-Vehicles-Elements-Nature
		size 256, 256
		ULx 0
		ULy .6484375
		LLx 1
		LLy 1
		URx
		URy
		LRx
		LRy

0,.6484375,0,1,1,.6484375,1,1

ULx - Upper left corner X position, as a fraction of the image's width from the left (number)
ULy - Upper left corner Y position, as a fraction of the image's height from the top (number)
LLx - Lower left corner X position, as a fraction of the image's width from the left (number)
LLy - Lower left corner Y position, as a fraction of the image's height from the top (number)
URx - Upper right corner X position, as a fraction of the image's width from the left (number)
URy - Upper right corner Y position, as a fraction of the image's height from the top (number)
LRx - Lower right corner X position, as a fraction of the image's width from the left (number)
LRy - Lower right corner Y position, as a fraction of the image's height from the top (number)


	file="Interface\common\search"
	<TexCoords left="0" right="1" top="0.4609375" bottom="0.671875"\>
	<TexCoords left="0" right="0.5" top="0.0078125" bottom="0.21875"\>
	<TexCoords left="0" right="0.5" top="0.0078125" bottom="0.21875"\>
	<TexCoords left="0.15" right="0.85" top="0.234375" bottom="0.4453125"\>
	<TexCoords left="0.0078125" right="0.9921875" top="0.4609375" bottom="0.671875"\>

	--

	other ideas...
		\LFGFRAME\UI-LFG-DUNGEONTOAST
		\Garrison\GarrisonLadingPage
		\Store\store-main
		\TalentFrame\spec-blue-bg
		\TalentFrame\spec-lock^
		\transmogrify\HorizontalTiles
		\vehicles\UI-Vehicles-Elements-Nature
		\vehicles\ui-vehicles-endcap
	some playerActionBarAlt texture are interesting ^^

	\vehicles\UI-Vehicles-FuelTank-Nature ( fuel running out = kick )
	\Calendar\CalendarEventBackground


World\AZEROTH\Elwynn\PassiveDoodads\Ballista\BALISTAWOOD03
World\AZEROTH\DUSKWOOD\PASSIVEDOODADS\Warpgate\RockWall03
World\AZEROTH\Stranglethorn\PASSIVEDOODADS\BRIDGE\StranglethornWoodBridge
World\AZEROTH\Stranglethorn\PASSIVEDOODADS\Rope03
World\Dreaming\PassiveDoodads\TREES\EMERALDDREAMWATERFALL
World\Dungeon\CAVERNSOFTIME\PassiveDoodads\HOURGLASS\COT_HOURGLASSSAND
World\Dungeon\WellofEternity\WOE_Water01
World\ENVIRONMENT\BUILDING\STRANGLETHORN\OILREFINERY\TEXTURE\JOSE\OILREFINERYEXTERIOR
World\ENVIRONMENT\DOODAD\6.0\FROSTWIND\ROCKS\TEXTURE\6FW_WMOROCKLAVA_03
World\ENVIRONMENT\DOODAD\6.0\FROSTWIND\ROCKS\TEXTURE\6FW_WMOVOLCANOROCK_03
World\ENVIRONMENT\DOODAD\6.0\SPIRESOFARRAK\ROCKS\TEXTURES\6SA_ROCK01
World\ENVIRONMENT\DOODAD\7.0\VALSHARAH\TREES\TEXTURE\7VS_LORETREE_BARK_01
World\ENVIRONMENT\DOODAD\BARRENS\RAZORFEN_CANOPIES\TEXTURE\GARY\GARYRAZORFENCANOPY_02
World\ENVIRONMENT\DOODAD\BLOODELVES\BLOODELFDESTROYER\BE_DESTROYER_SIDE
World\ENVIRONMENT\DOODAD\BLOODELVES\BLOODELFDESTROYER\BE_DESTROYER_SIDE02
World\ENVIRONMENT\DOODAD\BLOODELVES\BLOODELFDESTROYER\BE_DESTROYER_SIDE03
World\ENVIRONMENT\DOODAD\BURNINGLEGION\7.0_LEGION\LEGION_ANVIL\7LG_LEGION_GATEWAY_TRIM_DETAILS
World\ENVIRONMENT\DOODAD\DALARAN\INSCRIPTIONSHOP\INSCRIPTIONBOOKSHELVES01
World\ENVIRONMENT\DOODAD\FIRELANDS\FLOATINGROCKS\TEXTURE\FIRELANDS_FLOATINGROCK02
World\ENVIRONMENT\DOODAD\FIRELANDS\BRIDGE\FIRELANDSBRIDE_LAVAFLOWTALL
World\ENVIRONMENT\DOODAD\DUSKWOOD\BRIDGE\TEX\BRIDGEWEEDS
World\ENVIRONMENT\DOODAD\NAGRAND\ROCKSFLOATING\NAGRAND_ROCKFLOATING_GRASSSIDES
World\ENVIRONMENT\DOODAD\TANARIS\TEXTURES\TANARISRUINWALL_01
World\ENVIRONMENT\DOODAD\WORGEN\MINECAR\WORGEN_COAL
World\EXPANSION01\DOODADS\GENERIC\BLOODELF\BEDS\BE_Bed_02
World\EXPANSION01\DOODADS\GENERIC\BLOODELF\BEDS\BE_Bed_01
World\EXPANSION01\DOODADS\GENERIC\BLOODELF\SHROOMS\GhostlandsShroomTop01
World\EXPANSION01\DOODADS\GENERIC\BLOODELF\TRANSLOCATOR\BE_LOWERSTEP
World\EXPANSION01\DOODADS\GENERIC\DRAENEI\Cables\draenei_wire
World\EXPANSION01\DOODADS\GENERIC\DRAENEI\TEMPESTKEEP\BRIDGE_TRIM_ALPHA
World\EXPANSION01\DOODADS\HellfirePeninsula\Rocks\hellfirerocks_002
World\EXPANSION01\DOODADS\HellfirePeninsula\RocksFloating\hellfirerocks_003
World\EXPANSION01\DOODADS\NETHERSTORM\COLLECTORTOP\NetherstormStream01
World\EXPANSION01\DOODADS\SHATTRATH\PASSIVEDOODADS\CRYSTAL_TOPS\CAUSTIC.12
World\EXPANSION01\DOODADS\Sunwell\Passivedoodads\Sunwell\SUNWELL_GRATE_TRIM
World\EXPANSION01\DOODADS\TEROKKAR\SHRINE\JS_Shrine_trim_01
World\EXPANSION01\DOODADS\TEROKKAR\Bomb\BE_ARCANEBOMB_DIFFUSE
World\Expansion02\Doodads\IceCrown\Chains\jj_Frostmourne_Ice_Chain
World\Expansion02\Doodads\IceCrown\Altar\IceCrown_FrostmourneAltar_02
World\Expansion02\Doodads\IceCrown\Bones\IceCrown_Bonepile_01
World\Expansion02\Doodads\IceCrown\Bones\IceCrown_Bonepile_02
World\Expansion02\Doodads\IceCrown\Doors\IceCrown_Door_01
World\Expansion02\Doodads\Nexus\NEXUS_DRAGONORB
World\Expansion02\Doodads\Nexus\Nexus_Hanging_Beads_Wire_01
World\Expansion02\Doodads\Ulduar\UL_MalfurionFunnel02
World\Expansion02\Doodads\ZULDRAK\TrollRuins\DRAK_WALL_DARK
World\Expansion02\Doodads\ZULDRAK\TrollRuins\DRAK_WALL_PANELS
World\Expansion03\Doodads\Firelands\FireWaterfalls\Firelands_LavaWaterFalls_01
World\Expansion03\Doodads\Firelands\MiniVolcano_Doodad\sc_MiniVolcano_01
World\Expansion03\Doodads\Generic\ash_wood01
World\Expansion03\Doodads\Firelands\Ragnaros_Firewall\Hammercracks
World\Expansion03\Doodads\Gilneas\Trees\DarkForest_Tree_011
World\Expansion03\Doodads\LOSTISLES\Trees\LostIsles_MammothTree02
World\Expansion03\Doodads\TwilightHammer\Lamppost\TwilightsHammer_LavaBall_TEX_Glow
World\Expansion03\Doodads\TwilightHighlands\Crater\TW_Glows_04
World\Expansion03\Doodads\Vashjir\Veins\VJ_Veins_TEX
World\Expansion03\Doodads\Wildhammer\Pillars\jlo_WildHammer_WoodTrims_low
World\Expansion03\Doodads\Worgen\ITEMS\Hat
World\expansion04\doodads\Alliance\Boat\rlc_Ship_WoodTrimCloth
World\expansion04\doodads\Alliance\Boat\jlo_bbay_ceiling
World\expansion04\doodads\Mogu\PA_Rope_Tile_01
World\expansion04\doodads\Mogu\ThunderIsle_Raid_Door_2_trim
World\expansion04\doodads\Mogu\ThunderKing_LightningColumn_Bottom
World\expansion04\doodads\Pandaren\KitchenInset\PA_kitchenInset_02
World\expansion04\doodads\Pandaren\Keg\PA_Keg_D_09U
World\expansion04\doodads\Pandaren\Keg\PA_Keg_D_06U
World\expansion04\doodads\Pandaren\Keg\PA_Keg_D_07U
World\expansion04\doodads\Pandaren\Stone_Walls\PA_Wall_EastTemple_TEX_01
World\expansion04\doodads\Pandaren\Stone_Walls\PA_Wall_EastTemple_TEX_02
World\expansion04\doodads\Pandaren\WoodPlank02
World\expansion04\doodads\ThunderIsle\Doodads\LightningUnderTile_Blue
World\expansion04\doodads\ValleyofFourWinds\JungleRoots\V4W_JungleRoots
World\expansion04\doodads\ValleyofFourWinds\OrangeTree\VFW_SHAOrangeTree_Trunk
World\EXPANSION05\DOODADS\Ashran\6HU_Garrison_barracks_wall
World\EXPANSION05\DOODADS\Ashran\6OR_Garrison_WoodFloor
World\EXPANSION05\DOODADS\DeadMinesTable01
World\EXPANSION05\DOODADS\Draenei\6drstairnew
World\EXPANSION05\DOODADS\Dungeon\Doodads\6OG_Highmaul_Column2_dark
World\EXPANSION05\DOODADS\Dungeon\Doodads\6OG_Highmaul_ArenaTrims
World\EXPANSION05\DOODADS\Dungeon\Doodads\6IH_IronHorde_Wall03
World\EXPANSION05\DOODADS\Dungeon\Doodads\6_0_MoonCycleFloor_MoonCult
World\EXPANSION05\DOODADS\Dungeon\Doodads\6_0_MoonCycleFloor_MoonCult_blue
World\EXPANSION05\DOODADS\Dungeon\Doodads\6OG_HighMaul_Walls4
World\EXPANSION05\DOODADS\Dungeon\Doodads\Fel_Crystalline
World\EXPANSION05\DOODADS\Dungeon\Doodads\Fel_Crystalline_veins
World\EXPANSION05\DOODADS\Human\Doodads\6HU_Lumbermill_Map8
World\EXPANSION05\DOODADS\Human\Doodads\6HU_SHIP01_MAP01_B
World\EXPANSION05\DOODADS\Nagrand\Doodads\6NG_MossyRock01
World\EXPANSION05\DOODADS\ORCCLANS\6OC_OrcClans_VillageCenter03
World\EXPANSION05\DOODADS\ORCCLANS\6OC_OrcClans_Scrolls01
World\EXPANSION05\DOODADS\ORCCLANS\Beam_WebGlowBluePurple
World\EXPANSION05\DOODADS\SpiresOfArrak\Doodads\6sa_rock01
World\EXPANSION05\DOODADS\TanaanJungle\Doodads\6TJ_PatchCanopyTree_Stump_overgrown_01
World\EXPANSION05\DOODADS\TanaanJungle\Doodads\6TJ_PatchJungleRoots_01
World\Expansion06\Doodads\7XP_Fel_DarkRock01_Bone
World\Expansion06\Doodads\Artifact\7AF_Priest_ShadowMetaltrim
World\Expansion06\Doodads\Artifact\7AF_Priest_Pedestal02
World\Expansion06\Doodads\Artifact\firelands_rock
World\Expansion06\Doodads\Artifact\DeathwingAfterglow_RedMist
World\Expansion06\Doodads\Artifact\jlo_bbay_shiptrim_01_pirate
World\Expansion06\Doodads\Dalaran\7DL_Bush_Base_01
World\Expansion06\Doodads\Dalaran\7DA_Dalaran_PaintingGnome01
World\Expansion06\Doodads\Dalaran\7DL_Worgen_Rug01
World\Expansion06\Doodads\Dalaran\dal2_mural
World\Expansion06\Doodads\Dalaran\dal2_outerwall_plain
World\Expansion06\Doodads\Dalaran\dal_trim03
World\Expansion06\Doodads\Dalaran\DalaranCouter
World\Expansion06\Doodads\Dungeon\Doodads\7DU_VH_trapdoortile
World\Expansion06\Doodads\Dungeon\Doodads\7NE_NightElf_Curb_Set03_Suramar2
World\Expansion06\Doodads\Nightborn\7SR_PlanterTree_Canopy02
World\Expansion06\Doodads\NightElf\7NB_NIGHTBORN_SHIPMAP02 copy
World\Expansion06\Doodads\NightElf\7NE_Blackrook_Rug01b
World\Expansion06\Doodads\Stormwind\7SW_Stormwind_keepCarpet
World\Expansion06\Doodads\Stormwind\7SW_Stormwind_keepCarpet02
World\Expansion06\Doodads\ValSharah\7VS_NightmareGrass_01
World\Expansion06\Doodads\ValSharah\7vs_nightmarevine_bark
World\Expansion06\Doodads\Vrykul\7vr_vrykul_boatpattern
World\Expansion06\Doodads\Vrykul\6HU_SHIP01_ROPEMAP01
World\Expansion06\Doodads\Vrykul\7VR_Vrykul_RitualRunes01
World\Expansion06\Doodads\Vrykul\7vr_vrykul_tombdoor_g
World\ExteriorDesigners\ZULDRAK\DRAK_WALL_ARCH
World\Generic\Goblin\PassiveDoodads\LostIsles\Goblin_Rug_01
World\Generic\Orc\Passive Doodads\ALTAROFSTORMSSTATUES\DARKPORTALWALL10
World\KhazModan\Ironforge\PassiveDoodads\ELEVATORS\MM_IRNFG_ELEVATOR
World\KhazModan\Ironforge\PassiveDoodads\Plaques\DwarvenPlaque
World\KhazModan\Ironforge\PassiveDoodads\SLIMEJARS\SlimeJar01


dungeons

\PSDTEXTURES\SCARLET_MONASTARY\MM_BOOKS_01_NEW
\PSDTEXTURES\SCHOLOMANCE\OUTSIDE
\TEXTURES\6DU_MOONCULTIST\6DU_JD_BRICKWALL_MOONCULT
\TEXTURES\6HU_GARRISON\6HU_GARRISON_THATCHEDROOF_01
\TEXTURES\6SM_KARABOR\6TD_RC_KARABOR_FLOOR_2
\TEXTURES\7DU_SURAMAR\7DU_SURAMAR_NIGHTWELL_STARS
\TEXTURES\7DU_SURAMAR\7DU_SURAMAR_NIGHTWELL_STARS_EMMISIVE
\TEXTURES\BLOODELF\DH_BLOODELFPILLAR2
\TEXTURES\FLOOR\KG_KZN_TRANSITION_FLOOR
\TEXTURES\NIGHTELFRUINS\NIGHTELF_CRYSTAL_RESTORED
\TEXTURES\ORGRIMMAR_RAID\FV_OR_GLOWING_WINDOWS
\TEXTURES\ORGRIMMAR_RAID\FV_OR_GLOWING_WINDOWS_EMISSIVE
\TEXTURES\PANDAREN\BASE_HOUSES\PR_BELL_GAZEBO_TRIMS
\TEXTURES\PANDAREN\LEDGE\PR_LEDGE_GRASS1_ALPHA
\TEXTURES\PANDAREN\MOGU\CE_WALL_FACADE
\TEXTURES\PANDAREN\MOGU\JLO_MOGU_FLOOR_STONETILE_03
\TEXTURES\RAZORFEN\STU_RF-BONEPILE02
\TEXTURES\RAZORFEN\STU_RF_PIGHUTBOTTOM
\TEXTURES\ROOF\BM_LDRN_ROOF01
\TEXTURES\ROOF\BM_LDRN_ROOF01_BROKEN
\TEXTURES\SILVERMOONCITY\BLOODELF_ARCHTRIM
\TEXTURES\SILVERMOONCITY\BM_SLVRMN_GRASS01
\TEXTURES\SILVERMOONCITY\BLDELF_WINDOW
\TEXTURES\SILVERMOONCITY\TRIMSDARK02
\TEXTURES\SILVERMOONCITY\PILLARDARK_02
\TEXTURES\TRIM\BM_BLOODELF_STAIRS01
\TEXTURES\TRIM\JLO_SNKNTMP_COLUMN
\TEXTURES\WOOD\WOODPLANK04
\TEXTURES\WOOD\ELWYNNPILLARWOOD05

--]=]
