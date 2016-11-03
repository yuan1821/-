debugprofilestart()
--本地化
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
local UnitIsUnit = UnitIsUnit
local HealLevel = ln.HealLevel
local getUnitTarget = ln.getUnitTarget
local UnitCanAttack = UnitCanAttack

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
--设置公共变量
--治疗石
if yz_zls <= 30 or yz_zls >= 40 then yz_zls = 40; end
--圣盾术
if yz_sds <= 10 or yz_sds >= 30 then yz_sds = 20; end
--圣佑术
if yz_sys <= 40 or yz_sys >= 100 then yz_sys = 45; end
--圣疗术
if yz_sls <= 10 or yz_sls >= 30 then yz_sls = 20; end
--牺牲祝福
if yz_xszf <= 30 or yz_xszf >= 60 then yz_xszf = 40; end
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
--print(UnitGUID(tanks[1]))
local tktg
if tanks then tktg = tanksMin(tanks); end
--攻击目标列表
local emtg = ln.getTagertTable("player",40)
--print(emtg[1])
if emtg[1] ~= nil and canCast(20271) and getTalent(6,3) then
    --print(3)
    for i=1,#emtg do
        --print(i)
        if UnitExists(emtg[i]) and not UnitBuffID(emtg[i],196941,"player") and canCast(20271) and castSpell(emtg[i],20271,false,true)  then
            break
        end
    end
end
--神圣棱镜
--print(4)
if getTalent(5,3) and tanks[1] then
	local ttg = getUnitTarget(tanks[1])
    if UnitExists(ttg) then  TargetUnit(ttg);end
	if UnitExists(ttg) and canCast(114165) and UnitCanAttack("player",ttg) and castSpell("target",114165,false,false) then
	end
end

--驱散
if qskg == true then isDecursive(true); end
--团队类型
local grouptype = getGroupType();
--自保
--print(UnitBuffID(tk[1],53563))
if UnitBuffID("player",6940) and canCast(498) then
	castSpell("player",498,false,false)
end
if getHP("player") <= yz_sds and canCast(642) and isInCombat("player") and not UnitBuffID("player",25771) then
    castSpell("player",642,false,false);    
end
if getHP("player") <= yz_zls and canUse(5512) and isInCombat("player") then
    RunMacroText("/cast 治疗石")    
end
if ln.getHP("player") <= yz_sys and canCast(498) and isInCombat("player") and not UnitBuffID("player",25771) then
    castSpell("player",498,false,false);    
end
--黎明圣光
if canCast(85222) and getHealthNum(15,lmsgxx)~=false and getHealthNum(15,lmsgxx) >= lmsgrst then  
	castSpell("player",85222,false,false)
end
--圣光道标
--设置智能圣光道标开关，给血量最小的

if sgdbkg == true and tktg and not getTalent(7,1) and not UnitBuffID(tktg,53563,"player") and canCast(53563) and not UnitBuffID(tktg,156910,"player") then
    castSpell(tktg,53563,false,false);
end
if sgdbkg == true and tktg and getTalent(7,1) and grouptype == "party" and not UnitBuffID(tktg,53563,"player") and canCast(53563) and not UnitBuffID(tktg,156910,"player") then
    castSpell(tktg,53563,false,false);
end
if getTalent(7,1) and grouptype == "party" and canCast(156910) and not UnitBuffID("player",156910,"player") and not UnitBuffID(tktg,53563,"player") and castSpell("player",156910,false,false) then
end
if sgdbkg == true and tanks[1] and getTalent(7,1) and grouptype == "party" and not UnitBuffID(tanks[1],53563,"player") and canCast(53563) and not UnitBuffID(tanks[1],156910,"player") then
    castSpell(tktg,53563,false,false);
end

if sgdbkg == true and tanks[2] and getTalent(7,1) and grouptype == "raid" and canCast(156910) and htb and not UnitBuffID(tanks[2],156910,"player") and not UnitBuffID(tanks[2],53563,"player") and castSpell(tanks[2],156910,false,false) then
end


-- 护盾,自杀光
if htg and UnitIsUnit("player",htg) ~= true and UnitBuffID("player",17) and getHP(htg) <= 80 then
    castSpell(htg,183998,false,false);
    --return;
end
if UnitBuffID("player",642) and htb then
	for i=1,#htb do
		if getHP(htb[i])<100 and UnitIsUnit("player",htb[i]) ~= true and castSpell(htb[i],183998,false,false) then
			return
		end
	end
end
--print(111)

--免费神圣震击
if htg and UnitBuffID("player",21644) then
    castSpell(htg,20473,false,false);
end
--保T
if tktg then
    if canCast(633) and not UnitBuffID("player",25771) and getHP(tktg) <= yz_sls then
        castSpell(tktg,633,false,false)
    end
    if canCast(6940) and getHP(tktg) <= yz_xszf and not UnitBuffID(tktg,6940) then
        castSpell(tktg,6940,false,false)
    end
    if htg and getHP(htg) <= 15 and canCast(1022) and UnitGroupRolesAssigned(ht[i]) ~= "TANK" then
    	ln.castSpell(htg,1022,false,false)
    end
end
--爆发
--给有震击buff的闪现，没有的震击
--debugprofilestart()
--if UnitBuffID("player",105809) and htb then
	--for i=1,#htb do
		--if not (UnitBuffID(htb[i],200652) or UnitBuffID("player",53576) or UnitBuffID("player",185100)) and getHP(htb[i]) <= 70 then
               -- print("当前施法目标HP："..getHP(htb[i]))
               -- castSpell(htb[i],20473,false,false)
            
			--elseif (UnitBuffID(htb[i],200652) or UnitBuffID("player",53576) or UnitBuffID("player",185100)) and getHP(htb[i]) <= 70 then
               -- print("当前施法目标HP："..getHP(htb[i]))
				--castSpell(htb[i],19750,false,false)
		--end
	--end
--end
--print("脚本执行到此处总共耗时 "..debugprofilestop().." 毫秒")
--神圣复仇者
--print(111)
if canCast(105809) and ((getHealthNum(40,70) >= 6 and grouptype == "raid") or (getHealthNum(40,70) >= 3 and grouptype == "party")) then
	castSpell("player",105809,false,false)
end
--捆绑神器提尔的复仇
if canCast(200652) and UnitBuffID("player",105809) and sqkg == true then
	castSpell("player",200652,false,false)
end
--复仇之怒
if fcznkg == false and ((getHealthNum(40,70) >= 6 and grouptype == "raid") or (getHealthNum(40,70) >= 3 and grouptype == "party")) then
	ln.castSpell("player",31842,false,false)    
end
--律法之责
if canCast(214202) and UnitBuffID("player",31842)  then
	castSpell("player",214202,false,false)    
end
--保自己，为自杀做准备
if getHP("player") <= 60 and canCast(20473) and castSpell("player",20473,false,false) then	
	--return
end
if getHP("player") <= 90 and canCast(223306) and castSpell("player",223306,false,false) then	
	--return
end
-- if getHP("player") <= 70 and canCast(19750) and castSpell("player",19750,false,false) then
-- end

-- if getMana("player") <= 40 and getHP("player") <= 50 and canCast(19750) and (UnitBuffID("player",185100) or UnitBuffID("player",53576)) and castSpell("player",19750,false,false) then	
-- 	--return;
-- end
-- -- if getMana("player") <= 40 and getHP("player") <= 70 and canCast(82326) and UnitBuffID("player",53576) and castSpell("player",82326,false,false) then	
-- -- 	--return;
-- -- end
-- if getMana("player") <= 40 and getHP("player") <= 70 and canCast(19750) and (UnitBuffID("player",156910) or UnitBuffID("player",185100)) and castSpell("player",19750,false,false) then	
-- 	--return;
-- end
-- if getMana("player") <= 40 and getHP("player") <= 70 and canCast(82326) and castSpell("player",82326,false,false) then	
-- 	--return;
-- end
-- 治疗
if UnitExists(htg) then
	if htg and getHP(htg) <= 50 and canCast(20473) and castSpell(htg,20473,false,false) then
		--return;
	end
	if htg and getHP(htg) <= 50 and getMana("player") > 40 and canCast(19750) and (UnitBuffID("player",185100) or UnitBuffID("player",53576)) and castSpell(htg,19750,false,false) then	
    end	
	if htg and UnitIsUnit("player",htg) ~= true and getHP(htg) <= 50 and getHP("player") >= 40 and not (UnitBuffID("player",185100) or UnitBuffID("player",53576)) and castSpell(htg,183998,false,false) then	
	end

	if tktg and getHP(tktg) <= 80 and canCast(20473) and castSpell(tktg,20473,false,false) then
		--return;
	end
	if tktg and getHP(tktg) <= 80 and canCast(223306) and castSpell(tktg,223306,false,false) then
		--return;
	end	
	if tktg and getHP(tktg) <= 80 and canCast(19750) and (UnitBuffID(tktg,53563,"player") or UnitBuffID(tktg,156910,"player")) and castSpell(tktg,19750,false,false) then
		--return;
	end
	if getMana("player") < 10 and getHP("player") >= 30 and canCast(183998) and castSpell(tktg,183998,false,false) then
	end
	-- if tktg and ln.getHP(tktg) <= 60 and ln.canCast(59542) then
	-- 	ln.castSpell(tktg,59542,false,false)
	-- 	return
	-- end

	-- if tktg and getHP(tktg) <= 80 and getHP("player") >= 40 and castSpell(tktg,183998,false,false) then	
	-- 	--return;
	-- end

	-- if htg and getHP(htg) <= 75 and canCast(183998) and getHP("player") >= 45 and castSpell(htg,183998,false,false) then	
	-- end
	-- if getHP("player") <= 90 and canCast(223306) then
	-- 	castSpell("player",223306,false,false)

	-- end
	--print(222)
	if htg and getHP(htg) <= 80 and canCast(20473) and castSpell(htg,20473,false,false) then	
		
	end
	if htg and getHP(htg) <= 80 and canCast(19750) and (UnitBuffID("player",185100) or UnitBuffID("player",53576)) and castSpell(htg,19750,false,false) then	
		
	end	
	if htg and UnitIsUnit("player",htg) ~= true and getHP(htg) <= 80 and ln.getHP("player") >= 40 and castSpell(htg,183998,false,false) then	
	end

	if tktg and getHP(tktg) <= 95 and canCast(183998) and getHP("player") >= 30 and castSpell(htg,183998,false,false) then	
	end
	--print(333)
	if htg and UnitIsUnit("player",htg) ~= true and getHP(htg) <= 95 and getHP("player") >= 30 and canCast(183998) and castSpell(htg,183998,false,false) then	
		--return
	end

	if htg and canCast(82326) and castSpell(htg,82326,false,false) then
	end
end
print("团队脚本执行到此处总共耗时 "..debugprofilestop().." 毫秒")
