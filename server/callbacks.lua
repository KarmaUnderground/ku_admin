ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local templates = {}
AddEventHandler('ku_admin:registerUIAdminTabs', function(resource, tabs)
    local path = ""
    local files = {}

    for name, tab in pairs(tabs) do
        for index, file in pairs(tab.files) do
            RegisterResourceAsset(resource, tab.root .. '/' .. file)
            files[resource .. '/' .. tab.root .. '/' .. file] = LoadResourceFile(resource, tab.root .. '/' .. file)
        end
    end

    for path, content in pairs(files) do
        if path:find(".html") then
            templates[path] = content
            templates[path] = extract_js(templates[path], files)
            templates[path] = extract_css(templates[path], files)
        end
    end

end)

function extract_js(template, files)
    for script in template:gmatch("<script[^\"]*src=\"([^\"]*)\"") do
        template = template:gsub("<script[^\"]*src=\"" .. script .. "\"[^<]*</script>", "\n<script>\n" .. files[script] .. "\n</script>\n")
    end

    return template
end

function extract_css(template, files)
    for style in template:gmatch("<link[^\"]*href=\"([^\"]*)\"") do
        --template = template:gsub("<link[^\"]*href=\"" .. style .. "\"[^>]*/>", "\n<style>\n" .. files[style] .. "\n</style>\n")
    end

    return template
end

ESX.RegisterServerCallback('ku_admin:getUIAdminTabs', function(source, cb)
    cb(ui_admin_tabs)
end)