Tile = {}
Tile.__index = Tile

IMAGE_SIZE = 32

function Tile:New(pos_X, pos_Y) --Générer une Tile
    local this = {}
    setmetatable(this, Tile)
    this.tile_width = IMAGE_SIZE
    this.tile_height = IMAGE_SIZE
    this.position_X = pos_X
    this.position_Y = pos_Y
    this.destroyed = false
    return this
end

function Tile:GetTilePositionX() --Getter
    return self.position_X
end

function Tile:GetTilePositionY() --Getter
    return self.position_Y
end

function Tile:GetTileHeight() --Getter
    return self.tile_height
end

function Tile:GetTileWidth() --Getter
    return self.tile_width
end

function Tile:GetTileDestroyed() --Getter
    return self.destroyed
end

--function Tile:DestroyTile() --Détruire une Tile
--
--end