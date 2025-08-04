local ENABLE_XP = true
local ENABLE_PROCS = true

local SKILL_HERBALISM = 182

local PROC_CHANCES = {
    gather = 15,
    bar = 15,
    ink = 15,
    leather = 15,
}

local gatherXP = {
    [1731]=25, [1732]=50, [1733]=75, [1735]=100, [2040]=125, [324]=150,
    [175404]=175, [181555]=1000, [181556]=1500, [181569]=2000, [181557]=2500,
    [189978]=3000, [189979]=3500, [191133]=4000, [191134]=5000, [191136]=6000,
    [1617]=25, [1618]=25, [1619]=50, [1620]=75, [1621]=100, [1622]=100,
    [1623]=125, [1624]=150, [1628]=150, [1629]=175, [2041]=200, [2042]=225,
    [2043]=250, [2044]=250, [2045]=275, [2866]=275, [142140]=300, [142141]=300,
    [142142]=325, [142143]=325, [142144]=350, [142145]=350, [142146]=375,
    [142147]=375, [142148]=400, [142149]=425, [142150]=450, [181166]=500,
    [181270]=525, [181271]=550, [181275]=575, [181276]=600, [181277]=625,
    [181278]=650, [181279]=675, [181280]=700, [181281]=725, [190169]=750,
    [190170]=775,
    [369]=25, [270]=25, [414]=50, [268]=75, [271]=100, [700]=100,
    [358]=100, [371]=125, [357]=125, [320]=150, [677]=150, [697]=175,
    [698]=175, [701]=200, [699]=200, [2312]=225, [2314]=250, [2310]=275,
    [2315]=300, [2311]=300, [389]=325, [2313]=350, [4652]=375, [4635]=400,
    [4633]=425, [4632]=450, [4634]=500, [4636]=600,
}

local validGatherSpells = {
    [2656]=true, [29354]=true, [29356]=true,
    [2366]=true, [53847]=true, [53848]=true,
    [2575] = true,
}

local gatherProcs = {
    [1731]=2770, [1732]=2771, [1733]=2775, [1735]=2772, [2040]=3858, [324]=10620,
    [175404]=12363, [181555]=23424, [181556]=23425, [181569]=23425, [181557]=23426,
    [189978]=36909, [189979]=36909, [189980]=36912, [195036]=36912, [189981]=36910,
    [1617]=765, [1618]=2447, [1619]=2449, [190169]=36904, [190170]=36907,
}

local miningBars = {
    [2840]="Copper Bar", [3576]="Tin Bar", [2841]="Bronze Bar", [3577]="Gold Bar",
    [2842]="Silver Bar", [3859]="Steel Bar", [3860]="Mithril Bar", [6037]="Truesilver Bar",
    [12359]="Thorium Bar", [12655]="Enchanted Thorium Bar", [11371]="Dark Iron Bar", [12360]="Arcanite Bar", [23445]="Fel Iron Bar",
    [23446]="Adamantite Bar", [23447]="Eternium Bar", [23449]="Khorium Bar", [23448]="Felsteel Bar",
    [36916]="Cobalt Bar", [36913]="Saronite Bar", [36910]="Titanium Bar",
    [37663]="Titansteel Bar",
}

local pigmentInks = {
    [39774]="Midnight Ink", [43116]="Lion's Ink", [43126]="Ink of the Sea",
    [43127]="Snowfall Ink", [43118]="Jadefire Ink", [43117]="Dawnstar Ink",
    [43119]="Royal Ink", [43115]="Hunter's Ink", [43114]="Cerulean Ink",
    [43123]="Ink of the Sky", [39469]="Moonglow Ink", [43120]="Celestial Ink",
    [43121]="Fiery Ink", [43122]="Shimmering Ink", [43125]="Darkflame Ink",
    [43124]="Ethereal Ink", [37101]= "Ivory Ink",
}

local leatherOutputs = {
    [2318]="Light Leather", [2319]="Medium Leather", [4234]="Heavy Leather",
    [4304]="Thick Leather", [8170]="Rugged Leather",
}

local function TryProc(player, itemId, baseChance, source)
    if not ENABLE_PROCS then return end

    local bonus = 0
    if source == "mining" or source == "gathering" then
        local skill = player:GetSkillValue(186)
        bonus = math.floor(skill / 100)
    elseif source == "inscription" then
        local skill = player:GetSkillValue(773)
        bonus = math.floor(skill / 100)
    elseif source == "leatherworking" then
        local skill = player:GetSkillValue(165)
        bonus = math.floor(skill / 100)
    end

    local totalChance = baseChance + bonus

   local color = "|cff1eff00"
if totalChance >= 18 then
    color = "|cffff8000"
elseif totalChance >= 17 then
    color = "|cffa335ee"
elseif totalChance >= 16 then
    color = "|cff0070dd"
end

    if math.random(1, 100) <= totalChance then
        player:AddItem(itemId, 1)
        local link = GetItemLink(itemId) or ("item:" .. itemId)
        player:SendBroadcastMessage(string.format("|cff00ff00[Proc]|r Extra %s from %s! (%s%.0f%%|r chance)", link, source, color, totalChance))
    end
end

local function OnSpellCastFinished(event, player, spell)
    local spellId = spell:GetEntry()

    local target = spell:GetTarget()
    if not target then return end
    if target:GetObjectType() ~= "GameObject" then return end

    local go = target:ToGameObject()
    local entry = go:GetEntry()
    local xp = gatherXP[entry]
    if ENABLE_XP and xp then
    local level = player:GetLevel()
    local bonus = math.floor(xp * (level / 100))
    player:GiveXP(xp + bonus, level)
end

    local itemId = gatherProcs[entry]
    if itemId then
        TryProc(player, itemId, PROC_CHANCES.gather, "gathering")
    end
end

local function OnCreateItem(event, player, itemObj)
    local id = itemObj:GetEntry()
    local name = miningBars[id]
    local source = "mining"
    local chance = PROC_CHANCES.bar

    if not name then
        name = pigmentInks[id]
        if name then
            source = "inscription"
            chance = PROC_CHANCES.ink
        else
            name = leatherOutputs[id]
            if not name then return end
            source = "leatherworking"
            chance = PROC_CHANCES.leather
        end
    end

    TryProc(player, id, chance, source)
end

RegisterPlayerEvent(5, OnSpellCastFinished)
RegisterPlayerEvent(52, OnCreateItem)
