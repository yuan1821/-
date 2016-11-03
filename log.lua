local guid = UnitGUID("player")
local frame = CreateFrame('Frame')
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
function reader(self,event,...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
      destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
    
    if source == guid then
        if param == "SPELL_CAST_FAILED" then
            _G.lastspell_failed = spell
            _G.lastspell_failedtime = GetTime()
            if source == guid then
                --print(spellName.." 失败原因: "..spellType)
            end
            if spell == _G.lastspell_start then
                _G.lastspell_start = nil
            end
        end
        if param == "SPELL_CAST_START" then
            _G.lastspell_start = spell       
        end

        if param == "SPELL_CAST_SUCCESS" then
            _G.lastspell_time = GetTime()
            _G.lastspell_cast = spell
            if GetObject(destination) then
                _G.lastspell_target = destination
                --print("成功对 "..lastspell_target.."施放了 "..spellName)
            else
                _G.lastspell_target = none
            end
            
        end
    end
------------------------------------职业专用----------------------------------------
    if source == guid then
        if GetSpecializationInfo(GetSpecialization()) == 71 then --刺杀贼天赋
            if getCombatTime()>36 and Assassination_Burst_Initial == true then
                Assassination_Burst_Initial = false
                Assassination_Burst_Step = 0
                --print("起手循环关闭")
            end
            if _G.lastspell_cast == 100 and getCombatTime()<10 then
                Assassination_Burst_Initial = true
                Assassination_Burst_Step = 1
                --print("检测到使用冲锋，起手循环开始")
            end
        end
    end


end   
   
frame:SetScript("OnEvent", reader)
-------------------------------------------------------------------------------------------------------------------
--记录进入战斗的时间
-------------------------------------------------------------------------------------------------------------------
local Frame = CreateFrame('Frame')
Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
local function EnteringCombat(self,event,...)
	if event == "PLAYER_REGEN_DISABLED" then
		-- here we should manage stats snapshots
		--AgiSnap = getAgility()
		_G.data["Combat Started"] = GetTime()
		--ChatOverlay("|cffFF0000Entering Combat")
	end
end
Frame:SetScript("OnEvent",EnteringCombat)
-------------------------------------------------------------------------------------------------------------------
--容器（背包）内物品发生改变
-------------------------------------------------------------------------------------------------------------------
local Frame = CreateFrame('Frame')
Frame:RegisterEvent("BAG_UPDATE")
local function BagUpdate(self,event,...)
	if event == "BAG_UPDATE" then
		_G.data["bagsUpdated"] = true
	end
end
Frame:SetScript("OnEvent",BagUpdate)

