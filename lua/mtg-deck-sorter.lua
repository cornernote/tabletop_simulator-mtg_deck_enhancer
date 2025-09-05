-- ULTIMATE MTG Deck Sorter by CoRNeRNoTe
-- Sorts deck in your preferred order.

-- Most recent script can be found on GitHub:
-- https://github.com/cornernote/tabletop_simulator-mtg_deck_enhancer/blob/main/lua/mtg-deck-sorter.lua

local containedDeckData = null
local defaults = {
    sortBy = "name",
}
local selections = defaults

local sortByOptions = {
    "name",
    "cmc+name",
    "type+name",
    "cmc+type+name",
    "type+cmc+name",
}

local configOpen = false

function onSave()
    return JSON.encode(selections)
end

function onLoad(save_state)
    selections = JSON.decode(save_state) or defaults

    self.UI.setXml(getConfigXml())

    setSortByFromSelection()

    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "MTG Deck\nSorter",
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
    if containedDeckData then
        return false
    end

    local data = object.getData()

    if data.Name ~= "Deck" and data.Name ~= "DeckCustom" then
        return false
    end

    return true
end

function onObjectEnterContainer(container, object)
    if container ~= self then
        return
    end

    containedDeckData = object.getData()

    table.sort(containedDeckData.ContainedObjects, function(a, b)
        return compareCards(a, b, selections.sortBy)
    end)

    containedDeckData.DeckIDs = {}
    for _, card in ipairs(containedDeckData.ContainedObjects) do
        table.insert(containedDeckData.DeckIDs, card.CardID)
    end

    spawnObjectData({
        data = containedDeckData,
        position = self.getPosition() + Vector(0, 4, 0),
        rotation = self.getRotation() + Vector(0, 180, 0),
        callback_function = function(deck)
            deck.setPositionSmooth(self.getPosition() + Vector(0, 4, -4), false, true)
        end
    })

    local oldDeck = container.takeObject()
    Wait.condition(function()
        oldDeck.destroy()
    end, function()
        return oldDeck ~= null
    end)
end

function onObjectLeaveContainer(container, object)
    if container ~= self then
        return
    end

    containedDeckData = null
end

function compareCards(a, b, sortBy)
    local fields = {}
    for field in sortBy:gmatch("[^+]+") do
        table.insert(fields, field)
    end

    local function getValue(card, field)
        if field == "name" then
            return card.Nickname or ""
        elseif field == "cmc" then
            return getCmc(card.Nickname or "")
        elseif field == "type" then
            return getType(card.Nickname or "")
        end
        return ""
    end

    for _, field in ipairs(fields) do
        local va = getValue(a, field)
        local vb = getValue(b, field)

        if va ~= vb then
            return va < vb
        end
    end
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

function getType(name)
    local parts = {}
    for s in name:gmatch("([^\n]+)") do
        table.insert(parts, s)
    end
    return parts[2] or "Unknown"
end

function getCmc(name)
    local cmc = tonumber(name:match("(%d+)%s*CMC"))
    if cmc then
        return cmc
    end

    return 0
end

function getConfigXml()
    return [[
        <Button position="0 0 -52" width="50" height="50" image="https://cdn-icons-png.flaticon.com/512/3592/3592953.png" onClick="toggleConfig" />

        <Panel id="config" active="false" width="300" height="70" offsetXY="0 -150" color="#FFFFFF" outline="#666666" outlineSize="2 -2">
            <Row color="#999999" width="300">
                <Text id="WindowTitle" text="Config Options" fontSize="18" fontStyle="Bold" color="#000000" rectAlignment="UpperCenter" alignment="LowerCenter" width="230" height="80" offsetXY="0 55" />
            </Row>
            <TableLayout width="300" height="40" columnWidths="100 200" rectAlignment="UpperMiddle" offsetXY="0 -15" border="0" cellPadding="2" color="#FFFFFF">
                <Row preferredHeight="40">
                    <Cell>
                        <Text text="Sort By:"/>
                    </Cell>
                    <Cell>
                        <Dropdown id="sortBy" onValueChanged="toggleSortBy(selectedIndex)">
                            <Option selected="true">Name</Option>
                            <Option>CMC+Name</Option>
                            <Option>Type+Name</Option>
                            <Option>CMC+Type+Name</Option>
                            <Option>Type+CMC+Name</Option>
                        </Dropdown>
                    </Cell>
                </Row>
            </TableLayout>
        </Panel>
    ]]
end

function toggleConfig()
    if configOpen then
        self.UI.hide("config")
        configOpen = false
    else
        self.UI.show("config")
        configOpen = true
    end
end

function toggleSortBy(player, index)
    index = tonumber(index) + 1
    if sortByOptions[index] then
        selections.sortBy = sortByOptions[index] or "name"
    else
        selections.sortBy = "name"
    end
end

function setSortByFromSelection()
    if selections.sortBy then
        local index = 1
        for i, v in ipairs(sortByOptions) do
            if v == selections.sortBy then
                index = i
                break
            end
        end

        Wait.frames(function()
            self.UI.setAttribute("sortBy", "value", index - 1) -- UI is 0 indexed
        end, 20)
    end
end