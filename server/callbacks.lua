ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local admin_tabs = {}

AddEventHandler('ku_admin:registerUIAdminTabs', function(resource, tabs)
    local path = ""
    local files = {}

    for name, tab in pairs(tabs) do
        tab.name = name
        tab.templates = {}

        for index, file in pairs(tab.files) do
            RegisterResourceAsset(resource, tab.root .. '/' .. file)
            files[resource ..'/' .. tab.root .. '/' .. file] = LoadResourceFile(resource, tab.root .. '/' .. file)
        end

        for path, content in pairs(files) do
            if path:find(".html") then
                path = path:gsub(resource ..'/' .. tab.root .. '/', '')
    
                if path == tab.main_file then
                    path = 'main'
                else
                    path = path:gsub("/","_"):gsub(".html","")
                end

                tab.templates[path] = content
                tab.templates[path] = extract_js(tab.templates[path], files)
                tab.templates[path] = extract_css(tab.templates[path], files)
            end
        end

        tab.resource = resource
        tab.refresh_function = ('%s_%s_refresh_panel'):format(resource, name)

        admin_tabs[('%s/%s'):format(resource, tab.root)] = tab
    end
end)

function extract_js(template, files)
    for script in template:gmatch("<script[^\"]*src=\"([^\"]*)\"") do
        if files[script] == nil then
            print(("ku_admin: UI tabs file did not find file refered in html: %s"):format(script))
        else
            template = template:gsub("<script[^\"]*src=\"" .. script .. "\"[^<]*</script>", "\n<script>\n" .. files[script] .. "\n</script>\n")
        end
    end

    return template
end

function extract_css(template, files)
    local style_tag = "";

    for style in template:gmatch("<link[^>]*href=\"([^\"]*)\"[^>]*/>") do
        if files[style] == nil then
            print(("ku_admin: UI tabs did not find file refered in html: %s"):format(style))
        else
            template = template:gsub("<link[^\"]*href=\"" .. style .. "\"[^>]*/>", '\n<style>\n' .. (files[style]):gsub('%%','%%%%') .. '\n</style>\n')
        end
    end

    return template
end

ESX.RegisterServerCallback('ku_admin:getUIAdminTabs', function(source, cb)
    local tabs = {}
    for key, tab in pairs(admin_tabs) do
        table.insert(tabs, tab)
    end

    cb({tabs = tabs})
end)
