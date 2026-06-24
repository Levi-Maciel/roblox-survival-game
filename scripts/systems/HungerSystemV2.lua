-- HungerSystemV2.lua
-- Sistema de Fome melhorado
-- Coloque este script em: ServerScriptService como ModuleScript

local HungerSystem = {}

-- Configurações de fome
local DEFAULT_HUNGER = 100
local MAX_HUNGER = 100
local MIN_HUNGER = 0
local HUNGER_DECAY_RATE = 0.5 -- Fome reduzida por segundo
local CRITICAL_HUNGER = 20 -- Abaixo disso é crítico
local WARNING_HUNGER = 50 -- Abaixo disso mostra aviso

-- Criar nova instância de fome
function HungerSystem.new()
    local self = {}
    self.hunger = DEFAULT_HUNGER
    self.isCritical = false
    self.lastHungerUpdate = tick()
    self.warningShown = false
    
    return self
end

-- Atualizar fome (chamar em loop)
function HungerSystem:update(deltaTime)
    local now = tick()
    local timeSinceLastUpdate = now - self.lastHungerUpdate
    
    if timeSinceLastUpdate >= 1 then -- Atualizar a cada 1 segundo
        self.hunger = math.max(MIN_HUNGER, self.hunger - (HUNGER_DECAY_RATE * timeSinceLastUpdate))
        
        -- Verificar estado crítico
        if self.hunger <= CRITICAL_HUNGER and not self.isCritical then
            self.isCritical = true
            print("🔴 [FOME] CRÍTICO! Você está morrendo de fome!")
        elseif self.hunger > CRITICAL_HUNGER and self.isCritical then
            self.isCritical = false
            print("🟡 [FOME] Saiu do estado crítico")
        end
        
        -- Mostrar aviso
        if self.hunger <= WARNING_HUNGER and not self.warningShown then
            self.warningShown = true
            print("⚠️  [FOME] Aviso: Você está com fome!")
        elseif self.hunger > WARNING_HUNGER then
            self.warningShown = false
        end
        
        self.lastHungerUpdate = now
    end
end

-- Comer/Alimentar-se
function HungerSystem:eat(amount)
    self.hunger = math.min(MAX_HUNGER, self.hunger + amount)
    print(string.format("🍖 [FOME] Comeu +%.1f | Fome: %.1f/%d", amount, self.hunger, MAX_HUNGER))
end

-- Obter dano por fome
function HungerSystem:getStarvationDamage()
    if self.hunger <= CRITICAL_HUNGER then
        return 10 -- 10 pontos de dano por minuto
    elseif self.hunger <= WARNING_HUNGER then
        return 5 -- 5 pontos de dano por minuto
    end
    return 0
end

-- Obter fome em porcentagem
function HungerSystem:getHungerPercentage()
    return (self.hunger / MAX_HUNGER) * 100
end

-- Verificar se está crítico
function HungerSystem:isCriticalHunger()
    return self.isCritical
end

-- Obter informações de fome
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
