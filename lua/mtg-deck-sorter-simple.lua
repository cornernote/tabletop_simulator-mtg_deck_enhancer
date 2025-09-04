-- ULTIMATE MTG Deck Sorter (simplified) by CoRNeRNoTe
-- Sorts deck by card name.

-- Most recent script can be found on GitHub:
-- https://github.com/cornernote/tabletop_simulator-mtg_deck_enhancer/blob/main/lua/mtg-deck-sorter-simple.lua

function onObjectEnterContainer(container, object)
    if container ~= self then
        return
    end

    local deckData = object.getData()

    if deckData.Name ~= "Deck" and deckData.Name ~= "DeckCustom" then
        return
    end

    -- sort the ContainedObjects
    table.sort(deckData.ContainedObjects, function(a, b)
        return a.Nickname < b.Nickname -- ends up with A on bottom and Z on top when looking at the face
    end)

    -- rebuild DeckIDs with the new order
    deckData.DeckIDs = {}
    for _, card in ipairs(deckData.ContainedObjects) do
        table.insert(deckData.DeckIDs, card.CardID)
    end

    spawnObjectData({
        data = deckData,
        position = self.getPosition() + Vector(0, 4, -4),
    })

    container.takeObject().destroy()
end
