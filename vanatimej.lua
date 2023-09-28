_addon.name = 'VanaTimeJ'
_addon.author = 'DB'
_addon.version = '1.0'
_addon.commands = {'vanatimej'}

texts = require('texts')
config = require('config')
res_moon_phases = require('resources').moon_phases

local day_list = {
    [0] = {name = '火', color = '(255, 0, 0)'},
    [1] = {name = '土', color = '(255, 225, 0)'},
    [2] = {name = '水', color = '(100, 100, 255)'},
    [3] = {name = '風', color = '(0, 255, 0)'},
    [4] = {name = '氷', color = '(150, 200, 255)'},
    [5] = {name = '雷', color = '(255, 128, 128)'},
    [6] = {name = '光', color = '(255, 255, 255)'},
    [7] = {name = '闇', color = '(150, 150, 150)'},
}

defaults = {
    pos = {
        x = -100,
        y = 0,
    },
    flags = {
        bold = true,
        bottom = false,
        draggable = false,
        italic = false,
        right = true,
    },
    padding = 0,
    text = {
        alpha = 220,
        red = 255,
        green = 255,
        blue = 193,
        size = 11,
        font = 'MS Gothic',
        stroke = {
            alpha = 255,
            blue = 38,
            green = 47,
            red = 51,
            width = 2,
        }
    },
    bg = {
        alpha = 200,
        red = 0,
        green = 0,
        blue = 0,
        visible = false,
    }
}
settings = config.load(defaults)

time_text = texts.new(' ${day|XX} ${hours|XX}:${minutes|XX|%.2d} ${moon_phase|Unknown}(${moon_percent|-}%)', settings)

windower.register_event('load', function()
    local info = windower.ffxi.get_info()
    if info.logged_in then
        moon_change()
        day_change(info.day)
        time_change(info.time)
        time_text:show()
    end
end)

windower.register_event('login', function()
    time_text:show()
end)

windower.register_event('logout', function()
    time_text:hide()
end)

function moon_change()
    local info = windower.ffxi.get_info()
    time_text.moon_phase = res_moon_phases[info.moon_phase].ja
    time_text.moon_percent = info.moon
end

function day_change(day)
    time_text.day = '\\cs' .. day_list[day].color .. day_list[day].name .. '\\cr'
end

function time_change(time)
    time_text.hours = (time / 60):floor()
    time_text.minutes = time % 60
end

windower.register_event('time change', function(new, old)
    time_change(new)
end)

windower.register_event('day change', function(day)
    moon_change()
    day_change(day)
end)

windower.register_event('moon change', function()
    moon_change()
end)
