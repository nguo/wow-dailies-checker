--[[
SETUP
--]]
local addon = Dailies
local DONE_LIST_TYPE = "done"
local DONE_AND_QUEST_LOG_LIST_TYPE = "doneactive"
local QUEST_LOG_LIST_TYPE = "active"
local MISSING_LIST_TYPE = "missing"
local ALL_LIST_TYPE = "all"
local QUEST_STATES = {
  done = { shorthand = "(t)", descriptor = "turned-in", color = addon.colors.done_state },
  accepted = { shorthand = "(a)", descriptor = "accepted", color = addon.colors.accepted_state },
  completed = { shorthand = "(c)", descriptor = "completed", color = addon.colors.completed_state },
  missing = { shorthand = "(m)", descriptor = "missing", color = addon.colors.missing_state }
}

--[[
MAIN
--]]
local function colorize(str, color)
  return "|cff"..color..str.."|r"
end

local function contains(list, value)
  for _,v in pairs(list) do
    if v == value then
      return true
    end
  end
end

-- given a list of quest ids, categorizes them into different quest completion states 
local function categorizeQuests(allQids)
  local qidsDone = {}
  local qidsCompleted = {}
  local qidsAccepted = {}
  local qidsMissing = {}
  for _,qid in pairs(allQids) do
    if C_QuestLog.IsQuestFlaggedCompleted(qid) then
      table.insert(qidsDone, qid)
    elseif IsQuestComplete(qid) then
      table.insert(qidsCompleted, qid)
    elseif C_QuestLog.IsOnQuest(qid) then
      table.insert(qidsAccepted, qid)
    else
      table.insert(qidsMissing, qid)
    end
  end
  return qidsDone, qidsCompleted, qidsAccepted, qidsMissing
end

-- turns a list type into options for which quest completion states we're interested in
local function getStateChecks(listType)
  local checkDone = false
  local checkCompleted = false
  local checkAccepted = false
  local checkMissing = false
  if listType == DONE_LIST_TYPE or listType == DONE_AND_QUEST_LOG_LIST_TYPE or listType == ALL_LIST_TYPE then
    checkDone = true
  end
  if listType == DONE_LIST_TYPE then
    checkCompleted = true
  end
  if listType == DONE_AND_QUEST_LOG_LIST_TYPE or listType == QUEST_LOG_LIST_TYPE or listType == ALL_LIST_TYPE then
    checkCompleted = true
    checkAccepted = true
  end
  if listType == ALL_LIST_TYPE or listType == MISSING_LIST_TYPE then
    checkMissing = true
  end
  return checkDone, checkCompleted, checkAccepted, checkMissing
end

local function printQuestLine(questName, state)
  print("    "..colorize(questName.." "..QUEST_STATES[state].shorthand, QUEST_STATES[state].color))
end

local function printQuestsForState(questIds, state)
  for _,qid in pairs(questIds) do
    local name = C_QuestLog.GetQuestInfo(qid)
    if not name then
      print("[warn] missing quest "..qid)
    else
      printQuestLine(C_QuestLog.GetQuestInfo(qid), state)
    end
  end
end

-- prints out the status of the dailies
local function printStatus(listType, categorySubtype)
  local beginMsg = "Today's progress for "
  if listType == DONE_LIST_TYPE then
    beginMsg = beginMsg.."turned-in / quest log completed"
  elseif listType == DONE_AND_QUEST_LOG_LIST_TYPE then
    beginMsg = beginMsg.."turned-in / quest log completed / quest log accepted"
  elseif listType == QUEST_LOG_LIST_TYPE then
    beginMsg = beginMsg.."quest log completed / quest log accepted"
  elseif listType == MISSING_LIST_TYPE then
    beginMsg = beginMsg.."missing"
  elseif listType == ALL_LIST_TYPE then
    beginMsg = beginMsg.."turned-in / quest log completed / quest log accepted / missing"
  end
  print(colorize(addon.name..": "..beginMsg, addon.colors.main))
  if categorySubtype then
    print(colorize("Showing for category: ["..colorize(categorySubtype, "ffffff").."]", addon.colors.main))
  end

  local totalDone = 0
  local totalCompleted = 0
  local checkDone, checkCompleted, checkAccepted, checkMissing = getStateChecks(listType)

  -- go through each category's quests
  for category,categoryData in pairs(addon.db) do
    local numQuestsInCategory = #categoryData.quests
    if numQuestsInCategory > 0 and (not categorySubtype or categoryData.subtype == categorySubtype) then
      local qidsDone, qidsCompleted, qidsAccepted, qidsMissing = categorizeQuests(categoryData.quests)
      local numDone = #qidsDone
      totalCompleted = totalCompleted + #qidsCompleted
      local hasAnyAccepted = #qidsAccepted > 0
      local hasAnyCompleted = #qidsCompleted > 0
      if (numDone > 0 and checkDone) or (checkCompleted and hasAnyCompleted) or (checkAccepted and hasAnyAccepted) or checkMissing then
        print(""..colorize(categoryData.name, addon.colors.category_header))
        if categoryData.max == 1 then
          -- if there's only one quest completable in the category,
          -- just print generic name because we don't figure out which one was actually turned in/missing
          if numDone > 1 then
            totalDone = totalDone + 1
          end
          if checkDone and numDone > 1 then
            printQuestLine("Rotating Daily", "done")
          elseif checkCompleted and hasAnyCompleted then
            printQuestLine(C_QuestLog.GetQuestInfo(qidsCompleted[1]), "completed")
          elseif checkAccepted and hasAnyAccepted then
            printQuestLine(C_QuestLog.GetQuestInfo(qidsAccepted[1]), "accepted")
          elseif checkMissing then
            printQuestLine("Rotating Daily", "missing")
          end
        else
          totalDone = totalDone + numDone
          if checkDone then
            printQuestsForState(qidsDone, "done")
          end
          if checkCompleted then
            printQuestsForState(qidsCompleted, "completed")
          end
          if checkAccepted then
            printQuestsForState(qidsAccepted, "accepted")
          end
          if checkMissing then
            printQuestsForState(qidsMissing, "missing")
          end
        end
      end
    end
  end
  if checkDone then
    local summary = "Turned in "..totalDone.." dailies"
    if categorySubtype then
      summary = summary.." from the ["..colorize(categorySubtype, "ffffff").."] category"
    end
    print(colorize(summary, addon.colors.main))
  end
  if totalCompleted > 0 then
    if categorySubtype then
      print(colorize("!! Ready to turn in "..totalCompleted.." dailies from the ["..colorize(categorySubtype, "ffffff").."] category !!", addon.colors.alert))
    else
      print(colorize("!! Ready to turn in "..totalCompleted.." dailies !!", addon.colors.alert))
    end
  end
end

--[[
SLASH COMMAND
--]]
SLASH_DAILYCHECK1 = "/dcheck"
SLASH_DAILYCHECK2 = "/dch"
local DEFAULT_COMMAND = "dl"
local AVAIL_CATEGORIES = { "dungeons", "professions", "skettis", "ogrila", "netherwing", "sso", "pvp" }
function SlashCmdList.DAILYCHECK(msg, editbox)
  local msgParts = {}
  for part in string.gmatch(msg, "[^%s]+") do
    table.insert(msgParts, part)
  end
  local primaryCommand, subCommand
  if #msgParts == 2 then
    primaryCommand = msgParts[2]
    subCommand = msgParts[1]
  else
    local firstArg = msgParts[1]
    if contains(AVAIL_CATEGORIES, firstArg) then
      subCommand = msgParts[1]
    else
      primaryCommand = msgParts[1]
    end
  end
  if not primaryCommand then
    primaryCommand = DEFAULT_COMMAND
  end
  if primaryCommand == "d" then
    printStatus(DONE_LIST_TYPE, subCommand)
  elseif primaryCommand == "a" then
    printStatus(ALL_LIST_TYPE, subCommand)
  elseif primaryCommand == "dl" then
    printStatus(DONE_AND_QUEST_LOG_LIST_TYPE, subCommand)
  elseif primaryCommand == "ql" then
    printStatus(QUEST_LOG_LIST_TYPE, subCommand)
  elseif primaryCommand == "m" then
    printStatus(MISSING_LIST_TYPE, subCommand)
  else
    print(colorize(addon.name..":", addon.colors.main).." Options for command "..colorize(SLASH_DAILYCHECK1, addon.colors.args).." or "..colorize(SLASH_DAILYCHECK2, addon.colors.args))
    print("  "..colorize("(category)", addon.colors.args).." - by default, uses the 'dl' option")
    print("  "..colorize("(category) d", addon.colors.args).." - shows done list: turned-in / completed but not turned-in")
    print("  "..colorize("(category) ql", addon.colors.args).." - shows quest log list: completed but not turned-in / accepted")
    print("  "..colorize("(category) dl", addon.colors.args).." - shows done & quest log list: turned-in / completed but not turned-in / accepted")
    print("  "..colorize("(category) m", addon.colors.args).." - shows missing list: dailies that have not been taken")
    print("  "..colorize("(category) a", addon.colors.args).." - shows all the dailies")
    local questStateDescs = {}
    for state,stateData in pairs(QUEST_STATES) do
      table.insert(questStateDescs, colorize(state..stateData.shorthand, stateData.color))
    end
    print(colorize(addon.name..":", addon.colors.main).." Quest States Legend: "..table.concat(questStateDescs, ", "))
    print(colorize(addon.name..":", addon.colors.main).." The category portion is optional. If category is provided, only displays status for that category.")
    local stylizedCategories = {}
    for _,cat in pairs(AVAIL_CATEGORIES) do
      table.insert(stylizedCategories, colorize(cat, addon.colors.args))
    end
    print(colorize("DailiesChecker:", addon.colors.main).." Available categories: "..table.concat(stylizedCategories, ", "))
  end
end
