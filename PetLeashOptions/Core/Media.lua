---@class PetLeashOptions
local C = select(2, ...)

---@class Media
C.Media = {
    Colors = {
        Background = CreateColor(0.58, 0.49, 0.4),
        Foreground = CreateColor(0.84, 0.75, 0.64)
    },
    Fonts = {
        Bold = [[Interface\AddOns\PetLeash\Media\Fonts\Expressway.ttf]],
        Normal = [[Interface\AddOns\PetLeash\Media\Fonts\PTSansNarrow.ttf]]
    },
    Textures = {
        Arrow = [[Interface\AddOns\PetLeash\Media\Textures\Arrow]],
        Background = [[Interface\AddOns\PetLeash\Media\Textures\Background]],
        Blank = [[Interface\AddOns\PetLeash\Media\Textures\Blank]],
        Checkbox = [[Interface\AddOns\PetLeash\Media\Textures\Checkbox.png]],
        Close = [[Interface\AddOns\PetLeash\Media\Textures\Close]],
        CloseButton = [[Interface\AddOns\PetLeash\Media\Textures\CloseButton]],
        Glow = [[Interface\AddOns\PetLeash\Media\Textures\Glow]],
        PetJournalWidget = [[Interface\AddOns\PetLeash\Media\Textures\PetJournalWidget.png]],
        Slider = [[Interface\AddOns\PetLeash\Media\Textures\Slider.png]]
    }
}