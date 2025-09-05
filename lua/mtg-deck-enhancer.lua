-- ULTIMATE MTG Deck Enhancer by CoRNeRNoTe

-- Most recent script can be found on GitHub:
-- https://github.com/cornernote/tabletop_simulator-mtg_deck_enhancer/blob/main/lua/mtg-deck-enhancer.lua

local containedDeckData = null
local defaults = {
    sortBy = null,
    sleeve = null,
    plains = null,
    island = null,
    swamp = null,
    mountain = null,
    forest = null,
}
local selections = defaults

local landUrlPrefix = "https://cards.scryfall.io/"
local landImages = {
    standard = {
        plains = "/front/4/0/4069fb4a-8ee1-41ef-ab93-39a8cc58e0e5.jpg",
        island = "/front/a/2/a2e22347-f0cb-4cfd-88a3-4f46a16e4946.jpg",
        swamp = "/front/f/0/f0b234d8-d6bb-48ec-8a4d-d8a570a69c62.jpg",
        mountain = "/front/c/4/c44f81ca-f72f-445c-8901-3a894a2a47f9.jpg",
        forest = "/front/a/3/a305e44f-4253-4754-b83f-1e34103d77b0.jpg",
    },
    SPM = {
        plains = "/front/1/1/1164f7ec-7b2f-4cc9-90bb-7eaaa331b4cd.jpg",
        island = "/front/d/5/d59cb0b5-fd4f-4dde-a69f-7ca6aa12b89f.jpg",
        swamp = "/front/5/c/5cb03b18-d74c-4c89-9539-3549d2e8ff5f.jpg",
        mountain = "/front/b/0/b044630d-50e7-431b-8e91-bd53e967f594.jpg",
        forest = "/front/7/b/7b6c2532-be5a-4f1f-893c-36bcda2a699d.jpg",
    },
    TWOXM = {
        plains = "/front/c/c/cc3db531-3f21-49a2-8aeb-d98b7db94397.jpg", -- 373
        island = "/front/9/1/91595b00-6233-48be-a012-1e87bd704aca.jpg", -- 375
        swamp = "/front/8/e/8e5eef83-a3d4-44c7-a6cb-7f6803825b9e.jpg", -- 377
        mountain = "/front/6/4/6418bc71-de29-410c-baf3-f63f5615eee2.jpg", -- 379
        forest = "/front/1/4/146b803f-0455-497b-8362-03da2547070d.jpg", -- 381
    },
    TWOXM2 = {
        plains = "/front/9/f/9f015fe9-c7fa-4503-b0cc-c0e7f098882f.jpg", -- 374
        island = "/front/c/2/c2a51829-8319-4271-93b2-a7a635b30e80.jpg", -- 376
        swamp = "/front/9/4/94cb941f-e3cf-45d2-9989-2a0a454d5497.jpg", -- 378
        mountain = "/front/8/5/8584b531-6dfa-43b2-99ba-b614b147f9a8.jpg", -- 380
        forest = "/front/c/1/c10cf58b-e01e-413e-979b-c6fe9e93100b.jpg", -- 382
    },
    ACR = {
        plains = "/front/6/6/66ad5a57-7296-43cb-b477-826e65d37222.jpg", -- 101
        island = "/front/a/2/a22426c4-914a-4e0b-a28a-b8573b63e320.jpg", -- 103
        swamp = "/front/c/1/c163a697-01ee-4a55-814f-b0ba79be3a7f.jpg", -- 105
        mountain = "/front/1/a/1a534ae1-4e6f-43ae-a8ad-89e306f11f21.jpg", -- 107
        forest = "/front/b/8/b8a081ef-a2d4-4989-8b06-721f8b2c9798.jpg", -- 109
    },
    ACR2 = {
        plains = "/front/4/5/4578c984-afb6-4532-b5be-093ed4ecb8b9.jpg", -- 102
        island = "/front/a/7/a76f785d-1972-4bd6-8a43-848d51068712.jpg", -- 104
        swamp = "/front/0/7/07a6df7a-a080-4aef-9a76-5b08bbc4e762.jpg", -- 106
        mountain = "/front/d/0/d0a55d99-d668-4621-bb14-f7df210adbe4.jpg", -- 108
        forest = "/front/6/5/650e47f3-476f-4b32-b892-c1a01335d0fe.jpg", -- 110
    },
    AKH = {
        plains = "/front/c/7/c7191d23-b68f-406b-8c28-8dadbaef6562.jpg", -- 250
        island = "/front/b/e/bec6fced-62bb-4a99-9ea1-374056b5781b.jpg", -- 251
        swamp = "/front/6/0/60b7c997-e520-4ff6-8b3b-705c2f12a9d4.jpg", -- 252
        mountain = "/front/d/3/d3112990-3919-46b0-b927-14566c689a81.jpg", -- 253
        forest = "/front/2/c/2c2fc9f7-21af-4416-abf5-6fcb4f543680.jpg", -- 254
    },
    AKR = {
        plains = "/front/b/f/bfa36806-235e-49b7-a637-494c91926ede.jpg", -- 322
        island = "/front/a/7/a796d1c4-71af-432c-bb1a-df00252554d0.jpg", -- 308
        swamp = "/front/7/e/7e62bff1-e78e-4e1a-b021-d891eb0f309b.jpg", -- 335
        mountain = "/front/f/6/f6d3d5a6-7d26-44eb-b040-c50fb1f867e1.jpg", -- 315
        forest = "/front/1/a/1a26154f-dfe5-481d-acdd-237ea08f069a.jpg", -- 297
    },
    AKR2 = {
        plains = "/front/3/f/3f700330-5fcc-49b8-9163-072627016b95.jpg", -- 324
        island = "/front/9/b/9bdd8409-7309-4239-a0f0-39755506610a.jpg", -- 310
        swamp = "/front/6/f/6f0c11f7-f131-4d12-a027-a25df8155cc6.jpg", -- 337
        mountain = "/front/9/5/95b6bba2-cb1f-4598-827b-a0ab26e925aa.jpg", -- 317
        forest = "/front/c/e/ce27a3ec-4652-4bf8-9f06-281f53dd966c.jpg", -- 299
    },
    ANA = {
        plains = "/front/5/2/52ce85a5-1a3e-41a6-8a2c-ac9f78286af3.jpg", -- 1a
        island = "/front/9/b/9b4812c4-58ad-4215-8a3e-e731a42e156a.jpg", -- 3a
        swamp = "/front/1/9/19bef0f3-68a0-47ed-adcd-2adadc3ebe23.jpg", -- 5a
        mountain = "/front/8/a/8a05eb4e-dbea-4d41-939f-b9d92b56f56a.jpg", -- 7a
        forest = "/front/6/0/6066f195-385f-4c51-8090-3989fd692078.jpg", -- 9a
    },
    BFZ = {
        plains = "/front/5/8/58a735c9-08a1-4950-bf8c-ed1cfba76765.jpg", -- 250
        island = "/front/8/4/8490261d-4246-4232-b7fc-23204c14a7b5.jpg", -- 255
        swamp = "/front/1/3/132155ae-f7a4-4957-91cb-e51ff52716f9.jpg", -- 260
        mountain = "/front/0/c/0c9cbae1-6b04-4408-82fe-3fcf61dffbe2.jpg", -- 265
        forest = "/front/6/4/642102a2-abde-4e76-a6d6-08f7befe1196.jpg", -- 270
    },
    BFZ2 = {
        plains = "/front/5/a/5a8279b9-c1dd-43db-a01b-89567bb43374.jpg", -- 251
        island = "/front/5/c/5cde9dcf-f0b4-4e76-ac4e-d4a8ac355fbe.jpg", -- 256
        swamp = "/front/a/8/a8594426-c965-4187-a72d-7582f21b0ea1.jpg", -- 261
        mountain = "/front/3/a/3a42ac42-b21a-449b-abda-6906f06e8120.jpg", -- 266
        forest = "/front/4/9/491b26e4-1d52-457c-a00c-bdee127f8a97.jpg", -- 271
    },
    BFZ3 = {
        plains = "/front/0/a/0a143c32-d78b-40ee-8d2b-a8ce303162d6.jpg", -- 252
        island = "/front/2/1/21e41579-5cbf-41c8-ac1b-e6256220087d.jpg", -- 257
        swamp = "/front/5/4/5452c8e4-3463-4ae3-a9d1-5947bea4684e.jpg", -- 262
        mountain = "/front/3/7/37acb733-b3bd-4140-915d-b2c0989208aa.jpg", -- 267
        forest = "/front/2/d/2d3a6ecf-323d-4650-aabf-92995e3c72c6.jpg", -- 272
    },
    BFZ4 = {
        plains = "/front/b/1/b11c9a26-3234-480b-94cf-49f15f2b0002.jpg", -- 253
        island = "/front/6/9/695f7519-b011-4a86-9226-80c2d9747a42.jpg", -- 258
        swamp = "/front/4/6/46e0aaac-fc82-4ce9-87d1-8dead8ec29fd.jpg", -- 263
        mountain = "/front/1/1/11c94acd-ad60-4aec-b11b-f4dc4a9adfbc.jpg", -- 268
        forest = "/front/3/f/3f7f206a-7b5e-4fd5-8c9e-d665ac3f7dea.jpg", -- 273
    },
    BFZ5 = {
        plains = "/front/3/1/3138154c-5763-4105-a635-b697fe4c1e52.jpg", -- 254
        island = "/front/7/1/71207752-0d8a-4ab5-be64-cca600608e76.jpg", -- 259
        swamp = "/front/1/c/1c590ebb-1e3a-4861-b8f2-aef9c4259efd.jpg", -- 264
        mountain = "/front/3/c/3cecf0db-0e0e-4329-b055-bb9dad912ca8.jpg", -- 269
        forest = "/front/8/c/8c70181e-7b28-46b1-a51a-ba99e58e8566.jpg", -- 274
    },
    BLB = {
        plains = "/front/3/6/3663ff0c-d02f-49ac-bb88-6f0dbd684337.jpg", -- 262
        island = "/front/1/0/106a5332-0104-4ec9-9e1f-806381ae4cad.jpg", -- 266
        swamp = "/front/f/a/faa54bef-c90e-4e9b-b94b-942ea829e0d2.jpg", -- 270
        mountain = "/front/c/1/c1bba8fb-d763-4efa-8db1-e5e81994b5f9.jpg", -- 274
        forest = "/front/f/7/f791876a-f3fb-45b8-90a9-af846d8b8f74.jpg", -- 278
    },
    BLB2 = {
        plains = "/front/a/b/ab53b300-38b2-436c-834c-b0162dd3b757.jpg", -- 263
        island = "/front/f/7/f7b92adb-a384-4e03-8ba7-1e41b9fb2516.jpg", -- 267
        swamp = "/front/d/c/dcdbc78a-7854-4a66-911f-a40b33e25f39.jpg", -- 271
        mountain = "/front/0/2/02244055-cbeb-4074-9482-42ec20721312.jpg", -- 275
        forest = "/front/3/a/3a7a2a54-47e1-4694-b4f6-b7d659bb2b1f.jpg", -- 279
    },
    BLB3 = {
        plains = "/front/4/f/4f04188d-9a76-495d-b3a7-ee44810cf671.jpg", -- 264
        island = "/front/4/0/408eb23f-13fa-4f98-b316-18e3057f9136.jpg", -- 268
        swamp = "/front/0/2/0223cf7f-4c6e-487f-babb-a740a15e1f0c.jpg", -- 272
        mountain = "/front/0/b/0b384d24-8771-4860-8fc1-1b74217f1c4c.jpg", -- 276
        forest = "/front/0/0/0000419b-0bba-4488-8f7a-6194544ce91e.jpg", -- 280
    },
    BLB4 = {
        plains = "/front/1/1/11a94c04-b6d3-4118-b252-5146eedae4e8.jpg", -- 265
        island = "/front/2/a/2a9db98e-9f1d-4139-95c5-49f9d17a2107.jpg", -- 269
        swamp = "/front/4/6/4650ebaf-8e9f-431c-998d-e0f426b24d41.jpg", -- 273
        mountain = "/front/8/a/8a38bea4-2d1b-442b-aad5-ab1a0ae67aac.jpg", -- 277
        forest = "/front/2/0/208014f4-eed8-4856-a9d9-dbac10c4aa6a.jpg", -- 281
    },
    BRO = {
        plains = "/front/7/e/7e134268-9ce9-4192-b548-90bedbfe654e.jpg", -- 278
        island = "/front/f/e/fe9d36d3-9373-407c-91fd-975d8ee9e4fe.jpg", -- 280
        swamp = "/front/c/a/cabe866d-01c3-4ec5-9d41-70305208c2b1.jpg", -- 282
        mountain = "/front/c/4/c464b81a-3d91-4d07-bc9d-6756780417e3.jpg", -- 284
        forest = "/front/1/a/1a1b7277-0c09-42ab-aa6b-542a1e402580.jpg", -- 286
    },
    BRO2 = {
        plains = "/front/8/0/80b6636d-a342-4d49-9d1a-ab15b3d837c5.jpg", -- 279
        island = "/front/d/2/d20af588-2ce3-4e5a-9ab3-949401ead071.jpg", -- 281
        swamp = "/front/7/2/7232adef-c8eb-461f-b563-cb54cdeb22d5.jpg", -- 283
        mountain = "/front/c/d/cd757142-45b7-40db-80f2-fe161379aa4e.jpg", -- 285
        forest = "/front/c/1/c1c2a41c-e974-4c14-8d01-d278ecdb31bc.jpg", -- 287
    },
    DFT = {
        plains = "/front/2/d/2d2da8b9-797f-46e8-a15d-a86c7c56dc84.jpg", -- 272
        island = "/front/f/5/f53ed206-8ec4-46a6-8603-c819682e1433.jpg", -- 273
        swamp = "/front/e/9/e969e168-e74c-4608-9fa0-a5660bf7fa02.jpg", -- 274
        mountain = "/front/5/0/50748a4c-43a0-4274-9a84-046d76027166.jpg", -- 275
        forest = "/front/7/7/777e868d-cb88-4b8e-99d1-12ff67f5eae2.jpg", -- 276
    },
    DFT2 = {
        plains = "/front/4/e/4e196d67-1923-459d-98cf-646337914d3b.jpg", -- 507
        island = "/front/9/b/9b33841e-7006-41d4-98b0-313ab151c9ec.jpg", -- 508
        swamp = "/front/b/a/ba042d60-b1e8-44ad-9103-f40588a0b29c.jpg", -- 509
        mountain = "/front/c/7/c7533cbb-ab73-4a0c-9ea0-baa97c4665b8.jpg", -- 510
        forest = "/front/f/d/fd1b6c5c-4585-47c1-82eb-a324189f3ebd.jpg", -- 511
    },
    DFT3 = {
        plains = "/front/5/d/5dd76e71-df9b-4fd2-b534-d3f724a56a91.jpg", -- 512
        island = "/front/d/1/d13bb767-1123-48d2-960f-b90b6db3f6ed.jpg", -- 513
        swamp = "/front/f/4/f4d198b3-2ff5-484a-905f-c272de7c139d.jpg", -- 514
        mountain = "/front/5/e/5e4952a8-4e1f-4a74-8a06-c9d633b25dcd.jpg", -- 515
        forest = "/front/2/a/2a7aba60-d300-4c33-9e1e-846d6167dc50.jpg", -- 516
    },
    DMU = {
        plains = "/front/5/7/572eab93-7b1d-434b-ba92-844248e472d0.jpg", -- 277
        island = "/front/e/6/e67477a4-6878-4356-8037-807f41590ad1.jpg", -- 278
        swamp = "/front/f/1/f1b8c9a6-62eb-436e-9277-e2b8075d482d.jpg", -- 279
        mountain = "/front/0/a/0aaf15b9-1bf5-424a-a994-67beaae29d36.jpg", -- 280
        forest = "/front/e/8/e8e9959a-b422-4906-8d35-8b05c5dd6de1.jpg", -- 281
    },
    DSK = {
        plains = "/front/e/6/e67ce864-bf29-42f1-81ca-a98022892eec.jpg", -- 272
        island = "/front/4/0/40e3bf00-84cc-498c-b214-1052b4904d92.jpg", -- 273
        swamp = "/front/7/4/7442c1c7-1c10-4387-92e6-4bdea263064f.jpg", -- 274
        mountain = "/front/8/c/8c8841b2-9b4e-4f65-8e30-1e9423cb8fbc.jpg", -- 275
        forest = "/front/b/a/ba2a4cbb-f325-4178-80db-7090f5672414.jpg", -- 276
    },
    EOE = {
        plains = "/front/0/8/089ae01b-e042-4255-b0ee-17d8f416a8d9.jpg", -- 262
        island = "/front/7/6/76313c69-8ec7-49e3-a34e-ade26097284c.jpg", -- 263
        swamp = "/front/3/e/3e724e54-a622-4c77-8183-5a397a7c14a9.jpg", -- 264
        mountain = "/front/3/2/3204f401-1bcb-4d97-b15d-113a5d3c3e9f.jpg", -- 265
        forest = "/front/8/3/8335b9f1-e726-423b-8ba7-6151448ab3fd.jpg", -- 266
    },
    EOE2 = {
        plains = "/front/9/2/926aad15-87a8-4510-b327-d1648f89c497.jpg", -- 367
        island = "/front/8/1/81368899-5fef-4f10-80ea-b282eca0f42f.jpg", -- 368
        swamp = "/front/b/9/b938ac10-bd0f-4ce3-a743-958d5beadf58.jpg", -- 369
        mountain = "/front/6/b/6b092822-f34f-4384-9d0a-23d863d27231.jpg", -- 370
        forest = "/front/0/d/0d6250d3-728b-4412-8efc-911bb6f5e910.jpg", -- 371
    },
    FDN = {
        plains = "/front/6/e/6e6f19b3-4c76-4078-8ed2-b2832a33d066.jpg", -- 282
        island = "/front/8/8/886eae6e-ced2-4d94-96fa-9bb5385b06f4.jpg", -- 284
        swamp = "/front/6/f/6f23a73a-522b-40cf-a14b-ffdf47a24c01.jpg", -- 286
        mountain = "/front/3/a/3a3afd00-da06-4a9f-8cd1-7133728e0fdd.jpg", -- 288
        forest = "/front/b/b/bbbeb57d-5fa0-4ff7-b5e8-caafc139669b.jpg", -- 290
    },
    FDN2 = {
        plains = "/front/7/a/7a0f9892-89cd-46ff-bc87-114e175cb575.jpg", -- 283
        island = "/front/6/f/6f534ddc-f610-45cd-84dc-bb6df6c5a84f.jpg", -- 285
        swamp = "/front/f/d/fda1dbfa-a57b-4aa8-9993-c8f97aec28bb.jpg", -- 287
        mountain = "/front/0/4/042b04b4-f7f4-4c1a-86ad-b50d788aa99e.jpg", -- 289
        forest = "/front/1/1/117ab60a-b888-4585-b0c6-769d387069f7.jpg", -- 291
    },
    FIN = {
        plains = "/front/9/d/9dd2d666-7c6b-48ce-93dc-c004ebdd1fe9.jpg", -- 294
        island = "/front/b/9/b92ec9f6-a56d-40c6-aee2-7d5e1524c985.jpg", -- 297
        swamp = "/front/f/6/f66094ef-059b-4511-aa6e-835906736de4.jpg", -- 300
        mountain = "/front/a/1/a18ef64b-a9de-4548-b4d5-168758442db7.jpg", -- 303
        forest = "/front/b/e/be72862d-d71e-4b18-98a6-59019399f631.jpg", -- 306
    },
    FIN2 = {
        plains = "/front/e/6/e623b058-76d2-476b-9ee6-82807f7992c3.jpg", -- 295
        island = "/front/e/e/eeecf096-87dd-4dcb-953f-700445bf3f3a.jpg", -- 298
        swamp = "/front/a/7/a7f56d20-16dc-4b7f-98bf-124817a83bae.jpg", -- 301
        mountain = "/front/d/0/d061b9a8-e95d-48ec-a1c9-337433b62dfc.jpg", -- 304
        forest = "/front/3/d/3d08f6a6-316d-45d8-aabe-1760a20903ac.jpg", -- 307
    },
    FIN3 = {
        plains = "/front/e/e/ee86ac2f-f398-4422-8721-8ac859fbf5bc.jpg", -- 296
        island = "/front/3/4/347e00db-abcf-4053-aa27-4a5b42e1da55.jpg", -- 299
        swamp = "/front/0/8/08ec1e4f-e284-4216-a022-bd94c4dae02b.jpg", -- 302
        mountain = "/front/e/a/ea1735b9-fd10-4c9c-b9d3-046d8c22b852.jpg", -- 305
        forest = "/front/c/5/c52038c8-5bba-4d8e-845f-30af44300acc.jpg", -- 308
    },
    FIN4 = {
        plains = "/front/d/e/dec72b07-8f41-4d42-a455-794bf106302c.jpg", -- 572
        island = "/front/4/6/46255a65-b735-4888-85db-3ab2ab3d903c.jpg", -- 573
        swamp = "/front/1/1/1176ebbf-4130-4e4e-ad49-65101a7357b4.jpg", -- 574
        mountain = "/front/0/c/0cef98b7-d54a-456e-8240-1c5af3a72a04.jpg", -- 575
        forest = "/front/2/0/2036f825-ef57-4a40-b45f-0668d9c8ec6a.jpg", -- 576
    },
    HOU = {
        plains = "/front/c/2/c20ec10e-78fc-49dc-a112-7863a34056b1.jpg", -- 185
        island = "/front/a/7/a735e9b5-1231-4aa9-9eb3-c83037b849f2.jpg", -- 186
        swamp = "/front/e/f/ef5cb444-7b48-40c8-a4d9-3fee37429513.jpg", -- 187
        mountain = "/front/6/a/6ad4e9cd-76e2-4ee0-8185-8b3aec3578ce.jpg", -- 188
        forest = "/front/c/3/c318bae5-5d3f-4e91-adfe-13c182511ef7.jpg", -- 189
    },
    J14 = {
        plains = "/front/9/9/99577b28-4bfc-4192-bb23-c1f73666295e.jpg", -- 1★
        island = "/front/6/4/644791df-ac34-45c7-90c1-0ebd9e519840.jpg", -- 2★
        swamp = "/front/9/0/90bc54df-b5a0-43fd-b3e6-3ba3d295d25c.jpg", -- 3★
        mountain = "/front/a/f/af06d83f-1c5a-4eb6-92b4-216acfe20641.jpg", -- 4★
        forest = "/front/a/c/ac2c51de-2ec9-4a38-a117-75e90abf0feb.jpg", -- 5★
    },
    LCI = {
        plains = "/front/b/5/b5453630-bfff-4403-a9a9-49f1534e1d42.jpg", -- 287
        island = "/front/3/3/338e5b63-1fee-4a7c-af9b-483d383f79b7.jpg", -- 288
        swamp = "/front/a/8/a825ac86-d642-42fd-b6aa-94aa804907d9.jpg", -- 289
        mountain = "/front/7/c/7cb82fdb-5090-45c0-ae67-4846667c8625.jpg", -- 290
        forest = "/front/8/c/8c13cafb-3078-4856-a5b0-c38aace8a34a.jpg", -- 291
    },
    LTR = {
        plains = "/front/4/f/4ff9fbf5-de6f-4ef9-a6ab-56da4b341b77.jpg", -- 272
        island = "/front/e/b/eba0c7c5-ed63-41a5-93e1-a979a6f983b9.jpg", -- 274
        swamp = "/front/9/b/9b5f68bc-1842-4efd-b85a-d897cfd63bde.jpg", -- 276
        mountain = "/front/b/1/b1902b98-7579-4b7a-8cb8-9bd0e0da5f67.jpg", -- 278
        forest = "/front/2/f/2f5b488e-d725-4ef7-90f4-71091325c0b6.jpg", -- 280
    },
    LTR2 = {
        plains = "/front/8/5/8538a97f-302d-468a-8a6c-50c800d614e5.jpg", -- 273
        island = "/front/8/f/8fee8302-39ca-43c3-b139-62e591559306.jpg", -- 275
        swamp = "/front/d/4/d412d727-4fe8-4c21-a2cb-609395935dd8.jpg", -- 277
        mountain = "/front/a/f/af1b83d9-078b-44dc-a118-4659201f4854.jpg", -- 279
        forest = "/front/3/e/3efeaa30-9db9-4e68-a658-9064d6e67516.jpg", -- 281
    },
    LTR3 = {
        plains = "/front/c/0/c05ce2e3-44e9-441b-9467-46a3c6642184.jpg", -- 713
        island = "/front/a/a/aa03a3b5-cdc3-40cc-bd45-69ad65809d2f.jpg", -- 715
        swamp = "/front/d/5/d56b5831-e39a-4898-be06-b84f62d38456.jpg", -- 717
        mountain = "/front/6/4/6410d20e-408a-42c6-9884-ea9e22e2ee7c.jpg", -- 719
        forest = "/front/1/5/150d0710-9ecb-4187-a0f8-a70b330c8879.jpg", -- 721
    },
    LTR4 = {
        plains = "/front/4/d/4d48ef1f-e000-452b-aae8-c3257f149c7d.jpg", -- 714
        island = "/front/7/a/7abc7b3d-c0cb-438f-b9a9-a1f785cb1c9b.jpg", -- 716
        swamp = "/front/e/5/e59eff2f-2f15-4f70-90e5-759de12caf55.jpg", -- 718
        mountain = "/front/2/8/28cde170-c7af-4ee1-85f4-8a9289c5a4d3.jpg", -- 720
        forest = "/front/e/7/e7059825-0844-4271-89e8-645e2f515b59.jpg", -- 722
    },
    MH1 = {
        plains = "/front/7/a/7a961768-6166-4852-b518-23eb4cced47d.jpg", -- 250
        island = "/front/8/a/8ac1fceb-8427-409c-98a4-9a5c1ff980b4.jpg", -- 251
        swamp = "/front/c/8/c835f235-4196-4281-9788-13e5d54a92d0.jpg", -- 252
        mountain = "/front/d/2/d2209e6f-1d9d-43bb-a314-a8fefc509e78.jpg", -- 253
        forest = "/front/1/c/1c59fc48-704b-4187-b9d3-2a2cff6dd54b.jpg", -- 254
    },
    MH3 = {
        plains = "/front/e/8/e81ecd4f-4cde-4d8f-a9b7-d7c6098be981.jpg", -- 304
        island = "/front/1/c/1cb1ac28-ee04-4892-97ea-2cfdebbafcad.jpg", -- 305
        swamp = "/front/c/8/c8e3909e-e00a-4855-a0be-b1c538f89cb8.jpg", -- 306
        mountain = "/front/e/9/e9744bb5-9ad1-4287-9929-1146377d975b.jpg", -- 307
        forest = "/front/f/f/ff4c78b4-7178-4a60-ba22-086fb18146df.jpg", -- 308
    },
    MID = {
        plains = "/front/6/e/6ed1902d-0b09-4bbe-9059-a0779450ee05.jpg", -- 268
        island = "/front/8/d/8dc3bd34-4d12-4728-a53a-b5ae434d74b0.jpg", -- 270
        swamp = "/front/7/7/77ba59d8-c13c-4966-845f-c090e9f061cb.jpg", -- 272
        mountain = "/front/3/b/3ba24a61-e529-4490-8536-6276ea77c511.jpg", -- 274
        forest = "/front/a/d/ad8ff40e-2d40-4557-8209-d2c84eb4ccf2.jpg", -- 276
    },
    MID2 = {
        plains = "/front/5/a/5acefadb-8b2f-4319-a5e9-1e8fd9ef3086.jpg", -- 269
        island = "/front/e/d/ed2cfa62-c972-4373-b405-a075697d009c.jpg", -- 271
        swamp = "/front/3/8/38fef662-993c-4522-8b3f-7c1d3bb1d946.jpg", -- 273
        mountain = "/front/7/a/7a4c0731-555a-4bef-9d9e-b877f0339417.jpg", -- 275
        forest = "/front/1/2/122b5548-5ff5-43e4-b799-75c709b1c32d.jpg", -- 277
    },
    MKM = {
        plains = "/front/5/9/598f857d-ee17-4478-bb39-cc3ab77ab8d8.jpg", -- 272
        island = "/front/f/e/fe5f01e9-f85f-41e8-9527-88f76e7bfc02.jpg", -- 273
        swamp = "/front/5/3/53d0a415-26b8-4ba2-9503-b4ee2b93617c.jpg", -- 274
        mountain = "/front/5/3/5383b66e-e559-47d2-9967-9c2d5f898653.jpg", -- 275
        forest = "/front/8/1/8126b842-ea58-4988-8b3f-0394cf766b91.jpg", -- 276
    },
    MOM = {
        plains = "/front/e/e/ee7f525c-d777-4adf-8920-8adfc73bbc55.jpg", -- 282
        island = "/front/2/0/2039d727-3bb6-4a76-89ca-159ecf10cad8.jpg", -- 284
        swamp = "/front/e/1/e19e24a8-5a4f-4a2d-b8dd-eb92aac7be78.jpg", -- 286
        mountain = "/front/a/6/a6a57c6a-3603-466c-8a81-a9eb8de92aec.jpg", -- 288
        forest = "/front/7/e/7e6151d4-5129-4631-84a1-5cffc551c1e9.jpg", -- 290
    },
    MOM2 = {
        plains = "/front/8/a/8a790328-70b3-477d-bf02-8718870367ae.jpg", -- 283
        island = "/front/5/6/560c7de9-0046-4a76-a41a-fa1c3ef92f04.jpg", -- 285
        swamp = "/front/0/1/013612b4-fed9-4112-8018-9267ae608fd7.jpg", -- 287
        mountain = "/front/7/e/7e19c7e1-1b4b-4c7e-b011-eff8ed7de0fd.jpg", -- 289
        forest = "/front/e/0/e0ce5575-2d62-43c9-9c4b-fca4aff6ae4d.jpg", -- 291
    },
    NEO = {
        plains = "/front/c/a/ca8fb179-7e81-4b20-8b81-ea1aa97afe58.jpg", -- 293
        island = "/front/f/0/f0578f26-1396-4e1d-9986-8fc6c55aeb66.jpg", -- 295
        swamp = "/front/c/5/c50b3d79-2361-4858-98b0-64d83c4f7f70.jpg", -- 297
        mountain = "/front/0/3/03cd5953-37fc-4a8a-89f8-0b5dd8412dc9.jpg", -- 299
        forest = "/front/a/c/acc778ae-a2d0-493f-963d-e946bd7cacd9.jpg", -- 301
    },
    NEO2 = {
        plains = "/front/7/a/7a76d8ee-28fc-49ac-951c-a4d29822f91e.jpg", -- 294
        island = "/front/7/1/7132999f-6e2d-4689-8131-7b12076a348d.jpg", -- 296
        swamp = "/front/5/7/57ef531e-2a8f-4d40-b509-92e3a86b2257.jpg", -- 298
        mountain = "/front/7/d/7d75969d-c932-4b4e-8135-61968228bc32.jpg", -- 300
        forest = "/front/c/8/c8179106-e5d7-457a-9250-70df980b38ce.jpg", -- 302
    },
    ONE = {
        plains = "/front/5/0/50958c6e-9555-42ad-9bb3-2da9faa5cb52.jpg", -- 262
        island = "/front/5/c/5c6322d4-52bf-471a-a5b2-8329ef4be39a.jpg", -- 263
        swamp = "/front/7/3/736a0484-e091-4178-92c5-c517b0e92f3d.jpg", -- 264
        mountain = "/front/6/d/6d9e44c1-7b51-47cb-b564-608deb46cc44.jpg", -- 265
        forest = "/front/4/f/4fce7045-4572-4e9e-8853-2a5dcfc989ac.jpg", -- 266
    },
    ONE2 = {
        plains = "/front/3/6/36ccde39-98bd-4a67-bfcf-a66d9fbd9417.jpg", -- 267
        island = "/front/a/c/ac97baa8-5e57-45b6-9c64-cb9ce4806294.jpg", -- 268
        swamp = "/front/1/8/187e9fa1-6a50-4697-8645-fea4524e8dde.jpg", -- 269
        mountain = "/front/5/5/55c61b29-797f-4fda-acf1-039a807954c9.jpg", -- 270
        forest = "/front/b/6/b6ec4ded-7c8d-416a-9a12-3e5d6c91ac93.jpg", -- 271
    },
    ONE3 = {
        plains = "/front/3/e/3e82b57f-a886-4423-a921-9932055feb68.jpg", -- 365
        island = "/front/0/a/0a6f4848-85b9-4770-9820-516e2a295284.jpg", -- 366
        swamp = "/front/a/f/af92ec23-a252-4ae2-98d7-0dce19d18e35.jpg", -- 367
        mountain = "/front/8/6/864b4fb7-dbfe-4d9d-b520-4a307c31c876.jpg", -- 368
        forest = "/front/9/d/9d94fa1c-48d1-48bc-b725-5c11a158507b.jpg", -- 369
    },
    OTJ = {
        plains = "/front/c/f/cfe51d97-66f6-4ac3-b926-01ab7e4c5686.jpg", -- 272
        island = "/front/a/6/a624d656-207d-4e73-b615-59e7cf64ad64.jpg", -- 273
        swamp = "/front/3/b/3b383b16-8128-4d9e-a0d0-9b8ccc9ad6df.jpg", -- 274
        mountain = "/front/0/a/0a7dbfd2-cda7-4fc9-9677-e442fb5f5f6f.jpg", -- 275
        forest = "/front/b/a/baf8a774-65f3-431e-b084-328ff1000895.jpg", -- 276
    },
    P23 = {
        plains = "/front/f/0/f087c400-0ba2-4635-a928-dfbb01f550f8.jpg", -- 6
        island = "/front/0/d/0d0d544b-82b2-4b51-8410-4c5cb126d3f3.jpg", -- 7
        swamp = "/front/5/4/540ff80a-71a3-4a06-ac0f-0408f4acec13.jpg", -- 8
        mountain = "/front/6/d/6d5d112e-7018-48a1-95b8-fba6fc6b4e3b.jpg", -- 9
        forest = "/front/c/0/c044cd23-60bc-4b05-a8e1-cc0d69c9fa33.jpg", -- 10
    },
    PANA = {
        plains = "/front/b/3/b38e0742-63fe-49a0-a781-aa4fedaaaf66.jpg", -- 201
        island = "/front/9/3/93b0918a-398a-4c6d-a5a9-e35a999b24ae.jpg", -- 202
        swamp = "/front/0/a/0ac4751c-812a-4990-b093-336f3d6f4502.jpg", -- 203
        mountain = "/front/5/e/5e526e22-d1e4-401b-84b9-866f23139d75.jpg", -- 204
        forest = "/front/c/c/cc46739c-290c-4a2d-9301-5ab89727ce37.jpg", -- 205
    },
    PANA2 = {
        plains = "/front/c/0/c0072839-e1ae-4c4c-b350-cc98a7747c33.jpg", -- 231
        island = "/front/6/b/6b984a9f-38a4-44d2-b8fc-3cd77c843b55.jpg", -- 232
        swamp = "/front/1/8/1861c363-b591-497f-b203-b0e3b2ebf813.jpg", -- 233
        mountain = "/front/9/7/9706f62a-7a2e-4cf3-820d-78f1beaa76c5.jpg", -- 234
        forest = "/front/6/7/67575f45-f1e5-4837-ba1e-d565b230a0fd.jpg", -- 235
    },
    PANA3 = {
        plains = "/front/5/6/5696ea9a-4ddc-40c2-9de2-eca25acc4211.jpg", -- 236
        island = "/front/6/8/68d36bab-bba8-4b50-aecb-d4c68763c3a1.jpg", -- 237
        swamp = "/front/5/9/590189a3-d845-4d5a-9c8d-70b99633e6c5.jpg", -- 238
        mountain = "/front/3/d/3d336a36-0da7-457a-b613-b6ca92829fbe.jpg", -- 239
        forest = "/front/8/5/859fcdd6-4662-4c96-823c-8487dffd96a1.jpg", -- 240
    },
    PANA4 = {
        plains = "/front/d/1/d1225bf1-3237-4a86-ad35-588479cd0a10.jpg", -- 241
        island = "/front/0/5/05bc1b45-ffb8-4efa-8ba8-8601ff38ed62.jpg", -- 242
        swamp = "/front/9/5/951bd227-4212-439d-94bb-d1d8ac30ecee.jpg", -- 243
        mountain = "/front/a/b/ab92170a-0c92-4e48-8ed1-f93d2e08e842.jpg", -- 244
        forest = "/front/6/c/6c7913b8-60c7-4d61-b8bb-ee57a02e709a.jpg", -- 245
    },
    PANA5 = {
        plains = "/front/d/e/de9cabbe-96e9-410a-8440-d4439830400d.jpg", -- 257
        island = "/front/b/d/bd45e4e1-8459-412a-b021-88cdab8837c7.jpg", -- 258
        swamp = "/front/e/9/e9c6c520-fbaa-423a-ad7a-aacc46d6d2ce.jpg", -- 259
        mountain = "/front/5/a/5a641c50-8480-4377-9e59-a2e051f6c61e.jpg", -- 260
        forest = "/front/7/8/78ab5ec3-decf-41cc-9f2e-d76a2a2e8dcd.jpg", -- 261
    },
    PANA6 = {
        plains = "/front/8/6/86ed77dd-c4aa-4c4b-b670-4c6009215882.jpg", -- 262
        island = "/front/2/8/2805f5e0-e6a5-49f8-9217-febc4abf0f48.jpg", -- 263
        swamp = "/front/5/4/54a23169-4add-4227-8662-cc282002956d.jpg", -- 264
        mountain = "/front/a/0/a06b39f4-0b00-49f0-bb50-da00965ecc09.jpg", -- 265
        forest = "/front/5/d/5def198e-c011-489c-9ba6-9243114b5f7f.jpg", -- 266
    },
    PIP = {
        plains = "/front/c/3/c3f33598-1344-4365-9067-17a7379de894.jpg", -- 317
        island = "/front/a/5/a5b0a88d-7049-4206-8085-4a68ab0bfd81.jpg", -- 319
        swamp = "/front/2/3/237204ad-ab8a-496f-a093-48d00417350b.jpg", -- 321
        mountain = "/front/8/5/85f5bbab-7bf0-48d4-8138-d64f84f4d769.jpg", -- 323
        forest = "/front/b/e/be13351c-ca20-410c-8959-bbaa59816002.jpg", -- 325
    },
    PIP2 = {
        plains = "/front/a/d/ad6be912-4d77-45d2-b653-7fbbee6a881a.jpg", -- 318
        island = "/front/0/4/040ed422-663a-4b6c-bdcd-09092f1c9004.jpg", -- 320
        swamp = "/front/0/9/09af769d-a051-40d4-b203-7ec818c367ca.jpg", -- 322
        mountain = "/front/3/d/3d5691d3-751a-41dd-b2a3-c766c8973bfe.jpg", -- 324
        forest = "/front/3/a/3a1e5ef3-790d-4f45-a264-157448bab2e8.jpg", -- 326
    },
    PIP3 = {
        plains = "/front/0/7/07c15c48-8425-48f5-80f7-c8f74ad773e1.jpg", -- 845
        island = "/front/6/3/6317711a-83fc-4f6e-87d2-a147b34275ec.jpg", -- 847
        swamp = "/front/a/3/a37f8bb9-1d63-4f28-b15d-06f423785599.jpg", -- 849
        mountain = "/front/3/d/3d0e93c3-48e3-4ae5-a33f-4ef83f67ee37.jpg", -- 851
        forest = "/front/d/3/d35801ab-e484-44cb-b9ec-80723cb25bc7.jpg", -- 853
    },
    PIP4 = {
        plains = "/front/7/8/783eeb62-ab10-437d-a6cd-c3f99401b818.jpg", -- 846
        island = "/front/0/4/0480b669-e72b-4b21-b0f3-09d78abe421c.jpg", -- 848
        swamp = "/front/7/4/74c16759-117f-4f17-baea-88b18d391c38.jpg", -- 850
        mountain = "/front/8/4/84298c7a-8bae-4e62-bd0a-bcce2156fdf1.jpg", -- 852
        forest = "/front/a/9/a9305b9c-63af-49a3-97c2-0b3597555cc2.jpg", -- 854
    },
    PRM = {
        plains = "/front/6/a/6a5c5dcc-8e06-43ae-b765-f45957291eb9.jpg", -- 308
        island = "/front/e/8/e8732213-62b1-428d-bcb5-33c15b5e2120.jpg", -- 304
        swamp = "/front/c/4/c411f718-0676-480a-ab7e-0926e5138383.jpg", -- 310
        mountain = "/front/e/0/e0c1a97b-f64c-40f0-ab17-fbb3a2ef8982.jpg", -- 306
        forest = "/front/3/a/3af807cd-f640-4b13-9751-f74107b34f2b.jpg", -- 302
    },
    PRM2 = {
        plains = "/front/1/d/1dc5e9e3-05e0-4807-9998-b782df791697.jpg", -- 53879
        island = "/front/f/a/fa1980c8-6f8d-4d27-830e-2c3df98fb9bf.jpg", -- 53881
        swamp = "/front/b/e/bea00967-8eb9-453b-a7c0-7198b4b4f7d4.jpg", -- 53883
        mountain = "/front/d/a/dafbaffb-45ba-4b74-b57c-2a3f7c259e6b.jpg", -- 53877
        forest = "/front/2/4/2491fc97-f938-4d06-969b-3e8baa4dd96a.jpg", -- 53875
    },
    PSS4 = {
        plains = "/front/d/5/d5175a22-82f0-41d6-9d04-d524ace5c899.jpg", -- 1
        island = "/front/5/d/5dbd2888-56f7-4fe4-9eb2-1f125b581dde.jpg", -- 2
        swamp = "/front/3/1/31c98e87-f86d-4daa-b400-65f72cbbb460.jpg", -- 3
        mountain = "/front/f/6/f6d36bf6-a1fb-4a2b-a1ee-18cc7e1a6e1a.jpg", -- 4
        forest = "/front/f/9/f9bc7454-c312-48b9-95f4-43dbf7d00162.jpg", -- 5
    },
    REX = {
        plains = "/front/6/6/6620b5f4-b1e5-4d1b-bbf2-c6ad9c8284c5.jpg", -- 21
        island = "/front/7/6/76c343f5-6955-4ba2-a435-36d55182d1dd.jpg", -- 22
        swamp = "/front/8/4/843b35ec-7b59-4a22-8fee-2e876a02306b.jpg", -- 23
        mountain = "/front/a/a/aae84079-b65b-4132-86fb-e82503bb6c7b.jpg", -- 24
        forest = "/front/7/e/7e703632-5ed0-4509-a12b-594269f865f1.jpg", -- 25
    },
    SLD = {
        plains = "/front/2/8/282908d5-29e8-4a55-915e-64883ec3b714.jpg", -- 46
        island = "/front/0/d/0da4d5c0-7ad2-446d-b49e-5ee446bb23cd.jpg", -- 47
        swamp = "/front/f/9/f9c5c795-5463-425b-9720-627004925e20.jpg", -- 48
        mountain = "/front/e/8/e820a082-f876-4cfc-95a2-34be5b994d80.jpg", -- 49
        forest = "/front/f/2/f2bc8f49-6b8f-4466-908c-c6ff3e5c8c32.jpg", -- 50
    },
    SLD2 = {
        plains = "/front/5/f/5f4bf87b-1e31-4c09-b685-86592eb32be9.jpg", -- 63
        island = "/front/f/a/fa6f05fa-30e4-4b2c-9641-8a5847b59d65.jpg", -- 64
        swamp = "/front/b/6/b6ed633b-6452-4a0c-b308-ac28ad438933.jpg", -- 65
        mountain = "/front/0/5/05712bcb-eb67-4e84-a640-7e507675756a.jpg", -- 66
        forest = "/front/e/d/ed189e2b-a4e5-493b-9085-a5aae892e5a8.jpg", -- 67
    },
    SLD3 = {
        plains = "/front/3/4/34fe1359-c78c-41fb-95d9-fcc7c46f0bb1.jpg", -- 239
        island = "/front/e/b/ebbaf2e2-b4af-4a84-ab27-d8a6b40c9552.jpg", -- 240
        swamp = "/front/f/5/f52b53b7-4a20-48eb-a0bd-4ddf40aae740.jpg", -- 241
        mountain = "/front/2/7/277af45a-1f91-4fd4-804d-5b34241386b8.jpg", -- 242
        forest = "/front/2/a/2a9e6cdc-f92f-497c-8cd9-b69586098512.jpg", -- 243
    },
    SLD4 = {
        plains = "/front/e/0/e0ed0c75-0ec3-4f06-8c37-750fefb8136d.jpg", -- 325
        island = "/front/8/a/8af8122a-2943-4507-a93a-564fe63a035b.jpg", -- 326
        swamp = "/front/f/1/f19d95c5-278f-4ad5-99ea-9fcf85520de2.jpg", -- 327
        mountain = "/front/2/3/23fb3767-544d-4ae7-b7c4-af0944a0281b.jpg", -- 328
        forest = "/front/2/e/2e9a891d-a2c6-418d-a6bd-be2353b3e980.jpg", -- 329
    },
    SLD5 = {
        plains = "/front/8/6/8673e184-2b58-44ef-bb68-bd3d139ed0ba.jpg", -- 359
        island = "/front/6/d/6d8f64a6-ba1b-4cd9-8cf9-15f394f9524b.jpg", -- 360
        swamp = "/front/5/3/53f5c55d-09e5-49dd-906c-0f48a79b4c15.jpg", -- 361
        mountain = "/front/9/6/96549393-9607-43c8-91de-905462cbcb19.jpg", -- 362
        forest = "/front/e/7/e7f57347-7206-4a2f-a41b-0612d456cd30.jpg", -- 363
    },
    SLD9 = {
        plains = "/front/c/7/c71446bd-08f2-41fe-ae44-db44814c8afb.jpg", -- 415
        island = "/front/b/d/bd081bbf-8e82-405c-a522-f826fa0a6e1d.jpg", -- 416
        swamp = "/front/0/8/085b4641-62fb-4820-aded-ccc9403d319e.jpg", -- 417
        mountain = "/front/d/d/dd8611ec-6db3-4d29-8d3b-01e87bb38a55.jpg", -- 418
        forest = "/front/5/f/5fca5dbb-8d5e-4471-94f6-e0944cf60ed2.jpg", -- 419
    },
    SLD10 = {
        plains = "/front/7/1/715b89c9-2820-41ec-8a87-b2657ca0c7fe.jpg", -- 448
        island = "/front/f/7/f7c81707-adf0-48fd-8720-25db4d21b0b2.jpg", -- 449
        swamp = "/front/0/5/0520813a-fe20-4bde-8dc9-9a7add51c722.jpg", -- 450
        mountain = "/front/5/2/52248fe8-0f1b-4e3d-9024-842c921b6071.jpg", -- 451
        forest = "/front/a/9/a940a241-4efd-42f7-a670-2c4fed4755bb.jpg", -- 452
    },
    SLD12 = {
        plains = "/front/f/8/f8dca86c-4dd3-4016-bab1-dd259b68b66c.jpg", -- 888
        swamp = "/front/5/b/5b643680-4e28-4ae2-b4d6-609d2150a171.jpg", -- 890
        island = "/front/c/0/c0a03261-6766-47e6-ba81-c6c58618939d.jpg", -- 889
        forest = "/front/5/9/59f95235-3ca9-47d7-be6a-aebfb29fcbbd.jpg", -- 892
        mountain = "/front/5/2/5256e591-7510-41fd-8564-330562c00adb.jpg", -- 891
    },
    SLD13 = {
        plains = "/front/0/2/026777d1-e3a7-45a3-8967-527c0b4236e2.jpg", -- 1088
        island = "/front/d/0/d0a2259b-9ee8-42d7-92c0-d9421dd196e5.jpg", -- 1089
        swamp = "/front/f/4/f49d825e-0a51-43e8-9b5a-43a376b58d6f.jpg", -- 1090
        forest = "/front/f/8/f8f694e1-f9c9-428e-a85c-d09b3474c79b.jpg", -- 1092
        mountain = "/front/e/d/edf40698-620e-4032-b2e3-0d513a4a4250.jpg", -- 1091
    },
    SLD14 = {
        plains = "/front/9/1/912e30e7-9b8b-4c27-af3a-ffdcfe8b6feb.jpg", -- 1130
        island = "/front/9/6/96cb4d9d-4f2b-4f60-b48f-749747aa7c15.jpg", -- 1131
        swamp = "/front/f/3/f32a6e87-a9fb-4bd8-a09d-b160aa302a2b.jpg", -- 1132
        forest = "/front/1/a/1a13a86b-c4c5-4a7a-9e01-8669e9ed6557.jpg", -- 1134
        mountain = "/front/8/2/82b5f331-3d6f-4e0f-b5a4-61040ed61d39.jpg", -- 1133
    },
    SLD15 = {
        plains = "/front/d/7/d7147b73-a7fa-4ecf-b9a1-a3f4851a5bef.jpg", -- 1382
        island = "/front/c/c/cca2b9b7-9c12-488d-8f8b-540249d0d350.jpg", -- 1383
        swamp = "/front/3/8/387ec72f-dd6b-4769-be3a-981d580715be.jpg", -- 1384
        mountain = "/front/7/0/70099566-ba66-4d66-aafa-8232aa664a6d.jpg", -- 1385
        forest = "/front/5/6/56afe767-c967-4094-8d60-165bc7d11ab1.jpg", -- 1386
    },
    SLD16 = {
        plains = "/front/c/e/cefbe595-93a9-4a5d-b5a5-4f517cec7bdd.jpg", -- 1399
        island = "/front/b/3/b3a5eda4-6339-4303-97ef-c5a467585949.jpg", -- 1400
        swamp = "/front/a/2/a22f49c5-1dcd-453c-b169-0b2519c44d0c.jpg", -- 1401
        mountain = "/front/d/3/d3740beb-7fa5-4b83-be7d-039750b126c5.jpg", -- 1402
        forest = "/front/7/1/715c6de3-5f4a-483f-9b73-ddb23207c0f4.jpg", -- 1403
    },
    SLD17 = {
        plains = "/front/7/4/7432b894-e7a9-4de7-9470-846e65cd4d0c.jpg", -- 1468
        island = "/front/8/3/839e97b5-c04d-4088-af4e-fa64f4575e51.jpg", -- 1469
        swamp = "/front/d/b/db3c0baf-9b5c-44ff-86eb-ca0f24ab0fe1.jpg", -- 1470
        mountain = "/front/0/1/01550676-3659-47d7-9a47-67c31438ec09.jpg", -- 1471
        forest = "/front/c/a/cadcd72e-90ca-4cfc-a181-742e35c4a8ed.jpg", -- 1472
    },
    SLD18 = {
        plains = "/front/9/e/9ecc0bbe-a901-4565-940b-9f763cf006a4.jpg", -- 1473
        island = "/front/c/e/cef7e936-bd27-4955-a5ea-c1e88a9ab646.jpg", -- 1474
        swamp = "/front/9/7/97de8c3b-410e-4fc6-abfb-7315010e05d5.jpg", -- 1475
        mountain = "/front/c/e/cee2b472-8cb0-4722-a1b7-b700ac42a6c0.jpg", -- 1476
        forest = "/front/3/9/3995734f-5fa2-4039-af64-0bca88741089.jpg", -- 1477
    },
    SLD19 = {
        plains = "/front/5/1/513e5104-02b1-48db-a70e-d267066d2561.jpg", -- 1473★
        island = "/front/3/2/328fc009-d9c1-472d-8e07-778f60947642.jpg", -- 1474★
        swamp = "/front/6/a/6a04eb28-cba8-4619-972c-4e6ebff73f34.jpg", -- 1475★
        mountain = "/front/6/f/6f4fab9d-7753-489e-a63c-c107e7d27668.jpg", -- 1476★
        forest = "/front/a/f/af1d1476-7778-4743-804a-e3f497d38d77.jpg", -- 1477★
    },
    SLD20 = {
        plains = "/front/e/7/e7667207-283c-4318-b918-caa6368bb6e3.jpg", -- 1478
        island = "/front/7/3/73014252-76c1-4554-bd1a-c01ec5342dde.jpg", -- 1479
        swamp = "/front/e/3/e35962e5-00ed-4a2c-a6e1-67373615178a.jpg", -- 1480
        mountain = "/front/2/3/2373014c-21d1-43d5-b774-352cdc2a840e.jpg", -- 1481
        forest = "/front/9/8/98548336-f0f6-47ce-8ed6-977c8c8150af.jpg", -- 1482
    },
    SLD21 = {
        plains = "/front/4/7/471577f8-dc62-4f10-8adf-1e566ffc75fa.jpg", -- 1939
        island = "/front/e/0/e0bf27bd-ebd8-40bf-9e8a-8ccde26bd1ec.jpg", -- 1940
        swamp = "/front/5/8/58c53fd4-032f-47a9-9f1f-4f6d3c907bd2.jpg", -- 1941
        mountain = "/front/6/d/6d65590b-f390-4faa-80e8-43bd87a70ff7.jpg", -- 1942
        forest = "/front/3/2/32636e80-9455-43c8-b55f-dfa2d7b7465b.jpg", -- 1943
    },
    SLD22 = {
        plains = "/front/1/2/1299d0cf-76d1-4111-939c-5e1b43347a83.jpg", -- 2076
        island = "/front/8/0/80784e7c-2939-4233-9953-87370f85a3ae.jpg", -- 2077
        swamp = "/front/b/8/b8e58e37-6393-4e51-b129-849711e15335.jpg", -- 2078
        mountain = "/front/f/d/fdf1fea6-3e04-474c-9cda-ff49fee255f7.jpg", -- 2079
        forest = "/front/2/c/2ccc7cf2-c9ed-4505-9341-7b8dcf10590f.jpg", -- 2080
    },
    SLD23 = {
        plains = "/front/f/5/f5bccd95-0703-4755-8f31-bd8ab615bd04.jpg",
        island = "/front/d/3/d3b7f1bb-b47d-4096-b17a-db0587f566c6.jpg",
        swamp = "/front/0/c/0c70db5a-3d7f-4534-9e5a-01d510b8d62a.jpg",
        mountain = "/front/6/0/603114eb-c0eb-4734-87e6-7fc94beda3c7.jpg",
        forest = "/front/d/a/da462ed3-c8f5-409e-bdc8-53e36a4961dd.jpg",
    },
    SLD24 = {
        plains = "/front/d/d/dd81973f-c7a8-4855-affe-6a65b7f88406.jpg",
        island = "/front/2/1/21d03913-c905-439c-a603-7d7fae6b9cd9.jpg",
        swamp = "/front/4/1/4187a894-1a26-43ec-8e38-5422ae7e6b9b.jpg",
        mountain = "/front/c/c/ccf928c4-c8ee-479c-88df-d6bb35e0778a.jpg",
        forest = "/front/9/c/9cbaa22a-d679-48ef-805a-d09d6f1091aa.jpg",
    },
    SLDTXT = {
        plains = "/front/f/5/f5a19fcc-f465-43ac-8d08-ba0d2345b66d.jpg",
        island = "/front/b/d/bd07b50a-0bd7-49fa-9ada-96a8f96a62cc.jpg",
        swamp = "/front/1/c/1ccdc3f2-0e3e-45b4-a141-2eb029275e9a.jpg",
        mountain = "/front/2/e/2e4072f8-4833-4219-b620-3092a9f08874.jpg",
        forest = "/front/e/f/ef37620d-4fa4-4d2f-a668-7b1e556b3b04.jpg",
    },
    SNC = {
        plains = "/front/e/8/e882099c-63cd-42f0-b160-35e6922106b1.jpg", -- 272
        island = "/front/8/2/8221d15c-c993-4345-a6bb-6a7d215e3273.jpg", -- 274
        swamp = "/front/5/f/5f917d8d-7037-4f11-91f6-1ef96b3541bb.jpg", -- 276
        mountain = "/front/6/a/6a58066e-f9a2-4508-9cc0-908b1cf747e3.jpg", -- 278
        forest = "/front/c/7/c726424a-3336-4e15-9055-4a26371df361.jpg", -- 280
    },
    SNC2 = {
        plains = "/front/a/a/aa69cedc-49ce-48f3-88e1-94b9bc061bf4.jpg", -- 273
        island = "/front/5/a/5aaba7cd-c1dc-49cf-8d63-8bb3594a6541.jpg", -- 275
        swamp = "/front/b/4/b4569823-af23-4eea-acc9-2a2c62bce3b0.jpg", -- 277
        mountain = "/front/2/e/2e97dadd-0849-4c18-9523-4775d09fca9a.jpg", -- 279
        forest = "/front/6/3/633eb269-916e-4d79-821e-1f304283416c.jpg", -- 281
    },
    TDM = {
        plains = "/front/0/d/0d0f1dd6-9564-4adc-af7d-f83252e8581a.jpg", -- 272
        island = "/front/4/2/4208e66c-8c98-4c48-ab07-8523c0b26ca4.jpg", -- 273
        swamp = "/front/e/f/ef235170-8276-4ef0-bdfd-ba68d5b218ec.jpg", -- 274
        mountain = "/front/f/e/fe0865ba-47c0-40bc-b0c6-e1ea5ae08a98.jpg", -- 275
        forest = "/front/4/8/48811e13-5774-4da1-95ec-6ea5dc4976ad.jpg", -- 276
    },
    TDM2 = {
        plains = "/front/3/e/3e8c67e5-587a-43b2-af47-bbad1f8b52e9.jpg", -- 287
        island = "/front/b/3/b300be80-6618-4284-b5c3-95c1ab373e6f.jpg", -- 288
        swamp = "/front/5/7/57da24a0-89a7-4756-b4ca-4dea132e8f67.jpg", -- 289
        mountain = "/front/a/4/a4db1b7a-93f2-40a5-b649-80a099ddeb62.jpg", -- 290
        forest = "/front/7/e/7e33e540-2828-46ad-a441-366552843d9c.jpg", -- 291
    },
    THB = {
        plains = "/front/a/9/a9891b7b-fc52-470c-9f74-292ae665f378.jpg", -- 250
        island = "/front/a/c/acf7b664-3e75-4018-81f6-2a14ab59f258.jpg", -- 251
        swamp = "/front/0/2/02cb5cfd-018e-4c5e-bef1-166262aa5f1d.jpg", -- 252
        mountain = "/front/5/3/53fb7b99-9e47-46a6-9c8a-88e28b5197f1.jpg", -- 253
        forest = "/front/3/2/32af9f41-89e2-4e7a-9fec-fffe79cae077.jpg", -- 254
    },
    TLA = {
        plains = "/front/8/a/8a880169-41ca-4507-83fd-306a489d31ce.jpg", -- 287
        island = "/front/d/8/d894c61a-4062-442e-8ead-5197c3bffd00.jpg", -- 288
        swamp = "/front/8/7/874f0f27-81a4-4853-aaa0-2c15e07c177e.jpg", -- 289
        mountain = "/front/e/a/ea96ecc4-72f3-46a4-8900-6a7c5a83d4df.jpg", -- 290
        forest = "/front/0/5/05683891-cdd4-4401-b7d5-0ef17e79c699.jpg", -- 291
    },
    UGL = {
        plains = "/front/c/b/cb382733-ff3d-43e2-9b1e-efa2f7c28173.jpg", -- 84
        island = "/front/5/4/547f89f2-30a0-493a-914e-6251d2574099.jpg", -- 85
        swamp = "/front/6/9/69384f97-3333-4aa7-bc4f-928ba49a2c80.jpg", -- 86
        mountain = "/front/8/e/8e3c2e1a-181e-4275-ad09-51c9de039d32.jpg", -- 87
        forest = "/front/b/3/b3ed8a17-ce32-4100-8ffc-fb8af1c35142.jpg", -- 88
    },
    UND = {
        plains = "/front/2/2/2296cffa-be1f-49af-aaca-3166e7043de0.jpg", -- 88
        island = "/front/9/6/96ad5cbb-b64e-4e18-9aa0-ac076d4b2448.jpg", -- 90
        swamp = "/front/1/b/1b1d4996-ed4e-4818-a9ec-f5d8ee84ad26.jpg", -- 92
        mountain = "/front/7/3/737ac24f-a47b-486c-89df-3e3eaf495ff5.jpg", -- 94
        forest = "/front/1/2/12a035fe-8847-4678-84f7-01bac77ae011.jpg", -- 96
    },
    UNF = {
        plains = "/front/c/4/c453d1ea-9a42-4ccb-9391-eec122025647.jpg", -- 235
        island = "/front/1/d/1d018af9-dd14-46fa-8fd5-226defc9698f.jpg", -- 236
        swamp = "/front/4/6/46a6375e-9477-4871-8a15-02439f3f6f34.jpg", -- 237
        mountain = "/front/3/d/3d6da8eb-31b0-48c1-9ad9-552827967f91.jpg", -- 238
        forest = "/front/5/d/5dda1113-352c-471a-a7e0-a9a3cb3f19c5.jpg", -- 239
    },
    UNF2 = {
        plains = "/front/8/2/82283c22-9b64-4f41-a5bb-aeb737eee5c9.jpg", -- 240
        island = "/front/1/5/15303b22-ddf0-488d-b07e-a118f35ef00f.jpg", -- 241
        swamp = "/front/f/3/f3c850b9-d014-4cd1-8ffd-361ed4fe1e6d.jpg", -- 242
        mountain = "/front/9/e/9e1170a5-e5bb-4b86-8718-f75eec679b4e.jpg", -- 243
        forest = "/front/f/1/f1488e6b-f677-44c5-8ff3-6a2f9bdb28c2.jpg", -- 244
    },
    UNF3 = {
        plains = "/front/0/a/0a4af7f5-c89c-4e61-9d4b-b9e467ca55b4.jpg", -- 486
        island = "/front/3/8/38e083ce-0f15-4ff0-8af1-747565f2d0d8.jpg", -- 487
        swamp = "/front/5/8/58c4bbf1-2e52-4b43-ad35-9272b48d36a8.jpg", -- 488
        mountain = "/front/7/e/7e998ce9-4853-44d1-a01a-e2d493718ceb.jpg", -- 489
        forest = "/front/c/4/c46df0e0-648d-4dc9-a2c7-ac96125ba77c.jpg", -- 490
    },
    UNF4 = {
        plains = "/front/3/d/3deb3077-484d-42d4-a54b-5fade5335420.jpg", -- 491
        island = "/front/f/6/f670e5e4-721b-422a-b10e-09bb742cbc4b.jpg", -- 492
        swamp = "/front/2/d/2d49fc14-e848-4c44-a03c-6dfb83efed80.jpg", -- 493
        mountain = "/front/0/8/08bc7313-8b12-4ce1-9016-59b4e3c78ff1.jpg", -- 494
        forest = "/front/9/7/977ec5e4-3b44-4359-9ab8-4e25e2a9ec86.jpg", -- 495
    },
    UNH = {
        plains = "/front/1/d/1d7dba1c-a702-43c0-8fca-e47bbad4a00f.jpg", -- 136
        island = "/front/0/c/0c4eaecf-dd4c-45ab-9b50-2abe987d35d4.jpg", -- 137
        swamp = "/front/8/3/8365ab45-6d78-47ad-a6ed-282069b0fabc.jpg", -- 138
        mountain = "/front/4/2/42232ea6-e31d-46a6-9f94-b2ad2416d79b.jpg", -- 139
        forest = "/front/1/9/19e71532-3f79-4fec-974f-b0e85c7fe701.jpg", -- 140
    },
    UST = {
        plains = "/front/7/a/7a2c8b8e-2e28-4f10-b04f-9b313c60c0bb.jpg", -- 212
        island = "/front/1/0/105b2118-b22c-4ef5-bac7-836db4b8b9ee.jpg", -- 213
        swamp = "/front/f/1/f108b0fb-420a-422d-ae85-9a99c0f73169.jpg", -- 214
        mountain = "/front/4/4/44c1a862-00fc-4e79-a83a-289fef81503a.jpg", -- 215
        forest = "/front/f/8/f8772631-d4a1-440d-ac89-ac6659bdc073.jpg", -- 216
    },
    VOW = {
        plains = "/front/d/e/deabdaa1-6227-48e4-82d5-63a1771320b2.jpg", -- 268
        island = "/front/5/4/54ddd3aa-593c-4adb-b591-33c15d02131c.jpg", -- 270
        swamp = "/front/4/a/4abfe418-15f8-46ce-9b39-fd5a38b25d12.jpg", -- 272
        mountain = "/front/8/a/8a4448b6-0dbe-427c-b145-8ac915fc0dfc.jpg", -- 274
        forest = "/front/e/4/e4c83b60-3d49-4fdc-a6b7-06d1a0c4a126.jpg", -- 276
    },
    VOW2 = {
        plains = "/front/2/b/2b069f97-735a-4d85-8504-b5a863bd659b.jpg", -- 269
        island = "/front/5/4/54591ec7-94a1-470c-927a-788b6a514444.jpg", -- 271
        swamp = "/front/2/e/2e55a405-bf5b-4158-ba9a-239627ac9701.jpg", -- 273
        mountain = "/front/a/6/a6f72e53-52bb-4cf4-9b8b-34ed0c5f7c3c.jpg", -- 275
        forest = "/front/e/8/e8760175-e9bb-4ef9-87ca-591d1edd5163.jpg", -- 277
    },
    VOW3 = {
        plains = "/front/8/0/80897666-ade2-4f70-9c4d-235753b44a23.jpg", -- 408
        island = "/front/1/f/1fddf4cb-0680-4bc7-8bb3-cb15268aff46.jpg", -- 409
        swamp = "/front/9/1/91afb4f0-70ef-4539-9081-dc130c7c63f5.jpg", -- 410
        mountain = "/front/1/1/117716bf-43c8-4534-92da-d7948d4b5628.jpg", -- 411
        forest = "/front/a/7/a7279281-42d5-4226-b841-f1f4deff919b.jpg", -- 412
    },
    WOE = {
        plains = "/front/c/9/c9cd4d57-8c51-4fcf-8a9f-5d6a61c33e3d.jpg", -- 262
        island = "/front/b/d/bd4b4da4-83f6-4280-880b-b6033308f2a2.jpg", -- 263
        swamp = "/front/e/e/ee68f2cb-851b-4196-ac58-844d72628e6a.jpg", -- 264
        mountain = "/front/8/8/8822db23-34dc-452a-92bc-a3ceee4db375.jpg", -- 265
        forest = "/front/e/c/ecd6d8fb-780c-446c-a8bf-93386b22fe95.jpg", -- 266
    },
    ZEN = {
        plains = "/front/b/c/bc4f4b6d-ff35-4b1f-974b-f39569e6b3c7.jpg", -- 230
        island = "/front/e/f/efd86f2a-bd28-4731-838d-78e67be8b49e.jpg", -- 234
        swamp = "/front/7/c/7cd6becc-f06a-4fd3-8305-70604b92a187.jpg", -- 238
        mountain = "/front/2/3/232ee129-0db1-4a03-9eda-4692a8495b53.jpg", -- 242
        forest = "/front/f/0/f0ca4b9f-4ee6-4ad8-a95f-326ada9de3cd.jpg", -- 246
    },
    ZEN2 = {
        plains = "/front/6/b/6b362e9b-8d25-405e-b70e-f3c9533627a7.jpg", -- 231
        island = "/front/2/0/20b4cbcc-c394-4be3-8072-8893b48c866d.jpg", -- 235
        swamp = "/front/8/4/847cac15-b404-4e0f-964e-7aee41c93346.jpg", -- 239
        mountain = "/front/e/3/e3de70f1-6fb1-4191-b66f-491c794f9c05.jpg", -- 243
        forest = "/front/6/7/6744c441-42b3-48b2-af06-1e27ec776d97.jpg", -- 247
    },
    ZEN3 = {
        plains = "/front/3/6/36446ad6-8bf0-4e4e-bbab-379c22dbf4f6.jpg", -- 232
        island = "/front/5/5/551f905b-4ce0-4071-a721-7e51be14d114.jpg", -- 236
        swamp = "/front/a/0/a095fed4-0a2a-4092-b923-8f46c8ea22d8.jpg", -- 240
        mountain = "/front/0/3/03bacab3-25fb-4a0c-81b3-7e9e22899c2c.jpg", -- 244
        forest = "/front/5/2/52c21f91-6679-4adb-baf2-b06cf505150c.jpg", -- 248
    },
    ZEN4 = {
        plains = "/front/e/9/e9646663-ba93-446b-ad83-71503924e7f8.jpg", -- 233
        island = "/front/4/d/4dc3a90f-23c4-4c54-8825-32cb17977b48.jpg", -- 237
        swamp = "/front/b/c/bc9e2d99-a3ad-4bfb-a781-a8a9454085c9.jpg", -- 241
        mountain = "/front/7/a/7a298c5d-9937-4df6-a544-7b3bcfe84885.jpg", -- 245
        forest = "/front/3/4/341b05e6-93bb-4071-b8c6-1644f56e026d.jpg", -- 249
    },
    ZNR = {
        plains = "/front/9/5/9591fd15-78d9-4089-a075-031ab2affd2d.jpg", -- 266
        island = "/front/7/7/77ea783b-adaa-47be-9918-ca2f161c5d9e.jpg", -- 269
        swamp = "/front/9/5/95a58ce4-e07f-4c9c-98ae-3173d6d63cc5.jpg", -- 272
        mountain = "/front/9/6/96297bcc-8480-4b14-8612-1c395d481bce.jpg", -- 275
        forest = "/front/d/9/d949485e-5188-49f4-9d30-5e135532d445.jpg", -- 278
    },
    ZNR2 = {
        plains = "/front/5/6/5665190e-ea2a-498e-9c4f-f0bc514bd80c.jpg", -- 267
        island = "/front/b/b/bb695ab9-72dc-4b07-b42d-e2109a5254b6.jpg", -- 270
        swamp = "/front/2/6/26142ae3-5aa1-4b9b-989a-21c0e4e5089d.jpg", -- 273
        mountain = "/front/7/0/701aefd4-074a-47b8-88a3-32fb90b09dee.jpg", -- 276
        forest = "/front/1/8/184a9654-ce17-4378-b52b-fb6efbbf042f.jpg", -- 279
    },
    ZNR3 = {
        plains = "/front/5/d/5d918248-85ff-4fea-ac91-aa5466dd2829.jpg", -- 268
        island = "/front/1/b/1ba4b3ad-1aef-44d3-889a-aedd9e070975.jpg", -- 271
        swamp = "/front/4/1/418335b2-398f-499e-92ad-8d21a5a5b69f.jpg", -- 274
        mountain = "/front/c/8/c89b3c3a-3dba-47b3-9620-d4dd754a59e6.jpg", -- 277
        forest = "/front/e/2/e2ef9b74-481b-424b-8e33-f0b910f66370.jpg", -- 280
    },
    PLST = {
        plains = "/front/7/f/7f65a77d-6fa9-4f26-a9bd-8b34a9b1bed4.jpg", -- UGL-84
        island = "/front/5/4/547f89f2-30a0-493a-914e-6251d2574099.jpg",
        swamp = "/front/6/9/69384f97-3333-4aa7-bc4f-928ba49a2c80.jpg",
        mountain = "/front/8/e/8e3c2e1a-181e-4275-ad09-51c9de039d32.jpg",
        forest = "/front/b/3/b3ed8a17-ce32-4100-8ffc-fb8af1c35142.jpg",
    },
    -- leftovers (less than 5 types)
    SLP = {
        plains = "/front/a/f/afc24e1d-2fb0-46eb-926b-7345741d443e.jpg", -- 31
        island = "/front/e/f/ef2f3e0d-43e5-4d62-8a93-821ec723d522.jpg", -- 32
        swamp = "/front/7/8/7847ca54-c608-452a-a19e-3d08b8d8b8f3.jpg", -- 33
        mountain = "/front/9/f/9f883975-3505-4b5a-8dd4-8b8df9da658f.jpg", -- 34
        forest = "/front/e/d/ed22c591-19f4-4096-a08c-5523a26b307c.jpg", -- 6
    },
    PL24 = {
        mountain = "/front/5/e/5eeddb97-3b50-4ba3-b48d-d1807e644b72.jpg", -- 5
    },
    SLD100 = {
        swamp = "/front/5/0/50205489-2960-462c-a6cb-35a491dc54d5.jpg", -- 119
    },
    SLD101 = {
        swamp = "/front/6/0/6079aea9-145a-445d-a00f-1c0f4018a529.jpg", -- 384
    },
    SLD102 = {
        island = "/front/e/3/e306586a-427f-45b7-9e3b-cd9157cec07f.jpg", -- 385
    },
    SLD103 = {
        island = "/front/c/4/c4555e99-7f95-4c76-914f-0a42d49975cd.jpg", -- 386
    },
    SLD104 = {
        mountain = "/front/f/a/fa08a961-cd6a-403e-a098-1e7f716262bb.jpg", -- 387
    },
    SLD105 = {
        forest = "/front/2/4/249104ba-65fc-42d6-ad8b-d97640545d89.jpg", -- 388
    },
    SLD106 = {
        mountain = "/front/c/b/cb4abaf5-3bc0-464c-b31d-d579d0a9128d.jpg", -- 389
    },
    SLD107 = {
        plains = "/front/a/f/afb59eef-385b-4a9d-b70c-952387b30310.jpg", -- 390
    },
    SLD108 = {
        plains = "/front/7/7/771294b5-c1a1-4456-8399-1391bc5ba40e.jpg", -- 391
    },
    SLD109 = {
        island = "/front/3/3/3352b213-4ebc-4b4c-ae75-f256fbb33d95.jpg", -- 392
    },
    SLD1010 = {
        plains = "/front/8/2/825f809d-fb64-4101-a985-c3533f26a345.jpg", -- 393
    },
    SLD111 = {
        swamp = "/front/4/b/4b0c331d-56c6-47d9-bd52-30a92b6415b3.jpg", -- 394
    },
    SLD112 = {
        forest = "/front/3/c/3c5c5d09-6f93-44f5-894d-4c7be40bb006.jpg", -- 395
    },
    SLD113 = {
        island = "/front/4/c/4c23ffd3-dcee-4b29-99f0-4502c19f0947.jpg", -- 466
    },
    SLD114 = {
        forest = "/front/7/5/75d5a81e-1efc-46f3-b169-0422cbc8cd5e.jpg", -- 476
    },
    SLD115 = {
        swamp = "/front/a/1/a1f8f29a-5771-4407-8a2b-cfeeeff04611.jpg", -- 539
    },
    SLD116 = {
        plains = "/front/f/e/feb949a6-9261-4175-bcf1-5519d82f9dc3.jpg", -- 670
    },
    SLD117 = {
        island = "/front/d/e/de6d4527-a88e-4001-b8a7-53db87784c8f.jpg", -- 673
    },
    SLD119 = {
        forest = "/front/d/6/d65f7c03-647f-4e5a-98b1-1faa3d330e7b.jpg", -- 690
    },
    SLD119 = {
        mountain = "/front/8/9/8993e4d0-d306-4993-b5a7-dbba754d479e.jpg", -- 674
    },
    SLD120 = {
        plains = "/front/f/8/f8b86eac-3cd5-48ef-9fda-b4beff540c94.jpg", -- 1513
    },
    SLD121 = {
        forest = "/front/7/9/79053ce4-62d4-416c-b001-93740521fd07.jpg", -- 1515
    },
    SLD122 = {
        mountain = "/front/f/7/f76d6ecc-a774-44d5-8c16-e2ba4bf7d283.jpg", -- 1514
    },
}

local standardSleeve = "https://steamusercontent-a.akamaihd.net/ugc/1869555872447018243/605ECC61FD27EE474845AA7CC2AAC1AB2984DECB/"
local sleeveImages = {
    standardSleeve,
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

local sortByOptions = {
    name = "Name",
    cmc_name = "CMC + Name",
    type_name = "Type + Name",
    type_cmc_name = "Type + CMC + Name",
    cmc_type_name = "CMC + Type + Name",
}
local activeTool = null
local tools = {}
tools.landSwapper = {
    label = "Land Swapper",
    getSummaryXml = function()
        local xml = ""
        local lands = { "plains", "island", "swamp", "mountain", "forest" }
        local anySelected = false
        for _, land in ipairs(lands) do
            if selections[land] then
                anySelected = true
                break
            end
        end

        if anySelected then
            for _, land in ipairs(lands) do
                if selections[land] then
                    xml = xml .. string.format([[
                        <Panel>
                            <Button width="80" height="111" image="%s" id="%sPreview" />
                        </Panel>
                    ]], landUrlPrefix .. "small" .. selections[land], land)
                end
            end
        else
            xml = xml .. [[
                <Text fontSize="40" color="#000000EE" text="no land change" />
            ]]
        end
        return string.format([[
                <HorizontalLayout>
                    %s
                </HorizontalLayout>
        ]], xml)
    end,
    getToolXml = function()
        local cols = 20
        local buttonWidth = 75
        local buttonHeight = 100
        local xml = ""
        local index = 0

        for groupName, lands in pairs(landImages) do
            for landType, image in pairs(lands) do
                local col = index % cols
                local row = math.floor(index / cols)

                if col == 0 and row > 0 then
                    xml = xml .. [[</Row><Row preferredHeight="100">]]
                end

                xml = xml .. string.format([[
                        <Cell>
                            <Button width="%d" height="%d" image="%s" onClick="onLandClicked%s(%s)" />
                        </Cell>
                    ]],
                        buttonWidth, buttonHeight, landUrlPrefix .. "small" .. image, landType:gsub("^%l", string.upper), image
                )

                index = index + 1
            end
        end

        local images = JSON.decode(JSON.encode(landImages.standard))
        for land, _ in pairs(images) do
            if selections[land] then
                images[land] = selections[land]
            end
        end

        return string.format([[
            <Panel offsetXY="710 -270" width="1520">
                <ToggleGroup allowSwitchOff="true" height="400">
                    <HorizontalLayout spacing="25">
                        <Button width="300" height="390" image="%s" id="plains" onClick="onLandClickedPlains(%s)" />
                        <Button width="300" height="390" image="%s" id="island" onClick="onLandClickedIsland(%s)" />
                        <Button width="300" height="390" image="%s" id="swamp" onClick="onLandClickedSwamp(%s)" />
                        <Button width="300" height="390" image="%s" id="mountain" onClick="onLandClickedMountain(%s)" />
                        <Button width="300" height="390" image="%s" id="forest" onClick="onLandClickedForest(%s)" />
                    </HorizontalLayout>
                </ToggleGroup>
                <VerticalScrollView offsetXY="0 -620" width="1520" height="800" scrollSensitivity="30" horizontalScrollbarVisibility="AutoHideAndExpandViewport">
                    <TableLayout width="1500" height="%d">
                        <Row preferredHeight="%d">]] .. xml .. [[</Row>
                    </TableLayout>
                </VerticalScrollView>
            </Panel>
            ]],
                landUrlPrefix .. "large" .. images.plains, images.plains,
                landUrlPrefix .. "large" .. images.island, images.island,
                landUrlPrefix .. "large" .. images.swamp, images.swamp,
                landUrlPrefix .. "large" .. images.mountain, images.mountain,
                landUrlPrefix .. "large" .. images.forest, images.forest,
                (math.floor(index / cols) + 1) * buttonHeight,
                buttonHeight)
    end,
}
tools.sleeveChanger = {
    label = "Sleeve Changer",
    getSummaryXml = function()
        local xml = ""
        if selections.sleeve then
            xml = xml .. string.format([[
                <Button width="80" height="111" image="%s" id="sleevePreview" />
            ]], selections.sleeve)
        else
            xml = xml .. [[ <Text fontSize="40" color="#000000EE" text="no sleeve change" /> ]]
        end
        return xml
    end,
    getToolXml = function()
        local cols = 15
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
                                <Button width="%d" height="%d" image="%s" onClick="onSleeveClicked(%s)" />
                            </Cell>
                        ]],
                            buttonWidth, buttonHeight, image, image
                    )
                end

                id = id + 1
            end
        end

        local width = cols * buttonWidth
        local height = (math.floor(id / cols)) * buttonHeight + 100
        local sleeve = selections.sleeve
        if not sleeve then
            sleeve = standardSleeve
        end

        return string.format([[
                <Button offsetXY="1280 -270" width="300" height="390" image="%s" id="sleeve" onClick="onSleeveClicked(%s)" />
                <VerticalScrollView width="%d" height="1000" offsetXY="520 -570" scrollSensitivity="30" horizontalScrollbarVisibility="AutoHideAndExpandViewport">
                    <TableLayout width="%d" height="%d">
                        <Row preferredHeight="100">
                            <InputField id="sleeveInput" width="%d" height="80" fontSize="50" placeholder="Enter the URL of your sleeve here" onEndEdit="onSleeveInput()" />
                        </Row>
                        <Row preferredHeight="%d">]] .. xml .. [[</Row>
                    </TableLayout>
                </VerticalScrollView>
            ]],
                sleeve, sleeve, width + 20, width, height, width - 20, buttonHeight)
    end,
}
tools.deckSorter = {
    label = "Deck Sorter",
    getSummaryXml = function()
        if selections.sortBy then
            return string.format([[
                    <VerticalLayout>
                        <Text fontSize="30" color="#111111EE" text="Sort By" />
                        <Text fontSize="40" fontStyle="Bold" color="#000000EE" text="%s" />
                    </VerticalLayout>
                ]], sortByOptions[selections.sortBy] or selections.sortBy)
        end
        return [[
                <Text fontSize="40" color="#000000EE" text="no sorting" />
            ]]
    end,
    getToolXml = function()
        local buttonWidth = 30
        local buttonHeight = 45

        local cardsInContainerDeck = collapseDeck(containedDeckData.ContainedObjects)

        local function getSortBarXml()
            local sortBarXml = {}
            for sortById, sortBy in pairs(sortByOptions) do
                local isOn = (sortById == selections.sortBy) and 'isOn="true"' or ''
                table.insert(sortBarXml, string.format([[<ToggleButton fontSize="20" fontStyle="Bold" onValueChanged="onSelectSortBy(%s)" text="%s" %s />]], sortById, sortBy, isOn))
            end

            return [[
            <Panel offsetXY="710 -120" width="1520" height="80">
                <ToggleGroup allowSwitchOff="true">
                    <HorizontalLayout spacing="25">
                        ]] .. table.concat(sortBarXml, "\n") .. [[
                    </HorizontalLayout>
                </ToggleGroup>
            </Panel>
        ]]
        end

        local function getCardXml(card)
            return string.format([[
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

        local function getCardsXml()
            local xml = ""

            for row = 1, #cardsInContainerDeck do
                local card = cardsInContainerDeck[row]

                if card then
                    xml = xml .. getCardXml(card)
                end
            end

            return xml
        end

        return string.format([[
            %s
            <VerticalScrollView width="1520" height="1200" offsetXY="710 -780" scrollSensitivity="30" horizontalScrollbarVisibility="AutoHideAndExpandViewport">
                <TableLayout width="1500" height="%d" columnWidths="37 73 700 600 100" cellPadding="3" color="#ffffff">
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
                   %s
                </TableLayout>
            </VerticalScrollView>
        ]],
                getSortBarXml(),
                #cardsInContainerDeck * buttonHeight + buttonHeight,
                buttonHeight,
                getCardsXml()
        )
    end,
}

function onSave()
    return JSON.encode(selections)
end

function onLoad(save_state)
    selections = JSON.decode(save_state) or { }

    for k, v in pairs(defaults) do
        if v and not selections[k] then
            selections[k] = v
        end
    end

    createLabelButton()
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

    playTriggerEffect()
    self.clearButtons()

    containedDeckData = object.getData()

    drawUI()
end

function onObjectLeaveContainer(container, object)
    if container ~= self then
        return
    end

    if not containedDeckData then
        return
    end

    self.UI.setXml("")

    replaceDeckLandCards()
    replaceDeckSleeves()
    sortCards()
    playTriggerEffect()

    spawnNewDeck(function()
        containedDeckData = null
        activeTool = null
        drawUI()
        createLabelButton()
    end)

    Wait.condition(function()
        object.destroy()
    end, function()
        return object ~= null
    end)
end

function getToolbarXml()
    local toolbarXml = {}
    for toolId, tool in pairs(tools) do
        local isOn = (toolId == activeTool) and 'isOn="true"' or ''
        table.insert(toolbarXml, string.format([[
                <VerticalLayout spacing="0" childForceExpandHeight="false">
                    <Panel preferredHeight="100">
                        <ToggleButton fontSize="40" fontStyle="Bold" onValueChanged="onSelectTool(%s)" text="%s" %s />
                    </Panel>
                </VerticalLayout>
            ]], toolId, tool.label, isOn))
    end

    return [[
            <Panel offsetXY="770 -25" width="1400" height="150">
                <ToggleGroup allowSwitchOff="true">
                    <HorizontalLayout spacing="25">
                        ]] .. table.concat(toolbarXml, "\n") .. [[
                    </HorizontalLayout>
                </ToggleGroup>
            </Panel>
        ]]
end

function getSummaryXml()
    local summaryXml = {}
    for _, tool in pairs(tools) do
        table.insert(summaryXml, string.format([[
                <VerticalLayout spacing="0" childForceExpandHeight="false" height="130">
                    <Panel preferredHeight="130" color="#FFFFFF66">
                        %s
                    </Panel>
                </VerticalLayout>
            ]], tool.getSummaryXml() or ""))
    end

    return [[
            <Panel offsetXY="770 -130" width="1400" height="130">
                <HorizontalLayout spacing="25">
                    ]] .. table.concat(summaryXml, "\n") .. [[
                </HorizontalLayout>
            </Panel>
        ]]
end

function onSelectTool(player, tool)
    if activeTool == tool then
        activeTool = null
    else
        activeTool = tool
    end

    drawUI()
end

function drawUI()
    local xml = ""

    if containedDeckData then
        xml = xml .. [[
            <Button position="0 0 -52" width="50" height="50" image="https://steamusercontent-a.akamaihd.net/ugc/11685204108261470604/283D709CA895067E844870598EA083AB4E392F71/" onClick="ejectDeck" />
        ]]
        xml = xml .. getToolbarXml()
        if tools[activeTool] then
            if activeTool == "deckSorter" then
                sortCards()
            end

            xml = xml .. tools[activeTool].getToolXml()
        else
            xml = xml .. getSummaryXml()
        end
    end

    self.UI.setXml(xml)
end

function onSelectSortBy(player, sortBy)
    if sortBy == selections.sortBy then
        selections.sortBy = nul
    else
        selections.sortBy = sortBy
    end

    drawUI()
end

function onSleeveClicked(player, sleeveImageUrl)
    if selections.sleeve == sleeveImageUrl then
        selections.sleeve = null
    else
        selections.sleeve = sleeveImageUrl
    end

    self.UI.setAttribute("sleeveInput", "text", "")
    self.UI.setAttribute("sleeve", "image", selections.sleeve or standardSleeve)
    self.UI.setAttribute("sleeve", "onClick", "onSleeveClicked(" .. (selections.sleeve or "") .. ")")
end

function onSleeveInput(player, landImageUri)
    selections.sleeve = landImageUri
    self.UI.setAttribute("sleeve", "image", landImageUri)
end

function onLandClickedPlains(player, landImageUri)
    onLandClicked(player, "plains", landImageUri)
end

function onLandClickedIsland(player, landImageUri)
    onLandClicked(player, "island", landImageUri)
end

function onLandClickedSwamp(player, landImageUri)
    onLandClicked(player, "swamp", landImageUri)
end

function onLandClickedMountain(player, landImageUri)
    onLandClicked(player, "mountain", landImageUri)
end

function onLandClickedForest(player, landImageUri)
    onLandClicked(player, "forest", landImageUri)
end

function onLandClicked(player, landType, landImageUri)
    if landImageUri then
        if selections[landType] == landImageUri then
            selections[landType] = null
            landImageUri = landImages.standard[landType]
        else
            selections[landType] = landImageUri
        end

        self.UI.setAttribute(landType, "image", landUrlPrefix .. "large" .. landImageUri)
        self.UI.setAttribute(landType, "onClick", "onLandClicked" .. landType:gsub("^%l", string.upper) .. "(" .. (selections[landType] or "") .. ")")
    end
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

function sortCards()
    if not selections.sortBy then
        return
    end

    table.sort(containedDeckData.ContainedObjects, function(a, b)
        return compareCards(a, b, selections.sortBy)
    end)
end

function replaceDeckLandCards()
    if not containedDeckData.CustomDeck then
        return
    end

    local function getLandImage(name)
        local landFaces = {
            Plains = selections.plains,
            Island = selections.island,
            Swamp = selections.swamp,
            Mountain = selections.mountain,
            Forest = selections.forest,
        }

        if string.find(name, "Basic Land") then
            for landType, url in pairs(landFaces) do
                if url and string.find(name, landType) then
                    return landUrlPrefix .. "large" .. url
                end
            end
        end
    end

    local function getDeckEntryId(cardId, customDeck)
        local idStr = tostring(cardId)
        for i = #idStr, 1, -1 do
            local key = tonumber(idStr:sub(1, i))
            if customDeck[key] then
                return key
            end
        end
    end

    local function updateCard(card)
        local url = getLandImage(card.Nickname)
        if not url then
            return
        end

        if card.CustomDeck then
            for _, entry in pairs(card.CustomDeck) do
                entry.FaceURL = url
            end
        else
            card.FaceURL = url
        end

        if containedDeckData.ContainedObjects then
            local entryId = getDeckEntryId(card.CardID, containedDeckData.CustomDeck)
            if entryId then
                containedDeckData.CustomDeck[entryId].FaceURL = url
            end
        end
    end

    if containedDeckData.Name == "Card" or containedDeckData.Name == "CardCustom" then
        updateCard(containedDeckData)
    elseif containedDeckData.Name == "Deck" or containedDeckData.Name == "DeckCustom" then
        for _, card in pairs(containedDeckData.ContainedObjects or {}) do
            updateCard(card)
        end
    end
end

function replaceDeckSleeves()
    if not selections.sleeve then
        return
    end

    local function replaceDeckBackURL(data)
        if not data.CustomDeck then
            return
        end

        for _, entry in pairs(data.CustomDeck) do
            entry.BackURL = selections.sleeve
        end
    end

    if containedDeckData.Name == "Card" or containedDeckData.Name == "CardCustom" then
        replaceDeckBackURL(containedDeckData)
    elseif containedDeckData.Name == "Deck" or containedDeckData.Name == "DeckCustom" then
        replaceDeckBackURL(containedDeckData)
        for _, cardData in pairs(containedDeckData.ContainedObjects) do
            replaceDeckBackURL(cardData)
        end
    end
end

function compareCards(a, b, sortBy)
    local fields = {}
    for field in sortBy:gmatch("[^_]+") do
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

function ejectDeck()
    self.takeObject()
end

function createLabelButton()
    self.clearButtons()
    self.createButton({
        click_function = "null",
        function_owner = self,
        label = "ULTIMATE\nMTG Deck\nEnhancer",
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

function playTriggerEffect()
    local effects = self.AssetBundle.getTriggerEffects()
    if effects and #effects > 0 then
        self.AssetBundle.playTriggerEffect(math.random(1, #effects - 1))
    end
end

function spawnNewDeck(callback)
    containedDeckData.DeckIDs = {}
    for _, card in ipairs(containedDeckData.ContainedObjects) do
        table.insert(containedDeckData.DeckIDs, card.CardID)
    end

    local startPos = self.getPosition() + Vector(0, 1, 0)
    local endPos = self.getPosition() + Vector(0, 8, -4)  -- rises from 2 to 8
    local finalRotation = self.getRotation() + Vector(0, 180, 180)
    local spinTime = 2       -- total spin duration
    local rotations = 8      -- number of full 360° rotations
    local steps = 60         -- updates for smooth spin
    local delay = spinTime / steps
    local spinAngle = (360 * rotations) / steps

    spawnObjectData({
        data = containedDeckData,
        position = startPos,
        rotation = self.getRotation() + Vector(0, 180, 180),
        callback_function = function(deck)
            if not deck then
                return
            end

            -- spin and rise animation
            deck.setLock(true)  -- lock deck to prevent falling
            for i = 1, steps do
                Wait.time(function()
                    if not deck then
                        return
                    end

                    -- spin
                    local rot = deck.getRotation()
                    deck.setRotationSmooth(rot + Vector(0, spinAngle, 0), false, true)

                    -- rise smoothly
                    local t = i / steps
                    local pos = Vector(
                            startPos.x,
                            startPos.y + (endPos.y - startPos.y) * t,
                            startPos.z + (endPos.z - startPos.z) * t
                    )
                    deck.setPositionSmooth(pos, false, true)
                end, delay * i)
            end

            -- finalize position and rotation after spinning
            Wait.time(function()
                if deck then
                    deck.setPositionSmooth(endPos, false, true)
                    deck.setRotationSmooth(finalRotation, false, true)
                    deck.setLock(false)  -- unlock after it lands
                    callback()
                end
            end, spinTime)
        end
    })
end
