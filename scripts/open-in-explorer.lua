-- From: https://gist.github.com/Sneakpeakcss/05a97d509b8be67a6f11400b0bee54ab

mp.add_key_binding(nil, "open-in-explorer", function()
    local path = mp.get_property("path")
    if path ~= nil and not path:match("^%a[%a%d-_]+://") then
        local ps_code = [[
            Start-Process -FilePath explorer.exe -ArgumentList "/select,`"__path__`""
        ]]
        local path = string.gsub(path, "/", "\\")
        local path = string.gsub(path, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
        local ps_path = string.gsub(path, "([$`])", "`%1")      -- escape dollar/backtick signs for PowerShell
        local ps_code = string.gsub(ps_code, "__path__", ps_path)
        mp.command_native({
            name = "subprocess",
            playback_only = false,
            args = { 'powershell', '-NoProfile', '-Command', ps_code },
        })
    else
        mp.osd_message("Invalid path: " .. (path or "No path provided"))
    end
end)