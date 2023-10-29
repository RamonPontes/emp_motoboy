local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

function src.pay(amount)
    local user_id = vRP.getUserId(source)
    if user_id then
        TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(amount)).." dólares</b>.")
        vRP.giveBankMoney(user_id,amount)
    end
end