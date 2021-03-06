local Addon = LibStub("AceAddon-3.0"):GetAddon(PLR_NAME)
local Locale = Addon.Locale
local lang = "enUS"

-- Chat messages
local L = {}
setmetatable(L, Locale.MT)
Locale[lang] = L

L["ROLL_START"] = PLR_CHAT .. " Starting roll for %s -> Whipser me!"
L["ROLL_WINNER"] = PLR_CHAT .. " <%s> has won %s -> Trade me!"
L["ROLL_WINNER_WHISPER"] = "You have won %s! Please trade me."
L["ROLL_ANSWER_BID"] = "Ok, I registered your bid for %s."
L["ROLL_ANSWER_YES"] = "You can have it, just trade me."
L["ROLL_ANSWER_NO_SELF"] = "Sorry, I need that myself."
L["ROLL_ANSWER_NO_OTHER"] = "Sorry, I already gave it to someone else."
L["ROLL_ANSWER_NOT_TRADABLE"] = "Sorry, I can't trade it."
L["ROLL_ANSWER_AMBIGUOUS"] = "I am giving away multiple items right now, please send me the link of the item you want."
L["BID"] = "Do you need that %s?"
L["ITEM"] = "item"

-- Addon
local L = LibStub("AceLocale-3.0"):NewLocale(PLR_NAME, lang, lang == Locale.DEFAULT)
if not L then return end

LOOT_ROLL_INELIGIBLE_REASONPLR_NO_ADDON = "The owner of this item doesn't use the PersoLootRoll addon."
LOOT_ROLL_INELIGIBLE_REASONPLR_NO_DISENCHANT = "The PersoLootRoll addon doesn't support disenchanting."

L["TRADE"] = "Trade"
L["ITEM"] = "item"

L["HELP"] = "Start rolls and bid for items (/PersoLootRoll or /plr).\n"
 .. "Usage: \n"
 .. "/plr: Open options window\n"
 .. "/plr roll [item]* (<timeout> <owner>): Start a roll for one or more item(s)\n"
 .. "/plr bid <owner> ([item]): Bid for an item from another player\n"
 .. "/plr config: Change settings through the command line\n"
 .. "/plr help: Print this help message\n"
 .. "Legend: [..] = item link, * = one or more times, (..) = optional"
L["USAGE_ROLL"] = "Usage: /plr roll [item]* (<timeout> <owner>)"
L["USAGE_BID"] = "Usage: /plr bid <owner> ([item])"

L["ROLL_START"] = "Starting roll for %s from %s."
L["ROLL_END"] = "Ending roll for %s from %s."
L["ROLL_WINNER_OWN"] = "You have won your own %s."
L["ROLL_WINNER_SELF"] = "You have won %s from %s -> %s."
L["ROLL_WINNER_OTHER"] = "%s has won %s from you -> %s."
L["ROLL_CANCEL"] = "Canceling roll for %s from %s."
L["ROLL_ANSWER_0"] = "Pass"
L["ROLL_ANSWER_1"] = "Need"
L["ROLL_ANSWER_2"] = "Greed"
L["ROLL_ANSWER_3"] = "Disenchant"

L["BID_START"] = "Bidding with %q for %s from %s."
L["BID_PASS"] = "Passing on %s from %s."
L["BID_CHAT"] = "Asking %s for %s -> %s."
L["BID_NO_CHAT"] = "Whispering is disabled, you need to ask %s for %s yourself -> %s."

L["TRADE_START"] = "Starting trade with %s."
L["TRADE_CANCEL"] = "Canceling trade with %s."

L["AWARD_LOOT"] = "Award loot"

L["ERROR_PLAYER_NOT_FOUND"] = "Cannot find player %s."
L["ERROR_ITEM_NOT_TRADABLE"] = "You cannot trade that item."
L["ERROR_NOT_IN_GROUP"] = "You are not in a group or raid."
L["ERROR_ROLL_UNKNOWN"] = "That roll doesn't exist."
L["ERROR_ROLL_STATUS_NOT_0"] = "The roll has already been started or finished."
L["ERROR_ROLL_STATUS_NOT_1"] = "The roll is not running."
L["ERROR_ROLL_ANSWER_UNKNOWN_SELF"] = "That's not a valid answer."
L["ERROR_ROLL_ANSWER_UNKNOWN_OTHER"] = "%s has send an invalid bid for %s."

L["OPT_GENERAL"] = "General"
L["OPT_ENABLE"] = "Enable"
L["OPT_ENABLE_DESC"] = "Enable or disable the addon"
L["OPT_ECHO"] = "Chat information"
L["OPT_ECHO_DESC"] = "How much information do you want to see from the addon in chat?\n\n"
    .. "|cffffff00None:|r No info in chat.\n"
    .. "|cffffff00Error:|r Only error messages.\n"
    .. "|cffffff00Info:|r Errors and useful info that you probably want to act on.\n"
    .. "|cffffff00Verbose:|r Get notices about pretty much anything the addon does.\n"
    .. "|cffffff00Debug:|r Same as verbose, plus additional debug info."
L["OPT_ECHO_NONE"] = "None"
L["OPT_ECHO_ERROR"] = "Error"
L["OPT_ECHO_INFO"] = "Info"
L["OPT_ECHO_VERBOSE"] = "Verbose"
L["OPT_ECHO_DEBUG"] = "Debug"
L["OPT_CHAT"] = "Chat"
L["OPT_CHAT_DESC"] = "Change whether or not the addon will post things to the group/whisper chat."
L["OPT_ANNOUNCE"] = "Announce rolls and winners"
L["OPT_ANNOUNCE_DESC"] = "Announce rolls and winners in group/raid chat."
L["OPT_ANSWER"] = "Answer to whispers"
L["OPT_ANSWER_DESC"] = "Let the addon answer whispers from group/raid members about items you looted."
L["OPT_ROLL"] = "Roll on loot in chat"
L["OPT_ROLL_DESC"] = "Roll on loot you want (/roll) if others post links in group/raid chat."
L["OPT_WHISPER_GROUP"] = "Whisper by group type"
L["OPT_WHISPER_GROUP_DESC"] = "Whisper others if they got loot you want, depending on the type of group you are currently in."
L["OPT_WHIPSER_TARGET"] = "Whisper by target"
L["OPT_WHISPER_TARGET_DESC"] = "Whisper others if they got loot you want, depending on whether the target is in your guild or on your friend list."
