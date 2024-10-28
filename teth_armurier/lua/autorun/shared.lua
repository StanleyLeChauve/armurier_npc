ARMURERIE = ARMURERIE or {}
ARMURERIE.CONFIG = ARMURERIE.CONFIG or {}

-- vip = true
ARMURERIE.CONFIG.WEAPONS = {
    ["Pistolets"] = {
        { name = "Deagle", weapon = "fas2_deagle", price = 150 },
        { name = "M1911", weapon = "fas2_m1911", price = 150 },
        { name = "Glock-20", weapon = "fas2_glock20", price = 150 },
        { name = "P226", weapon = "fas2_p226", price = 150 },
    },
    ["Fusils d'assaults"] = {
        { name = "SG 552", weapon = "fas2_sg552", price = 500 },
        { name = "M4A1", weapon = "fas2_m4a1", price = 500, IsVIP = true},
        { name = "PP-19 Bizon", weapon = "fas2_pp19", price = 500 },
        { name = "G3A3", weapon = "fas2_g3", price = 500 }

    },
    ["Fusils légers"] = {
        { name = "MP5A5", weapon = "fas2_mp5a5", price = 220 },
        { name = "MP5K", weapon = "fas2_mp5k", price = 220 },
        { name = "MP5SD6", weapon = "fas2_mp5sd6", price = 220, IsVIP = true }
    },
    ["Fusils à pompe"] = {
        { name = "M3 Super 90", weapon = "fas2_m3s90", price = 220 },
    },
    ["Grenades"] = {
        { name = "Gre. Flash", weapon = "ptp_weapon_flash", price = 300 },
        { name = "Gre. Smoke", weapon = "ptp_weapon_smoke", price = 300 },
    },
    ["Accesoires"] = {
        { name = "Machette", weapon = "fas2_machete", price = 5 },
        { name = "Dét. Métaux", weapon = "weapon_checker", price = 5 },
        { name = "Radio", weapon = "aradio", price = 5 }
    },

}

ARMURERIE.CONFIG.IMGVIP = Material("armurier/diamond.png") 