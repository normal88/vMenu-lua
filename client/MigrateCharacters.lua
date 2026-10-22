local sourceResource = "vMenu"
local targetResource = GetCurrentResourceName()

local migratedCount = 0
local handle = StartFindKvp("mp_ped_")

while true do
    local key = FindKvp(handle)
    if not key then
        break
    end
    local data = GetResourceKvpString(key)

    if data and data ~= "" then
        migratedCount = migratedCount + 1
    end
end

EndFindKvp(handle)
