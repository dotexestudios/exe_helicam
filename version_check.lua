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
local githubRepo = "dotexestudios/exe_helicam"

local function checkVersion()
    print(color .. logo .. white)
    PerformHttpRequest("https://raw.githubusercontent.com/" .. githubRepo .. "/main/version", function(err, newestVersion, headers)
        if newestVersion then
            newestVersion = newestVersion:gsub("%s+", "")
            if newestVersion ~= currentVersion then
                print("\n^1-------------------------------------------------------")
                print(("^1[Update Available] ^7%s"):format(cache.resource))
                print(("^3Current: ^7%s | ^2Latest: ^7%s"):format(currentVersion, newestVersion))
                print(("^3Download: ^7https://github.com/%s"):format(githubRepo))
                print("^1-------------------------------------------------------\n")
            else
                print(("^2[Success] ^7%s is up to date (v%s)"):format(cache.resource, currentVersion))
            end
        else
            print(("^1[Error] ^7Could not check version for %s"):format(cache.resource))
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