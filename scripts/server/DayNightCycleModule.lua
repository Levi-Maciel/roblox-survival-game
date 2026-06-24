-- DayNightCycleModule.lua
-- Módulo de Ciclo Dia/Noite
-- Coloque este script em: ServerScriptService com o nome "DayNightCycleModule"

local DayNightCycle = {}

local CYCLE_LENGTH = 1200 -- 20 minutos (1200 segundos)
local DAY_START = 6
local NIGHT_START = 18

local lighting = game:GetService("Lighting")
local is_day = true
local cycle_running = false

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

local function updateLighting()
    local timeInfo = DayNightCycle:getTimeInfo()
    local isDaytime = timeInfo.isDaytime
    
    if isDaytime and not is_day then
        is_day = true
        print("☀️ [CICLO] Amanheceu!")
        lighting.Ambient = Color3.fromRGB(200, 200, 200)
        lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    elseif not isDaytime and is_day then
        is_day = false
        print("🌙 [CICLO] Anoiteceu!")
        lighting.Ambient = Color3.fromRGB(100, 100, 150)
        lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 150)
    end
end

function DayNightCycle:start()
    if cycle_running then
        warn("Ciclo já está rodando!")
        return
    end
    
    cycle_running = true
    print("🌍 [CICLO] Iniciando ciclo dia/noite...")
    
    lighting.ClockTime = DAY_START
    updateLighting()
    
    while cycle_running do
        local elapsed = 0
        
        while elapsed < CYCLE_LENGTH and cycle_running do
            local progress = elapsed / CYCLE_LENGTH
            local newClockTime = progress * 24
            
            lighting.ClockTime = newClockTime
            updateLighting()
            
            wait(1)
            elapsed = elapsed + 1
        end
    end
end

function DayNightCycle:stop()
    cycle_running = false
    print("⏹️  [CICLO] Ciclo parado")
end

function DayNightCycle:setTime(hour, minute)
    local clockTime = hour + (minute / 60)
    lighting.ClockTime = math.clamp(clockTime, 0, 24)
    updateLighting()
    print("⏱️  [CICLO] Hora alterada para: " .. string.format("%02d:%02d", hour, minute))
end

function DayNightCycle:getFormattedTime()
    return DayNightCycle:getTimeInfo().formattedTime
end

function DayNightCycle:isDaytime()
    return is_day
end

return DayNightCycle
