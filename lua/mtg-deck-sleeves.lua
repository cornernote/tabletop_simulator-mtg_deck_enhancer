-- ULTIMATE MTG Deck Sleeve Changer by CoRNeRNoTe
-- Swaps card sleeves on deck.

-- Most recent script can be found on GitHub:
-- https://github.com/cornernote/tabletop_simulator-mtg_deck_enhancer/blob/main/lua/mtg-deck-sleeves.lua

local defaults = {
    sleeve = "https://steamusercontent-a.akamaihd.net/ugc/1869555872447018243/605ECC61FD27EE474845AA7CC2AAC1AB2984DECB/",
}

local selections = defaults

local sleeveImages = {
    defaults.sleeve,
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447018942/88356A1F95A65CBEBAED0883F2504E4B4E65796C/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447074635/B8AE1DBE33909FFE6082C7DA1B5DBF7EEFD44109/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422032417702/6A2506A9E59002C46DF567714B3C2D4F79BEAB7A/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447056386/97F82F8C9BD4F8B239B7A22A3D080945A47EF0B1/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447056012/CF3DEB9A3ADA16F239632A788126DCE6E99E780E/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036970677/1BB5838C618EF510753A04298C84199AD8A309F4/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447078558/3F7E7B8EE826F758EBDD66490A17442E9619A20D/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447058073/E02D8C9472BEC664E6363F1687658E12516400FF/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447082566/411AA96D4CE0DD6424A3E45AC8FCAD396DF190B8/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422032369915/19711E0A3F109521C8D4174D40CD7BBDEF7A1276/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447022921/56A799BD5B912A6A793E3F8D5383B5FE47C81DBC/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036969876/056DC660B759FA36403C0DE93D9C0604AEC0337F/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036970322/7971AE24E3ACAB182A336AF063B8F3A7DA461ECB/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422032418452/26BC5F00CBB8A0283436FA6484A32B95D84615CB/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036968978/4ADFC95BA092652EB9E00F31D342E321292B25D6/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036978303/9A5BB30B0E323A7CF63FC64F8185A565CE62B9BE/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036978597/FF92098A4177556776C0ED225C71AA2E0F099DF2/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036976791/520DB4D118731902CA3D6C1A74DCC3FC28CB31F6/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036975818/C4C55DBF0A7D108FEC4B85390901A2563232F81A/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447033873/7021019ECB878A3768C60E642AF748BD5D2395A6/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447033360/C3E8EF6F55C8CB0C8C807213EBD001650617E3A1/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447032986/A8DFE2FD3CEA7FB05C89436B90C1589AC4A8FCDE/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447032607/1023C44D87DFC77A916F8925279B2F0B8FDBFCDE/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447031225/06E60BFCF7E19AD2D2CD4C101AF09C9E18809BB0/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036971101/2AC4E7C706E7D8204BD3066EA8E36747A06D9FD9/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036971490/86B8455B027F7C6EDA73726AB1E9A96FEB13FC59/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036971907/A84BFBC49C8329671E0654AD56BF07A748F61C04/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036972345/C9815619FC57AFF7E23D5E0F27D04F523AE6F3A1/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036973196/6051334480E7522B2A322DC77BCAE0583FE3CF13/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036973568/D0C83CB30907BFAE5AF539C2F47FC943AB75C7F6/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036974047/F77494B6BFBA686201FCC4F71BDCBBB9EB91AF4A/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036974550/72CAF6A947CA397CE12AF38FBDE9F8AF6D9E98EB/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036974983/90B0250A303D6F02BE0984CD87043F7900CDA230/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036975414/9B898AD727B52CAA1783BE28F62F432970BC18CC/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447030509/9FBBD8F84856735E2545DB3C14D61FECB4BFE641/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422036977939/58668A20AED602AC08932DF529B97C91971CC32E/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447021949/558C18CA44566497FE4CED8B2391A39A2B68B44D/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447021515/A965B6DC5739EBB06282E1F2134D530F62ABD13C/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872444408252/54BE3E4EBD7DD8DC45E853F141D94E07A22FB640/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872444405789/6F3EE53C9B3845827CB91D7849993AEAE1147E08/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872444406229/31845016ABBF25575230C12A763A5B9E93E9ED5E/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872444407047/9CAD6EE85A85DD4FBB4590CCC6A9E5B5A92CC282/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872444407548/F5B77F8E33D38742488B934E78F148419FF976D8/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872444407958/B1CC27296B183CE3AF34D46CDEB39184D7F68FD3/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447061848/04595EF1316C03AD1A54EE8FE53135448121E3ED/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447061370/C4ABDF1DA94C79AB905EFF913DA96557B8B67C99/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447060676/82B35561304B523A386FADDEBAA5DC4F44572392/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447059902/5D7E476FECFE1C6BE0BDB5EFB2FD1059A1D3CA7B/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447059500/789D746D42F80E48FD696AF79A192E6742E96BE0/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447042631/44715368A9B83C8EF4CE0123551DA932B073F017/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447043066/6D44D16315D7D4794808FDDD0C17C9D76EE2F82C/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447043407/06F855001AA6729A18AF367962C4E98C2ED97202/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447043787/5EA0F048FCB33D4F003D94BE25D7B843705402D1/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447044257/41BEB059BB5AAF6E15ABCC47ED29D00DB1CAD4AF/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447044788/69D9F8F61F1B571F1C4E3F0D737AE9E18779A24A/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447054127/EAD3B7CF2D2B0FD6030302D1FE3B7633A9EE2650/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447045627/681633A3A91DAC9321BC55E1C7C04EEC1FEAD9A8/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447045947/A39C2F72808C18A0E29B1701C575B792F9F627AA/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447046319/B2B0887D7E5A4FD6988DEA1850F465EBF0D447CE/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447045178/0E88949A205E55C8E973A4E9E6A7F6F14788CD5D/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447052906/C8F281E3D0177B99778F59C81A05578BD54E7340/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447052435/8D7D6669B726869C19E27ADE4E13B23CD93A71E6/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447051913/F67885E7A3C18CA5E479A0E5856C126AEA67DFB7/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447053317/41E806324ADDF9A28CB2DB8880E94325311D93CF/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447051448/38B57DF43EFA874D5F2283C8E8E05AFF1D2E3ED7/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447053748/CEB76766CE81A18F1E798FC5D40B7101D16C63C7/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447050834/39E06E352ECA7962629FFDAD315772A1CBAE4F9F/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447046781/0F715797C5DEB36A6DE7356787373704649ADC11/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447050361/2327F1F5077A206DA8A8A938DDFD7A76E3C1CFDF/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447054599/BF6FB3450B0958B10E6EE61E7D39CBA6BB7A998B/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447055615/E04AC568DDC125299454E6F7CE89A122036CBA97/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447020311/7831A0D35D6A5D5270D2BDA699CEB445088D88A2/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447020870/3E4A707588DCC085907BCC25392088F8117A6151/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447056787/173534F57D4D13B578F06413FEB4C080349D0E89/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447073914/E5E0F3847134A51403941E9D100DD0A0682623B6/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447073459/710AC301F4F1DA719C61FB0779859CFD4A9EF091/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447064780/EBDE9CD79ED4D813675444513C5C69AB8C94C941/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447065252/E1BBB0A83DF41A8D1204FBECE8C806CEAB669F2B/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447065750/3F8A009FDD6482338A1BBBBDDE92CF904F9C2BB0/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447066856/1CC0CBBEA482FEA7CB3822BFE430292DAD0326A5/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447066370/C6EC42C900325C74E644999E2295318717B4A76E/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447067812/B0BFEE6936BF475C033D9C737A848140D5CF689A/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447067369/8FCAB2DFA34742AD3ED5DEC034128E4EB64E2931/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447068299/498D5B6651868F51274192CF732E4C673BFE7F3A/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447064162/AB2F26B906670B00A8320001CAB95050AA2D473F/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447063688/D2D30EB5DB89B18ED6EFAF5DF2BBBD95592A2767/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447063219/DFA646B98B6ADB319ADF32BF6CDBB6ED55B91458/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447062858/6D734EC87C08C23709ED22370C82D187F1CEBE54/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447062295/DEBE9A5D242719DDBFA8F84532D99AD47A2B464E/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447041519/6D253E7B3EA52BFE4CAF7843C6901F9AED6FDAB3/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447041099/3D283BBDF7FD721CADE879929216F1E467D674E7/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447039473/329CBB8869EE2050B0D4C0C067B8327EE0D18450/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447040369/EAFC8C917CA2E97FF7F4D8FCC261CB72DBAFD949/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447039965/A60290FC5496C62EC9A7DD724343B66B4FE48411/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447059145/225C0452E4C7AF600EEE8E015B0D67890F9CD49A/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422032393541/BA2D0E76692C8028AC73DFCBC2A4542A5A2CCC1B/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555422032392399/CA1BC8FC5A3A44D376BBD0ED421D8BB70DA4E187/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447057636/E00B15E115FF80C80489D86601E742CA8945879D/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447057192/FA582811FBE626F33BBFB4171D5FBF048F3F08E9/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447069736/5F22FECE7F3FA34A3822BD50C9F3EF44369B4144/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447070194/F6062831D69B5CEB5FBD16B6D566B36E5A545300/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447070658/AA04FFE9DA1EBD9F4DFF619F8E8A0E1FA53F7010/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447071247/434C3E3AFC447DC3430E3361A23ADE125E2D1B73/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447071740/4FABCF1640DE71F4D7BD57A689B333118F1FBC18/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447072210/C429E2DC5264DAEAB5F87059D3A5B08B467E5EC9/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447072593/DC877BCF2399E3A6C6B3A6ADA7D6761664061652/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447073041/1A713A3E53A4075C258EB01E023102F14C880B85/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447069246/DD618E6EB7610F334AA7CD4F606058586048DA5F/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447068778/6D3F6A4E2F11760CFCC3FD1AAA8A64618C4D722E/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447025356/6C5230C2BC1D007063E3A692F98E6FE0ED973FEA/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447025894/6F15188C2893D0DC510337087947658375CEFA27/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447097534/BC1968DCD8798F4841CBE8C1BD4CA4261E3E4B12/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447098375/1BEEEAA9FBC7975C78F61AAB6E183C067A2EC9FF/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447099182/80D3DCB710F0C6BADB92BDBA803D23BD929C8B49/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447087349/17FF73A790FBACF30E9D41232376CD84B8942F07/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447086464/B2C7244E62467A0BAABADE1414A13356D3603C0F/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447087832/7E428167F53A8BD5FB420082F86A062F0EFF5EEF/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447086907/34551EEA373CDAF547834426ED026D63DF19C2D5/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447085639/E29409F3DB430DDCA816186A39403DBF8AE657F6/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447090769/3F24675F832F738711E9D91BEC157F6B539FCA54/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447091401/CADF7EE2DE3D44305CE042032769BE23599C9416/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447092649/5D53A845E4C95853472DFBEDAFF88627B8B24B2C/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447094271/61794AD46ED311761FC67901C6A37FFE7E8EDD42/",
    "https://steamusercontent-a.akamaihd.net/ugc/1869555872447095841/8C84315F66A9FC5ABC12B83F51DF71D387D77842/",
}

local configOpen = false

local show = {
    sleeveSelect = false,
}

function onSave()
    return JSON.encode({ mtgDeckSleeves = selections })
end

function onLoad(save_state)
    if save_state ~= "" then
        jsonState = JSON.decode(save_state)
        if jsonState and jsonState.mtgDeckSleeves then
            selections = jsonState.mtgDeckSleeves
        end
    end

    self.UI.setXml(getSleeveSelectXml() .. getSelectionXml())

    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "MTG Deck\nSleeves",
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

    local data = object.getData()

    if data.Name ~= "Card" and data.Name ~= "CardCustom" and data.Name ~= "Deck" and data.Name ~= "DeckCustom" then
        print("WARNING: Expected Deck or Card to be dropped, instead got " .. tostring(data.Name) .. ". Ejecting object!")
        emptyContainer(container, false)

        return
    end

    updateDeckData(data)

    local outputDeck = spawnObjectData({
        data = data,
        position = self.getPosition(),
        rotation = self.getRotation() + Vector(0, 180, 180),
    })

    outputDeck.setPositionSmooth(self.getPosition() + Vector(0, 4, -4), false, true)

    emptyContainer(container, true)
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

function updateDeckData(data)
    if data.Name == "Card" or data.Name == "CardCustom" then
        updateCustomDeckBackURL(data)
    elseif data.Name == "Deck" or data.Name == "DeckCustom" then
        updateCustomDeckBackURL(data)
        for _, cardData in pairs(data.ContainedObjects) do
            updateCustomDeckBackURL(cardData)
        end
    end
end

function updateCustomDeckBackURL(data)
    if not data.CustomDeck then
        return
    end

    for _, entry in pairs(data.CustomDeck) do
        entry.BackURL = selections.sleeve
    end
end

function hideAllSelects(except)
    local ids = {
        "sleeveSelect",
    }

    for _, id in ipairs(ids) do
        if id ~= except then
            self.UI.hide(id)
            show[id] = false
        else
            self.UI.show(id)
            show[id] = true
        end
    end
end

function getSleeveSelectXml()
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

function getSelectionXml()
    return string.format([[
            <Button position="0 0 -52" width="50" height="50" image="https://cdn-icons-png.flaticon.com/512/3592/3592953.png" onClick="toggleConfig" />

            <Panel id="preview">
                <Image position="0 -140 45" width="100" height="133" image="%s" id="sleevePreview" />
            </Panel>

            <Panel id="selection" active="false">
                <Button position="340 0 45" width="300" height="390" image="%s" id="sleeve" onClick="showSleeveSelectUI" />
                <Text position="340 -210 45" width="300" height="100" color="white" fontSize="24">Select Sleeve</Text>
            </Panel>
        ]],
            selections.sleeve, selections.sleeve
    )
end

function showSleeveSelectUI()
    if show.sleeveSelect then
        self.UI.hide("sleeveSelect")
        show.sleeveSelect = false
    else
        hideAllSelects("sleeveSelect")
    end
end

function sleeveClicked(player, image)
    selections.sleeve = image
    self.UI.setAttribute("sleeve", "image", image)
    self.UI.setAttribute("sleeveInput", "text", "")
    hideAllSelects()
end

function onSleeveInput(player, image)
    selections.sleeve = image
    self.UI.setAttribute("sleeve", "image", image)
    hideAllSelects()
end

function toggleConfig()
    if configOpen then
        self.UI.hide("selection")
        self.UI.show("preview")
        configOpen = false
    else
        self.UI.show("selection")
        self.UI.hide("preview")
        configOpen = true
    end

    hideAllSelects()
end
