-- HungerSystemModule.lua
-- Módulo de Fome
-- Coloque este script em: ServerScriptService com o nome "HungerSystemModule"

local HungerSystem = {}

local DEFAULT_HUNGER = 100
local MAX_HUNGER = 100
local HUNGER_DECAY_RATE = 0.5
local CRITICAL_HUNGER = 20
local WARNING_HUNGER = 50

function HungerSystem.new()
    local self = {}
    self.hunger = DEFAULT_HUNGER
    self.isCritical = false
    self.lastHungerUpdate = tick()
    self.warningShown = false
    
    return self
end

function HungerSystem:update(deltaTime)
    local now = tick()
    local timeSinceLastUpdate = now - self.lastHungerUpdate
    
    if timeSinceLastUpdate >= 1 then
        self.hunger = math.max(0, self.hunger - (HUNGER_DECAY_RATE * timeSinceLastUpdate))
        
        if self.hunger <= CRITICAL_HUNGER and not self.isCritical then
            self.isCritical = true
            print("🔴 [FOME] CRÍTICO! Você está morrendo de fome!")
        elseif self.hunger > CRITICAL_HUNGER and self.isCritical then
            self.isCritical = false
            print("🟡 [FOME] Saiu do estado crítico")
        end
        
        if self.hunger <= WARNING_HUNGER and not self.warningShown then
            self.warningShown = true
            print("⚠️  [FOME] Aviso: Você está com fome!")
        elseif self.hunger > WARNING_HUNGER then
            self.warningShown = false
        end
        
        self.lastHungerUpdate = now
    end
end

function HungerSystem:eat(amount)
    self.hunger = math.min(MAX_HUNGER, self.hunger + amount)
    print(string.format("🍖 [FOME] Comeu +%.1f | Fome: %.1f/%d", amount, self.hunger, MAX_HUNGER))
end

function HungerSystem:getHungerPercentage()
    return (self.hunger / MAX_HUNGER) * 100
end

function HungerSystem:isCriticalHunger()
    return self.isCritical
end

function HungerSystem:getInfo()
    local status = "Normal"
    if self.hunger <= CRITICAL_HUNGER then
        status = "Crítico"
    elseif self.hunger <= WARNING_HUNGER then
        status = "Aviso"
    end
    
    return {
        hunger = math.floor(self.hunger),
        maxHunger = MAX_HUNGER,
        percentage = math.floor(self:getHungerPercentage()),
        status = status,
        isCritical = self.isCritical
    }
end

return HungerSystem
