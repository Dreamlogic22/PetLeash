---@class PetLeash
local T = select(2, ...)

---@class Media
T.Media = {
    Colors = {
        Background = CreateColor(0.58, 0.49, 0.4),
        Foreground = CreateColor(0.84, 0.75, 0.64)
    },
    Fonts = {
        Bold = [[Interface\AddOns\PetLeash\Embeds\TherapyUX\Media\Fonts\Expressway.ttf]],
        Normal = [[Interface\AddOns\PetLeash\Embeds\TherapyUX\Media\PTSansNarrow.ttf]]
    },
    Textures = {
        Background = [[Interface\AddOns\PetLeash\Media\Textures\Background]],
        Blank = [[Interface\AddOns\PetLeash\Embeds\TherapyUX\Media\Blank]],
        Checkbox = [[Interface\AddOns\PetLeash\Media\Textures\Checkbox.png]],
        CloseButton = [[Interface\AddOns\PetLeash\Media\Textures\CloseButton]],
        Glow = [[Interface\AddOns\PetLeash\Embeds\TherapyUX\Media\Glow]],
        PetJournalWidget = [[Interface\AddOns\PetLeash\Media\Textures\Paw.png]]
    }
}

--     Textures = {
--         Slider = [[Interface\AddOns\PetLeash\Media\Textures\Slider.png]]
--     }
-- }