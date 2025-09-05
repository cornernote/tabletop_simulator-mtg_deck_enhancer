-- ULTIMATE MTG Deck Lister by CoRNeRNoTe
-- Lists deck cards onto a notecard.

-- Most recent script can be found on GitHub:
-- https://github.com/cornernote/tabletop_simulator-mtg_deck_enhancer/blob/main/lua/mtg-deck-lister.lua

local containedDeckData = null
local cardsInContainerDeck = {}
local defaults = {
    sortBy = "",
    sleeve = "",
}
local selections = defaults

local sortByOptions = {
    "",
    "name",
    "cmc+name",
    "type+name",
    "cmc+type+name",
    "type+cmc+name",
}

function onSave()
    return JSON.encode(selections)
end

function onLoad(save_state)
    selections = JSON.decode(save_state) or defaults

    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "MTG Deck\nEnhancer\n& Tools",
        position = { 0, 0.61, 0 },
        scale = { 0.5, 0.5, 0.5 },
        rotation = { 180, 0, 180 },
        color = { 0.1, 0.1, 0.1, 0.8 },
        font_color = { 1, 1, 1, 1 },
        width = 0,
        height = 0,
        font_size = 200,
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
    cardsInContainerDeck = collapseDeck(containedDeckData.ContainedObjects)

    table.sort(cardsInContainerDeck, function(a, b)
        return compareCards(a, b, selections.sortBy)
    end)

    self.UI.setXml(getConfigXml() .. getDeckListXml())
    setSortByFromSelection()
end

function onObjectLeaveContainer(container, object)
    if container ~= self then
        return
    end

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

    Wait.condition(function()
        object.destroy()
    end, function()
        return object ~= null
    end)

    self.UI.setXml("")
    containedDeckData = null
end

function collapseDeck(cards)
    local uniqueCards = {}

    for _, card in ipairs(cards or {}) do
        local key = card.CardID or card.Nickname
        if not uniqueCards[key] then
            card.Quantity = 1
            uniqueCards[key] = card
        else
            uniqueCards[key].Quantity = uniqueCards[key].Quantity + 1
        end
    end

    local result = {}
    for _, card in pairs(uniqueCards) do
        table.insert(result, card)
    end

    return result
end

function compareCards(a, b, sortBy)
    if not sortBy then
        return
    end

    local fields = {}
    for field in sortBy:gmatch("[^+]+") do
        table.insert(fields, field)
    end

    local function getValue(card, field)
        if field == "name" then
            return getName(card)
        elseif field == "cmc" then
            return getCmc(card)
        elseif field == "type" then
            return getType(card)
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

function getConfigXml()
    return string.format([[
        <Button position="0 0 -52" width="50" height="50" image="https://steamusercontent-a.akamaihd.net/ugc/11685204108261470604/283D709CA895067E844870598EA083AB4E392F71/" onClick="ejectDeck" />

        <Panel width="300" height="110" offsetXY="0 -150" color="#FFFFFF" outline="#666666" outlineSize="2 -2">
            <Row color="#999999" width="300">
                <Text id="WindowTitle" text="Config Options" fontSize="18" fontStyle="Bold" color="#000000" width="230" height="80" />
            </Row>
            <TableLayout width="300" height="40" columnWidths="100 200" border="0" cellPadding="2" color="#FFFFFF">
                <Row preferredHeight="40">
                    <Cell>
                        <Text text="Sort By:"/>
                    </Cell>
                    <Cell>
                        <Dropdown onValueChanged="toggleSortBy(selectedIndex)">
                            %s
                        </Dropdown>
                    </Cell>
                </Row>
                <Row preferredHeight="40">
                    <Cell>
                        <Text text="Sleeve:"/>
                    </Cell>
                    <Cell>
                        <InputField id="sleeveInput" width="300" placeholder="Enter sleeve URL" onEndEdit="onSleeveInput()" />
                    </Cell>
                </Row>
            </TableLayout>
        </Panel>
    ]], getConfigSortByOptionsXml())
end

function getConfigSortByOptionsXml()
    local optionsXml = {}
    for i, opt in ipairs(sortByOptions) do
        local label = opt
        local selected = (opt == selections.sortBy) and ' selected="true"' or ""
        table.insert(optionsXml, string.format('<Option%s>%s</Option>', selected, label))
    end

    return table.concat(optionsXml, "\n")
end

function toggleSortBy(player, index)
    index = tonumber(index) + 1
    selections.sortBy = sortByOptions[index] or ""

    table.sort(cardsInContainerDeck, function(a, b)
        return compareCards(a, b, selections.sortBy)
    end)

    self.UI.setXml(getConfigXml() .. getDeckListXml())
    setSortByFromSelection()
end

function getDeckListXml()
    local buttonWidth = 30
    local buttonHeight = 45

    local xml = ""

    for row = 1, #cardsInContainerDeck do
        local card = cardsInContainerDeck[row]

        if card then
            xml = xml .. string.format([[
                    <Row preferredHeight="%d">
                        <Cell>
                            <Image width="%d" height="%d" image="%s"/>
                        </Cell>
                        <Cell>
                            <Text fontSize="30" alignment="UpperRight" text="%s"/>
                        </Cell>
                        <Cell>
                            <Text fontSize="30" alignment="UpperLeft" text="%s"/>
                        </Cell>
                        <Cell>
                            <Text fontSize="30" alignment="UpperLeft" text="%s"/>
                        </Cell>
                        <Cell>
                            <Text fontSize="30" alignment="UpperRight" text="%s"/>
                        </Cell>
                    </Row>
                ]],
                    buttonHeight, buttonWidth, buttonHeight, getFirstFaceURL(card), card.Quantity, getName(card), getType(card), getCmc(card)
            )
        end
    end

    return string.format([[
        <VerticalScrollView width="1520" height="1000" position="1000 -300 45" scrollSensitivity="30" horizontalScrollbarVisibility="AutoHideAndExpandViewport">
            <TableLayout width="1500" height="%d" columnWidths="37 73 700 600 100" cellPadding="3">
                <Row preferredHeight="%d">
                    <Cell>

                    </Cell>
                    <Cell>
                        <Text fontSize="30" fontStyle="bold" text="Qty"/>
                    </Cell>
                    <Cell>
                        <Text fontSize="30" fontStyle="bold" text="Name"/>
                    </Cell>
                    <Cell>
                        <Text fontSize="30" fontStyle="bold" text="Type"/>
                    </Cell>
                    <Cell>
                        <Text fontSize="30" fontStyle="bold" text="CMC"/>
                    </Cell>
                </Row>
                ]] .. xml .. [[
            </TableLayout>
        </VerticalScrollView>
    ]],
            #cardsInContainerDeck * buttonHeight + buttonHeight, buttonHeight
    )
end

function getSleeveChangerXml()
    local cols = 20
    local rows = 9
    local buttonWidth = 75
    local buttonHeight = 100

    local xml = ""
    local id = 1

    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local image = sleeveImages[id]

            if image then
                if col == 0 and row > 0 then
                    xml = xml .. [[</Row><Row preferredHeight="100">]]
                end

                xml = xml .. string.format([[
                    <Cell>
                        <Button id="sleeve%d" width="%d" height="%d" image="%s" onClick="sleeveClicked(%s)" />
                    </Cell>
                ]],
                        id, buttonWidth, buttonHeight, image, image
                )
            end

            id = id + 1
        end
    end

    return string.format([[
        <VerticalScrollView id="sleeveSelect" active="false" width="1520" height="740" position="1000 -580 45" scrollSensitivity="30" horizontalScrollbarVisibility="AutoHideAndExpandViewport">
            <TableLayout width="1500" height="%d">
                <Row preferredHeight="40">
                    <InputField id="sleeveInput" width="1480" placeholder="Enter the URL of your sleeve here" onEndEdit="onSleeveInput" />
                </Row>
                <Row preferredHeight="%d">]] .. xml .. [[</Row>
            </TableLayout>
        </VerticalScrollView>
    ]],
            (math.floor(id / cols)) * buttonHeight + 40, buttonHeight)
end

function getFirstFaceURL(card)
    if not card.CustomDeck then
        return
    end

    for _, deckDef in pairs(card.CustomDeck) do
        if deckDef.FaceURL then
            return deckDef.FaceURL
        end
    end
end

function getName(card)
    local parts = {}
    for s in card.Nickname:gmatch("([^\n]+)") do
        table.insert(parts, s)
    end
    return parts[1] or "Unknown"
end

function getType(card)
    local parts = {}
    for s in card.Nickname:gmatch("([^\n]+)") do
        table.insert(parts, s)
    end
    return parts[2] or "Unknown"
end

function getCmc(card)
    local cmc = tonumber(card.Nickname:match("(%d+)%s*CMC"))
    if cmc then
        return cmc
    end

    return 0
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

function ejectDeck()
    self.takeObject()
end