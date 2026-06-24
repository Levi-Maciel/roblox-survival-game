-- DayNightCycle.lua
-- Sistema de Ciclo Dia/Noite
-- Coloque este script em: ServerScriptService

local DayNightCycle = {}

-- Configurações
local CYCLE_LENGTH = 1200 -- Comprimento total do ciclo em segundos (20 minutos)
local DAY_START = 6 -- Hora que o dia começa (6 da manhã)
local NIGHT_START = 18 -- Hora que a noite começa (6 da noite)
local AMBIENT_BRIGHTNESS = 0.5 -- Brilho ambiente padrão
local NIGHT_AMBIENT_BRIGHTNESS = 0.2 -- Brilho ambiente à noite

local lighting = game:GetService("Lighting")
local is_day = true
local cycle_running = false

-- Cores para dia e noite
local DAY_COLOR = Color3.fromRGB(255, 255, 255) -- Branco
local NIGHT_COLOR = Color3.fromRGB(100, 100, 150) -- Azul escuro

-- Função para obter informações do ciclo atual
function DayNightCycle:getTimeInfo()
    local clockTime = lighting.ClockTime
    local hours = math.floor(clockTime)
    local minutes = math.floor((clockTime - hours) * 60)
    local isDaytime = clockTime >= DAY_START and clockTime < NIGHT_START
    
    return {
        clockTime = clockTime,
        hours = hours,
        minutes = minutes,
        isDaytime = isDaytime,
        formattedTime = string.format("%02d:%02d", hours, minutes)
    }
end

-- Função para atualizar a iluminação com base na hora
local function updateLighting()
    local timeInfo = DayNightCycle:getTimeInfo()
    local isDaytime = timeInfo.isDaytime
    
    if isDaytime and not is_day then
        is_day = true
        print("☀️ [CICLO] Amanheceu!")
        
        -- Transição para o dia
        lighting.Ambient = Color3.fromRGB(200, 200, 200)
        lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        
    elseif not isDaytime and is_day then
        is_day = false
        print("🌙 [CICLO] Anoiteceu!")
        
        -- Transição para a noite
        lighting.Ambient = Color3.fromRGB(100, 100, 150)
        lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 150)
    end
end

-- Função para começar o ciclo dia/noite
function DayNightCycle:start()
    if cycle_running then
        warn("Ciclo dia/noite já está rodando!")
        return
    end
    
    cycle_running = true
    print("🌍 [CICLO] Iniciando ciclo dia/noite...")
    print("   Comprimento do ciclo: " .. CYCLE_LENGTH .. "s (20 minutos reais = 24 horas do jogo)")
    
    -- Inicializar iluminação
    lighting.ClockTime = DAY_START
    updateLighting()
    
    -- Loop do ciclo
    while cycle_running do
        local elapsed = 0
        
        -- Ciclo completo de 24 horas
        while elapsed < CYCLE_LENGTH and cycle_running do
            local progress = elapsed / CYCLE_LENGTH -- 0 a 1
            local newClockTime = progress * 24 -- 0 a 24
            
            lighting.ClockTime = newClockTime
            updateLighting()
            
            wait(1) -- Atualizar a cada 1 segundo
            elapsed = elapsed + 1
        end
    end
end

-- Função para parar o ciclo
function DayNightCycle:stop()
    cycle_running = false
    print("⏹️  [CICLO] Ciclo dia/noite parado")
end

-- Função para pular para uma hora específica
function DayNightCycle:setTime(hour, minute)
    local clockTime = hour + (minute / 60)
    lighting.ClockTime = math.clamp(clockTime, 0, 24)
    updateLighting()
    print("⏱️  [CICLO] Hora alterada para: " .. string.format("%02d:%02d", hour, minute))
end

-- Função para obter hora atual formatada
function DayNightCycle:getFormattedTime()
    return DayNightCycle:getTimeInfo().formattedTime
end

-- Função para verificar se está de dia
function DayNightCycle:isDaytime()
    return is_day
end

-- Iniciar o ciclo automaticamente
DayNightCycle:start()

return DayNightCycle
