local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

InService = false

local service = {
    [1] = {
        x = 132.28,
        y = -1304.54,
        z = 29.21,
        h = 206.14448547363,
        notify = "Você tem uma entrega do SexShop!"
    },
    [2] = {
        x = 126.56,
        y = -1458.36,
        z = 29.3,
        h = 48.31071472168,
        notify = "Você tem uma entrega do KFC!"
    },
    [3] = {
        x = 45.38,
        y = -994.39,
        z = 29.33,
        notify = "Você tem uma entrega do HotDog da esquina!"
    },
    [4] = {
        x = 298.21,
        y = -584.33,
        z = 43.27,
        notify = "Você tem uma entrega EMERGENCIAL no HOSPITAL!"
    }
}

local entrega = {
    [1] = {
        x = 275.27,
        y = -1689.43,
        z = 29.28,
        h = 50.751121520996,
        reward = math.random(100,500)
    }
}

Citizen.CreateThread(function()
    local cord = vector3(-22.16,-1391.43,29.42-1)
    local ped = PlayerPedId()


    local model = GetHashKey("a_m_y_motox_02")
    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(1)
    end

    local npc = CreatePed(4, model, cord, 357.94586181641, false, true)
    
    SetPedFleeAttributes(npc, 0, 0)
    SetPedDropsWeaponsWhenDead(npc, false)
    SetPedDiesWhenInjured(npc, false)
    SetEntityInvincible(npc , true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    while true do

        local time = 1000

            if InService == false then
                local player_cords = GetEntityCoords(ped)
                if GetDistanceBetweenCoords(player_cords,cord,true) <= 10 then 
                    time = 10 
                    DrawMarker(23,cord.x,cord.y+0.5,cord.z,0,0,0,0,0,0,1.00,1.00,1.00,0,120,255,100,0,0,0,0)

                    if GetDistanceBetweenCoords(player_cords,cord,true) <= 1.5 then drawTxt("PRESSIONE  ~r~E~w~  PARA PROCURAR SERVIÇO",4,0.5,0.93,0.50,255,255,255,180) end if IsControlJustPressed(0, 38) then 
                        TriggerEvent("Notify","importante","Aguarde estamos buscando serviço!")
                        Citizen.Wait(math.random(10000,20000))
                        src.rotas()
                        InService = true
                    end
                end
            else
                time = 5000
            end

        Citizen.Wait(time)
    end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function src.rotas()
    local rota = math.random(1,#service)

        if rota then
            TriggerEvent("Notify","importante",service[rota].notify,8000)
            local model = GetHashKey("s_m_m_scientist_01")
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(1)
            end

            local npc = CreatePed(4, model, service[rota].x,service[rota].y,service[rota].z-1, service[rota].h, false, true)
        


            SetPedFleeAttributes(npc, 0, 0)
            SetPedDropsWeaponsWhenDead(npc, false)
            SetPedDiesWhenInjured(npc, false)
            SetEntityInvincible(npc , true)
            FreezeEntityPosition(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            local ped = PlayerPedId()
            local bi = addBlip("rotas",rota)
            Citizen.CreateThread(function()
                while true do
                    local time = 10
                    local player_cords = GetEntityCoords(ped)
                    if GetDistanceBetweenCoords(player_cords,service[rota].x,service[rota].y,service[rota].z,false) <= 1.5 and IsControlJustPressed(0, 38) then 
                        DeleteObject(obj)
                        local ped = PlayerPedId()
                        local obj = Objeto(ped,"anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)


                        ClearPedTasks(npc)
                        TaskWanderStandard(npc, 10.0, 10)
                        FreezeEntityPosition(npc, false)
                        DeleteEntity(npc)
                        RemoveBlip(bi)
                        local ent = math.random(1,#entrega)
                        local blip = addBlip("entrega",ent)
                        TriggerEvent("Notify","importante","Entregue o seu item no local demarcado no mapa!",8000)

                        local model = GetHashKey("s_m_m_scientist_01")
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                            Wait(1)
                        end
            
                        local npcs = CreatePed(4, model, entrega[ent].x, entrega[ent].y, entrega[ent].z-1, entrega[ent].h, false, true)

                        SetPedFleeAttributes(npcs, 0, 0)
                        SetPedDropsWeaponsWhenDead(npcs, false)
                        SetPedDiesWhenInjured(npcs, false)
                        SetEntityInvincible(npcs , true)
                        FreezeEntityPosition(npcs, true)
                        SetBlockingOfNonTemporaryEvents(npcs, true)
                        while true do
                            time = 10
                            local player_cords = GetEntityCoords(ped)

                            if GetDistanceBetweenCoords(player_cords,entrega[ent].x, entrega[ent].y, entrega[ent].z,false) <= 1.5 and IsControlJustPressed(0, 38) then 
                                TaskWanderStandard(npcs, 10.0, 10)
                                FreezeEntityPosition(npcs, false)
                                DeleteEntity(npcs)
                                RemoveBlip(blip)
                                vSERVER.pay(entrega[ent].reward)
                                InService = false
                            end
                            Citizen.Wait(time)
                        end
                    end
                    Citizen.Wait(time)
                end
            end)
        end
end

function Objeto(npc,dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
	local ped = npc

	RequestModel(GetHashKey(prop))
	while not HasModelLoaded(GetHashKey(prop)) do
		Citizen.Wait(10)
	end

	if pos1 then
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),pos1,pos2,pos3,pos4,pos5,pos6,true,true,false,true,1,true)
        return(object)
    else
		vRP.CarregarAnim(dict)
		TaskPlayAnim(ped,dict,anim,3.0,3.0,-1,flag,0,0,0,0)
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
        return(object)
    end
	Citizen.InvokeNative(0xAD738C3085FE7E11,object,true,true)
end

function addBlip(type,rotas)
    if type == 'rotas' then
        local blip = AddBlipForCoord(service[rotas].x, service[rotas].y, service[rotas].z)
        SetBlipSprite(blip,280)
        SetBlipAsShortRange(blip,true)
        SetBlipColour(blip,46)
        SetBlipScale(blip,1.0)
        SetBlipRoute(blip, true)
        return blip
    elseif type == 'entrega' then
        local blip = AddBlipForCoord(entrega[rotas].x, entrega[rotas].y, entrega[rotas].z)
        SetBlipSprite(blip,280)
        SetBlipAsShortRange(blip,true)
        SetBlipColour(blip,46)
        SetBlipScale(blip,1.0)
        SetBlipRoute(blip, true)
        return blip
    end
end
