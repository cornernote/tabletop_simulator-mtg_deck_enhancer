-- ULTIMATE MTG Deck Sorter (simplified) by CoRNeRNoTe
-- Sorts deck by card name.

-- Most recent script can be found on GitHub:
-- https://github.com/cornernote/tabletop_simulator-mtg_deck_enhancer/blob/main/lua/mtg-deck-sorter-simple.lua

function onObjectEnterContainer(container, object)
    -- ignore objects entering other containers
    if container ~= self then
        return
    end

    -- get the deck data
    local deckData = object.getData()

    -- ensure we have a deck
    if deckData.Name ~= "Deck" and deckData.Name ~= "DeckCustom" then
        broadcastAll("Not a deck...")
        return
    end

    -- sort the ContainedObjects, modify as needed for your sorting requirements
    table.sort(deckData.ContainedObjects, function(a, b)
        return a.Nickname < b.Nickname -- ends up with A on bottom and Z on top when looking at the face
    end)

    -- rebuild DeckIDs with the new order
    deckData.DeckIDs = {}
    for _, card in ipairs(deckData.ContainedObjects) do
        table.insert(deckData.DeckIDs, card.CardID)
    end

    -- spawn a new deck near the bag
    spawnObjectData({
        data = deckData,
        position = self.getPosition() + Vector(0, 4, -4),
    })

    -- destroy the original deck
    container.takeObject().destroy()
end