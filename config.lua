Dailies = {
    name = "DailiesChecker"
}
-- colors for the text
Dailies.colors = {
    main = "3189f3",
    args = "f4dd48",
    done_state = "82b893",
    completed_state = "31d9f3",
    missing_state = "d56549",
    partial_state = "f3e131",
    accepted_state = "a375f4",
    category_header = "f3e131",
    alert = "41eb02"
}
-- dailies quest db
Dailies.db = {
    dungeons = {
        name = "Normal Dungeon",
        quests = { 11389, 11371, 11376, 11383, 11364, 11500, 11385, 11387, 11500 },
        max = 1,
        subtype = "dungeons"
    },
    heroics = {
        name = "Heroic Dungeon",
        quests = { 11369, 11384, 11382, 11363, 11362, 11375, 11354, 11386, 11373, 11378, 11374, 11372, 11368, 11388, 11370, 11499 },
        max = 1,
        subtype = "dungeons"
    },
    skettis = {
        name = "Skettis",
        quests = { 11008, 11085 },
        max = -1,
        subtype = "skettis"
    },
    ogrila = {
        name = "Ogri'la",
        quests = { 11080, 11023, 11066, 11051 },
        max = -1,
        subtype = "ogrila"
    },
    netherwing = {
        name = "Netherwing",
        quests = { 11015, 11018, 11017, 11016, 11020, 11035, 11076, 11077, 11055, 11086, 11101, 11097 },
        max = -1,
        subtype = "netherwing"
    },
    sso = {
        name = "Shattered Sun Offensive",
        quests = {
            11875, 11523, 11536, 11525, 11547, 11533, 11537, 11544, 11877, 11514, 11515, 11516, 11880,
            11542, 11539, 11521, 11541, 11546, 11540, 11543
        },
        max = -1,
        subtype = "sso"
    },
    pvpbg = {
        name = "PvP Battlegrounds",
        quests = { 11340, 11337, 11336, 11335, 11342, 11338, 11339, 11341 },
        max = 1,
        subtype = "pvp"
    },
    pvpzone = {
        name = "PvP Zones",
        quests = { 11502, 11503, 11505, 11506, 10106, 10110 },
        max = -1,
        subtype = "pvp"
    },
    cooking = {
        name = "Cooking",
        quests = { 11379, 11381, 11377, 11380 },
        max = 1,
        subtype = "professions"
    },
    fishing = {
        name = "Fishing",
        quests = { 11665, 11667, 11669, 11668, 11666 },
        max = 1,
        subtype = "professions"
    }
}
