local color = "^4"
local white = "^7"
local logo = [[
                                     ▄▄▄▄    ▄               █    ▀
         ▄▄▄   ▄   ▄   ▄▄▄          █▀   ▀ ▄▄█▄▄  ▄   ▄   ▄▄▄█  ▄▄▄     ▄▄▄    ▄▄▄
        █▀  █   █▄█   █▀  █         ▀█▄▄▄    █    █   █  █▀ ▀█    █    █▀ ▀█  █   ▀
        █▀▀▀▀   ▄█▄   █▀▀▀▀             ▀█   █    █   █  █   █    █    █   █   ▀▀▀▄
   █    ▀█▄▄▀  ▄▀ ▀▄  ▀█▄▄▀         ▀▄▄▄█▀   ▀▄▄  ▀▄▄▀█  ▀█▄██  ▄▄█▄▄  ▀█▄█▀  ▀▄▄▄▀
]]

local currentVersion = GetResourceMetadata(cache.resource, 'version', 0)
local githubRepo = "dotexestudios/exe_versions"

local function compareVersions(v1, v2)
    local parts1 = {}
    for part in v1:gmatch("%d+") do table.insert(parts1, tonumber(part)) end
    local parts2 = {}
    for part in v2:gmatch("%d+") do table.insert(parts2, tonumber(part)) end

    for i = 1, math.max(#parts1, #parts2) do
        local n1 = parts1[i] or 0
        local n2 = parts2[i] or 0
        if n1 < n2 then return -1 end
        if n1 > n2 then return 1 end
    end
    return 0
end

local function checkVersion()
    print(color .. logo .. white)
    local url = ("https://raw.githubusercontent.com/%s/main/%s"):format(githubRepo, cache.resource)
    PerformHttpRequest(url, function(err, responseText, headers)
        if responseText then
            local data = {}
            for line in responseText:gmatch("[^\r\n]+") do
                local key, value = line:match("^(.-):%s*(.*)$")
                if key and value then data[key] = value end
            end

            local newestVersion = data["version"]
            local description = data["version_description"] or "No description provided"
            local filesChanged = data["files_changed"] or ""

            if newestVersion then
                local comparison = compareVersions(currentVersion, newestVersion)

                if comparison == -1 then
                    print("\n^1-------------------------------------------------------^4")
                    print(("^1[Update Available] ^7%s^4"):format(cache.resource))
                    print(("^3Current: ^7%s | ^2Latest: ^7%s^4"):format(currentVersion, newestVersion))
                    print(("^5Notes: ^7%s^4"):format(description))
                    if filesChanged ~= "" then
                        print("^3Files Changed:")
                        for file in filesChanged:gmatch("([^,]+)") do
                            print(("^7 - %s^4"):format(file:gsub("^%s*(.-)%s*$", "%1")))
                        end
                    end
                    print(("^3Download: ^7https://github.com/dotexestudios/exe_helicam^4"):format(githubRepo))
                    print("^1-------------------------------------------------------\n^4")
                elseif comparison == 1 then
                    print(("^3[Developer] ^7%s is running a higher version than the repo (v%s)^4"):format(cache.resource, currentVersion))
                else
                    print(("^2[Success] ^7%s is up to date (v%s)^4"):format(cache.resource, currentVersion))
                end
            end
        else
            print(("^1[Error] ^7Could not check version for %s"^4):format(cache.resource))
        end
    end, "GET", "", "")
end

AddEventHandler("onResourceStart", function(resource)
    if resource ~= cache.resource then return end
    Wait(5000)
    checkVersion()
end)

CreateThread(function()
    if cache.resource ~= "exe_helicam" then
        while true do
            Wait(5000)
            print("Cannot check version for exe_helicam, make sure you are using the correct resource name")
        end
    end
end)