-- all weapons can shoot through "water"
for _, weaponDef in pairs(WeaponDefs) do
    weaponDef.waterweapon = true
    weaponDef.firesubmersed = true
    weaponDef.canattackground = false
end