-- PlayerSpawnSystem.lua
-- Sistema completo de spawn de jogadores
-- Coloque este script em: StarterPlayer > StarterCharacterScripts

local character = script.Parent
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local player = game.Players:GetPlayerFromCharacter(character)

-- Configurações
local RESPAWN_TIME = 5 -- Tempo de respawn em segundos
local SPAWN_PROTECTION_TIME = 3 -- Tempo de proteção após spawn
local SPAWN_OFFSET = Vector3.new(0, 3, 0) -- Offset vertical para evitar clipping

-- Importar o sistema de spawn locations
local SpawnLocations = require(game.ServerScriptService:WaitForChild("SpawnLocationModule"))

-- Função para teleportar o jogador para um spawn point
local function teleportToSpawn(spawnLocation)
    if not spawnLocation then
        warn("Spawn location inválido!")
        return
    end
    
    local targetPosition = spawnLocation.position + SPAWN_OFFSET
    humanoidRootPart.CFrame = CFrame.new(targetPosition) * CFrame.Angles(0, math.rad(spawnLocation.rotation or 0), 0)
    
    if player then
        print("[SPAWN] " .. player.Name .. " spawned em: " .. spawnLocation.name)
    end
end

-- Função para aplicar proteção de spawn
local function applySpawnProtection()
    -- Criar um escudo invisível temporário
    local shield = Instance.new("Part")
    shield.Name = "SpawnShield"
    shield.CanCollide = false
    shield.CFrame = humanoidRootPart.CFrame
    shield.Size = Vector3.new(6, 6, 6)
    shield.Transparency = 1
    shield.TopSurface = Enum.SurfaceType.Smooth
    shield.BottomSurface = Enum.SurfaceType.Smooth
    shield.Parent = character
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = humanoidRootPart
    weld.Part1 = shield
    weld.Parent = shield
    
    print("[PROTEÇÃO] Escudo de spawn ativado por " .. SPAWN_PROTECTION_TIME .. "s")
    
    wait(SPAWN_PROTECTION_TIME)
    
    shield:Destroy()
    print("[PROTEÇÃO] Escudo de spawn removido")
end

-- Função para quando o jogador morre
local function onPlayerDeath()
    if player then
        print("[MORTE] " .. player.Name .. " morreu! Respawnando em " .. RESPAWN_TIME .. "s...")
    end
    
    wait(RESPAWN_TIME)
    
    local spawnLocation = SpawnLocations:getRandomSpawnLocation()
    teleportToSpawn(spawnLocation)
    applySpawnProtection()
end

-- Inicializar jogador no primeiro spawn
local initialSpawn = SpawnLocations:getRandomSpawnLocation()
teleportToSpawn(initialSpawn)
applySpawnProtection()

-- Conectar evento de morte
humanoid.Died:Connect(onPlayerDeath)

-- Debug: Mostrar informações ao spawn
if player then
    print("=== JOGADOR SPAWNED ===")
    print("Nome: " .. player.Name)
    print("Posição: " .. tostring(humanoidRootPart.Position))
    print("Saúde: " .. humanoid.Health)
    print("=======================")
end
