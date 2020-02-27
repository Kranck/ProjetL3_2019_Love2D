require("var")

require(SRCDIR.."Tile")
require(SRCDIR.."Terrain")
require(TILESDIR.."Terre")
require(TILESDIR.."Pierre")
require(SRCDIR.."Personnage")
require(SRCDIR.."Camera")
require(SRCDIR.."Equipe")

local nuklear = require 'nuklear'
local Menu    = require(UIDIR..'uiMenu')
local InGame  = require(UIDIR..'uiInGame')
local Pause   = require(UIDIR..'uiPause')


-- A DEPLACER PLUS TARD DANS LE LOAD ; d'ailleurs avec le menu il faudra différer
-- la génération du terrain et des équipes -> on ne connait pas le nb de teams et 
-- de persos

local terrain = Terrain:New(HEIGHT, WIDTH)
local current_team_nb = 2
local perso = nil


-- On instancie les équipes et les personnages
for i=1, TEAM_NB do
    table.insert(terrain.teams, Equipe:New(terrain, TEAM_COLORS[i], "Equipe "..i))
end

-- Premier personnage à jouer
perso = terrain.teams[current_team_nb].personnages[current_team_nb]


-- Changer de perso
function love.keyreleased(key)
    -- Dès qu'on appuie sur entrée génère une nouvelle map et la redessine
    if key == "return" then
        terrain = Terrain:New(HEIGHT, WIDTH)
        -- On instancie les équipes et les personnages
        for i=1, TEAM_NB do
            table.insert(terrain.teams, Equipe:New(terrain, TEAM_COLORS[i], "Equipe "..i))
        end
        -- Premier personnage à jouer
        perso = terrain.teams[current_team_nb].personnages[1]
    end

    

    for i=1, CHAR_NB do
        if key == ""..i then
            if terrain.teams[current_team_nb].personnages[i] ~= nil then
                perso = terrain.teams[current_team_nb].personnages[i]
            end
        end 
    end
end


-- Casser un bloc
function love.keypressed(key)
    if key == 'f' then
        perso.DestroyBlock()
    end
end

-- Zoom avec la molette
function love.wheelmoved(x, y)
    if y<0 then
        --Camera.x, Camera.y = Camera:mousePosition()
        for i=1, 50 do
            Camera:scale(1.001, perso)
        end
    elseif y>0 then
        --Camera.x, Camera.y = Camera:mousePosition()
        for i=1, 50 do
            Camera:scale(1/1.001, perso)
        end
    end    
end

-- HUDs
local uiMenu, uiInGame, uiPause

function love.load()
    uiMenu   = nuklear.newUI()
    uiInGame = nuklear.newUI()
    uiPause  = nuklear.newUI()
end

-- update func
function love.update()
    uiMenu:frame(Menu)
    uiInGame:frameBegin()
    InGame(uiInGame, perso.getItems(), terrain.teams)
    uiInGame:frameEnd()
    uiPause:frame(Pause)

    -- Reset info before movement
    
    local grounded = perso.isGrounded()
    
    -- check if a personnage has been knocked out of the map or is dead
    for i, t in ipairs(terrain.teams) do
        to_remove = {}
        for j, p in ipairs(t.personnages) do
            local persoCheckedGrounded = p.isGrounded()
            if persoCheckedGrounded == "outOfBounds" or p.getHP()<=0 then
                table.insert(to_remove, j)
            end
        end
        for j=1, table.getn(to_remove) do
            table.remove(t.personnages, to_remove[j])
        end
    end

    if grounded == "outOfBounds" or perso.getHP()<=0 then
        perso = terrain.nextPerso(current_team_nb)
    end

    local moved = false -- Reset : le personnage ne s'est pas déplacer pendant cette frame

    if love.keyboard.isScancodeDown("left") or love.keyboard.isScancodeDown("a") then
        perso.MoveLeft(grounded)
        moved = true -- a bougé
    end

    if love.keyboard.isScancodeDown("right") or love.keyboard.isScancodeDown("d") then
        perso.MoveRight(grounded);
        moved = true -- a bougé
    end

    if love.keyboard.isScancodeDown("up") or love.keyboard.isScancodeDown("w") then
        perso.changeAngleUp()
    end

    if love.keyboard.isScancodeDown("down") or love.keyboard.isScancodeDown("s") then
        perso.changeAngleDown()
    end

    if love.keyboard.isScancodeDown("space") then
        perso.Jump(grounded)
    end

    love.wheelmoved(0, 0)

end


-- fonction d'affichage
function love.draw()
    
    Camera:set()

    -- On affiche un terrain dès qu'on lance le programme
    terrain.draw()
    
    window_width, window_height = love.graphics.getDimensions()
    Camera:setPosition(perso)

    -- On affiche le curseur pour la visée
    perso.DrawCursor()

    uiInGame:draw()

    Camera:unset()

    -- Affiche les informations de débuggage pour un personnage
    if DEBUG then
        perso.Debug(grounded)
    end
end