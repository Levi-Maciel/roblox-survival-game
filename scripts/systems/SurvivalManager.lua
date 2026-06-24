-- SurvivalManager.lua
-- Gerenciador central de sistemas de sobrevivência
-- Coloque este script em: ServerScriptService

local SurvivalManager = {}

local HealthSystem = require(game.ServerScriptService:WaitForChild("HealthSystemModule"))
local HungerSystem = require(game.ServerScriptService:WaitForChild("HungerSystemModule"))
local DayNightCycle = require(game.ServerScriptService:WaitForChild("DayNightCycleModule"))

local players = game:GetService("Players")
local playerSystems = {}

-- Função para inicializar sistemas de um jogador
local function initializePlayerSystems(character)
    local player = players:GetPlayerFromCharacter(character)
    if not player then return end
    
    -- Criar instâncias dos sistemas
    local hungerSystem = HungerSystem.new()
    local healthSystem = HealthSystem.new(character, hungerSystem)
    
    playerSystems[player.UserId] = {
        character = character,
        hunger = hungerSystem,
        health = healthSystem,
        lastUpdate = tick()
    }
    
    print(string.format("✅ [SURVIVAL] Sistemas iniciados para %s", player.Name))
    
    -- Loop de atualização dos sistemas
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
        local playerData = playerSystems[player.UserId]
        
        if not playerData or not playerData.character or not playerData.character.Parent then
            connection:Disconnect()
            playerSystems[player.UserId] = nil
            return
        end
        
        -- Atualizar sistemas
        playerData.hunger:update(deltaTime)
        playerData.health:update(deltaTime)
    end)
end

-- Quando um jogador entra
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(0.1) -- Pequeno delay para garantir que tudo está carregado
        initializePlayerSystems(character)
    end)
end)

-- Quando um jogador sai
players.PlayerRemoving:Connect(function(player)
    playerSystems[player.UserId] = nil
    print(string.format("👋 [SURVIVAL] Dados de %s removidos", player.Name))
end)

-- Função para obter dados de um jogador
function SurvivalManager:getPlayerData(player)
    return playerSystems[player.UserId]
end

-- Função para dar comida a um jogador
function SurvivalManager:feedPlayer(player, amount)
    local data = playerSystems[player.UserId]
    if data then
        data.hunger:eat(amount)
    end
end

-- Função para danificar um jogador
function SurvivalManager:damagePlayer(player, amount)
    local data = playerSystems[player.UserId]
    if data then
        data.health:takeDamage(amount)
    end
end

-- Função para curar um jogador
function SurvivalManager:healPlayer(player, amount)
    local data = playerSystems[player.UserId]
    if data then
        data.health:heal(amount)
    end
end

return SurvivalManager
