local UnitExists = UnitExists;
local GetTime = GetTime;
local GetObjectPosition = GetObjectPosition;
local CheckIntersection = CheckIntersection;
local CastSpellByName = CastSpellByName;
local IsAoeSpellPending = IsAoeSpellPending;
local GetObjects = GetObjects;
local UnitCanAttack = UnitCanAttack;
local UnitIsDeadOrGhost = UnitIsDeadOrGhost;
local UnitIsVisible = UnitIsVisible;
local UnitCanAssist = UnitCanAssist;
local UnitInParty = UnitInParty;
local UnitInRaid = UnitInRaid;
local UnitAffectingCombat = UnitAffectingCombat;
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local GetPowerRegen = GetPowerRegen;
local UnitClass = UnitClass;
local GetSpecialization = GetSpecialization;
local UnitGUID = UnitGUID;
local GetSpellCooldown = GetSpellCooldown;
local UnitChannelInfo = UnitChannelInfo;
local GetSpellInfo = GetSpellInfo;
local UnitCastingInfo = UnitCastingInfo;
local UnitBuff = UnitBuff;
local UnitDebuff = UnitDebuff;
local GetSpellBookItemInfo = GetSpellBookItemInfo;
local GetTalentInfo = GetTalentInfo;
local GetUnitSpeed = GetUnitSpeed;
local GetSpellCharges = GetSpellCharges;
local GetUnitBoundingRadius = GetUnitBoundingRadius;
local IsUsableSpell = IsUsableSpell;
local GetItemCount = GetItemCount;
local GetItemSpell = GetItemSpell;
local GetInventoryItemID = GetInventoryItemID;
local GetItemCooldown = GetItemCooldown;
local RunMacroText = RunMacroText;
local TargetUnit = TargetUnit;
local UnitClassification = UnitClassification;
local IsInInstance = IsInInstance;
local CancelUnitBuff = CancelUnitBuff;
local GetNumGroupMembers = GetNumGroupMembers;
local GetDistance = GetDistance


-------------------------------------------------------------------------------------------------------------------
--对指定目标释放指定技能
--参数：目标，技能，技能是否属于AOE（布尔值），技能是否需要面向（布尔值），前一个施法后是否延时1秒释放（布尔值）
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function castSpell(Unit,SpellID,Aoe,Face)
	--if Unit == nil then return false;end
    --local lastspell,lastspellid = getCastSpellTime() 
    --if lastspell == false or nil then lastspell = 999;end
    --print(lastspell)
	--local DelayedTime = 0
	
    --if DTime == true then
		--DelayedTime = 1
	--else 
		--DelayedTime = 0
	--end 

	if not UnitExists(Unit) then
		return false
	end   
    

	--if lastspell and lastspell < DelayedTime  then
		--return false
	--end

	local position2 = GetObjectPosition(Unit)
	local position1 = GetObjectPosition("player")
	if position2.Z > position1.Z and position2.Z - position1.Z <= 2 then
		position1.Z = position2.Z
	elseif position2.Z < position1.Z and position1.Z - position2.Z <= 2 then
		position2.Z = position1.Z
	end
	
	position1.Z = position1.Z + 2
	position2.Z = position2.Z + 2
	
	local facechk
	if Face == false or Face == nil then
		facechk = true
	elseif Face == true then
		facechk = getFacing(Unit)
	end
	
	-- if AfterTime ~= nil and type(AfterTime) == "number" then
	-- 	sptime[SpellID] = GetTime() + AfterTime
	-- else 
	-- 	sptime[SpellID] = GetTime()
	-- end

	--if lastspell >= DelayedTime then

		if Aoe == false then
			if facechk and UnitExists(Unit) and getSpellCD(SpellID) <= 0  and not CheckIntersection(position1, position2, {"Structure"}) then
				--sptime[SpellID] = GetTime()
				DelayedTime = 0
				CastSpellByName(GetSpellInfo(SpellID),Unit)
				--sptime[lastcasttime] = GetTime()
				return true
			end
			return false
		end
		
		if Aoe == true then
			if facechk and UnitExists(Unit) and getSpellCD(SpellID) <= 0  and not CheckIntersection(position1, position2, {"Structure"}) then
				--sptime[SpellID] = GetTime()
				DelayedTime = 0
				CastSpellByName(GetSpellInfo(SpellID),Unit)
				--sptime[lastcasttime] = GetTime()
				if IsAoeSpellPending() then	
					local position = GetObjectPosition(Unit)
					ClickTerrain(position) 
					CancelAoeSpell()
					return true
				end
				return false				
			end
			return false
		end
	--end
	return false
end

-------------------------------------------------------------------------------------------------------------------
--获得敌对目标列表（包含中立）
--参数：中心单位，距离
--返回：列表，数量
-------------------------------------------------------------------------------------------------------------------
local function filtera(unit)
 		-- body
 		return not UnitIsDeadOrGhost(unit) and UnitCanAttack("player",unit) and UnitIsVisible(unit);
end 
function getEnemiesTable(Unit,Radius) 
	if Radius == nil then Radius = 50; end
	
		
 	
	local EnemiesTable = GetObjects({
										IncludedTypes = {"Unit"},  
										IncludedUnitReactions = {"ExceptionallyHostile","VeryHostile","Hostile","Neutral"},									
										Scales = {
												  {
													Center = GetObjectPosition(Unit),
													MaxDistance = Radius,											    
												  }
												},
									
										FilterFunction = filtera
										
									}
									
									)		
		
		
	
		return EnemiesTable, #EnemiesTable
		
       
end
-------------------------------------------------------------------------------------------------------------------
--获得友好目标列表（包含中立）
--参数：中心单位，距离
--返回：列表，数量
-------------------------------------------------------------------------------------------------------------------
local function filterb(unit)
	-- body
	return not UnitIsDeadOrGhost(unit) and UnitIsVisible(unit) and UnitCanAssist("player",unit) and (UnitInParty(unit) or UnitInRaid(unit))  ;
end
function getFriendlyTable(Unit,Radius)
	
	
	local FriendlyTable = GetObjects({
  									IncludedTypes = {"Unit"},  
  									IncludedUnitReactions = {"Friendly","VeryFriendly","ExceptionallyFriendly","Neutral","Exalted"},									
  									Scales = {
											  {
											    Center = GetObjectPosition(Unit),
											    MaxDistance = Radius,											    
											  }
											},
                                	FilterFunction = filterb
								}
								
								)
		
		return FriendlyTable ,#FriendlyTable
	
		
end

-------------------------------------------------------------------------------------------------------------------
--获得可治疗目标列表（按血量从小到大排列）
--参数：中心单位，距离
--返回：列表,数量
-------------------------------------------------------------------------------------------------------------------
compp = function(a, b) return (UnitHealth(a) + UnitGetIncomingHeals(a) - UnitHealthMax(a)) < (UnitHealth(b) + UnitGetIncomingHeals(b) - UnitHealthMax(b)) end

function getHealTable(Unit,Radius)
	if Radius == nil then Radius = 50; end
	
	
		local HealTable = getFriendlyTable(Unit,Radius)
        if HealTable == nil then return nil;end
		if HealTable ~= nil and #HealTable > 1 then table.sort(HealTable,compp);end
        
		return HealTable ,#HealTable
	
end

-------------------------------------------------------------------------------------------------------------------
--获得可攻击目标列表（已进入战斗对象）
--参数：中心单位，距离
--返回：列表，数量
-------------------------------------------------------------------------------------------------------------------
local function filterd(unit)
	-- body
	return UnitIsVisible(unit) and UnitExists(unit) and UnitCanAttack("player",unit) and not UnitIsDeadOrGhost(unit) and UnitAffectingCombat(unit);
end
function getTagertTable(Unit,Radius)
	if Radius == nil then Radius = 50; end
	
	
	local TagertTable = GetObjects({
  									IncludedTypes = {"Unit"},  
  									IncludedUnitReactions = {"ExceptionallyHostile","VeryHostile","Hostile","Neutral"},									
  									Scales = {
											  {
											    Center = GetObjectPosition(Unit),
											    MaxDistance = Radius,											    
											  }
											},
                                	FilterFunction = filterd
								}
								
								)	
		return TagertTable ,#TagertTable
	
	
end

-------------------------------------------------------------------------------------------------------------------
--获得指定对象血量百分比
--参数：对象（默认为player）
--返回：血量百分比（0-100）
-------------------------------------------------------------------------------------------------------------------
function getHP(Unit)
	
	if Unit == nil then
		Unit = "player" 
	end;
	local health = UnitHealth(Unit);
	local healthmax = UnitHealthMax(Unit);
	if UnitExists(Unit) and not UnitIsDeadOrGhost(Unit) and (type(health) == "number" and type(healthmax) == "number" and healthmax > 0) then		
		return 100 * (UnitHealth(Unit) / UnitHealthMax(Unit))		
	end
	return 0
	
end

-------------------------------------------------------------------------------------------------------------------
--获得指定对象能量百分比
--参数：对象（默认为player）
--返回：能量百分比（0-100）
-------------------------------------------------------------------------------------------------------------------
function getMana(Unit)

	if Unit == nil then
		Unit = "player" 
	end;
	local power = UnitPower(Unit);
	local powermax = UnitPowerMax(Unit);
	if UnitExists(Unit) and not UnitIsDeadOrGhost(Unit) and (type(power) == "number" and type(powermax) == "number" and powermax > 0) then
		return power / powermax * 100;
	else
		return 0;
	end
	
end

-------------------------------------------------------------------------------------------------------------------
--获得指定对象能量恢复时间
--参数：对象,指定能量点数（默认为最高）
--返回：时间
-------------------------------------------------------------------------------------------------------------------

function getTimeToMax(Unit,Max)

	local maxp = Max or UnitPowerMax(Unit)
	local curr = UnitPower(Unit)
	local curr2
	local regen = select(2,GetPowerRegen(Unit))
	if select(3,UnitClass("player")) == 11 and GetSpecialization() == 2 and isKnown(114107) then
		curr2 = curr + 4*getCombo()
	else
		curr2 = curr
	end
	local m = (maxp - curr2) * (1.0 / regen) 
	if m <= 0 then
		return 0;
	else
		return m;
	end
	
end

-------------------------------------------------------------------------------------------------------------------
--获得指定对象死亡所需时间
--参数：对象（默认为当前目标）
--返回：时间
-------------------------------------------------------------------------------------------------------------------

function round2(num, idp)
  mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
function getTimeToDie(unit)
	unit = unit or "target";
	local thpcurr,thpstart,timestart,currtar,priortar,timecurr,timeToDie
	if thpcurr == nil then thpcurr = 0; end
	if thpstart == nil then thpstart = 0; end
	if timestart == nil then timestart = 0; end
	if UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
		if currtar ~= UnitGUID(unit) then
			priortar = currtar;
			currtar = UnitGUID(unit);
		end
		if thpstart == 0 and timestart == 0 then
			thpstart = UnitHealth(unit);
			timestart = GetTime();
		else
			thpcurr = UnitHealth(unit);
			timecurr = GetTime();
			if thpcurr >= thpstart then
				thpstart = thpcurr;
				timeToDie = 999;
			else
				if ((timecurr - timestart)==0) or ((thpstart - thpcurr)==0) then
					timeToDie = 999;
				else
					timeToDie = round2(thpcurr/((thpstart - thpcurr) / (timecurr - timestart)),2);
				end
			end
		end
	elseif not UnitIsVisible(unit) or currtar ~= UnitGUID(unit) then
		currtar = 0;
		priortar = 0;
		thpstart = 0;
		timestart = 0;
		timeToDie = 0;
	end
	if timeToDie == nil then
		return 999
	else
		return timeToDie
	end
end

-------------------------------------------------------------------------------------------------------------------
--获得指定对技能冷却时间
--参数：技能ID
--返回：时间
-------------------------------------------------------------------------------------------------------------------
function getSpellCD(SpellID)

	if type(SpellID) ~= number then
		return 0
	end
	if GetSpellCooldown(SpellID) == 0 then
		return 0
	else
		local Start ,CD = GetSpellCooldown(SpellID)
		local MyCD = Start + CD - GetTime()
		-- if getOptionCheck("Latency Compensation") then
		-- 	MyCD = MyCD - getLatency()
		-- end
		return MyCD
	end
end

-------------------------------------------------------------------------------------------------------------------
--获得两个对象是否在一定角度内
--参数：对象1，对象2（默认自己），角度(默认180)
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function getFacing(Unit1,Unit2,Degrees) 
	if Degrees == nil then
		Degrees = 90
	end
	if Unit2 == nil then
		Unit2 = "player"
	end
	if UnitExists(Unit1) and UnitIsVisible(Unit1) and UnitExists(Unit2) and UnitIsVisible(Unit2) then
		local position1 = GetObjectPosition(Unit1)
		local position2 = GetObjectPosition(Unit2)
		local Angle1,Angle2,Angle3
		local Angle1 = position1.R
		local Angle2 = position2.R
		local Y1,X1,Z1 = position1.X,position1.Y,position1.Z
		local Y2,X2,Z2 = position2.X,position2.Y,position2.Z
		if Y1 and X1 and Z1 and Angle1 and Y2 and X2 and Z2 and Angle2 then
			local deltaY = Y2 - Y1
			local deltaX = X2 - X1
			Angle1 = math.deg(math.abs(Angle1-math.pi*2))
			if deltaX > 0 then
				Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
			elseif deltaX <0 then
				Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
			end
			if Angle2-Angle1 > 180 then
				Angle3 = math.abs(Angle2-Angle1-360)
			else
				Angle3 = math.abs(Angle2-Angle1)
			end

			if Angle3 < Degrees then
				return true
			else
				return false
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
--对接Ovale一键输出助手，直接释放指定栏的技能
--参数：第几栏（数字）
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isOvale(number)
	
	local spellId = Ovale["frame"]["actions"][number]["spellId"];
	if  not UnitIsDeadOrGhost("target") and UnitCanAttack("player","target") and UnitChannelInfo("player")~= GetSpellInfo(spellId) then
		
			castSpell("target",spellId,false,false);
			return true;
	end
	return false
	
end
function isInOvale(spellId,tablelist)

	if spellId == nil or tablelist == nil then
		return false
	end
	
	for i=1,#tablelist do 
		if spellId == tablelist[i] then
			return true
			--break
		end
	end

end

-------------------------------------------------------------------------------------------------------------------
--是否正在释放技能
--参数：对象，技能（默认为所有技能），【是否可以打断（布尔值）】
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isCastingSpell(unit, spells, interruptable)
	if (type(unit) ~= "string") then
		unit = "target"
	end
	if (not UnitIsVisible(unit)) then
		return false, "false";
	end
	if (type(spells) ~= "string") then
		spells = "*";
	else
		spells = spells;
	end
	if (type(interruptable) ~= "boolean") then
		interruptable = nil;
	end
	local spell1, _, displayname1, icon1, starttime1, endtime1, _, _, interrupt1 = UnitCastingInfo(unit);
	local spell2, _, displayname2, icon2, starttime2, endtime2, _, interrupt2 = UnitChannelInfo(unit);
	if (spells == "*") then
		if (spell1) then
			if (interrupt1 ~= nil and interruptable == interrupt1) then
				return false, "false";
			end
			return true, 1, spell1, (endtime1 - starttime1) / 1000, endtime1 / 1000 - GetTime(), GetTime() - starttime1 / 1000;
		elseif (spell2) then
			if (interrupt2 ~= nil and interruptable == interrupt2) then
				return false, "false";
			end
			return true, 2, spell2, (endtime2 - starttime2) / 1000, endtime2 / 1000 - GetTime(), GetTime() - starttime2 / 1000;
		else
			return false, "false";
		end
	end
	local spells_array = {strsplit(",", spells)};
	for i = 1, #spells_array do
		local spell = strtrim(spells_array[i]);
		if (spell ~= "") and spell then
			local  spellname, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell);
			if (spell1 and spell == spell1) or (spell1 == spellname) then
				if (interrupt1 ~= nil and interruptable == interrupt1) then
					return false, "false";
				end
				return true, 1, spell1, (endtime1 - starttime1) / 1000, endtime1 / 1000 - GetTime(), GetTime() - starttime1 / 1000;
			end
			if (spell2 and spell == spell2) or ( spell2 == spellname) then
				if (interrupt2 ~= nil and interruptable == interrupt2) then
					return false, "false";
				end
				return true, 2, spell2, (endtime2 - starttime2) / 1000, endtime2 / 1000 - GetTime(), GetTime() - starttime2 / 1000;
			end
		end
	end
	return false, "false";
end

-------------------------------------------------------------------------------------------------------------------
--判断是否有指定buff(包含debuff)
--参数：对象，buff，源【可替换为EXACT作为精准查找，针对武僧的虎眼酒】
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function UnitAllBuffID(unit,spellID,filter)
    local Unit= unit
    local SpellID = spellID
    local Filter = filter
	if UnitBuffID_buff(Unit,SpellID,Filter) ~= nil then
		return true
	elseif UnitDebuffID(Unit,SpellID,Filter) ~= nil then
		return true 
	else 
		return false
	end
end
		


function UnitBuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitBuff(unit,spellName)
	else
		local exactSearch = strfind(strupper(filter),"EXACT")
		local playerSearch = strfind(strupper(filter),"PLAYER")
		if exactSearch then
			for i=1,40 do
				local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitBuff(unit,i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitBuff(unit,i)
						end
					end
				else
					return nil
				end
			end
		else
			return UnitBuff(unit,spellName,nil,filter)
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
--判断是否有指定debuff
--参数：对象，debuff，源
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function UnitDebuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitDebuff(unit,spellName)
	else
		local exactSearch = strfind(strupper(filter),"EXACT")
		local playerSearch = strfind(strupper(filter),"PLAYER")
		if exactSearch then
			for i=1,40 do
				local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitDebuff(unit,i)
						end
					end
				else
					return nil
				end
			end
		else
			return UnitDebuff(unit,spellName,nil,filter)
		end
	end
end

udb = UnitDebuffID;

-------------------------------------------------------------------------------------------------------------------
--判断是否有指定天赋
--参数：行，列
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function getTalent(Row,Column)
	return select(4,GetTalentInfo(Row,Column,GetActiveSpecGroup())) or false
end

-------------------------------------------------------------------------------------------------------------------
--判断对象是否在战斗中
--参数：对象
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isInCombat(Unit) 
	if UnitExists(Unit) == false then
		return false
	end
	if UnitAffectingCombat(Unit) then
		return true
	else
		return false
	end
end

-------------------------------------------------------------------------------------------------------------------
--判断对象能量恢复速度
--参数：对象
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getRegen(Unit)
	local regen = select(2,GetPowerRegen(Unit))
	return 1.0 / regen
end

-------------------------------------------------------------------------------------------------------------------
--判断对象是否已经持续移动超出了指定时间
--参数：时间（秒）
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isMovingTime(time) 
	if time == nil then time = 1 end
	if GetUnitSpeed("player") > 0 then
		if IsRunning == nil then
			IsRunning = GetTime()
			IsStanding = nil
		end
		if GetTime() - IsRunning > time then
			return true
		end
	else
		if IsStanding == nil then
			IsStanding = GetTime()
			IsRunning = nil
		end
		if GetTime() - IsStanding > time then
			return false
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
--判断对象是否移动中
--参数：对象
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isMoving(Unit) 
	if GetUnitSpeed(Unit) > 0 then
		return true
	else
		return false
	end
end

-------------------------------------------------------------------------------------------------------------------
--判断是否已经掌握了技能
--参数：技能（ID号）
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isKnown(spellID)  
	local spellName = GetSpellInfo(spellID)
	if GetSpellBookItemInfo(tostring(spellName)) ~= nil then
		return true
	end
	-- if IsPlayerSpell(tonumber(spellID)) == true then
		-- return true
	-- end	
	return false
end

-------------------------------------------------------------------------------------------------------------------
--获得对象buff持续剩余时间
--参数：对象，buff，源
--返回：时间
-------------------------------------------------------------------------------------------------------------------
function getBuffRemain(Unit,BuffID,Source)
	if UnitBuffID(Unit,BuffID,Source) ~= nil then
		return (select(7,UnitBuffID_buff(Unit,BuffID,Source)) - GetTime())
	end
	return 0
end

-------------------------------------------------------------------------------------------------------------------
--获得对象buff层数
--参数：对象，buff，源
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getBuffStacks(unit,BuffID,Source)
	if UnitBuffID(unit,BuffID,Source) then
		return (select(4,UnitBuffID_buff(unit,BuffID,Source)))
	else
		return 0
	end
end

-------------------------------------------------------------------------------------------------------------------
--获得充能技能层数
--参数：技能
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getCharges(spellID)
	return select(1,GetSpellCharges(spellID))
end

-------------------------------------------------------------------------------------------------------------------
--获得充能技能剩余时间
--参数：技能
--返回：时间
-------------------------------------------------------------------------------------------------------------------
function getRecharge(spellID)
	local charges,maxCharges,chargeStart,chargeDuration = GetSpellCharges(spellID)
	if charges then
		if charges < maxCharges then
			chargeEnd = chargeStart + chargeDuration
			return chargeEnd - GetTime()
		end
		return 0
	end
end

-------------------------------------------------------------------------------------------------------------------
--获得对象debuff持续剩余时间
--参数：对象，debuff，源
--返回：时间
-------------------------------------------------------------------------------------------------------------------
function getDebuffRemain(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return (select(7,UnitDebuffID(Unit,DebuffID,Source)) - GetTime())
	end
	return 0
end

-------------------------------------------------------------------------------------------------------------------
--获得对象debuff层数
--参数：对象，debuff，源
--返回：时间
-------------------------------------------------------------------------------------------------------------------
function getDebuffStacks(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) then
		return (select(4,UnitDebuffID(Unit,DebuffID,Source)))
	else
		return 0
	end
end

-------------------------------------------------------------------------------------------------------------------
--获得对象连击点数
--参数：对象
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getCombo(Unit)
	return UnitPower(Unit,4) 
end

-------------------------------------------------------------------------------------------------------------------
--获得对象真气点数
--参数：对象
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getChi(Unit)
	return UnitPower(Unit,12)
end

-------------------------------------------------------------------------------------------------------------------
--获得对象最大真气点数
--参数：对象
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getChiMax(Unit)
	return UnitPowerMax(Unit,12)
end

-------------------------------------------------------------------------------------------------------------------
--获得对象恐能
--参数：对象
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getKL(Unit)
	return UnitPower(Unit,13)
end

-------------------------------------------------------------------------------------------------------------------
--获得对象间距离（模型边界到边界）
--参数：对象1，对象2（默认自己）
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getDistance(Unit1,Unit2)
	-- If Unit2 is nil we compare player to Unit1
	if Unit2 == nil then
		Unit2 = Unit1
		Unit1 = "player"
	end
	if UnitExists(Unit1) and UnitIsVisible(Unit1) == true
		and UnitExists(Unit2) and UnitIsVisible(Unit2) == true then
		
		return GetDistance(Unit1,Unit2) - (GetUnitBoundingRadius(Unit1) + GetUnitBoundingRadius(Unit2))
	else
		return 999
	end
end

-------------------------------------------------------------------------------------------------------------------
--指定技能是否可用
--参数：技能，是否检查移动状态（false为不检查）
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function canCast(SpellID,MovementCheck)
	local myCooldown = getSpellCD(SpellID) or 0
	
	if isKnown(SpellID) and IsUsableSpell(SpellID) and myCooldown < 0.1	and (MovementCheck == false or myCooldown == 0 or isMoving("player") ~= true or UnitBuffID("player",79206) ~= false or MovementCheck == nil) then
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------
--指定物品是否可用
--参数：物品（ID）
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function canUse(itemID)
	if itemID==0 then return false end
	if (GetItemCount(itemID,false,false) > 0  or itemID<19) then
		if itemID<=19 then
			if GetItemSpell(GetInventoryItemID("player",itemID))~=nil then 
				local slotItemID = GetInventoryItemID("player",itemID)
				if GetItemCooldown(slotItemID)==0 then
					return true
				end
			else
				return false
			end
		elseif itemID>19 and GetItemCooldown(itemID)==0 then
			return true
		else
			return false
		end
	else
		return false
	end
end

-------------------------------------------------------------------------------------------------------------------
--在自己与目标连线中间释放AOE技能
--参数：对象，技能
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function castGroundBetween(Unit,SpellID)
	if UnitExists(Unit) and getSpellCD(SpellID) <= 0.4 and CheckIntersection("player", Unit, {"Structure"}) then
		
		local X3,Y3,Z3,R3
		local Unit1pos = GetObjectPosition("player")
		local Unit2pos = GetObjectPosition(Unit)
		local Unit3pos = GetObjectPosition(Unit)
		local X1,Y1,Z1,R1 = Unit1pos.X,Unit1pos.Y,Unit1pos.Z,Unit1pos.R
		local X2,Y2,Z2,R2 = Unit2pos.X,Unit2pos.Y,Unit2pos.Z,Unit2pos.R		
		local X3,Y3,Z3,R3 = Unit3pos.X,Unit3pos.Y,Unit3pos.Z,Unit3pos.R	
			X3 = (X1+X2)/2
			Y3 = (Y1+Y2)/2
			Z3 = (Z1+Z2)/2
			R3 = R1
			Unit3pos.X = X3
			Unit3pos.Y = Y3
			Unit3pos.Z = Z3
			CastSpellByName(GetSpellInfo(SpellID),Unit)
			if IsAoeSpellPending() then
			ClickTerrain(Unit3pos)
			CancelAoeSpell()
			return true
			end
	end
	return false
end

-------------------------------------------------------------------------------------------------------------------
--获得技能释放的施法所需时间
--参数：技能
--返回：时间
-------------------------------------------------------------------------------------------------------------------
function getCastTime(spellID)
	local castTime = select(4,GetSpellInfo(spellID))/1000
	return castTime
end

-------------------------------------------------------------------------------------------------------------------
--获得对象技能施法剩余时间（还有多久将技能释放完毕）
--参数：对象
--返回：时间
-------------------------------------------------------------------------------------------------------------------
function getCastTimeRemain(unit)
	if UnitCastingInfo(unit) ~= nil then
		return select(6,UnitCastingInfo(unit))/1000 - GetTime()
	elseif UnitChannelInfo(unit) ~= nil then
		return select(6,UnitChannelInfo(unit))/1000 - GetTime()
	else
		return 0
	end
end

-------------------------------------------------------------------------------------------------------------------
--一键驱散
--参数：是否秒驱（布尔值）
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isDecursive(Break)
	if not DecursiveRootTable  then
		print("|cffff0000需要安装Decursive插件才能使用");
		return false;
	end
	local n = DecursiveRootTable["Dcr"]["Status"]["UnitNum"]
	local i;
	for i=1, n do
		local unit,Spell,IsCharmed,Debuff1Prio = isDecursive_EX(i)
		if unit then
			if UnitIsVisible(unit) and Spell then
				if canCast(Spell,false) then
					if Break then
						RunMacroText("/stopcasting");
						castSpell(unit,Spell,false,false);
					else
						castSpell(unit,Spell,false,false);
					end
					return true
				end
			end
		end
	end
end
function isDecursive_EX(id)
	local Dcr = DecursiveRootTable["Dcr"];
	local unit = Dcr.Status.Unit_Array[id]
	local f = Dcr["MicroUnitF"]["UnitToMUF"][unit]
	if not f then
		return false;
	end
	local IsDebuffed = f["IsDebuffed"]
	if IsDebuffed then
		local DebuffType = f["FirstDebuffType"]
		local Spell = Dcr.Status.CuringSpells[DebuffType]
		local IsCharmed = f["IsCharmed"]
		local Debuff1Prio = f["Debuff1Prio"]
		return unit,Spell,IsCharmed,Debuff1Prio
	end
end

-------------------------------------------------------------------------------------------------------------------
--自动获得据你指定距离内的敌对目标
--参数：距离
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function targetSeach(Radius)
	local tg
	if UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("player","target")  ) then
	  tg = nil
	  RunMacroText("/cleartarget")
	end
	local emt1,emtn = getTagertTable("player",Radius)
	for i=1,emtn do
	   if UnitExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("player","target")  then
		  tg="target"
		  return true
		  
	   else if UnitAffectingCombat("player") and tg == nil and UnitIsVisible(emt1[i]) and UnitExists(emt1[i]) and UnitCanAttack("player",emt1[i]) and not UnitIsDeadOrGhost(emt1[i]) and UnitAffectingCombat(emt1[i]) and getFacing(emt1[i],"player") then
			 tg = emt1[i]
			 TargetUnit(emt1[i])
			 return true
			      
		  end
	   end
	end
	return false
end

-------------------------------------------------------------------------------------------------------------------
--指定目标是否是Boss
--参数：对象
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isBoss(unit)
	if unit==nil then unit="target" end
	if UnitExists(unit) then
		local npcID = string.match(UnitGUID(unit),"-(%d+)-%x+$")
		local bossCheck = LibStub("LibBossIDs-1.0").BossIDs[tonumber(npcID)] or false
		if ((UnitClassification(unit) == "rare" and UnitHealthMax(unit)>(4*UnitHealthMax("player")))
			or UnitClassification(unit) == "rareelite" 
			or UnitClassification(unit) == "worldboss" 
			or (UnitClassification(unit) == "elite" and UnitHealthMax(unit)>(4*UnitHealthMax("player")) and select(2,IsInInstance())~="raid")--UnitLevel(unit) >= UnitLevel("player")+3) 
			or UnitLevel(unit) < 0)
				and not UnitIsTrivial(unit)
				and select(2,IsInInstance())~="party"
		then
			return true
		elseif bossCheck or isDummy() then
			return true
		else
			return false
		end
	else
		return false
	end
end

-------------------------------------------------------------------------------------------------------------------
--如果UnitID身上有SpellID内的某个来自于Filter的buff超过TimeLeft存在，返回true。
--参数：对象，Buff，时间点（Timeleft默认为0），源
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isBuffed(UnitID,SpellID,TimeLeft,Filter)
	if not TimeLeft then TimeLeft = 0 end
	if type(SpellID) == "number" then SpellID = { SpellID } end
	for i=1,#SpellID do
		local spell,rank = GetSpellInfo(SpellID[i])
		if spell then
			local buff = select(7,UnitBuff(UnitID,spell,rank,Filter))
			if buff and ( buff == 0 or buff - GetTime() > TimeLeft ) then return true end
		end
	end
end


-------------------------------------------------------------------------------------------------------------------
--如果player正在坐骑上，返回true。
--参数：无
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isBused()
    if IsMounted() == true then
        return true
    else
        return false
    end
end

-------------------------------------------------------------------------------------------------------------------
--如果Unit正在战斗中，返回true
--参数：单位
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isInCombat(Unit)
	if UnitAffectingCombat(Unit) then
		return true
	else
		return false
	end
end

-------------------------------------------------------------------------------------------------------------------
--如果Unit被群体控制技能控制，返回true
--参数：单位
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = {84868, 3355, 19386, 118, 28272, 28271, 61305, 61721, 161372, 61780, 161355, 126819, 161354, 115078, 20066, 9484, 6770, 1776, 51514, 107079, 10326, 8122, 154359, 2094, 5246, 5782, 5484, 6358, 115268, 339};

	-- {
	-- 	339,	-- Druid - Entangling Roots
	-- 	102359,	-- Druid - Mass Entanglement
	-- 	1499,	-- Hunter - Freezing Trap
	-- 	19386,	-- Hunter - Wyvern Sting
	-- 	118,	-- Mage - Polymorph
	-- 	115078,	-- Monk - Paralysis
	-- 	20066,	-- Paladin - Repentance
	-- 	10326,	-- Paladin - Turn Evil
	-- 	9484,	-- Priest - Shackle Undead
	-- 	605,	-- Priest - Dominate Mind
	-- 	6770,	-- Rogue - Sap
	-- 	2094,	-- Rogue - Blind
	-- 	51514,	-- Shaman - Hex
	-- 	710,	-- Warlock - Banish
	-- 	5782,	-- Warlock - Fear
	-- 	5484,	-- Warlock - Howl of Terror
	-- 	115268,	-- Warlock - Mesmerize
	-- 	6358,	-- Warlock - Seduction
	-- }
	for i=1,#longTimeCC do
		--local checkCC=longTimeCC[i]
		if UnitDebuffID(Unit,longTimeCC[i])~=nil then
			return true
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------------------------
--是否启用某天赋
--参数：行，列
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function getTalent(Row,Column)
	return select(4,GetTalentInfo(Row,Column,GetActiveSpecGroup())) or false
end

-------------------------------------------------------------------------------------------------------------------
--获取指定范围内血量低于某值的数量
--参数：距离，血量（1-100）
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getHealthNum(raidus,hp)
    local ht = getHealTable("player",raidus)
    local hht = 0
    local getHP = getHP
    if ht == nil then
        return false
    else
        for i=1,#ht do
            if getHP(ht[i]) <= hp then
                hht = hht + 1
            end
        end
    end
    return hht
end

-------------------------------------------------------------------------------------------------------------------
--将活着的坦克按绝对血量最大值的大小排列
--参数：坦克列表
--返回：列表
-------------------------------------------------------------------------------------------------------------------
compb = function(a, b) return UnitHealthMax(a) > UnitHealthMax(b) end
function tankChoice(tanks)
	-- body
	if type(tanks) ~= "table" then
		print("传入的不是表")
		return nil
	end
	local temp
    if tanks then
        for i=1,#tanks do 
            if i == 1 then
                temp = tanks[1]
            end
            if i ~= 1 then
                if UnitHealthMax(tanks[i]) > UnitHealthMax(tanks[1]) and not UnitIsDeadOrGhost(tanks[i]) then
                    temp = tanks[1]
                    tanks[1] = tanks[i]
                    tanks[i] = temp
                end
            end
        end
    end
    return tanks
end

-------------------------------------------------------------------------------------------------------------------
--获取坦克现有血量值最小的
--参数：坦克列表
--返回：列表
-------------------------------------------------------------------------------------------------------------------
function tanksMin(tanks)
	if type(tanks) ~= "table" then
		print("传入的不是表")
		return nil
	end
	local temp
    if tanks then
        for i=1,#tanks do 
            if i == 1 then
                temp = tanks[1]
            end
            if i ~= 1 then
                if UnitHealth(tanks[i]) < UnitHealth(tanks[1]) and not UnitIsDeadOrGhost(tanks[i]) then
                    temp = tanks[1]
                    tanks[1] = tanks[i]
                    tanks[i] = temp
                end
            end
        end
    end
    return tanks[1]
end

-------------------------------------------------------------------------------------------------------------------
--获取坦克列表
--参数：单位，范围
--返回：列表
-------------------------------------------------------------------------------------------------------------------
local function filtere(unit)
	-- body
	return not UnitIsDeadOrGhost(unit) and UnitIsVisible(unit) and UnitCanAssist("player",unit) and (UnitGroupRolesAssigned(unit) == "TANK") or UnitName(unit)=="防御者鸥图";
end
function getTanksTable(Unit,Radius)
    
    local tanks = {} 
    local ht = getFriendlyTable(Unit,Radius)
    if ht ~=nil then
        for i=1, #ht do
            if UnitGroupRolesAssigned(ht[i]) == "TANK" or UnitName(ht[i])=="防御者鸥图" then
                table.insert(tanks,ht[i])
            end
        end
    end
    return tanks
end
-------------------------------------------------------------------------------------------------------------------
--获取黎明之光的释放条件
--参数：血量
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function lmzg(hp)
	-- body
	local ht = getHealTable("player",15)
	local x = 0
	if ht then
		for i=1,#ht do
			if getFacing("player",ht[i],45) and getHP(ht[i]) <= hp then
				x=x+1
			end
		end
	end
	return x
end
-------------------------------------------------------------------------------------------------------------------
--获取进入战斗的时间
--参数：
--返回：时间
-------------------------------------------------------------------------------------------------------------------

function getCombatTime()
    if _G.data == nil then _G.data={};end
	local combatStarted = _G.data["Combat Started"]
	local combatTime = _G.data["Combat Time"]
	if combatStarted == nil then
		return 0
	end
	if combatTime == nil then
		combatTime = 0
	end
	if UnitAffectingCombat("player") == true then
		combatTime = (GetTime() - combatStarted)
	else
		combatTime = 0
	end
	_G.data["Combat Time"] = combatTime
	return (math.floor(combatTime*1000)/1000)
end
-------------------------------------------------------------------------------------------------------------------
--主动饰品是否可用
--参数：数字（1或2）
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function canTrinket(trinketSlot)
	if trinketSlot == 1 then trinketSlot = 13;end
	if trinketSlot == 2 then trinketSlot = 14;end
	if trinketSlot == 13 or trinketSlot == 14 then
		if trinketSlot == 13 and GetInventoryItemCooldown("player",13)==0 then
			return true
		end
		if trinketSlot == 14 and GetInventoryItemCooldown("player",14)==0 then
			return true
		end
	else
		return false
	end
end
-------------------------------------------------------------------------------------------------------------------
--使用指定技能在指定时间打断指定目标
--参数：技能，时间（1-100），目标
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function castInterrupt(SpellID,Percent,Unit)
if Unit == nil then Unit = "target" end
	if UnitExists(Unit) then
		local castName, _, _, _, castStartTime, castEndTime, _, _, castInterruptable = UnitCastingInfo(Unit)
		local channelName, _, _, _, channelStartTime, channelEndTime, _, channelInterruptable = UnitChannelInfo(Unit)
		-- first make sure we will be able to cast the spell
		if canCast(SpellID,false) == true then
			-- make sure we cover melee range
			local allowedDistance = select(6,GetSpellInfo(SpellID))
			if allowedDistance < 5 then
				allowedDistance = 5
			end
			--check for cast
			if channelName ~= nil then
				--target is channeling a spell that is interruptable
				--load the channel variables into the cast variables to make logic a little easier.
				castName = channelName
				castStartTime = channelStartTime
				castEndTime = channelEndTime
				castInterruptable = channelInterruptable
			end
			--This is actually Not Interruptable... so lets swap it around to use in the positive.
			if castInterruptable == false then
				castInterruptable = true
			else
				castInterruptable = false
			end
			--we can't attack the target.
			if UnitCanAttack("player",Unit) == nil then
				return false
			end
			if castInterruptable then
				--target is casting something that is interruptable.
				--the following 2 variables are named logically... value is in seconds.
				local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
				local timeLeft = ((GetTime() * 1000 - castEndTime) * -1) / 1000
				local castTime = castEndTime - castStartTime
				local currentPercent = timeSinceStart / castTime * 100000
				--interrupt percentage check
				if currentPercent > Percent then
					return false
				end
				--cast the spell
				if getDistance("player",Unit) < allowedDistance then
					if castSpell(Unit,SpellID,false,false) then
						return true
					end
				end
			end
		end
	end
	return false
end
-------------------------------------------------------------------------------------------------------------------
--取消指定buff
--参数：目标，buffid，源
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function CancelUnitBuffID(unit,spellID,filter)
	--local spellName = GetSpellInfo(spellID)
	for i=1,40 do
		local _,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitBuff(unit,i)
		if buffSpellID ~= nil then
			if buffSpellID == spellID then
				CancelUnitBuff(unit,i);
				return true
			end
		else
			return false
		end
	end
end
-------------------------------------------------------------------------------------------------------------------
--指定目标是否是存在可攻击的目标
--参数：目标
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isValidUnit(Unit)
	if ObjectExists(Unit) and not UnitIsDeadOrGhost(Unit) then
		if not UnitAffectingCombat("player") and UnitIsUnit(Unit,"target") and (select(2,IsInInstance()) == "none" or hasThreat(Unit) or isDummy(Unit)) and UnitCanAttack(Unit, "player") then
			return true
		end
		if UnitAffectingCombat("player") and (hasThreat(Unit) or isDummy(Unit) or (ObjectExists("target") and UnitAffectingCombat("target"))) then
			return true
		end
	end
	return false
end
-------------------------------------------------------------------------------------------------------------------
--指定目标之间是否是有仇恨
--参数：目标1，目标2
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function hasThreat(unit,playerUnit)
	local unit = unit or "target"
	local playerUnit = playerUnit or "player"
	local unitThreat = UnitThreatSituation(playerUnit, unit)~=nil
	local targetOfTarget 
	local targetFriend
	if UnitExists("targettarget") then targetOfTarget = UnitTarget(unit) else targetOfTarget = "player" end
	if UnitExists("targettarget") then targetFriend = (UnitInParty(targetOfTarget) or UnitInRaid(targetOfTarget)) else targetFriend = false end

		if unitThreat then 
			return true
		elseif targetFriend then
			return true
		end
	-- end
	return false
end
-------------------------------------------------------------------------------------------------------------------
--指定目标是否是木桩
--参数：目标
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isDummy(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if UnitExists(Unit) and UnitGUID(Unit) then
		local dummies = {
		-- Misc/Unknown
			[79987]  = "Training Dummy", 	          -- Location Unknown
			[92169]  = "Raider's Training Dummy",     -- Tanking (Eastern Plaguelands)
			[96442]  = "Training Dummy", 			  -- Damage (Location Unknown)
			[109595] = "Training Dummy",              -- Location Unknown
			[113963] = "Raider's Training Dummy", 	  -- Damage (Location Unknown)
		-- Level 1
			[17578]  = "Hellfire Training Dummy",     -- Lvl 1 (The Shattered Halls)
			[60197]  = "Training Dummy",              -- Lvl 1 (Scarlet Monastery)
			[64446]  = "Training Dummy",              -- Lvl 1 (Scarlet Monastery)
		-- Level 3	
			[44171]  = "Training Dummy",              -- Lvl 3 (New Tinkertown, Dun Morogh)
			[44389]  = "Training Dummy",              -- Lvl 3 (Coldridge Valley)
			[44848]  = "Training Dummy", 			  -- Lvl 3 (Camp Narache, Mulgore)
			[44548]  = "Training Dummy",              -- Lvl 3 (Elwynn Forest)
			[44614]  = "Training Dummy",              -- Lvl 3 (Teldrassil, Shadowglen)
			[44703]  = "Training Dummy", 			  -- Lvl 3 (Ammen Vale)
			[44794]  = "Training Dummy", 			  -- Lvl 3 (Dethknell, Tirisfal Glades)
			[44820]  = "Training Dummy",              -- Lvl 3 (Valley of Trials, Durotar)
			[44937]  = "Training Dummy",              -- Lvl 3 (Eversong Woods, Sunstrider Isle)
			[48304]  = "Training Dummy",              -- Lvl 3 (Kezan)
		-- Level 55	
			[32541]  = "Initiate's Training Dummy",   -- Lvl 55 (Plaguelands: The Scarlet Enclave)
			[32545]  = "Initiate's Training Dummy",   -- Lvl 55 (Eastern Plaguelands)
		-- Level 60
			[32666]  = "Training Dummy",              -- Lvl 60 (Siege of Orgrimmar, Darnassus, Ironforge, ...)
		-- Level 65
			[32542]  = "Disciple's Training Dummy",   -- Lvl 65 (Eastern Plaguelands)
		-- Level 70
			[32667]  = "Training Dummy",              -- Lvl 70 (Orgrimmar, Darnassus, Silvermoon City, ...)
		-- Level 75
			[32543]  = "Veteran's Training Dummy",    -- Lvl 75 (Eastern Plaguelands)
		-- Level 80
			[31144]  = "Training Dummy",              -- Lvl 80 (Orgrimmar, Darnassus, Ironforge, ...)
			[32546]  = "Ebon Knight's Training Dummy",-- Lvl 80 (Eastern Plaguelands)
		-- Level 85
			[46647]  = "Training Dummy",              -- Lvl 85 (Orgrimmar, Stormwind City)
		-- Level 90
			[67127]  = "Training Dummy",              -- Lvl 90 (Vale of Eternal Blossoms)
		-- Level 95	
			[79414]  = "Training Dummy",              -- Lvl 95 (Broken Shore, Talador)
		-- Level 100
			[87317]  = "Training Dummy",              -- Lvl 100 (Lunarfall, Frostwall) - Damage
			[87321]  = "Training Dummy",              -- Lvl 100 (Stormshield) - Healing
			[87760]  = "Training Dummy",              -- Lvl 100 (Frostwall) - Damage
			[88289]  = "Training Dummy",              -- Lvl 100 (Frostwall) - Healing
			[88316]  = "Training Dummy",              -- Lvl 100 (Lunarfall) - Healing
			[88835]  = "Training Dummy",              -- Lvl 100 (Warspear) - Healing
			[88906]  = "Combat Dummy",                -- Lvl 100 (Nagrand)
			[88967]  = "Training Dummy",              -- Lvl 100 (Lunarfall, Frostwall)
			[89078]  = "Training Dummy",              -- Lvl 100 (Frostwall, Lunarfall)
		-- Levl 100 - 110
			[92164]  = "Training Dummy", 			  -- Lvl 100 - 110 (Dalaran) - Damage
			[92165]  = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Eastern Plaguelands) - Damage
			[92167]  = "Training Dummy",              -- Lvl 100 - 110 (The Maelstrom, Eastern Plaguelands, The Wandering Isle)
			[92168]  = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (The Wandering Isles, Easter Plaguelands)
			[100440] = "Training Bag", 				  -- Lvl 100 - 110 (The Wandering Isles)
			[100441] = "Dungeoneer's Training Bag",   -- Lvl 100 - 110 (The Wandering Isles)
			[102045] = "Rebellious Wrathguard",       -- Lvl 100 - 110 (Dreadscar Rift) - Dungeoneer
			[102048] = "Rebellious Felguard",         -- Lvl 100 - 110 (Dreadscar Rift)
			[102052] = "Rebellious Imp", 			  -- Lvl 100 - 110 (Dreadscar Rift) - AoE
			[103402] = "Lesser Bulwark Construct",    -- Lvl 100 - 110 (Hall of the Guardian)
			[103404] = "Bulwark Construct",           -- Lvl 100 - 110 (Hall of the Guardian) - Dungeoneer
			[107483] = "Lesser Sparring Partner",     -- Lvl 100 - 110 (Skyhold)
			[107555] = "Bound Void Wraith",           -- Lvl 100 - 110 (Netherlight Temple)
			[107557] = "Training Dummy",              -- Lvl 100 - 110 (Netherlight Temple) - Healing
			[108420] = "Training Dummy",              -- Lvl 100 - 110 (Stormwind City, Durotar)
			[111824] = "Training Dummy", 			  -- Lvl 100 - 110 (Azsuna)
			[113674] = "Imprisoned Centurion",        -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Dungeoneer
			[113676] = "Imprisoned Weaver", 	      -- Lvl 100 - 110 (Mardum, the Shattered Abyss)
			[113687] = "Imprisoned Imp",              -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Swarm
			[113858] = "Training Dummy",              -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113859] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113862] = "Training Dummy",              -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113863] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113871] = "Bombardier's Training Dummy", -- Lvl 100 - 110 (Trueshot Lodge) - Damage
			[113966] = "Dungeoneer's Training Dummy", -- Lvl 100 - 110 - Damage
			[113967] = "Training Dummy",              -- Lvl 100 - 110 (The Dreamgrove) - Healing
			[114832] = "PvP Training Dummy",          -- Lvl 100 - 110 (Stormwind City)
			[114840] = "PvP Training Dummy",          -- Lvl 100 - 110 (Orgrimmar)
		-- Level 102
			[87318]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall) - Damage
			[87322]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Stormshield) - Tank
			[87761]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall) - Damage
			[88288]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall) - Tank
			[88314]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall) - Tank
			[88836]  = "Dungeoneer's Training Dummy", -- Lvl 102 (Warspear) - Tank	
			[93828]  = "Training Dummy",              -- Lvl 102 (Hellfire Citadel)
			[97668]  = "Boxer's Trianing Dummy",      -- Lvl 102 (Highmountain)
			[98581]  = "Prepfoot Training Dummy",     -- Lvl 102 (Highmountain)
		-- Level ??		
			[24792]  = "Advanced Training Dummy",     -- Lvl ?? Boss (Location Unknonw)
			[30527]  = "Training Dummy", 		      -- Lvl ?? Boss (Location Unknonw)
			[31146]  = "Raider's Training Dummy",     -- Lvl ?? (Orgrimmar, Stormwind City, Ironforge, ...)
			[70245]  = "Training Dummy",              -- Lvl ?? (Throne of Thunder)
			[87320]  = "Raider's Training Dummy",     -- Lvl ?? (Lunarfall, Stormshield) - Damage
			[87329]  = "Raider's Training Dummy",     -- Lvl ?? (Stormshield) - Tank
			[87762]  = "Raider's Training Dummy",     -- Lvl ?? (Frostwall, Warspear) - Damage
			[88837]  = "Raider's Training Dummy",     -- Lvl ?? (Warspear) - Tank
			[92166]  = "Raider's Training Dummy",     -- Lvl ?? (The Maelstrom, Dalaran, Eastern Plaguelands, ...) - Damage
			[101956] = "Rebellious Fel Lord",         -- lvl ?? (Dreadscar Rift) - Raider
			[103397] = "Greater Bulwark Construct",   -- Lvl ?? (Hall of the Guardian) - Raider
			[107202] = "Reanimated Monstrosity", 	  -- Lvl ?? (Broken Shore) - Raider
			[107484] = "Greater Sparring Partner",    -- Lvl ?? (Skyhold)
			[107556] = "Bound Void Walker",           -- Lvl ?? (Netherlight Temple) - Raider
			[113636] = "Imprisoned Forgefiend",       -- Lvl ?? (Mardum, the Shattered Abyss) - Raider
			[113860] = "Raider's Training Dummy",     -- Lvl ?? (Trueshot Lodge) - Damage
			[113864] = "Raider's Training Dummy",     -- Lvl ?? (Trueshot Lodge) - Damage
			[113964] = "Raider's Training Dummy",     -- Lvl ?? (The Dreamgrove) - Tanking
		}
		if dummies[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] ~= nil then
			return true
		end
	end
end
-------------------------------------------------------------------------------------------------------------------
--目标是否活着，死了返回true
--参数：目标
--返回：布尔值
-------------------------------------------------------------------------------------------------------------------
function isAlive(Unit)
	-- body
	return UnitIsDeadOrGhost(Unit)
end
-------------------------------------------------------------------------------------------------------------------
--返回当前在小队还是团队
--参数：无
--返回："raid"/"party"
-------------------------------------------------------------------------------------------------------------------
function getGroupType()
	-- body
	local grouptype = ""
	if GetNumGroupMembers()>5 then
	    grouptype="raid"
	else
	    grouptype="party"
	end
	return grouptype;
end
-------------------------------------------------------------------------------------------------------------------
--返回周围却血量最大的中心人物
--参数：距离,血线
--返回：unit
-------------------------------------------------------------------------------------------------------------------
function getUnitHealAoe(raidus,hp)
	-- body
	local htb = getHealTable("player",raidus)
	local getUnitHealthNum = getUnitHealthNum
	local temp = htb[1]
	if temp == nil then
		return false
	end
	for i=1,#htb do
		if i == 1 then
			temp = htb[1]
		elseif getUnitHealthNum(htb[i],10,hp) > getUnitHealthNum(htb[1],10,hp) then
			temp = htb[1]
			htb[1] = htb[i]
			htb[i] = temp
		end
	end
	if getUnitHealthNum(htb[1],10,hp) > 0 then
		return htb[1] or false
	else
		return false
	end
end
-------------------------------------------------------------------------------------------------------------------
--获取指定目标的指定范围内血量低于某值的数量
--参数：单位，距离，血量（1-100）
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getUnitHealthNum(unit,raidus,hp)
    local ht = getHealTable(unit,raidus)
    local hht = 0
    local getHP = getHP
    if ht == nil then
        return 0
    else
        for i=1,#ht do
            if getHP(ht[i]) <= hp then
                hht = hht + 1
            end
        end
    end
    return hht
end
-------------------------------------------------------------------------------------------------------------------
--获取指定目标周围平均缺血情况
--参数：单位，距离
--返回：平均缺血百分比,平均缺血量,总缺血量
-------------------------------------------------------------------------------------------------------------------
function HealLevel(Unit,Radius)
	-- body
	local ht = getHealTable(Unit,Radius)
	local aoi = 0
	local aoo = 0
	local num = getUnitHealthNum(Unit,Radius,100)
	if ht == nil then
		return 100,1000000000,1000000000
	elseif ht then
		for i=1,#ht do
			aoi = aoi + UnitHealthMax(ht[i]) - UnitHealth(ht[i])
			aoo = aoo + 100 - getHP(ht[i])
		end
		return aoo/num,aoi/num,aoi
	else
		return 100,1000000000,1000000000
	end
end
-------------------------------------------------------------------------------------------------------------------
--获取最适合的AOE目标
--参数：类别（1为敌对AOE，2为治疗AOE）,距自身距离，技能范围,最低人数，[治疗aoe的血线]
--返回：单位，数量
-------------------------------------------------------------------------------------------------------------------
function getAoeTarget(TYPE,dist,range,num,hp)
	local ht = getHealTable("player",dist)
	local emt = getEnemiesTable("player",dist)
    if emt ==nil or ht ==nil then return nil;end
	local tg
	local temp1
	local temp2
	if hp == nil then hp = 90; end
	if TYPE == 1 and emt~=nil and ht~=nil then
		for i=1,#emt do			
				if getUnitEnemiesNum(emt[1],range) < getUnitEnemiesNum(emt[i],range) then
					emt[1] = emt[i]					
				end			
		end
		for i=1,#ht do			
				if getUnitEnemiesNum(ht[1],range) < getUnitEnemiesNum(ht[i],range) then
					ht[1] = ht[i]					
				end			
		end
		if getUnitEnemiesNum(emt[1],range) >= getUnitEnemiesNum(ht[1],range) and getUnitEnemiesNum(emt[1],range) >= num    then
			return emt[1],getUnitEnemiesNum(emt[1],range)
		elseif getUnitEnemiesNum(emt[1],range) < getUnitEnemiesNum(ht[1],range) and getUnitEnemiesNum(ht[1],range) >= num then
			return ht[1],getUnitEnemiesNum(emt[1],range)
		else
			return nil
		end
	end
	if TYPE == 2 and emt~=nil and ht~=nil then
		for i=1,#emt do			
			if getUnitHealthNum(emt[1],range,hp) < getUnitHealthNum(emt[i],range,hp) then
				emt[1] = emt[i]					
			end			
		end
		for i=1,#ht do			
			if getUnitHealthNum(ht[1],range,hp) < getUnitHealthNum(ht[i],range,hp) then
				ht[1] = ht[i]					
			end			
		end
		if getUnitHealthNum(emt[1],range,hp) >= getUnitHealthNum(ht[1],range,hp) and getUnitHealthNum(emt[1],range,hp) >= num then
			return emt[1],getUnitHealthNum(emt[1],range,hp)
		elseif getUnitHealthNum(emt[1],range,hp) < getUnitHealthNum(ht[1],range,hp) and getUnitHealthNum(ht[1],range,hp) >= num then
			return ht[1],getUnitHealthNum(emt[1],range,hp)
		else
			return nil
		end
	end
	-- if TYPE == 3 and emt~=nil and ht ~=nil then
	-- 	for i=1,#emt do			
	-- 		if getUnitHealthNum(emt[1],range,hp) < getUnitHealthNum(emt[i],range,hp) then
	-- 			emt[1] = emt[i]					
	-- 		end			
	-- 	end
		
	-- 	return emt[1],getUnitHealthNum(emt[1],range,hp)
		
	-- end
	return false
end
-------------------------------------------------------------------------------------------------------------------
--获取指定目标的指定范围内敌对目标的数量
--参数：单位，距离
--返回：数值
-------------------------------------------------------------------------------------------------------------------
function getUnitEnemiesNum(unit,raidus)
    local ht = getTagertTable(unit,raidus)
    local hht = 0
    if ht == nil then
        return 0
    else
        return #ht
    end
    return 0
end
-------------------------------------------------------------------------------------------------------------------
--获取上一个释放成功的技能和距今时间
--参数：无
--返回：时间，技能ID
-------------------------------------------------------------------------------------------------------------------
function getCastSpellTime()
    --if _G.Last_Spell_Success == nil then _G.Last_Spell_Success ={};end
       
    if _G.lastspell_cast == nil then return false;end
    if _G.lastspell_time ~= nil then
    local ht = _G.lastspell_cast
    local hht = _G.lastspell_time
    return math.floor((GetTime()-hht)*1000)/1000,ht
    end
end
-------------------------------------------------------------------------------------------------------------------
--获取上一个释放失败的技能和距今时间
--参数：无
--返回：时间，技能ID
-------------------------------------------------------------------------------------------------------------------
function getFailedSpellTime()
    --if _G.Last_Spell_Success == nil then _G.Last_Spell_Success ={};end
       
    if _G.lastspell_failed == nil then return false;end
    if _G.lastspell_failedtime ~= nil then
    local ht = _G.lastspell_failed
    local hht = _G.lastspell_failedtime
    return math.floor((GetTime()-hht)*1000)/1000,ht
    end
end
-------------------------------------------------------------------------------------------------------------------
--获取某一目标的目标
--参数：目标
--返回：目标
-------------------------------------------------------------------------------------------------------------------
function getUnitTarget(Unit)           
    local target = GetUnitTarget(Unit)
    if target ~= nil then
    return GetObject(target)
    else return nil
    end
end
