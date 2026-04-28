-- ================================================================
-- TibiRepTracker
-- Suivi des reputations de l'extension Midnight (WoW 12.0.5)
-- Renown 1-20 | Code couleur WoW | Deplagable | Quetes hebdo
-- Auteur : Tibizcui - Kirin Tor
-- ================================================================

local ADDON = "TibiRepTracker"

-- ================================================================
-- DONNEES : 4 FACTIONS MIDNIGHT + QUETES
-- ================================================================

-- Systeme Renown : cap 20, 2500 rep par rang
local REP_PER_RANK  = 2500
local RENOWN_CAP    = 20

--[[
  Code couleur Renown (inspire des qualites d'objets WoW) :
    Rangs  1-4   -> Blanc   (Common)     debutant
    Rangs  5-8   -> Vert    (Uncommon)   familier
    Rangs  9-12  -> Bleu    (Rare)       honore
    Rangs 13-16  -> Violet  (Epic)       revere
    Rangs 17-20  -> Orange  (Legendary)  exalte / max
    Paragon      -> Or      bonus Paragon
]]

local FACTIONS = {
  {
    id       = 2710,
    name     = "Cour de Lune-d'Argent",
    zone     = "Eversong Woods",
    icon     = "Interface\\Icons\\Achievement_Zone_EversongWoods",
    qm_name  = "Caerdis Fairdawn",
    qm_coord = "43.4, 47.4",
    qm_zone  = "Saltheril's Haven",
    color    = {r=0.95, g=0.55, b=0.75},
    quests   = {
      { name="Saltheril's Soiree - Haute Estime (Hebdo)",
        npc="Lord Saltheril", coords="43.4, 47.4", zone="Eversong Woods",
        rep=1500, type="weekly", questID=91629, mapID=2395,
        tip="Choisissez votre sous-faction noble pour la semaine." },
      { name="Fortifier les Pierres-Runes : Chevaliers du Sang (Hebdo)",
        npc="Representant des Chevaliers du Sang", coords="43.4, 47.4", zone="Eversong Woods",
        rep=1000, type="weekly", questID=90574, mapID=2395,
        tip="Disponible apres avoir choisi les Chevaliers du Sang." },
      { name="Fortifier les Pierres-Runes : Eclaireurs (Hebdo)",
        npc="Representant des Eclaireurs", coords="43.4, 47.4", zone="Eversong Woods",
        rep=1000, type="weekly", questID=90575, mapID=2395,
        tip="Disponible apres avoir choisi les Eclaireurs." },
      { name="Fortifier les Pierres-Runes : Mages (Hebdo)",
        npc="Representant des Mages", coords="43.4, 47.4", zone="Eversong Woods",
        rep=1000, type="weekly", questID=90573, mapID=2395,
        tip="Disponible apres avoir choisi les Mages." },
      { name="Fortifier les Pierres-Runes : Ombres du Carrefour (Hebdo)",
        npc="Representant des Ombres", coords="43.4, 47.4", zone="Eversong Woods",
        rep=1000, type="weekly", questID=90576, mapID=2395,
        tip="Disponible apres avoir choisi les Ombres du Carrefour." },
      { name="Quete donjon hebdo (Halduron Luminebright)",
        npc="Halduron Luminebright", coords="Silvermoon City", zone="Silvermoon City",
        rep=1500, type="weekly", questID=nil, mapID=nil,
        tip="Terminez un donjon Midnight (difficulte libre, meme Donjon Compagnon)." },
      { name="Campagne de zone Eversong (unique)",
        npc="Jonas Everdawn", coords="Silvermoon City", zone="Silvermoon City",
        rep=5000, type="onetime", questID=nil, mapID=nil,
        tip="Completer la campagne principale d'Eversong Woods." },
      { name="Objets de lore Eversong (unique, 250 rep chacun)",
        npc="Objets interactifs dans la zone", coords="Eversong Woods", zone="Eversong Woods",
        rep=250, type="onetime", questID=nil, mapID=nil,
        tip="Chaque objet de lore collecte donne 250 rep. A faire une seule fois." },
    },
  },
  {
    id       = 2696,
    name     = "Tribu Amani",
    zone     = "Zul'Aman",
    icon     = "Interface\\Icons\\Achievement_Zone_ZulAman",
    qm_name  = "Magovu",
    qm_coord = "45.8, 65.8",
    qm_zone  = "Amani'Zar Village, Zul'Aman",
    color    = {r=0.85, g=0.42, b=0.10},
    quests   = {
      { name="Abondance hebdomadaire (Hebdo)",
        npc="Officier de la Tribu Amani", coords="45.8, 65.8", zone="Zul'Aman",
        rep=1000, type="weekly", questID=89507, mapID=2437,
        tip="Gagnez 20 000 points lors des evenements Abondance dans Zul'Aman." },
      { name="Quete donjon hebdo (Halduron Luminebright)",
        npc="Halduron Luminebright", coords="Silvermoon City", zone="Silvermoon City",
        rep=1500, type="weekly", questID=nil, mapID=nil,
        tip="Terminez un donjon Midnight (difficulte libre, meme Donjon Compagnon)." },
      { name="Campagne de zone Zul'Aman (unique)",
        npc="Chef de la Tribu Amani", coords="45.8, 65.8", zone="Zul'Aman",
        rep=5000, type="onetime", questID=nil, mapID=2437,
        tip="Completer la campagne principale de Zul'Aman. Ne se repete pas." },
      { name="Objets de lore Zul'Aman (unique, 250 rep chacun)",
        npc="Objets interactifs dans la zone", coords="45.8, 65.8", zone="Zul'Aman",
        rep=250, type="onetime", questID=nil, mapID=2437,
        tip="Collectez les objets de lore disperses dans Zul'Aman." },
      { name="Telescopes des Sommets (unique, 100 rep chacun)",
        npc="Pic de Zul'Aman", coords="45.8, 65.8", zone="Zul'Aman",
        rep=100, type="onetime", questID=nil, mapID=2437,
        tip="Placez les telescopes sur les plus hauts pics de la zone." },
      { name="Quetes quotidiennes de zone",
        npc="Officiers Amani", coords="45.8, 65.8", zone="Zul'Aman",
        rep=75, type="daily", questID=nil, mapID=2437,
        tip="Quetes du monde et Missions Speciales dans Zul'Aman." },
    },
  },
  {
    id       = 2704,
    name     = "Hara'ti",
    zone     = "Harandar",
    icon     = "Interface\\Icons\\Achievement_Zone_Harandar",
    qm_name  = "Naynar",
    qm_coord = "51.0, 50.8",
    qm_zone  = "Le Repaire, Harandar",
    color    = {r=0.30, g=0.80, b=0.55},
    quests   = {
      { name="Legendes des Haranir - Legendes Perdues (Hebdo)",
        npc="Zur'ashar Kassameh", coords="54.2, 53.0", zone="Harandar",
        rep=1000, type="weekly", questID=89268, mapID=2413,
        tip="Choisissez une relique Hara'ti et jouez son histoire. Choix Warband-wide." },
      { name="Quete donjon hebdo (Halduron Luminebright)",
        npc="Halduron Luminebright", coords="Silvermoon City", zone="Silvermoon City",
        rep=1500, type="weekly", questID=nil, mapID=nil,
        tip="Terminez un donjon Midnight (difficulte libre, meme Donjon Compagnon)." },
      { name="Campagne de zone Harandar (unique)",
        npc="Conseil Hara'ti", coords="51.0, 50.8", zone="Harandar",
        rep=5000, type="onetime", questID=nil, mapID=2413,
        tip="Completer la campagne principale de Harandar (L'Assemblee du Conseil)." },
      { name="Objets de lore Harandar (unique, 250 rep chacun)",
        npc="Objets interactifs dans la zone", coords="51.0, 50.8", zone="Harandar",
        rep=250, type="onetime", questID=nil, mapID=2413,
        tip="Collectez les objets de lore disperses dans Harandar." },
      { name="Telescopes des Sommets (unique, 100 rep chacun)",
        npc="Pic de Harandar", coords="51.0, 50.8", zone="Harandar",
        rep=100, type="onetime", questID=nil, mapID=2413,
        tip="Placez les telescopes sur les plus hauts pics de Harandar." },
      { name="Quetes quotidiennes de zone",
        npc="Membres Hara'ti", coords="51.0, 50.8", zone="Harandar",
        rep=75, type="daily", questID=nil, mapID=2413,
        tip="Quetes du monde et Missions Speciales dans Harandar." },
    },
  },
  {
    id       = 2699,
    name     = "La Singularite",
    zone     = "Tempete du Vide",
    icon     = "Interface\\Icons\\Achievement_Zone_Voidstorm",
    qm_name  = "Chercheur du Vide Anomander",
    qm_coord = "52.6, 72.8",
    qm_zone  = "Crete Hurlante, Tempete du Vide",
    color    = {r=0.55, g=0.30, b=0.95},
    quests   = {
      { name="Assaut de Stormarion - Tenez Bon ! (Hebdo)",
        npc="Commandant de la Singularite", coords="26.7, 68.2", zone="Tempete du Vide",
        rep=1000, type="weekly", questID=90962, mapID=2405,
        tip="Defendez la Citadelle Stormarion contre l'Hote Devorant. Cycle de 30 min." },
      { name="Quete donjon hebdo (Halduron Luminebright)",
        npc="Halduron Luminebright", coords="Silvermoon City", zone="Silvermoon City",
        rep=1500, type="weekly", questID=nil, mapID=nil,
        tip="Terminez un donjon Midnight (difficulte libre, meme Donjon Compagnon)." },
      { name="Campagne de zone Tempete du Vide (unique)",
        npc="Magister Umbric", coords="52.6, 72.8", zone="Tempete du Vide",
        rep=5000, type="onetime", questID=nil, mapID=2405,
        tip="Completer la campagne principale de Voidstorm." },
      { name="Objets de lore Tempete du Vide (unique, 250 rep chacun)",
        npc="Objets interactifs dans la zone", coords="52.6, 72.8", zone="Tempete du Vide",
        rep=250, type="onetime", questID=nil, mapID=2405,
        tip="Collectez les objets de lore disperses dans Voidstorm." },
      { name="Telescopes des Sommets (unique, 100 rep chacun)",
        npc="Pic de Voidstorm", coords="52.6, 72.8", zone="Tempete du Vide",
        rep=100, type="onetime", questID=nil, mapID=2405,
        tip="Placez les telescopes sur les plus hauts pics de Voidstorm." },
      { name="Quetes quotidiennes de zone",
        npc="Agents de la Singularite", coords="52.6, 72.8", zone="Tempete du Vide",
        rep=75, type="daily", questID=nil, mapID=2405,
        tip="Quetes du monde et Missions Speciales dans Voidstorm." },
    },
  },
}

-- ================================================================
-- VERIFICATION QUETE COMPLETEE
-- ================================================================
local function IsQuestDone(questID)
  if not questID then return false end
  return C_QuestLog.IsQuestFlaggedCompleted(questID)
end
-- ================================================================
-- COULEURS RENOWN (style qualite d'objet WoW)
-- ================================================================
local function GetRenownColor(rank)
  if rank >= 17 then return {r=1.00, g=0.50, b=0.00} end  -- Orange  (Legendaire / Exalte)
  if rank >= 13 then return {r=0.65, g=0.30, b=1.00} end  -- Violet  (Epique)
  if rank >= 9  then return {r=0.30, g=0.60, b=1.00} end  -- Bleu    (Rare)
  if rank >= 5  then return {r=0.30, g=0.85, b=0.30} end  -- Vert    (Peu commun)
  return              {r=1.00, g=1.00, b=1.00}            -- Blanc   (Commun)
end

local function GetRenownLabel(rank)
  if rank >= 20 then return "Exalte" end
  if rank >= 17 then return "Revere" end
  if rank >= 13 then return "Honore" end
  if rank >= 9  then return "Aimable" end
  if rank >= 5  then return "Familier" end
  return "Neutre"
end

local TYPE_COLORS = {
  weekly  = {r=0.30, g=0.60, b=1.00},  -- bleu
  onetime = {r=1.00, g=0.82, b=0.00},  -- jaune/or
  daily   = {r=0.30, g=0.85, b=0.30},  -- vert
}
local TYPE_LABELS = {
  weekly  = "[Hebdo]",
  onetime = "[Unique]",
  daily   = "[Quotidien]",
}

-- ================================================================
-- SAUVEGARDE
-- ================================================================
TibiRepTrackerDB = TibiRepTrackerDB or {
  pos      = {point="CENTER", x=0, y=0},
  open     = false,
  selected = 1,
  renown   = {[2710]=0, [2696]=0, [2704]=0, [2699]=0},
}

-- ================================================================
-- LECTURE RENOWN EN JEU (API 12.x)
-- ================================================================
local function GetRenownData(factionId)
  -- API Midnight / TWW : C_MajorFactions
  if C_MajorFactions and C_MajorFactions.GetMajorFactionData then
    local ok, d = pcall(C_MajorFactions.GetMajorFactionData, factionId)
    if ok and d then
      local rank    = d.renownLevel            or 0
      local cur     = d.renownReputationEarned or 0
      local paragon = d.isDataComplete and (rank >= RENOWN_CAP)
      return {
        rank    = rank,
        cur     = cur,
        max     = REP_PER_RANK,
        pct     = math.min(1.0, cur / REP_PER_RANK),
        paragon = paragon,
        found   = true,
      }
    end
  end
  -- Fallback : donnees sauvegardees
  local saved = TibiRepTrackerDB.renown[factionId] or 0
  local rank  = math.floor(saved / REP_PER_RANK)
  local cur   = saved % REP_PER_RANK
  return {
    rank    = math.min(rank, RENOWN_CAP),
    cur     = cur,
    max     = REP_PER_RANK,
    pct     = (cur / REP_PER_RANK),
    paragon = (rank >= RENOWN_CAP),
    found   = false,
  }
end

-- ================================================================
-- CONSTRUCTION DE L'INTERFACE
-- ================================================================
local mainFrame

local function BuildUI()

  -- Fenetre principale
  mainFrame = CreateFrame("Frame", "TRTMainFrame", UIParent, "BackdropTemplate")
  mainFrame:SetSize(460, 200)

  -- Touche ECHAP pour fermer
  mainFrame:SetScript("OnKeyDown", function(self, key)
    if key == "ESCAPE" then
      self:Hide()
      TibiRepTrackerDB.open = false
    end
  end)
  mainFrame:EnableKeyboard(true)
  mainFrame:SetPropagateKeyboardInput(true)
  mainFrame:SetFrameStrata("HIGH")
  mainFrame:SetMovable(true)
  mainFrame:EnableMouse(true)
  mainFrame:RegisterForDrag("LeftButton")
  mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
  mainFrame:SetScript("OnDragStop", function(s)
    s:StopMovingOrSizing()
    local point, _, _, x, y = s:GetPoint()
    TibiRepTrackerDB.pos = {point=point, x=x, y=y}
  end)

  mainFrame:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile=true, tileSize=32, edgeSize=32,
    insets={left=11, right=12, top=12, bottom=11},
  })
  mainFrame:SetBackdropColor(0.04, 0.02, 0.06, 0.97)
  mainFrame:SetBackdropBorderColor(0.72, 0.60, 0.28, 1.0)

  -- Titre (cadre avec meme bordure que la fenetre principale)
  local titleBg = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
  titleBg:SetPoint("TOP", mainFrame, "TOP", 0, 14)
  titleBg:SetSize(380, 44)
  titleBg:SetFrameLevel(mainFrame:GetFrameLevel() + 2)
  titleBg:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile=true, tileSize=32, edgeSize=20,
    insets={left=7, right=7, top=7, bottom=7},
  })
  titleBg:SetBackdropColor(0.04, 0.02, 0.06, 0.97)
  titleBg:SetBackdropBorderColor(0.72, 0.60, 0.28, 1.0)

  -- Logo gauche (enfant de titleBg pour etre au-dessus)
  local logoLeft = titleBg:CreateTexture(nil, "OVERLAY")
  logoLeft:SetSize(26, 26)
  logoLeft:SetTexture("Interface\\AddOns\\TibiRepTracker\\medias\\Tibi-repTracker")

  -- Logo droite
  local logoRight = titleBg:CreateTexture(nil, "OVERLAY")
  logoRight:SetSize(26, 26)
  logoRight:SetTexture("Interface\\AddOns\\TibiRepTracker\\medias\\Tibi-repTracker")

  -- Texte du titre (enfant de titleBg)
  local titleStr = titleBg:CreateFontString(nil, "OVERLAY")
  titleStr:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
  titleStr:SetPoint("CENTER", titleBg, "CENTER", 0, 5)
  titleStr:SetText("|cFFFFD700Reputations - |r|cFF9480FFMidnight|r")

  -- Logos ancres sur le texte
  logoLeft:SetPoint("RIGHT", titleStr, "LEFT", -6, 0)
  logoRight:SetPoint("LEFT", titleStr, "RIGHT", 6, 0)

  -- Sous-titre auteur (enfant de titleBg)
  local byLine = titleBg:CreateFontString(nil, "OVERLAY")
  byLine:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
  byLine:SetPoint("TOP", titleStr, "BOTTOM", 0, 0)
  byLine:SetText("|cFF9480FFBy Tibizcui|r")

  -- Bouton fermer
  local closeBtn = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
  closeBtn:SetPoint("TOPRIGHT", -5, -5)
  closeBtn:SetScript("OnClick", function()
    mainFrame:Hide()
    TibiRepTrackerDB.open = false
  end)

  -- Sous-titre
  local drag = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  drag:SetPoint("TOP", 0, -30)
  drag:SetText("|cFF888888Glisser pour deplacer|r")

  -- Separateur
  local sep = mainFrame:CreateTexture(nil, "ARTWORK")
  sep:SetTexture("Interface\\Common\\UI-TooltipDivider-Transparent")
  sep:SetPoint("TOPLEFT", 15, -45)
  sep:SetSize(430, 14)

  -- ================================================================
  -- SELECTEUR DE FACTION (4 boutons)
  -- ================================================================
  local tabY   = -60
  local tabW   = 104
  local tabH   = 36
  local tabGap = 4

  mainFrame.factionBtns = {}
  for i, fac in ipairs(FACTIONS) do
    local tx = 12 + (i-1) * (tabW + tabGap)
    local btn = CreateFrame("Button", nil, mainFrame, "BackdropTemplate")
    btn:SetSize(tabW, tabH)
    btn:SetPoint("TOPLEFT", tx, tabY)
    btn:SetBackdrop({
      bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile=true, tileSize=8, edgeSize=8,
      insets={left=3, right=3, top=3, bottom=3},
    })
    btn:SetBackdropColor(fac.color.r*0.15, fac.color.g*0.15, fac.color.b*0.15, 0.95)
    btn:SetBackdropBorderColor(fac.color.r*0.5, fac.color.g*0.5, fac.color.b*0.5, 0.8)

    local btnTxt = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btnTxt:SetPoint("CENTER", 0, 0)
    btnTxt:SetSize(tabW - 8, tabH)
    btnTxt:SetText(fac.name)
    btnTxt:SetTextColor(fac.color.r, fac.color.g, fac.color.b)
    btnTxt:SetWordWrap(true)
    btnTxt:SetJustifyH("CENTER")

    btn:SetScript("OnClick", function()
      TibiRepTrackerDB.selected = i
      mainFrame:RefreshContent()
    end)
    btn:SetScript("OnEnter", function(s)
      s:SetBackdropBorderColor(fac.color.r, fac.color.g, fac.color.b, 1.0)
      GameTooltip:SetOwner(s, "ANCHOR_BOTTOM")
      GameTooltip:AddLine(fac.name, fac.color.r, fac.color.g, fac.color.b)
      GameTooltip:AddLine("Zone : "..fac.zone, 0.8, 0.8, 0.8)
      GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function(s)
      GameTooltip:Hide()
      if TibiRepTrackerDB.selected ~= i then
        s:SetBackdropBorderColor(fac.color.r*0.5, fac.color.g*0.5, fac.color.b*0.5, 0.8)
      end
    end)

    btn.fac = fac
    btn.idx = i
    mainFrame.factionBtns[i] = btn
  end

  -- Separateur sous les onglets
  local sep2 = mainFrame:CreateTexture(nil, "ARTWORK")
  sep2:SetTexture("Interface\\Common\\UI-TooltipDivider-Transparent")
  sep2:SetPoint("TOPLEFT", 15, tabY - tabH - 2)
  sep2:SetSize(430, 14)

  -- ================================================================
  -- BARRE DE RENOWN
  -- ================================================================
  local barY = tabY - tabH - 18

  local barBg = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
  barBg:SetPoint("TOPLEFT", 14, barY)
  barBg:SetSize(432, 26)
  barBg:SetBackdrop({
    bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile=true, tileSize=8, edgeSize=6,
    insets={left=2, right=2, top=2, bottom=2},
  })
  barBg:SetBackdropColor(0, 0, 0, 0.75)
  barBg:SetBackdropBorderColor(0.5, 0.45, 0.25, 0.8)

  mainFrame.barFill = barBg:CreateTexture(nil, "ARTWORK")
  mainFrame.barFill:SetPoint("TOPLEFT", barBg, "TOPLEFT", 3, -3)
  mainFrame.barFill:SetHeight(20)
  mainFrame.barFill:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")

  mainFrame.barText = barBg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  mainFrame.barText:SetPoint("CENTER", barBg, "CENTER")

  -- ================================================================
  -- ZONE INFO FACTION (PNJ Quartier-Maitre)
  -- ================================================================
  local infoY = barY - 34

  mainFrame.infoLine1 = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  mainFrame.infoLine1:SetPoint("TOPLEFT", 16, infoY)
  mainFrame.infoLine1:SetSize(430, 16)
  mainFrame.infoLine1:SetJustifyH("LEFT")

  mainFrame.infoLine2 = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  mainFrame.infoLine2:SetPoint("TOPLEFT", 16, infoY - 18)
  mainFrame.infoLine2:SetSize(430, 16)
  mainFrame.infoLine2:SetJustifyH("LEFT")

  -- Separateur
  local sep3 = mainFrame:CreateTexture(nil, "ARTWORK")
  sep3:SetTexture("Interface\\Common\\UI-TooltipDivider-Transparent")
  sep3:SetPoint("TOPLEFT", 15, infoY - 38)
  sep3:SetSize(430, 14)

  -- ================================================================
  -- PANNEAU QUETES (avec scroll)
  -- ================================================================
  local questY = infoY - 52

  -- Titre quetes
  local questHeader = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  questHeader:SetPoint("TOPLEFT", 16, questY)
  questHeader:SetText("|cFFFFD700Quetes disponibles|r")

  -- Legende
  local legend = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  legend:SetPoint("TOPLEFT", 16, questY - 18)
  legend:SetText(
    "|cFF4D99FF[Hebdo]|r  " ..
    "|cFFFFCC00[Unique]|r  " ..
    "|cFF4DCC4D[Quotidien]|r"
  )

  -- ScrollFrame
  local scrollBg = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
  scrollBg:SetPoint("TOPLEFT", 12, questY - 38)
  scrollBg:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -12, 22)
  scrollBg:SetBackdrop({
    bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile=true, tileSize=8, edgeSize=8,
    insets={left=3, right=3, top=3, bottom=3},
  })
  scrollBg:SetBackdropColor(0.02, 0.01, 0.04, 0.88)
  scrollBg:SetBackdropBorderColor(0.5, 0.45, 0.25, 0.6)

  local scroll = CreateFrame("ScrollFrame", "TRTQuestScroll", scrollBg, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", scrollBg, "TOPLEFT", 5, -5)
  scroll:SetPoint("BOTTOMRIGHT", scrollBg, "BOTTOMRIGHT", -22, 5)

  mainFrame.questContent = CreateFrame("Frame", nil, scroll)
  mainFrame.questContent:SetSize(400, 800)
  scroll:SetScrollChild(mainFrame.questContent)

  -- ================================================================
  -- FONCTION DE RAFRAICHISSEMENT
  -- ================================================================
  function mainFrame:RefreshContent()
    local sel = TibiRepTrackerDB.selected or 1
    local fac = FACTIONS[sel]
    if not fac then return end

    -- Highlight onglet actif
    for i, btn in ipairs(self.factionBtns) do
      local f = FACTIONS[i]
      if i == sel then
        btn:SetBackdropColor(f.color.r*0.35, f.color.g*0.35, f.color.b*0.35, 1.0)
        btn:SetBackdropBorderColor(f.color.r, f.color.g, f.color.b, 1.0)
      else
        btn:SetBackdropColor(f.color.r*0.12, f.color.g*0.12, f.color.b*0.12, 0.95)
        btn:SetBackdropBorderColor(f.color.r*0.4, f.color.g*0.4, f.color.b*0.4, 0.7)
      end
    end

    -- Donnees renown
    local rd  = GetRenownData(fac.id)
    local col = GetRenownColor(rd.rank)
    local lbl = GetRenownLabel(rd.rank)

    -- Mise a jour de la barre
    local fillW = math.max(3, math.floor(426 * rd.pct))
    self.barFill:SetWidth(fillW)
    self.barFill:SetVertexColor(col.r, col.g, col.b, 1.0)

    if rd.paragon then
      self.barText:SetText(string.format(
        "|cFF%02X%02X%02XRenown %d - %s - PARAGON|r",
        col.r*255, col.g*255, col.b*255, rd.rank, lbl))
    else
      self.barText:SetText(string.format(
        "|cFF%02X%02X%02XRenown %d / %d - %s - %d / %d rep|r",
        col.r*255, col.g*255, col.b*255,
        rd.rank, RENOWN_CAP, lbl,
        rd.cur, rd.max))
    end

    -- Infos Quartier-Maitre
    self.infoLine1:SetText(
      "|cFF888888Zone :|r |cFFFFCC44"..fac.zone..
      "|r   |cFF888888Quartier-Maitre :|r |cFFCCBB88"..fac.qm_name.."|r")
    self.infoLine2:SetText(
      "|cFF888888Localisation :|r |cFF99CCFF"..fac.qm_zone..
      "  ("..fac.qm_coord..")|r")

     -- Nettoyer les quetes precedentes
    for _, c in pairs({self.questContent:GetChildren()}) do c:Hide() end
    for _, r in pairs({self.questContent:GetRegions()}) do r:Hide() end

    -- Init etat ouvert/ferme des sections si besoin
    if not TibiRepTrackerDB.sections then
      TibiRepTrackerDB.sections = {weekly=false, onetime=false, daily=false}
    end

    -- Regrouper les quetes par type
    local groups = {
      {key="weekly",  label="Quetes Hebdomadaires", quests={}},
      {key="onetime", label="Quetes Uniques",        quests={}},
      {key="daily",   label="Quetes Quotidiennes",   quests={}},
    }
    for _, quest in ipairs(fac.quests) do
      for _, g in ipairs(groups) do
        if quest.type == g.key then
          table.insert(g.quests, quest)
        end
      end
    end

    -- Construction des sections deroulantes
    local y = 0

    local function BuildQuestRow(parent, quest, yOff, faction)
      local tc      = TYPE_COLORS[quest.type] or {r=1, g=1, b=1}
      local tlbl    = TYPE_LABELS[quest.type] or ""
      local done    = IsQuestDone(quest.questID)
      local nameCol = done and "|cFF888888" or "|cFFEEEEEE"

      local row = CreateFrame("Button", nil, parent, "BackdropTemplate")
      row:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -yOff)
      row:SetSize(391, 54)
      row:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=8, edgeSize=6,
        insets={left=2, right=2, top=2, bottom=2},
      })
      row:SetBackdropColor(tc.r*0.06, tc.g*0.06, tc.b*0.06, done and 0.4 or 0.85)
      row:SetBackdropBorderColor(tc.r*0.4, tc.g*0.4, tc.b*0.4, done and 0.3 or 0.7)

      local stripe = row:CreateTexture(nil, "ARTWORK")
      stripe:SetPoint("TOPLEFT", row, "TOPLEFT", 2, -2)
      stripe:SetSize(4, 50)
      stripe:SetTexture("Interface\\BUTTONS\\WHITE8X8")
      if done then
        stripe:SetVertexColor(0.35, 0.35, 0.35, 0.5)
      else
        stripe:SetVertexColor(tc.r, tc.g, tc.b, 0.9)
      end

      local statusTxt = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
      statusTxt:SetPoint("TOPRIGHT", row, "TOPRIGHT", -5, -5)
      if done then
        statusTxt:SetText("|cFF44FF44[Fait]|r")
      else
        statusTxt:SetText(string.format("|cFF%02X%02X%02X%s|r",
          tc.r*255, tc.g*255, tc.b*255, tlbl))
      end

      local qName = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
      qName:SetPoint("TOPLEFT", row, "TOPLEFT", 12, -5)
      qName:SetSize(370, 16)
      qName:SetJustifyH("LEFT")
      qName:SetText(nameCol..quest.name.."|r")
      qName:SetWordWrap(false)

      local npcStr = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      npcStr:SetPoint("TOPLEFT", row, "TOPLEFT", 12, -22)
      npcStr:SetSize(370, 14)
      npcStr:SetJustifyH("LEFT")
      if done then
        npcStr:SetText("|cFF555555PNJ : "..quest.npc.."  Coord. de zone : "..quest.coords.."|r")
      else
        npcStr:SetText(
          "|cFF888888PNJ :|r |cFFCCBB88"..quest.npc..
          "|r  |cFF888888Coord. de zone :|r |cFF99CCFF"..quest.coords.."|r")
      end

      local repStr = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      repStr:SetPoint("TOPLEFT", row, "TOPLEFT", 12, -36)
      repStr:SetSize(370, 14)
      repStr:SetJustifyH("LEFT")
      if done then
        repStr:SetText("|cFF555555Rep : +"..quest.rep.."  "..quest.tip.."|r")
      else
        repStr:SetText(
          "|cFF888888Rep :|r |cFF"..
          string.format("%02X%02X%02X", col.r*255, col.g*255, col.b*255)..
          "+"..quest.rep..
          "|r  |cFF666666"..quest.tip.."|r")
      end

      row:EnableMouse(true)
      row:SetScript("OnClick", function()
        -- Suivi reputation barre d'etat 1
        if faction and faction.id and GetNumFactions then
          for i = 1, GetNumFactions() do
            local _, _, _, _, _, _, _, _, _, _, _, _, _, fid = GetFactionInfo(i)
            if fid == faction.id then
              SetWatchedFactionIndex(i)
              break
            end
          end
        end
        -- TomTom waypoint
        if quest.coords and quest.coords ~= "" and TomTom then
          local x, y = quest.coords:match("([%d%.]+),%s*([%d%.]+)")
          if x and y then
            local mapID = quest.mapID or C_Map.GetBestMapForUnit("player")
            TomTom:AddWaypoint(mapID, tonumber(x)/100, tonumber(y)/100, {
              title = quest.name,
              persistent = false,
              minimap = true,
              world = true,
            })
            print("|cFF4D99FFTibiRepTracker|r Waypoint ajoute : "..quest.name.." ("..quest.coords..")")
          else
            print("|cFF4D99FFTibiRepTracker|r Coordonnees non disponibles pour cette quete.")
          end
        elseif not TomTom then
          print("|cFFFF4444TibiRepTracker|r TomTom n'est pas installe ou active.")
        end
      end)
      row:SetScript("OnEnter", function(s)
        GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
        GameTooltip:AddLine(quest.name, tc.r, tc.g, tc.b)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Type : "..tlbl, tc.r, tc.g, tc.b)
        GameTooltip:AddLine("PNJ : "..quest.npc, 0.9, 0.9, 0.7)
        GameTooltip:AddLine("Localisation : "..quest.zone, 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Coordonnees : "..quest.coords, 0.7, 0.9, 1.0)
        GameTooltip:AddLine("Reputation : +"..quest.rep, col.r, col.g, col.b)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(quest.tip, 0.75, 0.75, 0.75, true)
        GameTooltip:Show()
      end)
      row:SetScript("OnLeave", function() GameTooltip:Hide() end)

      return row
    end

    for _, group in ipairs(groups) do
      if #group.quests > 0 then
        local tc      = TYPE_COLORS[group.key]  or {r=1, g=1, b=1}
        local isOpen  = TibiRepTrackerDB.sections[group.key]
        local count   = #group.quests

        -- En-tete cliquable
        local header = CreateFrame("Button", nil, self.questContent, "BackdropTemplate")
        header:SetPoint("TOPLEFT", self.questContent, "TOPLEFT", 2, -y)
        header:SetSize(391, 26)
        header:SetBackdrop({
          bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
          edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
          tile=true, tileSize=8, edgeSize=6,
          insets={left=2, right=2, top=2, bottom=2},
        })
        header:SetBackdropColor(tc.r*0.18, tc.g*0.18, tc.b*0.18, 0.95)
        header:SetBackdropBorderColor(tc.r*0.8, tc.g*0.8, tc.b*0.8, 0.9)

        -- Fleche d'etat
        local arrow = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        arrow:SetPoint("LEFT", header, "LEFT", 8, 0)
        arrow:SetText(isOpen and "|cFFFFFFFF[-]|r" or "|cFFFFFFFF[+]|r")

        -- Titre du groupe
        local hTitle = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hTitle:SetPoint("LEFT", header, "LEFT", 28, 0)
        hTitle:SetText(string.format("|cFF%02X%02X%02X%s|r",
          tc.r*255, tc.g*255, tc.b*255, group.label))

        -- Compteur de quetes
        local hCount = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hCount:SetPoint("RIGHT", header, "RIGHT", -8, 0)
        hCount:SetText("|cFFAAAAAA"..count.." quete"..(count>1 and "s" or "").."|r")

        y = y + 30

        -- Quetes de ce groupe (visibles seulement si ouvert)
        local questRows = {}
        for _, quest in ipairs(group.quests) do
          local row = BuildQuestRow(self.questContent, quest, y, fac)
          if not isOpen then row:Hide() end
          table.insert(questRows, row)
          y = y + 58
        end

        -- Espace si ferme
        if not isOpen then
          y = y - (#group.quests * 58)
        end

        -- Clic sur l'en-tete : ouvrir / fermer
        header:SetScript("OnClick", function()
          local nowOpen = not TibiRepTrackerDB.sections[group.key]
          TibiRepTrackerDB.sections[group.key] = nowOpen
          -- Rafraichir entierement
          mainFrame:RefreshContent()
        end)

        header:SetScript("OnEnter", function(s)
          s:SetBackdropColor(tc.r*0.30, tc.g*0.30, tc.b*0.30, 1.0)
        end)
        header:SetScript("OnLeave", function(s)
          s:SetBackdropColor(tc.r*0.18, tc.g*0.18, tc.b*0.18, 0.95)
        end)

        y = y + 4
      end
    end

self.questContent:SetHeight(y + 10)

    -- Calcul hauteur dynamique de la fenetre
    -- 200 = hauteur fixe du haut (titre + onglets + barre + infos + legende)
    local contentHeight = y + 10
    local topFixed = 270
    local totalH = topFixed + contentHeight + 30
    totalH = math.max(320, math.min(totalH, 900))
    mainFrame:SetSize(mainFrame:GetWidth(), totalH)

    -- scrollBg suit mainFrame automatiquement via ancrage BOTTOMRIGHT
    mainFrame.questContent:SetHeight(math.max(300, contentHeight))
  end

  -- ================================================================
  -- POIGNEE DE REDIMENSIONNEMENT (coin bas droite)
  -- ================================================================
  mainFrame:SetResizable(true)
  mainFrame:SetResizeBounds(380, 300, 900, 1000)

  local resizeBtn = CreateFrame("Button", nil, mainFrame)
  resizeBtn:SetSize(16, 16)
  resizeBtn:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -4, 4)
  resizeBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  resizeBtn:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  resizeBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
  resizeBtn:SetScript("OnMouseDown", function()
    mainFrame:StartSizing("BOTTOMRIGHT")
  end)
  resizeBtn:SetScript("OnMouseUp", function()
    mainFrame:StopMovingOrSizing()
    TibiRepTrackerDB.width  = mainFrame:GetWidth()
    TibiRepTrackerDB.height = mainFrame:GetHeight()
  end)

  mainFrame:Hide()
end

-- ================================================================
-- BOUTON MINIMAP
-- ================================================================
local minimapBtn

local function BuildMinimapButton()
  minimapBtn = CreateFrame("Button", "TRTMinimapBtn", Minimap)
  minimapBtn:SetSize(32, 32)
  minimapBtn:SetFrameStrata("MEDIUM")
  minimapBtn:SetFrameLevel(8)
  minimapBtn:SetMovable(true)
  minimapBtn:EnableMouse(true)
  minimapBtn:SetClampedToScreen(true)
  minimapBtn:SetToplevel(true)


  -- Icone (remplit tout le bouton)
  local icon = minimapBtn:CreateTexture(nil, "ARTWORK")
  icon:SetPoint("CENTER", minimapBtn, "CENTER", 0, 0)
  icon:SetSize(30, 30)
  icon:SetTexture("Interface\\AddOns\\TibiRepTracker\\medias\\Tibi-repTracker")

  -- Ring dore WoW par-dessus
  local ring = minimapBtn:CreateTexture(nil, "OVERLAY")
  ring:SetPoint("CENTER", minimapBtn, "CENTER", 8, -8)
  ring:SetSize(56, 56)
  ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

  -- Highlight survol
  local hl = minimapBtn:CreateTexture(nil, "HIGHLIGHT")
  hl:SetPoint("CENTER", minimapBtn, "CENTER", 0, 0)
  hl:SetSize(36, 36)
  hl:SetAlpha(0.3)
  hl:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  -- Position autour de la minimap
  local mmAngle = (TibiRepTrackerDB and TibiRepTrackerDB.mmAngle) or 220

  local function SetMMPos(angle)
    mmAngle = angle
    if TibiRepTrackerDB then TibiRepTrackerDB.mmAngle = angle end
    local r = 105
    minimapBtn:ClearAllPoints()
minimapBtn:SetPoint("CENTER", Minimap, "CENTER",
  math.cos(math.rad(angle)) * r,
  math.sin(math.rad(angle)) * r)
  end

  SetMMPos(mmAngle)

  -- Repositionne si la minimap bouge (resize UI etc.)
  minimapBtn:SetScript("OnShow", function()
    SetMMPos(mmAngle)
  end)

  -- Drag autour de la minimap
  minimapBtn:RegisterForDrag("LeftButton")
  minimapBtn:SetScript("OnDragStart", function(s)
    s:SetScript("OnUpdate", function()
      local mx, my = Minimap:GetCenter()
      local scale  = UIParent:GetEffectiveScale()
      local cx, cy = GetCursorPosition()
      SetMMPos(math.deg(math.atan2(cy/scale - my, cx/scale - mx)))
    end)
  end)
  minimapBtn:SetScript("OnDragStop", function(s)
    s:SetScript("OnUpdate", nil)
  end)

  minimapBtn:SetScript("OnClick", function()
    if mainFrame:IsShown() then
      mainFrame:Hide()
      TibiRepTrackerDB.open = false
    else
      mainFrame:Show()
      mainFrame:RefreshContent()
      TibiRepTrackerDB.open = true
    end
  end)

  minimapBtn:SetScript("OnEnter", function(s)
    GameTooltip:SetOwner(s, "ANCHOR_LEFT")
    GameTooltip:AddLine("TibiRepTracker", 0.45, 0.70, 1.0)
    GameTooltip:AddLine("Reputations Midnight", 0.9, 0.9, 0.9)
    GameTooltip:AddLine("Clic : ouvrir / fermer", 0.7, 0.7, 0.7)
    GameTooltip:AddLine("Glisser : deplacer l'icone", 0.7, 0.7, 0.7)
    GameTooltip:Show()
  end)
  minimapBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- ================================================================
-- COMMANDES SLASH
-- ================================================================
SLASH_TIBIREPTRACKER1 = "/trt"
SLASH_TIBIREPTRACKER2 = "/tibirep"
SlashCmdList["TIBIREPTRACKER"] = function()
  if mainFrame:IsShown() then
    mainFrame:Hide()
    TibiRepTrackerDB.open = false
  else
    mainFrame:Show()
    mainFrame:RefreshContent()
    TibiRepTrackerDB.open = true
  end
end

-- ================================================================
-- EVENEMENTS
-- ================================================================
local evFrame = CreateFrame("Frame")
evFrame:RegisterEvent("ADDON_LOADED")
evFrame:RegisterEvent("PLAYER_LOGIN")
evFrame:RegisterEvent("MAJOR_FACTION_RENOWN_LEVEL_CHANGED")
evFrame:RegisterEvent("UPDATE_FACTION")
evFrame:RegisterEvent("QUEST_TURNED_IN")
evFrame:RegisterEvent("QUEST_LOG_UPDATE")

evFrame:SetScript("OnEvent", function(_, event, arg1)

  if event == "ADDON_LOADED" and arg1 == ADDON then

    BuildUI()
    BuildMinimapButton()

    -- Restaurer position fenetre
    local p = TibiRepTrackerDB.pos
    if p and p.x then
      mainFrame:ClearAllPoints()
      mainFrame:SetPoint(p.point or "CENTER", UIParent, p.point or "CENTER", p.x, p.y)
    else
      mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end

    -- Restaurer taille si redimensionnee manuellement
    if TibiRepTrackerDB.width and TibiRepTrackerDB.height then
      mainFrame:SetSize(TibiRepTrackerDB.width, TibiRepTrackerDB.height)
    end

    if TibiRepTrackerDB.open then
      mainFrame:Show()
      mainFrame:RefreshContent()
    end

  elseif event == "PLAYER_LOGIN" then
    print("|cFF4D99FFTibiRepTracker|r charge -- tapez |cFFFFD700/trt|r pour ouvrir.")

  elseif event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" or event == "UPDATE_FACTION"
      or event == "QUEST_TURNED_IN" or event == "QUEST_LOG_UPDATE" then
    if mainFrame and mainFrame:IsShown() then
      mainFrame:RefreshContent()
    end
  end

end)
