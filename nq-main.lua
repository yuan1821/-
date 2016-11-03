--本地化
local yz_zls = yz_zls;
local yz_sds = yz_sds;
local yz_sys = yz_sys;
local yz_sls = yz_sls;
local yz_xszf = yz_xszf;
local fcznkg = fcznkg;
local htgkg = htgkg;
local qskg = qskg;
local sgdbkg = sgdbkg
local lmsgrsd = lmsgrsd
local lmsgrst = lmsgrst
local ghzwkg = ghzwkg
local tbrs =tbrs
local xdrs =xdrs
local dzxx = dzxx
local lmsgxx = lmsgxx
local sqkg = sqkg

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


--天赋判断
--if not (getTalent(1,1) and getTalent(2,3) and getTalent(3,1) and getTalent(4,3) and getTalent(5,2) and getTalent(6,2) and getTalent(7,2)) then
	--print("天赋仅支持1313222")
	--return
--end
--没事不要乱进战斗
if not isInCombat("player") or isBused("player") or isAlive("player") then return; end
--左ctrl光环掌握
if IsLeftControlKeyDown() and canCast(31821) and ghzwkg == true then
	castSpell("player",31821,false,false)
end
--左Shift复仇之怒
if (fcznkg == true and ln.canCast(31842) and IsLeftShiftKeyDown()) then
	castSpell("player",31842,false,false)
end
--左Alt神器技能
if canCast(200652) and sqkg == false then
	castSpell("player",200652,false,false)
	--return
end
--技能不插入
if UnitCastingInfo("player") or UnitChannelInfo("player") or getSpellCD(61304) > 0 then return; end;
local grouptype = getGroupType();

if grouptype == "party" then
    return "Action1"
elseif grouptype == "raid" then
    return "Action2"
else
    print("出错")
end
