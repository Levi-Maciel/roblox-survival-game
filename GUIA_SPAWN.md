# 📍 Guia de Sistema de Spawn

## Como Usar

### 1. **Adicionar o Módulo de Spawn**

1. No Roblox Studio, vá para **ServerScriptService**
2. Insira um novo **ModuleScript**
3. Renomeie para **"SpawnLocationModule"**
4. Cole o código de `scripts/server/SpawnLocationModule.lua`

### 2. **Configurar Spawn Locations**

Abra `SpawnLocationModule.lua` e configure seus pontos de spawn:

```lua
local SPAWN_LOCATIONS = {
    {name = "Spawn Principal", position = Vector3.new(0, 50, 0), rotation = 0, enabled = true},
    {name = "Spawn Norte", position = Vector3.new(0, 50, 100), rotation = 0, enabled = true},
    -- Adicione mais spawns aqui
}
```

**Parâmetros:**
- `name`: Nome do spawn (string)
- `position`: Posição (Vector3)
- `rotation`: Rotação em graus (número)
- `enabled`: Ativo? (booleano)

### 3. **Adicionar Script de Spawn ao Jogador**

1. Vá para **StarterPlayer > StarterCharacterScripts**
2. Insira um novo **LocalScript**
3. Cole o código de `scripts/player/PlayerSpawnSystem.lua`

### 4. **Testando**

1. Clique em **Play** no Roblox Studio
2. Seu personagem deve aparecer em um spawn location aleatório
3. Se morrer, respawnará em outro spawn após 5 segundos

---

## 🎮 Personalizando Spawns

### Como encontrar coordenadas?

1. No Roblox Studio, clique em **View > Properties** (se não estiver visível)
2. Selecione uma part/modelo
3. Procure por **Position** nas propriedades
4. Copie os valores X, Y, Z

Exemplo: Se a posição é `(10, 20, 30)`, use:
```lua
position = Vector3.new(10, 20, 30)
```

### Adicionar novo spawn

Adicione uma nova entrada na tabela `SPAWN_LOCATIONS`:

```lua
{
    name = "Novo Spawn",
    position = Vector3.new(X, Y, Z),
    rotation = GRAUS,
    enabled = true
}
```

---

## ⚙️ Configurações Avançadas

### Ajustar tempo de respawn

Em `PlayerSpawnSystem.lua`, mude:

```lua
local RESPAWN_TIME = 5 -- Mude para o valor desejado
```

### Ajustar tempo de proteção

```lua
local SPAWN_PROTECTION_TIME = 3 -- Tempo em segundos
```

### Desabilitar um spawn

Mude `enabled = false` para o spawn que deseja desabilitar:

```lua
{name = "Spawn Montanha", position = Vector3.new(50, 100, 50), rotation = 45, enabled = false}
```

---

## 🐛 Troubleshooting

**Jogador não spawna?**
- Verifique se o ModuleScript está em ServerScriptService
- Verifique se o nome está exatamente "SpawnLocationModule"
- Procure erros no Output (F9)

**Jogador spawn dentro de objetos?**
- Ajuste o Y (altura) da posição
- Aumente `SPAWN_OFFSET` em PlayerSpawnSystem.lua

**Jogadores não estão protegidos?**
- Certifique-se de que `applySpawnProtection()` está sendo chamada
- Verifique se `SPAWN_PROTECTION_TIME` é maior que 0

---

## 📝 Exemplo Completo

Aqui está um exemplo com 3 spawns customizados:

```lua
local SPAWN_LOCATIONS = {
    {
        name = "Praia",
        position = Vector3.new(0, 10, 0),
        rotation = 0,
        enabled = true
    },
    {
        name = "Caverna",
        position = Vector3.new(-50, 0, -50),
        rotation = 90,
        enabled = true
    },
    {
        name = "Topo da Montanha",
        position = Vector3.new(100, 200, 0),
        rotation = 180,
        enabled = true
    },
}
```

---

## ✅ Checklist

- [ ] ModuleScript criado em ServerScriptService
- [ ] Spawn locations configurados
- [ ] LocalScript adicionado ao StarterCharacterScripts
- [ ] Testado no Play
- [ ] Respawn funcionando
- [ ] Proteção de spawn funcionando

