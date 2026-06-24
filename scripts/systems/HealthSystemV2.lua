-- HealthSystem.lua
-- Sistema de Saúde com dano por fome e regeneração
-- Coloque este script em: ServerScriptService como ModuleScript

local HealthSystem = {}

-- Configurações de saúde
local DEFAULT_HEALTH = 100
local MAX_HEALTH = 100
local REGENERATION_RATE = 5 -- Saúde regenerada por minuto quando bem alimentado
local STARVATION_DAMAGE = 10 -- Dano por minuto quando morrendo de fome
local HUNGER_THRESHOLD = 20 -- Abaixo disso começa a perder saúde
local REGENERATION_THRESHOLD = 70 -- Acima disso começa a regenerar saúde

-- Criar nova instância de saúde
function HealthSystem.new(character, hungerSystem)
    local self = {}
    self.character = character
    self.health = DEFAULT_HEALTH
    self.maxHealth = MAX_HEALTH
    self.isDead = false
    self.hungerSystem = hungerSystem
    self.lastHealthUpdate = tick()
    
    return self
end

-- Receber dano
function HealthSystem:takeDamage(amount)
    if self.isDead then return end
    
    self.health = math.max(0, self.health - amount)
    print(string.format("💔 [SAÚDE] Dano: %.1f | Saúde atual: %.1f/%d", amount, self.health, self.maxHealth))
    
    if self.health <= 0 then
        self:die()
    end
end

-- Curar
function HealthSystem:heal(amount)
    if self.isDead then return end
    
    self.health = math.min(self.maxHealth, self.health + amount)
    print(string.format("💚 [SAÚDE] Curado: +%.1f | Saúde: %.1f/%d", amount, self.health, self.maxHealth))
end

-- Morrer
function HealthSystem:die()
    self.isDead = true
    print("💀 [SAÚDE] Você morreu!")
    local humanoid = self.character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

-- Atualizar saúde (baseado em fome)
function HealthSystem:update(deltaTime)
    if self.isDead or not self.hungerSystem then return end
    
    local now = tick()
    local timeSinceLastUpdate = now - self.lastHealthUpdate
    
    if timeSinceLastUpdate >= 1 then -- Atualizar a cada 1 segundo
        if self.hungerSystem.hunger <= HUNGER_THRESHOLD then
            -- Morrendo de fome - perder saúde
            local damagePerSecond = STARVATION_DAMAGE / 60
            self:takeDamage(damagePerSecond)
        elseif self.health < self.maxHealth and self.hungerSystem.hunger >= REGENERATION_THRESHOLD then
            -- Bem alimentado - regenerar saúde
            local healPerSecond = REGENERATION_RATE / 60
            self:heal(healPerSecond)
        end
        
        self.lastHealthUpdate = now
    end
end

-- Obter saúde em porcentagem
function HealthSystem:getHealthPercentage()
    return (self.health / self.maxHealth) * 100
end

-- Obter informações de saúde
function HealthSystem:getInfo()
    return {
        health = math.floor(self.health),
        maxHealth = self.maxHealth,
        percentage = math.floor(self:getHealthPercentage()),
        isDead = self.isDead
    }
end

return HealthSystem
