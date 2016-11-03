--本地化

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
local HealLevel = ln.HealLevel

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
local hl = HealLevel("player",40)

if tanks and tktg then
	for i=1,#tanks do
		if not isAlive(tanks[i]) and not UnitBuffID(tanks[i],139,"player") and getHP(tanks[i]) < 99 and castSpell(tanks[i],139,false,false) then
			print("对"..UnitName(tanks[i]).."释放了恢复")
		end
	end
	if getHP(tktg) <= 50 and canCast(2050) and castSpell(tktg,2050,false,false) then
		print("对"..UnitName(tktg).."释放了圣言术：静")
	end
	if getHP(tktg) <= 40 and canCast(2061) and castSpell(tktg,2050,false,false) then
		print("对"..UnitName(tktg).."释放了快速治疗")
	end
end

if hl >= 80 then
	if htg then


end
