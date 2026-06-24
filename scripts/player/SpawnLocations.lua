-- SpawnLocations.lua
-- Sistema de locais de spawn customizáveis
-- Coloque este script em: ServerScriptService

local SpawnLocations = {}

-- Defina aqui os pontos de spawn do seu jogo
-- Você pode adicionar quantos pontos de spawn quiser
local SPAWN_LOCATIONS = {
    -- Formato: {posição, rotação (opcional)}
    
    -- Spawn principal (centro)
    {
        name = "Spawn Principal",
        position = Vector3.new(0, 50, 0),
        rotation = 0,
        enabled = true
    },
    
    -- Spawn no norte
    {
        name = "Spawn Norte",
        position = Vector3.new(0, 50, 100),
        rotation = 0,
        enabled = true
    },
    
    -- Spawn no sul
    {
        name = "Spawn Sul",
        position = Vector3.new(0, 50, -100),
        rotation = 180,
        enabled = true
    },
    
    -- Spawn no leste
    {
        name = "Spawn Leste",
        position = Vector3.new(100, 50, 0),
        rotation = 90,
        enabled = true
    },
    
    -- Spawn no oeste
    {
        name = "Spawn Oeste",
        position = Vector3.new(-100, 50, 0),
        rotation = -90,
        enabled = true
    },
    
    -- Spawn na montanha
    {
        name = "Spawn Montanha",
        position = Vector3.new(50, 100, 50),
        rotation = 45,
        enabled = true
    },
    
    -- Spawn na floresta
    {
        name = "Spawn Floresta",
        position = Vector3.new(-75, 45, -75),
        rotation = -45,
        enabled = true
    },
}

-- Função para obter um spawn location aleatório ativo
function SpawnLocations:getRandomSpawnLocation()
    local activeSpawns = {}
    
    for _, spawn in ipairs(SPAWN_LOCATIONS) do
        if spawn.enabled then
            table.insert(activeSpawns, spawn)
        end
    end
    
    if #activeSpawns == 0 then
        warn("Nenhum spawn location ativo encontrado!")
        return SPAWN_LOCATIONS[1]
    end
    
    return activeSpawns[math.random(1, #activeSpawns)]
end

-- Função para obter um spawn location específico por nome
function SpawnLocations:getSpawnLocationByName(name)
    for _, spawn in ipairs(SPAWN_LOCATIONS) do
        if spawn.name == name then
            return spawn
        end
    end
    warn("Spawn location '" .. name .. "' não encontrado!")
    return nil
end

-- Função para listar todos os spawns
function SpawnLocations:listAllSpawns()
    print("=== SPAWN LOCATIONS ===")
    for i, spawn in ipairs(SPAWN_LOCATIONS) do
        local status = spawn.enabled and "✓ Ativo" or "✗ Inativo"
        print(i .. ". " .. spawn.name .. " - " .. status)
        print("   Posição: " .. tostring(spawn.position))
    end
    print("======================")
end

-- Função para ativar/desativar um spawn
function SpawnLocations:setSpawnEnabled(name, enabled)
    for _, spawn in ipairs(SPAWN_LOCATIONS) do
        if spawn.name == name then
            spawn.enabled = enabled
            print("Spawn '" .. name .. "' agora está " .. (enabled and "ativo" or "inativo"))
            return true
        end
    end
    warn("Spawn '" .. name .. "' não encontrado!")
    return false
end

return SpawnLocations
