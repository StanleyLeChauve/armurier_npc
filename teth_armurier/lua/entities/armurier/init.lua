AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/bsnow/zone_teth/new_era_scp_security/new_era_scp_security.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:AcceptInput( name, ply, caller, data )
	if name == "Use" then
        net.Start("TETH:ARMURIER:OPENPANEL")
        net.Send(caller)
	end
end

function ENT:OnTakeDamage()
	return false
end