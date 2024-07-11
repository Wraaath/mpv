local watch_later_dirs = {
    "Z:/Videos/Shows",
    "Z:/Videos/Movies",
    "Z:/Audio/Music"
}

local function is_watch_later_enabled(path)
    local normalized_path = path:gsub("\\", "/"):lower()
    for _, dir in ipairs(watch_later_dirs) do
        local normalized_dir = dir:gsub("\\", "/"):lower()
        if normalized_path:sub(1, #normalized_dir) == normalized_dir then
            return true
        end
    end
    return false
end

mp.register_event("start-file", function()
    local path = mp.get_property("path")
    if path then
        mp.msg.info("Current path: " .. path)
        if is_watch_later_enabled(path) then
            mp.msg.info("Watch later enabled for: " .. path)
            mp.set_property_bool("save-position-on-quit", true)
        else
            mp.msg.info("Watch later disabled for: " .. path)
            mp.set_property_bool("save-position-on-quit", false)
        end
    else
        mp.msg.warn("Path not found")
    end
end)
