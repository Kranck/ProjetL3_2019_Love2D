--------- Chemins vers les fichiers -----------
SRCDIR = "sources/"
TILESDIR = "sources/tiles/"
UIDIR = "sources/ui/"
ASSETSDIR = "assets/"
TEXTUREDIR = "assets/textures/"
WEAPONDIR = "sources/weapons/"

------------------ Tailles --------------------
WINDOW_HEIGHT = 720
WINDOW_WIDTH  = 1280
HEIGHT =  WINDOW_HEIGHT/16  -- 45
WIDTH  = WINDOW_WIDTH/16 -- 80

-- Taille du pavage
TILESIZE = 32

-- Orientation values
RIGHT = 1
LEFT = -1

--------------- Option de debug ---------------
DEBUG = true

--------------- Game Parameters ---------------
PLAY_TYPE_TABLE = { ['normal']  = 1, --> normal
                    ['weapons'] = 2, --> menu arme/craft
                    ['pause']   = 3, --> menu pause
                    ['main']    = 4, --> mnu principal
                    }
PLAY = PLAY_TYPE_TABLE.normal

CHAR_HP = 100
CHAR_NB = 4
TEAM_NB = 2

------------------- DESIGN --------------------

TEAM_COLORS = {
	'#E03A3E',
	'#00471B',
	'#002B5C',
	'#FFCD00',
	'#5A2D81',
	'#C4CED4',
}