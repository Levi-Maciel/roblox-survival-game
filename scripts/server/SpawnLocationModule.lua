-- SpawnLocationModule.lua
-- Este é o módulo que será utilizado pelos scripts de spawn
-- Coloque este script em: ServerScriptService com o nome "SpawnLocationModule"

local SpawnLocations = {}

-- CONFIGURAÇÃO DE SPAWN LOCATIONS
local SPAWN_LOCATIONS = {
    -- Formato: {name, position, rotation, enabled}
    
    {name = "Spawn Principal", position = Vector3.new(0, 50, 0), rotation = 0, enabled = true},
    {name = "Spawn Norte", position = Vector3.new(0, 50, 100), rotation = 0, enabled = true},
    {name = "Spawn Sul", position = Vector3.new(0, 50, -100), rotation = 180, enabled = true},
    {name = "Spawn Leste", position = Vector3.new(100, 50, 0), rotation = 90, enabled = true},
    {name = "Spawn Oeste", position = Vector3.new(-100, 50, 0), rotation = -90, enabled = true},
    {name = "Spawn Montanha", position = Vector3.new(50, 100, 50), rotation = 45, enabled = true},
    {name = "Spawn Floresta", position = Vector3.new(-75, 45, -75), rotation = -45, enabled = true},
}

-- Obter spawn aleatório ativo
function SpawnLocations:getRandomSpawnLocation()
    local activeSpawns = {}
    
    for _, spawn in ipairs(SPAWN_LOCATIONS) do
        if spawn.enabled then
            table.insert(activeSpawns, spawn)
        end
    end
    
    if #activeSpawns == 0 then
        warn("Nenhum spawn ativo!")
        return SPAWN_LOCATIONS[1]
    end
    
    return activeSpawns[math.random(1, #activeSpawns)]
end

-- Obter spawn por nome
function SpawnLocations:getSpawnByName(name)
    for _, spawn in ipairs(SPAWN_LOCATIONS) do
        if spawn.name == name then
            return spawn
        end
    end
    return nil
end

-- Listar todos os spawns
function SpawnLocations:listSpawns()
    print("\n=== SPAWN LOCATIONS ===")
    for i, spawn in ipairs(SPAWN_LOCATIONS) do
        local status = spawn.enabled and "✓" or "✗"
        print(string.format("%d. %s [%s] - %s", i, spawn.name, status, tostring(spawn.position)))
    end
    print("======================\n")
end

-- Ativar/Desativar spawn
function SpawnLocations:setSpawnEnabled(name, enabled)
    for _, spawn in ipairs(SPAWN_LOCATIONS) do
        if spawn.name == name then
            spawn.enabled = enabled
            return true
        end
    end
    return false
end

return SpawnLocations
