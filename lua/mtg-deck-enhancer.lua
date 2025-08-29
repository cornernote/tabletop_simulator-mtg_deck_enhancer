-- ULTIMATE MTG Deck Enhancer by CoRNeRNoTe
-- Adds card sleeves and full-art lands for enhanced deck visuals.

-- Most recent script can be found on GitHub:
-- https://github.com/cornernote/tabletop_simulator-mtg_deck_enhancer/blob/main/lua/mtg-deck-enhancer.lua

local defaults = {
    sleeve = "https://steamusercontent-a.akamaihd.net/ugc/1869555872447018243/605ECC61FD27EE474845AA7CC2AAC1AB2984DECB/",
    plains = "https://cards.scryfall.io/png/front/4/0/4069fb4a-8ee1-41ef-ab93-39a8cc58e0e5.png",
    island = "https://cards.scryfall.io/png/front/a/2/a2e22347-f0cb-4cfd-88a3-4f46a16e4946.png",
    swamp = "https://cards.scryfall.io/png/front/f/0/f0b234d8-d6bb-48ec-8a4d-d8a570a69c62.png",
    mountain = "https://cards.scryfall.io/png/front/c/4/c44f81ca-f72f-445c-8901-3a894a2a47f9.png",
    forest = "https://cards.scryfall.io/png/front/a/3/a305e44f-4253-4754-b83f-1e34103d77b0.png",
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
    defaults.sleeve,
    defaults.sleeve,
    defaults.sleeve,
    defaults.sleeve,
    defaults.sleeve,
    defaults.sleeve,
    defaults.sleeve,
    defaults.sleeve,
    defaults.sleeve,
    defaults.sleeve,
}

local landImages = {
    { type = "plains", url = defaults.plains, group = "-1" },
    { type = "island", url = defaults.island, group = "-1" },
    { type = "swamp", url = defaults.swamp, group = "-1" },
    { type = "mountain", url = defaults.mountain, group = "-1" },
    { type = "forest", url = defaults.forest, group = "-1" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/a/7a961768-6166-4852-b518-23eb4cced47d.jpg", group = "1" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/a/8ac1fceb-8427-409c-98a4-9a5c1ff980b4.jpg", group = "1" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/8/c835f235-4196-4281-9788-13e5d54a92d0.jpg", group = "1" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/d/2/d2209e6f-1d9d-43bb-a314-a8fefc509e78.jpg", group = "1" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/c/1c59fc48-704b-4187-b9d3-2a2cff6dd54b.jpg", group = "1" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/9/99577b28-4bfc-4192-bb23-c1f73666295e.jpg", group = "2" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/4/644791df-ac34-45c7-90c1-0ebd9e519840.jpg", group = "2" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/0/90bc54df-b5a0-43fd-b3e6-3ba3d295d25c.jpg", group = "2" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/f/af06d83f-1c5a-4eb6-92b4-216acfe20641.jpg", group = "2" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/c/ac2c51de-2ec9-4a38-a117-75e90abf0feb.jpg", group = "2" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/2/c20ec10e-78fc-49dc-a112-7863a34056b1.jpg", group = "3" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/7/a735e9b5-1231-4aa9-9eb3-c83037b849f2.jpg", group = "3" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/f/ef5cb444-7b48-40c8-a4d9-3fee37429513.jpg", group = "3" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/a/6ad4e9cd-76e2-4ee0-8185-8b3aec3578ce.jpg", group = "3" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/3/c318bae5-5d3f-4e91-adfe-13c182511ef7.jpg", group = "3" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/d/1/d1225bf1-3237-4a86-ad35-588479cd0a10.jpg", group = "4" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/0/5/05bc1b45-ffb8-4efa-8ba8-8601ff38ed62.jpg", group = "4" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/5/951bd227-4212-439d-94bb-d1d8ac30ecee.jpg", group = "4" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/b/ab92170a-0c92-4e48-8ed1-f93d2e08e842.jpg", group = "4" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/c/6c7913b8-60c7-4d61-b8bb-ee57a02e709a.jpg", group = "4" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/a/5acefadb-8b2f-4319-a5e9-1e8fd9ef3086.jpg", group = "5" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/d/ed2cfa62-c972-4373-b405-a075697d009c.jpg", group = "5" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/8/38fef662-993c-4522-8b3f-7c1d3bb1d946.jpg", group = "5" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/a/7a4c0731-555a-4bef-9d9e-b877f0339417.jpg", group = "5" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/2/122b5548-5ff5-43e4-b799-75c709b1c32d.jpg", group = "5" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/0/e0ed0c75-0ec3-4f06-8c37-750fefb8136d.jpg", group = "6" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/a/8af8122a-2943-4507-a93a-564fe63a035b.jpg", group = "6" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/1/f19d95c5-278f-4ad5-99ea-9fcf85520de2.jpg", group = "6" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/3/23fb3767-544d-4ae7-b7c4-af0944a0281b.jpg", group = "6" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/e/2e9a891d-a2c6-418d-a6bd-be2353b3e980.jpg", group = "6" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/d/1dc5e9e3-05e0-4807-9998-b782df791697.jpg", group = "7" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/a/fa1980c8-6f8d-4d27-830e-2c3df98fb9bf.jpg", group = "7" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/e/bea00967-8eb9-453b-a7c0-7198b4b4f7d4.jpg", group = "7" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/d/a/dafbaffb-45ba-4b74-b57c-2a3f7c259e6b.jpg", group = "7" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/4/2491fc97-f938-4d06-969b-3e8baa4dd96a.jpg", group = "7" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/a/7a2c8b8e-2e28-4f10-b04f-9b313c60c0bb.jpg", group = "8" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/0/105b2118-b22c-4ef5-bac7-836db4b8b9ee.jpg", group = "8" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/1/f108b0fb-420a-422d-ae85-9a99c0f73169.jpg", group = "8" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/4/4/44c1a862-00fc-4e79-a83a-289fef81503a.jpg", group = "8" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/8/f8772631-d4a1-440d-ac89-ac6659bdc073.jpg", group = "8" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/f/5f4bf87b-1e31-4c09-b685-86592eb32be9.jpg", group = "9" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/a/fa6f05fa-30e4-4b2c-9641-8a5847b59d65.jpg", group = "9" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/6/b6ed633b-6452-4a0c-b308-ac28ad438933.jpg", group = "9" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/0/5/05712bcb-eb67-4e84-a640-7e507675756a.jpg", group = "9" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/d/ed189e2b-a4e5-493b-9085-a5aae892e5a8.jpg", group = "9" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/e/6ed1902d-0b09-4bbe-9059-a0779450ee05.jpg", group = "10" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/d/8dc3bd34-4d12-4728-a53a-b5ae434d74b0.jpg", group = "10" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/7/77ba59d8-c13c-4966-845f-c090e9f061cb.jpg", group = "10" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/b/3ba24a61-e529-4490-8536-6276ea77c511.jpg", group = "10" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/d/ad8ff40e-2d40-4557-8209-d2c84eb4ccf2.jpg", group = "10" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/b/cb382733-ff3d-43e2-9b1e-efa2f7c28173.jpg", group = "11" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/4/547f89f2-30a0-493a-914e-6251d2574099.jpg", group = "11" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/9/69384f97-3333-4aa7-bc4f-928ba49a2c80.jpg", group = "11" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/e/8e3c2e1a-181e-4275-ad09-51c9de039d32.jpg", group = "11" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/3/b3ed8a17-ce32-4100-8ffc-fb8af1c35142.jpg", group = "11" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/1/3138154c-5763-4105-a635-b697fe4c1e52.jpg", group = "12" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/1/71207752-0d8a-4ab5-be64-cca600608e76.jpg", group = "12" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/c/1c590ebb-1e3a-4861-b8f2-aef9c4259efd.jpg", group = "12" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/c/3cecf0db-0e0e-4329-b055-bb9dad912ca8.jpg", group = "12" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/c/8c70181e-7b28-46b1-a51a-ba99e58e8566.jpg", group = "12" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/2/52ce85a5-1a3e-41a6-8a2c-ac9f78286af3.jpg", group = "13" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/b/9b4812c4-58ad-4215-8a3e-e731a42e156a.jpg", group = "13" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/9/19bef0f3-68a0-47ed-adcd-2adadc3ebe23.jpg", group = "13" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/a/8a05eb4e-dbea-4d41-939f-b9d92b56f56a.jpg", group = "13" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/0/6066f195-385f-4c51-8090-3989fd692078.jpg", group = "13" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/f/9f015fe9-c7fa-4503-b0cc-c0e7f098882f.jpg", group = "14" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/2/c2a51829-8319-4271-93b2-a7a635b30e80.jpg", group = "14" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/4/94cb941f-e3cf-45d2-9989-2a0a454d5497.jpg", group = "14" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/5/8584b531-6dfa-43b2-99ba-b614b147f9a8.jpg", group = "14" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/1/c10cf58b-e01e-413e-979b-c6fe9e93100b.jpg", group = "14" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/b/2b069f97-735a-4d85-8504-b5a863bd659b.jpg", group = "15" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/4/54591ec7-94a1-470c-927a-788b6a514444.jpg", group = "15" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/e/2e55a405-bf5b-4158-ba9a-239627ac9701.jpg", group = "15" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/6/a6f72e53-52bb-4cf4-9b8b-34ed0c5f7c3c.jpg", group = "15" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/8/e8760175-e9bb-4ef9-87ca-591d1edd5163.jpg", group = "15" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/d/1d7dba1c-a702-43c0-8fca-e47bbad4a00f.jpg", group = "16" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/0/c/0c4eaecf-dd4c-45ab-9b50-2abe987d35d4.jpg", group = "16" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/3/8365ab45-6d78-47ad-a6ed-282069b0fabc.jpg", group = "16" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/4/2/42232ea6-e31d-46a6-9f94-b2ad2416d79b.jpg", group = "16" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/9/19e71532-3f79-4fec-974f-b0e85c7fe701.jpg", group = "16" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/1/b11c9a26-3234-480b-94cf-49f15f2b0002.jpg", group = "17" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/9/695f7519-b011-4a86-9226-80c2d9747a42.jpg", group = "17" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/4/6/46e0aaac-fc82-4ce9-87d1-8dead8ec29fd.jpg", group = "17" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/1/11c94acd-ad60-4aec-b11b-f4dc4a9adfbc.jpg", group = "17" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/f/3f7f206a-7b5e-4fd5-8c9e-d665ac3f7dea.jpg", group = "17" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/3/b38e0742-63fe-49a0-a781-aa4fedaaaf66.jpg", group = "18" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/3/93b0918a-398a-4c6d-a5a9-e35a999b24ae.jpg", group = "18" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/0/a/0ac4751c-812a-4990-b093-336f3d6f4502.jpg", group = "18" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/e/5e526e22-d1e4-401b-84b9-866f23139d75.jpg", group = "18" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/c/cc46739c-290c-4a2d-9301-5ab89727ce37.jpg", group = "18" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/c/cc3db531-3f21-49a2-8aeb-d98b7db94397.jpg", group = "19" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/1/91595b00-6233-48be-a012-1e87bd704aca.jpg", group = "19" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/e/8e5eef83-a3d4-44c7-a6cb-7f6803825b9e.jpg", group = "19" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/4/6418bc71-de29-410c-baf3-f63f5615eee2.jpg", group = "19" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/4/146b803f-0455-497b-8362-03da2547070d.jpg", group = "19" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/d/e/deabdaa1-6227-48e4-82d5-63a1771320b2.jpg", group = "20" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/4/54ddd3aa-593c-4adb-b591-33c15d02131c.jpg", group = "20" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/4/a/4abfe418-15f8-46ce-9b39-fd5a38b25d12.jpg", group = "20" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/a/8a4448b6-0dbe-427c-b145-8ac915fc0dfc.jpg", group = "20" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/4/e4c83b60-3d49-4fdc-a6b7-06d1a0c4a126.jpg", group = "20" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/9/e9646663-ba93-446b-ad83-71503924e7f8.jpg", group = "21" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/4/d/4dc3a90f-23c4-4c54-8825-32cb17977b48.jpg", group = "21" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/c/bc9e2d99-a3ad-4bfb-a781-a8a9454085c9.jpg", group = "21" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/a/7a298c5d-9937-4df6-a544-7b3bcfe84885.jpg", group = "21" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/4/341b05e6-93bb-4071-b8c6-1644f56e026d.jpg", group = "21" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/0/a/0a143c32-d78b-40ee-8d2b-a8ce303162d6.jpg", group = "22" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/1/21e41579-5cbf-41c8-ac1b-e6256220087d.jpg", group = "22" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/4/5452c8e4-3463-4ae3-a9d1-5947bea4684e.jpg", group = "22" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/7/37acb733-b3bd-4140-915d-b2c0989208aa.jpg", group = "22" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/d/2d3a6ecf-323d-4650-aabf-92995e3c72c6.jpg", group = "22" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/9/a9891b7b-fc52-470c-9f74-292ae665f378.jpg", group = "23" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/c/acf7b664-3e75-4018-81f6-2a14ab59f258.jpg", group = "23" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/0/2/02cb5cfd-018e-4c5e-bef1-166262aa5f1d.jpg", group = "23" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/3/53fb7b99-9e47-46a6-9c8a-88e28b5197f1.jpg", group = "23" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/2/32af9f41-89e2-4e7a-9fec-fffe79cae077.jpg", group = "23" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/d/5d918248-85ff-4fea-ac91-aa5466dd2829.jpg", group = "24" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/b/1ba4b3ad-1aef-44d3-889a-aedd9e070975.jpg", group = "24" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/4/1/418335b2-398f-499e-92ad-8d21a5a5b69f.jpg", group = "24" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/8/c89b3c3a-3dba-47b3-9620-d4dd754a59e6.jpg", group = "24" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/2/e2ef9b74-481b-424b-8e33-f0b910f66370.jpg", group = "24" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/6/8673e184-2b58-44ef-bb68-bd3d139ed0ba.jpg", group = "25" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/d/6d8f64a6-ba1b-4cd9-8cf9-15f394f9524b.jpg", group = "25" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/3/53f5c55d-09e5-49dd-906c-0f48a79b4c15.jpg", group = "25" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/6/96549393-9607-43c8-91de-905462cbcb19.jpg", group = "25" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/7/e7f57347-7206-4a2f-a41b-0612d456cd30.jpg", group = "25" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/6/36446ad6-8bf0-4e4e-bbab-379c22dbf4f6.jpg", group = "26" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/5/551f905b-4ce0-4071-a721-7e51be14d114.jpg", group = "26" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/0/a095fed4-0a2a-4092-b923-8f46c8ea22d8.jpg", group = "26" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/0/3/03bacab3-25fb-4a0c-81b3-7e9e22899c2c.jpg", group = "26" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/2/52c21f91-6679-4adb-baf2-b06cf505150c.jpg", group = "26" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/a/5a8279b9-c1dd-43db-a01b-89567bb43374.jpg", group = "27" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/c/5cde9dcf-f0b4-4e76-ac4e-d4a8ac355fbe.jpg", group = "27" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/a/8/a8594426-c965-4187-a72d-7582f21b0ea1.jpg", group = "27" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/a/3a42ac42-b21a-449b-abda-6906f06e8120.jpg", group = "27" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/4/9/491b26e4-1d52-457c-a00c-bdee127f8a97.jpg", group = "27" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/2/2296cffa-be1f-49af-aaca-3166e7043de0.jpg", group = "28" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/6/96ad5cbb-b64e-4e18-9aa0-ac076d4b2448.jpg", group = "28" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/b/1b1d4996-ed4e-4818-a9ec-f5d8ee84ad26.jpg", group = "28" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/3/737ac24f-a47b-486c-89df-3e3eaf495ff5.jpg", group = "28" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/2/12a035fe-8847-4678-84f7-01bac77ae011.jpg", group = "28" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/6/5665190e-ea2a-498e-9c4f-f0bc514bd80c.jpg", group = "29" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/b/bb695ab9-72dc-4b07-b42d-e2109a5254b6.jpg", group = "29" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/6/26142ae3-5aa1-4b9b-989a-21c0e4e5089d.jpg", group = "29" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/0/701aefd4-074a-47b8-88a3-32fb90b09dee.jpg", group = "29" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/8/184a9654-ce17-4378-b52b-fb6efbbf042f.jpg", group = "29" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/2/82283c22-9b64-4f41-a5bb-aeb737eee5c9.jpg", group = "30" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/5/15303b22-ddf0-488d-b07e-a118f35ef00f.jpg", group = "30" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/3/f3c850b9-d014-4cd1-8ffd-361ed4fe1e6d.jpg", group = "30" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/e/9e1170a5-e5bb-4b86-8718-f75eec679b4e.jpg", group = "30" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/1/f1488e6b-f677-44c5-8ff3-6a2f9bdb28c2.jpg", group = "30" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/b/6b362e9b-8d25-405e-b70e-f3c9533627a7.jpg", group = "31" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/0/20b4cbcc-c394-4be3-8072-8893b48c866d.jpg", group = "31" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/4/847cac15-b404-4e0f-964e-7aee41c93346.jpg", group = "31" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/3/e3de70f1-6fb1-4191-b66f-491c794f9c05.jpg", group = "31" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/7/6744c441-42b3-48b2-af06-1e27ec776d97.jpg", group = "31" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/8/58a735c9-08a1-4950-bf8c-ed1cfba76765.jpg", group = "32" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/4/8490261d-4246-4232-b7fc-23204c14a7b5.jpg", group = "32" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/3/132155ae-f7a4-4957-91cb-e51ff52716f9.jpg", group = "32" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/0/c/0c9cbae1-6b04-4408-82fe-3fcf61dffbe2.jpg", group = "32" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/4/642102a2-abde-4e76-a6d6-08f7befe1196.jpg", group = "32" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/0/c0072839-e1ae-4c4c-b350-cc98a7747c33.jpg", group = "33" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/b/6b984a9f-38a4-44d2-b8fc-3cd77c843b55.jpg", group = "33" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/8/1861c363-b591-497f-b203-b0e3b2ebf813.jpg", group = "33" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/7/9706f62a-7a2e-4cf3-820d-78f1beaa76c5.jpg", group = "33" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/7/67575f45-f1e5-4837-ba1e-d565b230a0fd.jpg", group = "33" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/5/9591fd15-78d9-4089-a075-031ab2affd2d.jpg", group = "34" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/7/77ea783b-adaa-47be-9918-ca2f161c5d9e.jpg", group = "34" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/5/95a58ce4-e07f-4c9c-98ae-3173d6d63cc5.jpg", group = "34" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/9/6/96297bcc-8480-4b14-8612-1c395d481bce.jpg", group = "34" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/d/9/d949485e-5188-49f4-9d30-5e135532d445.jpg", group = "34" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/4/c453d1ea-9a42-4ccb-9391-eec122025647.jpg", group = "35" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/d/1d018af9-dd14-46fa-8fd5-226defc9698f.jpg", group = "35" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/4/6/46a6375e-9477-4871-8a15-02439f3f6f34.jpg", group = "35" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/d/3d6da8eb-31b0-48c1-9ad9-552827967f91.jpg", group = "35" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/d/5dda1113-352c-471a-a7e0-a9a3cb3f19c5.jpg", group = "35" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/c/bc4f4b6d-ff35-4b1f-974b-f39569e6b3c7.jpg", group = "36" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/f/efd86f2a-bd28-4731-838d-78e67be8b49e.jpg", group = "36" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/c/7cd6becc-f06a-4fd3-8305-70604b92a187.jpg", group = "36" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/3/232ee129-0db1-4a03-9eda-4692a8495b53.jpg", group = "36" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/0/f0ca4b9f-4ee6-4ad8-a95f-326ada9de3cd.jpg", group = "36" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/c/7/c7191d23-b68f-406b-8c28-8dadbaef6562.jpg", group = "37" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/e/bec6fced-62bb-4a99-9ea1-374056b5781b.jpg", group = "37" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/0/60b7c997-e520-4ff6-8b3b-705c2f12a9d4.jpg", group = "37" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/d/3/d3112990-3919-46b0-b927-14566c689a81.jpg", group = "37" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/c/2c2fc9f7-21af-4416-abf5-6fcb4f543680.jpg", group = "37" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/6/5696ea9a-4ddc-40c2-9de2-eca25acc4211.jpg", group = "38" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/6/8/68d36bab-bba8-4b50-aecb-d4c68763c3a1.jpg", group = "38" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/9/590189a3-d845-4d5a-9c8d-70b99633e6c5.jpg", group = "38" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/d/3d336a36-0da7-457a-b613-b6ca92829fbe.jpg", group = "38" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/8/5/859fcdd6-4662-4c96-823c-8487dffd96a1.jpg", group = "38" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/3/4/34fe1359-c78c-41fb-95d9-fcc7c46f0bb1.jpg", group = "39" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/e/b/ebbaf2e2-b4af-4a84-ab27-d8a6b40c9552.jpg", group = "39" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/f/5/f52b53b7-4a20-48eb-a0bd-4ddf40aae740.jpg", group = "39" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/7/277af45a-1f91-4fd4-804d-5b34241386b8.jpg", group = "39" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/2/a/2a9e6cdc-f92f-497c-8cd9-b69586098512.jpg", group = "39" },
    { type = "plains", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/1/1/1164f7ec-7b2f-4cc9-90bb-7eaaa331b4cd.jpg", group = "39" },
    { type = "island", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/d/5/d59cb0b5-fd4f-4dde-a69f-7ca6aa12b89f.jpg", group = "39" },
    { type = "swamp", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/5/c/5cb03b18-d74c-4c89-9539-3549d2e8ff5f.jpg", group = "39" },
    { type = "mountain", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/b/0/b044630d-50e7-431b-8e91-bd53e967f594.jpg", group = "39" },
    { type = "forest", url = "https://c1.scryfall.com/file/scryfall-cards/large/front/7/b/7b6c2532-be5a-4f1f-893c-36bcda2a699d.jpg", group = "39" },
}

local groupLands = true

local configOpen = false

local show = {
    sleeveSelect = false,
    landSelect = false,
    plainsSelect = false,
    islandSelect = false,
    swampSelect = false,
    mountainSelect = false,
    forestSelect = false,
}

function onSave()
    return JSON.encode(selections)
end

function onLoad(save_state)
    if save_state ~= "" then
        selections = JSON.decode(save_state)
    end

    self.UI.setXml(getLandSelectXml() .. getLandTypesSelectXml() .. getSleeveSelectXml() .. getSelectionXml())

    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "MTG Deck\nEnhancer",
        position = { 0, -0.3, -1.3 },
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
        rotation = self.getRotation() + Vector(180, 180, 0),
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
        updateCustomDeckLand(data)
    elseif data.Name == "Deck" or data.Name == "DeckCustom" then
        updateCustomDeckBackURL(data)

        for _, cardData in pairs(data.ContainedObjects) do
            updateCustomDeckBackURL(cardData)
        end

        updateCustomDeckLands(data)
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

function updateCustomDeckLand(data)
    if not data.CustomDeck then
        return
    end

    local url = getLandImage(data.Nickname)

    if url then
        for _, entry in pairs(data.CustomDeck) do
            entry.FaceURL = url
        end
    end
end

function updateCustomDeckLands(data)
    if not data.CustomDeck or not data.ContainedObjects then
        return
    end

    for _, card in pairs(data.ContainedObjects) do

        local url = getLandImage(card.Nickname)
        if url then
            if card.CustomDeck then
                for _, entry in pairs(card.CustomDeck) do
                    entry.FaceURL = url
                end
            else
                card.FaceURL = url
            end

            -- find and update the entry in the deck.CustomDeck
            local entryId = getDeckEntryId(card.CardID, data.CustomDeck)
            if entryId then
                data.CustomDeck[entryId].FaceURL = url
            end
        end
    end
end

function getDeckEntryId(cardId, customDeck)
    local idStr = tostring(cardId)
    for i = #idStr, 1, -1 do
        local key = tonumber(idStr:sub(1, i))
        if customDeck[key] then
            return key
        end
    end
    return nil -- no match
end

function getLandImage(name)
    local landFaces = {
        Plains = selections.plains,
        Island = selections.island,
        Swamp = selections.swamp,
        Mountain = selections.mountain,
        Forest = selections.forest,
    }

    if string.find(name, "Basic Land") then
        for landType, url in pairs(landFaces) do
            if string.find(name, landType) then
                return url
            end
        end
    end
end

function hideAllSelects(except)
    local ids = {
        "sleeveSelect",
        "landSelect",
        "plainsSelect",
        "islandSelect",
        "swampSelect",
        "mountainSelect",
        "forestSelect",
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
    local cols = 15
    local rows = 9
    local buttonWidth = 75
    local buttonHeight = 100
    local depth = 50
    local startX = -250
    local startY = 350

    local xml = ""
    local id = 1

    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local posX = startX - (col * buttonWidth)
            local posY = startY + (row * buttonHeight)
            local image = sleeveImages[id] or ""
            xml = xml .. string.format([[
                <Button id="sleeve%d" position="%d %d %d" rotation="180 180 0" width="%d" height="%d" image="%s" onClick="sleeveClicked(%s)" />
            ]],
                    id, posX, posY, depth, buttonWidth, buttonHeight, image, image
            )
            id = id + 1
        end
    end

    xml = xml .. [[
        <InputField id="sleeveInput" position="-775 270 50" rotation="180 180 0" width="1120" placeholder="Enter the URL of your sleeve here" onEndEdit="onSleeveInput"></InputField>
    ]]

    return [[<Panel id="sleeveSelect" active="false">]] .. xml .. [[</Panel>]]
end

function getLandSelectXml()
    local cols = 25
    local rows = 9
    local buttonWidth = 75
    local buttonHeight = 100
    local depth = 50
    local startX = -250
    local startY = 300

    local xml = ""
    local id = 1

    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local posX = startX - (col * buttonWidth)
            local posY = startY + (row * buttonHeight)
            local image = landImages[id] or { type = "", url = "" }
            xml = xml .. string.format([[
                <Button id="land%d" position="%d %d %d" rotation="180 180 0" width="%d" height="%d" image="%s" onClick="landClicked(%s)" />
            ]],
                    id, posX, posY, depth, buttonWidth, buttonHeight, image.url, image.url
            )
            id = id + 1
        end
    end

    return [[<Panel id="landSelect" active="false">]] .. xml .. [[</Panel>]]
end

function getLandTypesSelectXml()
    return getLandTypeSelectXml("plains")
            .. getLandTypeSelectXml("island")
            .. getLandTypeSelectXml("swamp")
            .. getLandTypeSelectXml("mountain")
            .. getLandTypeSelectXml("forest")
end

function getLandTypeSelectXml(type)
    local cols = 20
    local rows = 2
    local buttonWidth = 75
    local buttonHeight = 100
    local depth = 50
    local startX = -400
    local startY = 300

    local xml = ""
    local id = 1

    local landTypeImages = {}

    for _, image in ipairs(landImages) do
        if image.type == type then
            table.insert(landTypeImages, image)
        end
    end

    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local posX = startX - (col * buttonWidth)
            local posY = startY + (row * buttonHeight)
            local image = landTypeImages[id] or { type = "", url = "" }
            xml = xml .. string.format([[
                <Button id="%s%d" position="%d %d %d" rotation="180 180 0" width="%d" height="%d" image="%s" onClick="%sClicked(%s)" />
            ]],
                    type, id, posX, posY, depth, buttonWidth, buttonHeight, image.url, type, image.url
            )
            id = id + 1
        end
    end

    return [[<Panel id="]] .. type .. [[Select" active="false">]] .. xml .. [[</Panel>]]
end

function getSelectionXml()
    return string.format([[
            <Button position="0 0 -52" rotation="180 180 0" width="50" height="50" image="https://cdn-icons-png.flaticon.com/512/3592/3592953.png" id="forest" onClick="toggleConfig" />
            <Panel id="preview">
                <Image position="125 140 50" rotation="180 180 0" width="45" height="60" image="%s" id="sleevePreview" />
                <Image position="75 140 50" rotation="180 180 0" width="45" height="60" image="%s" id="plainsPreview" />
                <Image position="25 140 50" rotation="180 180 0" width="45" height="60" image="%s" id="islandPreview" />
                <Image position="-25 140 50" rotation="180 180 0" width="45" height="60" image="%s" id="swampPreview" />
                <Image position="-75 140 50" rotation="180 180 0" width="45" height="60" image="%s" id="mountainPreview" />
                <Image position="-125 140 50" rotation="180 180 0" width="45" height="60" image="%s" id="forestPreview" />
            </Panel>
            <Panel id="config" active="false">
                <Button id="groupLandsButtonOff" position="0 120 50" rotation="180 180 0" width="150" height="40" fontSize="20" onClick="toggleGroupLands(0)">Ungroup Lands</Button>
                <Button id="groupLandsButtonOn" active="false" position="0 120 50" rotation="180 180 0" width="150" height="40" fontSize="20" onClick="toggleGroupLands(1)">Group Lands</Button>
                <Button position="-340 0 50" rotation="180 180 0" width="300" height="390" image="%s" id="sleeve" onClick="showSleeveSelectUI" />
                <Button position="-660 0 50" rotation="180 180 0" width="300" height="390" image="%s" id="plains" onClick="showLandSelectUI(plains)" />
                <Button position="-980 0 50" rotation="180 180 0" width="300" height="390" image="%s" id="island" onClick="showLandSelectUI(island)" />
                <Button position="-1300 0 50" rotation="180 180 0" width="300" height="390" image="%s" id="swamp" onClick="showLandSelectUI(swamp)" />
                <Button position="-1620 0 50" rotation="180 180 0" width="300" height="390" image="%s" id="mountain" onClick="showLandSelectUI(mountain)" />
                <Button position="-1940 0 50" rotation="180 180 0" width="300" height="390" image="%s" id="forest" onClick="showLandSelectUI(forest)" />
                <Text position="-340 200 50" rotation="180 180 0" width="230" height="100" color="white" fontSize="24">Select Sleeve</Text>
                <Panel id="groupLandsTexts">
                    <Text position="-660 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Land</Text>
                    <Text position="-980 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Land</Text>
                    <Text position="-1300 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Land</Text>
                    <Text position="-1620 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Land</Text>
                    <Text position="-1940 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Land</Text>
                </Panel>
                <Panel id="ungroupLandsTexts" active="false">
                    <Text position="-660 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Plains</Text>
                    <Text position="-980 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Island</Text>
                    <Text position="-1300 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Swamp</Text>
                    <Text position="-1620 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Mountain</Text>
                    <Text position="-1940 200 50" rotation="180 180 0" width="300" height="100" color="white" fontSize="24">Select Forest</Text>
                </Panel>
            </Panel>
        ]],
            selections.sleeve, selections.plains, selections.island, selections.swamp, selections.mountain, selections.forest,
            selections.sleeve, selections.plains, selections.island, selections.swamp, selections.mountain, selections.forest
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

function showLandSelectUI(player, type)
    local index = type .. "Select"

    if (groupLands) then
        index = "landSelect"
    end

    if show[index] then
        self.UI.hide(index)
        show[index] = false
    else
        hideAllSelects(index)
    end
end

function sleeveClicked(player, image)
    selections.sleeve = image
    self.UI.setAttribute("sleeve", "image", image)
    self.UI.setAttribute("sleevePreview", "image", image)
    self.UI.setAttribute("sleeveInput", "text", "")
    hideAllSelects()
end

function onSleeveInput(player, image)
    selections.sleeve = image
    self.UI.setAttribute("sleevePreview", "image", image)
    self.UI.setAttribute("sleeve", "image", image)
    hideAllSelects()
end

function landClicked(player, image, id)
    local index = tonumber(id:match("^land(%d+)"))
    local land = landImages[index] or { type = "", url = "", group = "-1" }

    if land.group then
        for _, otherLand in ipairs(landImages) do
            if otherLand.group == land.group then
                if otherLand.type then
                    selections[otherLand.type] = otherLand.url
                    self.UI.setAttribute(otherLand.type, "image", otherLand.url)
                    self.UI.setAttribute(otherLand.type .. "Preview", "image", otherLand.url)
                end
            end
        end
    end

    hideAllSelects()
end

function plainsClicked(player, image)
    landTypeClicked("plains", image)
end

function islandClicked(player, image)
    landTypeClicked("island", image)
end

function swampClicked(player, image)
    landTypeClicked("swamp", image)
end

function mountainClicked(player, image)
    landTypeClicked("mountain", image)
end

function forestClicked(player, image)
    landTypeClicked("forest", image)
end

function landTypeClicked(type, image)
    if image then
        selections[type] = image
        self.UI.setAttribute(type, "image", image)
        self.UI.setAttribute(type .. "Preview", "image", image)
    end

    hideAllSelects()
end

function toggleGroupLands()
    if groupLands then
        self.UI.show("GroupLandsButtonOn")
        self.UI.hide("GroupLandsButtonOff")

        self.UI.hide("groupLandsTexts")
        self.UI.show("ungroupLandsTexts")
        groupLands = false
    else
        self.UI.show("GroupLandsButtonOff")
        self.UI.hide("GroupLandsButtonOn")

        self.UI.hide("ungroupLandsTexts")
        self.UI.show("groupLandsTexts")
        groupLands = true
    end

    hideAllSelects()
end

function toggleConfig()
    if configOpen then
        self.UI.hide("config")
        self.UI.show("preview")
        configOpen = false
    else
        self.UI.show("config")
        self.UI.hide("preview")
        configOpen = true
    end

    hideAllSelects()
end
