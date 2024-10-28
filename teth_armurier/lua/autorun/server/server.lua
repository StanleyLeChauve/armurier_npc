
util.AddNetworkString("TETH:ARMURIER:OPENPANEL")
util.AddNetworkString("TETH:ARMURIER:ACHAT")

local function IsValidWeapon(category, weaponClass)
    local categories = ARMURERIE.CONFIG.WEAPONS
    if categories[category] then
        for _, weapon in ipairs(categories[category]) do
            if weapon.weapon == weaponClass then
                return weapon
            end
        end
    end
    return nil
end

local function GetWeaponInfo(weaponClass)
    for category, weapons in pairs(ARMURERIE.CONFIG.WEAPONS) do
        local weapon = IsValidWeapon(category, weaponClass)
        if weapon then
            return category, weapon
        end
    end
    return nil, nil
end



net.Receive("TETH:ARMURIER:ACHAT", function(len, ply)
    local weaponClass = net.ReadString()


    local npcs = ents.FindByClass("armurier")
    for _, npc in ipairs(npcs) do
        if npc.value == value then
            npcs = npc
        end
    end

    if ply:GetPos():DistToSqr(npcs:GetPos()) > 300^2 then
        ply:ChatPrint("Vous êtes trop loin de l'armurier.")
        return
    end

    local category, weaponInfo = GetWeaponInfo(weaponClass)
    if not weaponInfo then
        ply:ChatPrint("Arme invalide.")
        return
    end


    if weaponInfo.IsVIP then 
        if ply:GetUserGroup() != "Donateur" then
            ply:ChatPrint("Vous devez posseder le grade donateur !")
            return 
        end
    end
    print(weaponInfo.price)
    print(ply:getDarkRPVar("money"))

    if ply:getDarkRPVar("money") < tonumber(weaponInfo.price) then
        ply:ChatPrint("Vous n'avez pas assez d'argent.")
        return
    end

    ply:addMoney(-weaponInfo.price)
    ply:Give(weaponInfo.weapon)
    ply:ChatPrint("Vous avez acheté " .. weaponInfo.name .. " pour " .. weaponInfo.price .. " $.")
end)

