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
HEIGHT = WINDOW_HEIGHT/16  -- 45
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
CD_DESTROYBLOCK = 0.25

--------------- Option de debug ---------------
DEBUG = true

--------------- Game Parameters ---------------
PLAY_TYPE_TABLE = { ['normal']  = 1, --> normal
                    ['weapons'] = 2, --> menu arme/craft
                    ['pause']   = 3, --> menu pause
					['main']    = 4, --> menu principal
					['endgame'] = 5, --> fin de partie
                    }
PLAY = PLAY_TYPE_TABLE.normal

CHAR_HP = 100
CHAR_NB = 4
TEAM_NB = 4

TOUR_TIME = 40.0

SENSI = 50 -- Entre 20 et 120 

---------------- Weapons Parameters -----------------

WEAPONS_INIT = {
	['revolver'] = {
		['available'] = 1, -- >= 0 craftable ; < 0 non-craftable 
		['cost'] = {Gold = 30, Terre = 2, Pierre = 5, Souffre = 0, Fer = 20},
		['dmg'] = 20,
		['durability'] = 20,
		['current_durability'] = 20,
		['img'] = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
	},
	['revolver_ammo'] = {
		['available'] = 10,
		['cost'] = {Gold = 2, Terre = 0, Pierre = 0, Souffre = 1, Fer = 1},
		['img'] = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
	}
}

------------------- DESIGN --------------------
TEAM_COLORS = {
	'#E03A3E',
	'#002B5C',
	'#00471B',
	'#FFCD00',
	'#692261',
	'#C4CED4',
}