local template = assert(rf2.loadScript(rf2.radio.template))()
local margin = template.margin
local indent = template.indent
local lineSpacing = template.lineSpacing
local tableSpacing = template.tableSpacing
local sp = template.listSpacing.field
local yMinLim = rf2.radio.yMinLimit
local x = margin
local y = yMinLim - lineSpacing
local inc = { x = function(val) x = x + val return x end, y = function(val) y = y + val return y end }
local labels = {}
local fields = {}

local function quot(a, b)
    return (a - (a % b)) / b
end

labels[#labels + 1] = { t = "Stats",                 x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "Total flight count",    x = x + indent, y = inc.y(lineSpacing), readOnly = true, sp = x + sp, min = 0, max = 4294967296, vals = { 1, 2, 3 ,4 } }
fields[#fields + 1] = { t = "Total flight time",     x = x + indent, y = inc.y(lineSpacing), readOnly = true, sp = x + sp, min = 0, max = 4294967296, vals = { 5, 6, 7, 8 } }
fields[#fields + 1] = { t = "Total flight distance", x = x + indent, y = inc.y(lineSpacing), readOnly = true, sp = x + sp, min = 0, max = 4294967296, vals = { 9, 10, 11, 12 } }

return {
    read        = 152, -- MSP_PERSISTENT_STATS
    --write       = , -- not writeable yet?
    eepromWrite = false,
    reboot      = false,
    readOnly    = true,
    title       = "Persistent Stats",
    minBytes    = 12,
    labels      = labels,
    fields      = fields,
    postLoad  = function(self)
        local time_raw = self.fields[2].value
        local time_s = math.fmod(time_raw, 60)
        local time_raw = quot(time_raw, 60)
        local time_min = math.fmod(time_raw, 60)
        local time_h = quot(time_raw, 60)
        self.fields[2].value = string.format("%02d h %02d min %02d s", time_h, time_min, time_s)
    end,
    simulatorResponse = { 0, 0, 0, 0, 0, 2, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}
