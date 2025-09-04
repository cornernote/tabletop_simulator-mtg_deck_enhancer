-- ULTIMATE MTG Deck Sorter by CoRNeRNoTe
-- Sorts deck in your preferred order.

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

function onObjectEnterContainer(container, object)
    if container ~= self then
        return
    end

    broadcastToAll("WARNING: No tool selected. Right click and choose state. Ejecting object!")
    emptyContainer(container, false)
end

function emptyContainer(container, destroy, pos, rot)
    local count = container.getQuantity()
    local basePos = pos or container.getPosition() + Vector(0, 4, -4)
    local baseRot = rot or container.getRotation() + Vector(180, 180, 180)

    for _ = 1, count do
        local obj = container.takeObject({
            position = basePos,
            rotation = baseRot,
            smooth = true,
        })

        Wait.frames(function()
            if obj then
                local size = obj.getBoundsNormalized().size
                local adjustedPos = basePos + Vector(0, 0, -size.z / 2)
                obj.setPositionSmooth(adjustedPos, false, true)
            end

            if destroy and obj then
                obj.destroy()
            end
        end, 1)
    end
end