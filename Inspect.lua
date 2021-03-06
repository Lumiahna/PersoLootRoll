local Addon = LibStub("AceAddon-3.0"):GetAddon(PLR_NAME)
local Util = Addon.Util
local Item = Addon.Item
local Self = {}

-- How long before refreshing cache entries (s)
Self.REFRESH = 1800
-- How long before checking for requeues
Self.QUEUE_DELAY = 60
-- How long between two inspect requests
Self.INSPECT_DELAY = 2
-- How many tries per char
Self.MAX_PER_CHAR = 3
-- We are not interested in those slots
Self.IGNORE = {Item.TYPE_BODY, Item.TYPE_HOLDABLE, Item.TYPE_TABARD, Item.TYPE_THROWN}

Self.cache = {}
Self.queue = {}

Self.lastQueued = 0

-------------------------------------------------------
--                    Read cache                     --
-------------------------------------------------------

-- Get cache entry for given unit and location
function Self.Get(unit, location)
    return Util.TblGet(Self.cache, {unit, location}) or 0
end

-- Check if an entry exists and isn't out-of-date
function Self.IsValid(unit)
    return Self.cache[unit] and Self.cache[unit].time + Self.REFRESH > GetTime()
end

-------------------------------------------------------
--                   Update cache                    --
-------------------------------------------------------

-- Update the cache entry for the given player
function Self.Update(unit)
    unit = Util.GetName(unit)

    local info = Self.cache[unit] or {}
    local inspectsLeft = Self.queue[unit] or Self.MAX_PER_CHAR

    -- Remember when we did this
    info.time = GetTime()

    -- Determine the level for all basic inventory locations
    Util(Item.SLOTS).Omit(Self.IGNORE).Map(Util.Tbl).Iter(function (slots, location)
        local levels = Util(slots).Map(function (slot)
            local item = Item.FromSlot(slot, unit)
            if item and select(2, item:GetFullInfo()) then
                return item.quality ~= LE_ITEM_QUALITY_LEGENDARY and item.level or 0
            end
        end).Values()()

        -- Only set it if we got links for all slots
        if #levels == #slots then
            info[location] = math.max(info[location] or 0, math.min(unpack(levels)))
        elseif not info[location] then
            info[location] = false
        end
    end)

    -- Determine the min level of all unique relic types for the currently equipped artifact weapon
    local weapon = Item.GetEquippedArtifact(unit)
    if weapon then
        local relics = weapon:GetUniqueRelicSlots()

        Util(relics).GroupKeys().Iter(function (slots, location)
            local levels = Util(slots).Map(function (slot)
                local item = weapon:GetGem(slot)
                return item and select(2, item:GetFullInfo()) and item.level or nil
            end).Values()()

            -- Only set it if we got links for all slots
            if #levels == #slots then
                info[location] = math.max(info[location] or 0, math.min(unpack(levels)))
            elseif not info[location] then
                info[location] = false
            end
        end)
    end

    -- Check if the inspect was successfull
    local n = Util.TblCount(info)
    local failed = n == 0 or Util(info).Only(false).Count()() >= n/2

    -- Update cache and queue entries
    Self.cache[unit] = info
    Self.queue[unit] = failed and inspectsLeft > 1 and inspectsLeft - 1 or nil
end

-- Clear everything and stop tracking for one or all players
function Self.Clear(unit)
    if unit then
        Self.cache[unit] = nil
        Self.queue[unit] = nil
    else
        Self.Stop()
        Self.lastQueued = 0
        wipe(Self.cache)
        wipe(Self.queue)
    end
end

-- Queue a unit or the entire group for inspection
function Self.Queue(unit)
    unit = Util.GetName(unit)
    if not Addon:IsTracking() or not unit or UnitIsUnit(unit, "player") then return end

    if unit then
        Self.queue[unit] = Self.queue[unit] or Self.MAX_PER_CHAR
    else
        -- Queue all group members with missing or out-of-date cache entries
        Self.lastQueued = GetTime()
        Util.SearchGroup(function (i, unit)
            if unit and  unit ~= UnitName("player") and not Self.queue[unit] and not Self.IsValid(unit) then
                Self.queue[unit] = Self.MAX_PER_CHAR
            end
        end)
    end
end

-- Start the inspection loop
function Self.Loop()
    -- Check if the loop is already running
    if Addon:TimerIsRunning(Self.timer) then return end

    -- Queue new units to inspect
    if Self.lastQueued + Self.QUEUE_DELAY <= GetTime() then
        Self.Queue()
    end

    -- Get the next unit to inspect (with max inspects left -> wide search, random -> so we don't get stuck on one unit)
    local units = Util(Self.queue).Filter(function (i, unit) return CanInspect(unit) end, true)()
    local unit = next(units) and Util(units).Only(Util(units).Values().Unpack(math.max)(), true).Keys().Random()()
    
    if unit then
        -- Request inspection
        Self.target = unit
        NotifyInspect(unit)
        Self.timer = Addon:ScheduleTimer(Self.Loop, Self.INSPECT_DELAY)
    else
        Self.timer = Addon:ScheduleTimer(Self.Loop, Self.QUEUE_DELAY - (GetTime() - Self.lastQueued))
    end
 end

-- Check if we should start the loop, and then start it
function Self.Start()
    local timerIsRunning = Addon:TimerIsRunning(Self.timer)
    local delayHasPassed = Self.timer and GetTime() - (Self.timer.ends - Self.timer.delay) > Self.INSPECT_DELAY

    if Addon:IsTracking() and not InCombatLockdown() and (not timerIsRunning or delayHasPassed) then
        Self.Stop()
        Self.Loop()
    end
end

-- Stop the inspection loop
function Self.Stop()
    if Self.timer then
        Addon:CancelTimer(Self.timer)
        Self.timer = nil
    end
end

-------------------------------------------------------
--                      Events                       --
-------------------------------------------------------

-- INSPECT_READY
function Self.OnInspectReady(unit)
    -- Inspect the unit
    if unit == Self.target then
        if Self.queue[unit] and Util.UnitInGroup(unit, true) then
            Self.Update(unit)
        end

        ClearInspectPlayer()
        Self.target = nil
    end
    
    -- Extend a running loop timer
    if Addon:TimerIsRunning(Self.timer) then
        Self.timer = Addon:ExtendTimerTo(Self.timer, Self.INSPECT_DELAY)
    end
end

-- Export

Addon.Inspect = Self