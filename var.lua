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

----------------- Constantes ------------------
-- Orientation values
RIGHT = 1
LEFT = -1

JUMPSPEED = 4.6

-- Vitesse en l'air
AIRSPEED = 1.8

-- Vitesse au sol
GROUNDSPEED = 1.3 * AIRSPEED

-- Accélération de chute
GRAVITY = 0.15

-- Vitesse de chute maximale
MAX_SPEED_FALLING = 3.4

RANGE = TILESIZE * 2

-- Délai pour les actions (en secondes)
CD_DESTROYBLOCK = 1

--------------- Option de debug ---------------
DEBUG = true

--------------- Game Parameters ---------------
PLAY_TYPE_TABLE = { ['normal']  = 1, --> normal
                    ['weapons'] = 2, --> menu arme/craft
                    ['pause']   = 3, --> menu pause
                    ['main']    = 4, --> menu principal
                    }
PLAY = PLAY_TYPE_TABLE.normal

CHAR_HP = 100
CHAR_NB = 4
TEAM_NB = 2

------------------- DESIGN --------------------

TEAM_COLORS = {
	'#E03A3E',
	'#002B5C',
	'#00471B',
	'#FFCD00',
	'#5A2D81',
	'#C4CED4',
}