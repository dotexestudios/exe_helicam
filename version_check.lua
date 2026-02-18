local color = "^4"
local white = "^7"
local logo = [[
                                     ▄▄▄▄    ▄               █    ▀
         ▄▄▄   ▄   ▄   ▄▄▄          █▀   ▀ ▄▄█▄▄  ▄   ▄   ▄▄▄█  ▄▄▄     ▄▄▄    ▄▄▄
        █▀  █   █▄█   █▀  █         ▀█▄▄▄    █    █   █  █▀ ▀█    █    █▀ ▀█  █   ▀
        █▀▀▀▀   ▄█▄   █▀▀▀▀             ▀█   █    █   █  █   █    █    █   █   ▀▀▀▄
   █    ▀█▄▄▀  ▄▀ ▀▄  ▀█▄▄▀         ▀▄▄▄█▀   ▀▄▄  ▀▄▄▀█  ▀█▄██  ▄▄█▄▄  ▀█▄█▀  ▀▄▄▄▀
]]

local currentVersion = GetResourceMetadata(cache.resource, 'version', 0)
local githubRepo = "dotexestudios/exe_helicam"

local function checkVersion()
    print(color .. logo .. white)
    PerformHttpRequest("https://raw.githubusercontent.com/" .. githubRepo .. "/refs/heads/main/version", function(err, responseText, headers)
        if responseText then
            local data = {}
            for line in responseText:gmatch("[^\r\n]+") do
                local key, value = line:match("^(.-):%s*(.*)$")
                if key and value then
                    data[key] = value
                end
            end

            local newestVersion = data["version"]
            local description = data["version_description"] or "No description provided"
            local filesChanged = data["files_changed"] or ""

            if newestVersion and newestVersion ~= currentVersion then
                print("\n^1-------------------------------------------------------")
                print(("^1[Update Available] ^7%s"):format(cache.resource))
                print(("^3Current: ^7%s | ^2Latest: ^7%s"):format(currentVersion, newestVersion))
                print(("^5Notes: ^7%s"):format(description))

                if filesChanged ~= "" then
                    print("^3Files Changed:")
                    for file in filesChanged:gmatch("([^,]+)") do
                        print(("^7 - %s"):format(file:gsub("^%s*(.-)%s*$", "%1")))
                    end
                end

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