-- HealthSystemModule.lua
-- Módulo de Saúde
-- Coloque este script em: ServerScriptService com o nome "HealthSystemModule"

local HealthSystem = {}

local DEFAULT_HEALTH = 100
local MAX_HEALTH = 100
local REGENERATION_RATE = 5
local STARVATION_DAMAGE = 10
local HUNGER_THRESHOLD = 20
local REGENERATION_THRESHOLD = 70

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

function HealthSystem:takeDamage(amount)
    if self.isDead then return end
    
    self.health = math.max(0, self.health - amount)
    print(string.format("💔 [SAÚDE] Dano: %.1f | Saúde: %.1f/%d", amount, self.health, self.maxHealth))
    
    if self.health <= 0 then
        self:die()
    end
end

function HealthSystem:heal(amount)
    if self.isDead then return end
    
    self.health = math.min(self.maxHealth, self.health + amount)
    print(string.format("💚 [SAÚDE] Curado: +%.1f | Saúde: %.1f/%d", amount, self.health, self.maxHealth))
end

function HealthSystem:die()
    self.isDead = true
    print("💀 [SAÚDE] Você morreu!")
    local humanoid = self.character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

function HealthSystem:update(deltaTime)
    if self.isDead or not self.hungerSystem then return end
    
    local now = tick()
    local timeSinceLastUpdate = now - self.lastHealthUpdate
    
    if timeSinceLastUpdate >= 1 then
        if self.hungerSystem.hunger <= HUNGER_THRESHOLD then
            local damagePerSecond = STARVATION_DAMAGE / 60
            self:takeDamage(damagePerSecond)
        elseif self.health < self.maxHealth and self.hungerSystem.hunger >= REGENERATION_THRESHOLD then
            local healPerSecond = REGENERATION_RATE / 60
            self:heal(healPerSecond)
        end
        
        self.lastHealthUpdate = now
    end
end

function HealthSystem:getHealthPercentage()
    return (self.health / self.maxHealth) * 100
end

function HealthSystem:getInfo()
    return {
        health = math.floor(self.health),
        maxHealth = self.maxHealth,
        percentage = math.floor(self:getHealthPercentage()),
        isDead = self.isDead
    }
end

return HealthSystem
