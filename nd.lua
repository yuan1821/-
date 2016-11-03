--本地化
if _G.castSpell == nil then
_G.castSpell = {}
_G.castSpell[145205] = GetTime()
end
local isInCombat = ln.isInCombat;
local isBused = ln.isBused;
local canCast = ln.canCast;
local isAlive = ln.isAlive;
local castSpell = ln.castSpell;
local getFriendlyTable = ln.getFriendlyTable;
local getSpellCD = ln.getSpellCD;
local getHealTable = ln.getHealTable;
local getTanksTable = ln.getTanksTable;
local tanksMin = ln.tanksMin;
local tankChoice = ln.tankChoice;
local isDecursive = ln.isDecursive;
local getGroupType = ln.getGroupType;
local getHP = ln.getHP;
local UnitAffectingCombat = UnitAffectingCombat;
local UnitBuffID = ln.UnitBuffID;
local RunMacroText = RunMacroText;
local getHealthNum = ln.getHealthNum;
local UnitGroupRolesAssigned = UnitGroupRolesAssigned;
local UnitIsUnit = UnitIsUnit;
local getMana = ln.getMana;
local getTalent = ln.getTalent
local canUse = ln.canUse
local getUnitHealAoe = ln.getUnitHealAoe
local isMoving = ln.isMoving
local GetTime = GetTime
local getBuffRemain = ln.getBuffRemain
local getUnitHealthNum = ln.getUnitHealthNum
local getCombatTime = ln.getCombatTime

--没事不要乱进战斗
if not isInCombat("player") or isBused("player") or isAlive("player") then return; end
--左ctrl宁静
if IsLeftControlKeyDown() and canCast(740) and njkg == true then
	castSpell("player",740,false,false)
end
--左Alt神器技能
if canCast(208253) and IsLeftAltKeyDown() and sqkg == true then
	castSpell("player",208253,false,false)
	--return
end
--技能不插入
if UnitCastingInfo("player") or UnitChannelInfo("player") or getSpellCD(61304) > 0 then return; end;
--团队状态
local grouptype = getGroupType();
local kg
if grouptype == "party" then
	kg = 1
elseif grouptype == "raid" then
	kg = 2
else
	print("你到底在什么团队状态")
end
--驱散
if qskg == true then isDecursive(true); end
--获得治疗目标
local ht = getFriendlyTable("player",40)
local htb = getHealTable("player",40)
local htg = "player"
if htgkg == true and htb then
    htg = htb[1]
else 
    htg = "target"
end
--print(#ht)
--print(IsInGroup("target"))
--获得坦克列表和坦克目标
local tanks = getTanksTable("player",40)
local tktg
if tanks then tktg = tanksMin(tanks); end

if getCombatTime() > 30 and canCast(208253) and castSpell("player",208253,false,false) then
	--print("已经释放神器")
	--return
end
if getCombatTime() > 30 and canCast(197721) and castSpell("player",197721,false,false) then
	--print("已经释放繁盛")
	--return
end

--团刷
local aoetg = getUnitHealAoe(30,90)
--if aoetg ~= false then print(UnitName(aoetg)); end
if aoetg ~= false and ((kg==2 and getUnitHealthNum(aoetg,10,90) >= 5) or (kg==1 and getUnitHealthNum(aoetg,10,90) >= 3)) then
	if UnitExists(aoetg) and isMoving(aoetg) == false and canCast(145205) and (_G.castSpell[145205] == nil or GetTime() - _G.castSpell[145205] >= 30) and castSpell(aoetg,145205,true,false) then
		_G.castSpell[145205] = GetTime()
		--print(_G.castSpell[145205])
		--print("对"..UnitName(aoetg).."释放了百花齐放")
	end
	if aoetg and canCast(48438) and castSpell(aoetg,48438,false,false) then
		--print("对"..UnitName(aoetg).."释放了野性成长")
	end
end

if htg and getBuffRemain("player",16870) > 0 and castSpell(htg,8936,false,false) then
	--print("对"..UnitName(htg).."释放了免费愈合")
end

if tktg and getHP(tktg) <= 95 then

	if getHP(tktg) <= 40 and getBuffRemain(tktg,8936,"player") <= 0 and canCast(8936) and castSpell(tktg,8936,false,false) then
		--print("对"..UnitName(tktg).."释放了愈合")
	end	


	if getBuffRemain(tktg,33763,"player") <= 0 and canCast(33763) and castSpell(tktg,33763,false,false) then
		--print("对"..UnitName(tktg).."释放了生命绽放")
	end

	if getBuffRemain(tktg,774,"player") <= 0 and canCast(774) and castSpell(tktg,774,false,false) then
		--print("对"..UnitName(tktg).."释放了回春术")
	end	
	if getHP(tktg) <= 30 and canCast(102342) and castSpell(tktg,102342,false,false) then
		--print("对"..UnitName(tktg).."释放了铁木树皮")
	end
	if getHP(tktg) <= 40 and canCast(18562) and castSpell(tktg,18562,false,false) then
		--print("对"..UnitName(tktg).."释放了迅捷治愈")
	end
	if getHP(tktg) <= 70 and canCast(5185) and castSpell(tktg,5185,false,false) then
		--print("对"..UnitName(tktg).."释放了治疗之触")
	end
end

if htg and getHP(htg) <= 95 then
	if getHP(htg) <= 30 and canCast(102342) and castSpell(htg,102342,false,false) and getHP(tktg) > 60 then
		-- print("对"..UnitName(htg).."释放了铁木树皮")
	end
	if getHP(htg) <= 40 and getBuffRemain(htg,8936,"player") <= 0 and canCast(8936) and castSpell(htg,8936,false,false) then
		--print("对"..UnitName(htg).."释放了愈合")
	end
	if getBuffRemain(htg,774,"player") <= 0 and canCast(774) and castSpell(htg,774,false,false) then
		--print("对"..UnitName(htg).."释放了回春术")
	end	
	if getHP(htg) <= 40 and canCast(18562) and castSpell(htg,18562,false,false) then
		--print("对"..UnitName(htg).."释放了迅捷治愈")
	end

	if getHP(htg) <= 60 and canCast(5185) and castSpell(htg,5185,false,false) then
		--print("对"..UnitName(htg).."释放了治疗之触")
	end

	--if getBuffRemain(htg,33763,"player") <= 0 and canCast(33763) and castSpell(htg,33763,false,false) then
		--print("对"..UnitName(htg).."释放了生命绽放")
	--end


end
