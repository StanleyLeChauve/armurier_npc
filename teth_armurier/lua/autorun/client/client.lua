surface.CreateFont("TETH:ARMURIER:BUTTON", {
    font = "Nunito", 
    extended = false,
    size = ScreenScale(10),
    weight = 10,
    antialias = true,
})


surface.CreateFont("TETH:ARMURIER:CROSS", {
    font = "Nunito ExtraLight", 
    extended = false,
    size = ScreenScale(15),
    weight = 10,
    antialias = true,
})

surface.CreateFont("TETH:ARMURIER:PETIT", {
    font = "Nunito ExtraLight", 
    extended = false,
    size = ScreenScale(9),
    weight = 10,
    antialias = true,
})

local categories = ARMURERIE.CONFIG.WEAPONS
local function mask(drawMask, draw)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCIL_REPLACE)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilReferenceValue(1)
    drawMask()
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilReferenceValue(1)
    draw()
    render.SetStencilEnable(false)
    render.ClearStencil()
end

local function createMenu()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    frame:ShowCloseButton(false)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(42, 42, 42))
        surface.SetDrawColor(Color(62, 61, 61, 187))
        surface.DrawLine(ScrW() * 0.15, ScrH() * 0.05, ScrW() * 0.15, ScrH() * 0.45)
        draw.SimpleText("Vous avez "..string.Comma(LocalPlayer():getDarkRPVar("money"), " ").."$", "TETH:ARMURIER:BUTTON", ScrW()*0.02, ScrH()*0.45, Color(255,255,255), TEXT_ALIGN_LEFT)

        draw.SimpleText("ARMURIER", "TETH:ARMURIER:BUTTON", ScrW()*0.05, ScrH()*0.01, Color(255,255,255), TEXT_ALIGN_LEFT)
    end

    local CROIX = vgui.Create("DButton", frame)
    CROIX:SetText("×")
    CROIX:SetPos(ScrW() * 0.46, 0)
    CROIX:SetSize(ScrW() * 0.05, ScrH() * 0.03)
    CROIX:SetFont("TETH:ARMURIER:CROSS")
    local col = Color(255, 255, 255)
    CROIX.Think = function(self)
        if self:IsHovered() then
            col = Color(94, 7, 7)
        else
            col = Color(255, 255, 255)
        end
        self:SetTextColor(col)
    end
    CROIX.Paint = nil
    CROIX.DoClick = function()
        frame:Close()
    end

    local categoryScrollPanel = vgui.Create("DScrollPanel", frame)
    categoryScrollPanel:SetSize(ScrW() * 0.15, ScrH() * 0.5)
    categoryScrollPanel:SetPos(0, ScrH() * 0.05)

    local weaponScrollPanel = vgui.Create("DScrollPanel", frame)
    weaponScrollPanel:SetSize(ScrW() * 0.6, ScrH() * 0.5)
    weaponScrollPanel:SetPos(ScrW() * 0.2, ScrH() * 0.05)

    local weaponList = vgui.Create("DIconLayout", weaponScrollPanel)
    weaponList:SetSize(ScrW() * 0.25, 560)
    weaponList:SetPos(0, 0)
    weaponList:SetSpaceY(5)

    for category, _ in pairs(categories) do
        local categoryButton = categoryScrollPanel:Add("DButton")
        categoryButton:SetText(category)
        categoryButton:SetSize(ScrW() * 0.3, 40)
        categoryButton:Dock(TOP)
        categoryButton:DockMargin(10, 5, 10, 0)
        categoryButton:SetFont("TETH:ARMURIER:BUTTON")
        categoryButton:SetTextColor(Color(255, 255, 255))
        local colorRed = Color(49, 49, 49)
        local RIPPLE_DIE_TIME = 1
        local RIPPLE_START_ALPHA = 50

        categoryButton.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(2, 0, 0, w, h, Color(226, 147, 43))
            end

            paint.startPanel(self)
            mask(function()
                paint.roundedBoxes.roundedBox(0, 0 + 1, 0 + 1, w - 2, h - 2, colorRed)
            end,
            function()
                local ripple = self.rippleEffect
                if not ripple then return end

                local rippleX, rippleY, rippleStartTime = ripple[1], ripple[2], ripple[3]
                local percent = (RealTime() - rippleStartTime) / RIPPLE_DIE_TIME

                if percent >= 1 then
                    self.rippleEffect = nil
                else
                    local alpha = RIPPLE_START_ALPHA * (1 - percent)
                    local radius = math.max(w, h) * percent * math.sqrt(2)
                    paint.roundedBoxes.roundedBox(radius, rippleX - radius, rippleY - radius, radius * 2, radius * 2, ColorAlpha(color_white, alpha))
                end
            end)
            paint.endPanel()
        end

        categoryButton.DoClick = function(self)
            weaponList:Clear()
            local posX, posY = self:LocalCursorPos()
            self.rippleEffect = {posX, posY, RealTime()}
            for _, weapon in ipairs(categories[category]) do
                local weaponPanel = weaponList:Add("DPanel")
                weaponPanel:SetSize(ScrW() * 0.3, ScrH() * 0.03)
                weaponPanel.Paint = function(self, w, h)
                    draw.RoundedBox(1, 0, 0, w, h, Color(49, 49, 49))
                    draw.SimpleText(string.upper(weapon.name), "TETH:ARMURIER:BUTTON", ScrW() * 0.01, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.SimpleText(weapon.price .. " $", "TETH:ARMURIER:BUTTON", ScrW() * 0.1, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end
                local acheter = vgui.Create("DButton", weaponPanel)
                    acheter:SetText("")
                    acheter:SetPos(ScrW() * 0.15, 0)
                    acheter:SetSize(ScrW() * 0.1, ScrH() * 0.03)
                    acheter:SetFont("TETH:ARMURIER:BUTTON")

                    local col = Color(255, 255, 255)
                    function acheter.Paint(self, w, h)

                        if weapon.vip then 
                            surface.SetDrawColor(255, 255, 255, 255) 
                            surface.SetMaterial(ARMURERIE.CONFIG.IMGVIP)
                            surface.DrawTexturedRect(ScrW()*0.03, ScrH()*0.005, ScrW()*0.014, ScrH()*0.02)
                        end


                        if self:IsHovered() then
                            if LocalPlayer():getDarkRPVar("money") >= weapon.price then
                                col = Color(12, 93, 42)
                            else
                                col = Color(94, 7, 7)
                            end
                        else
                            col = Color(255, 255, 255)
                        end

                        draw.SimpleText("Voir", "TETH:ARMURIER:BUTTON", ScrW()*0.05,0, col)
                    end

                    acheter.DoClick = function()

                        local arme = vgui.Create("DFrame", frame)
                        arme:SetTitle("")
                        arme:SetSize(ScrW() * 0.25, ScrH() * 0.25)
                        arme:SetPos(ScrW()*0.37, ScrH()*0.35)
                        arme:ShowCloseButton(false)
                        arme:MakePopup()
                        arme.Paint = function(self, w, h)

                            draw.RoundedBox(8, 0, 0, w, h, Color(26, 26, 26))
                        
                            local weaponName = weapon.weapon
                            local getweapon = weapons.Get(weaponName)
                        
                            if not weapon then
                                draw.SimpleText("ERREUR LORS DE L'INITIALISATION DE L'ARME", "TETH:ARMURIER:BUTTON", w / 2, h / 2, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                                return
                            end
                        
                            local isVIP = weapon.IsVIP
                            local isVIPtxt = weapon.IsVIP and "Oui" or not weapon.IsVIP and "Non"
                            local price = weapon.price or "Non défini"
                            local damage = getweapon.Primary.Damage or "Non défini"
                            local rpm = getweapon.Primary.RPM or "Non défini"
                            local magSize = getweapon.Primary.ClipSize or "Non défini"
                            local ammoType = getweapon.Primary.Ammo or "Non défini"
                            local kickUp = getweapon.Primary.KickUp or 0
                            local kickDown = getweapon.Primary.KickDown or 0
                            local kickHorizontal = getweapon.Primary.KickHorizontal or 0
                            local recul = math.Round(( ( kickUp + kickDown + kickHorizontal ) / 3 )*23, 2)
                        
                            local textColor = Color(255, 255, 255)
                            local pos_xdetails = 0.01
                    
                            if weapon.IsVIP then
                                pos_xdetails = 0.035
                            end
                            draw.SimpleText("Détails du "..weapon.name, "TETH:ARMURIER:PETIT", ScrW()*pos_xdetails, ScrH()*0.01, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                            draw.SimpleText("Prix : " .. string.Comma(price, " ").. " $", "TETH:ARMURIER:PETIT", ScrW()*0.01, ScrH()*0.04, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                            draw.SimpleText("Dégats : " .. damage, "TETH:ARMURIER:PETIT",  ScrW()*0.15, ScrH()*0.04, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        
                            draw.SimpleText("CPM : " .. rpm, "TETH:ARMURIER:PETIT",  ScrW()*0.15, ScrH()*0.08, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        
                            draw.SimpleText("Chargeur: " .. magSize, "TETH:ARMURIER:PETIT",  ScrW()*0.15, ScrH()*0.12, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        
                            draw.SimpleText("Type Mun.: " .. ammoType, "TETH:ARMURIER:PETIT",  ScrW()*0.01, ScrH()*0.08, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        
                            draw.SimpleText("Recul : " .. recul, "TETH:ARMURIER:PETIT",  ScrW()*0.15, ScrH()*0.16, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                            if isVIP then 
                                surface.SetDrawColor(255, 255, 255, 255) 
                                surface.SetMaterial(ARMURERIE.CONFIG.IMGVIP)
                                surface.DrawTexturedRect(ScrW()*0.01, ScrH()*0.01, ScrW()*0.02, ScrH()*0.03)
                            end
                        end

                        local wep = vgui.Create("DModelPanel", arme)
                        wep:SetSize(ScrW() * 0.1, ScrH() * 0.1)
                        wep:SetPos(0, arme:GetTall() - wep:GetTall())
                        wep:SetModel("models/weapons/g17/w_m9.mdl")

                        local CROIX = vgui.Create("DButton", arme)
                        CROIX:SetText("×")
                        CROIX:SetPos(ScrW() * 0.21, 0)
                        CROIX:SetSize(ScrW() * 0.05, ScrH() * 0.03)
                        CROIX:SetFont("TETH:ARMURIER:CROSS")
                        local col = Color(255, 255, 255)
                        CROIX.Think = function(self)
                            if self:IsHovered() then
                                col = Color(94, 7, 7)
                            else
                                col = Color(255, 255, 255)
                            end
                            self:SetTextColor(col)
                        end
                        CROIX.Paint = nil
                        CROIX.DoClick = function()
                            arme:Close()
                        end
                        

                        local BUY = vgui.Create("DButton", arme)
                        BUY:SetText("ACHETER")
                        BUY:SetPos(ScrW() * 0.08, ScrH()*0.21)
                        BUY:SetSize(ScrW() * 0.1, ScrH() * 0.03)
                        BUY:SetFont("TETH:ARMURIER:BUTTON")
                        local col = Color(255, 255, 255)
                        BUY.Think = function(self)
                            if self:IsHovered() then
                                col = Color(90, 219, 150)
                            else
                                col = Color(255, 255, 255)
                            end
                            self:SetTextColor(col)
                        end
                        BUY.Paint = nil
                        BUY.DoClick = function()
                            net.Start("TETH:ARMURIER:ACHAT")
                            net.WriteString(weapon.weapon)
                            net.SendToServer() 
                        end
                    end
            end
        end
    end
end

net.Receive("TETH:ARMURIER:OPENPANEL", function()
    createMenu()
end)
