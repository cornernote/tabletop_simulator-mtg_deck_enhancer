-- ULTIMATE MTG Deck Tools by CoRNeRNoTe
-- Multiple tools for your MTG decks.

-- Most recent script can be found on GitHub:
-- https://github.com/cornernote/tabletop_simulator-mtg_deck_enhancer/blob/main/lua/mtg-deck-tools.lua

function onLoad()
    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "MTG Deck\nTools",
        position = { 0, -0.5, 1.3 },
        rotation = { 180, 0, 180 },
        color = { 0.1, 0.1, 0.1, 1 },
        font_color = { 1, 1, 1, 1 },
        width = 0,
        height = 0,
        font_size = 250,
    })
end

function tryObjectEnter(object)
    return false
end
