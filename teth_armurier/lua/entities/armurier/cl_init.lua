include("shared.lua")

local mat = Material("teth_logo.png")
function ENT:Draw()
    self:DrawModel()
    local pos = self:GetPos() + self:GetForward() + self:GetRight() * 15 + self:GetUp() * 80
    local ang = self:GetAngles()
    
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)
    
    cam.Start3D2D(pos, ang, 0.1)
        draw.SimpleText("ARMURIER", "eventpanel_btn", 55, 30, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        surface.SetMaterial(mat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(-10, 0, 64, 64)
    cam.End3D2D()
end