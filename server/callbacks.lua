ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local templates = {}

AddEventHandler('ku_admin:registerUIAdminTabs', function(resource, tabs)
    local file_tree = {}

    local index = 0
    local path = ""
    local file_name = ""
    local f_content = ""

    local pointer = nil

    -- Build file tree
    for name, tab in pairs(tabs) do
        for index, file in pairs(tab.files) do
            -- Load the resource file
            RegisterResourceAsset(resource, tab.root .. '/' .. file)
            f_content = LoadResourceFile(resource, tab.root .. '/' .. file)

            file_name = file
            path = ""

            -- Split file name and path
            index = string.find(file, "/[^/]*$")
            if index then 
                file_name = file:sub(index+1)
                path = file:sub(0, index-1)
            end

            -- build folder tree
            pointer = file_tree;
            for folder in file:gmatch("([^/]*)/") do
                if not pointer[folder] then
                    pointer[folder] = {}
                end
                pointer = pointer[folder]
            end

            -- Add the file into the last folder
            pointer[file_name] = f_content
        end

        build_templates(file_tree, "")
    end
end)

function build_file_tree()
end

function build_templates(folder, path)
    for name, item in pairs(folder) do
        if type(item) == "table" then
            build_templates(item, path .. "/" .. name)
        else
            if name:find(".html") then
                print(name .. " " .. path)
                templates[name] = item
                templates[name] = extract_js(templates[name], folder)
                templates[name] = extract_css(templates[name], folder)
            end
        end
    end
end

function extract_css(item, folder)

end

function extract_js(item, folder)
    local script_name = ""
    local path = ""
    local index = nil

    for script in item:gmatch("<script[^\"]*src=\"([^\"]*)\"") do
        script_name = script
        path = ""

        -- Split file name and path
        index = string.find(script, "/[^/]*$")
        if index then 
            script_name = script_name:sub(index+1)
            path = script_name:sub(0, index-1)
        end

        -- build folder tree
        pointer = folder;
        for f in path:gmatch("([^/]*)/") do
            pointer = pointer[f]
        end

        item = item:gsub("<script[^\"]*src=\"" .. script .. "\"[^<]*</script>", "<script>" .. pointer[script_name] .. "</script>")
    end

    return item
end

ESX.RegisterServerCallback('ku_admin:getUIAdminTabs', function(source, cb)
    cb(ui_admin_tabs)
end)