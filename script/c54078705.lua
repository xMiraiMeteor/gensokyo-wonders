--Marisa the Excruciatingly Ordinary Magician
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsRace,RACE_SPELLCASTER),1,99)
	--Cannot be destroyed by effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --Opponent's monsters DEF down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.defval)
	c:RegisterEffect(e2)
	--Neither player can activate the effects of monsters with 1000 or less DEF
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetCondition(function(e) return e:GetHandler():IsSynchroSummoned() end)
	e3:SetValue(function(e,re,tp) return re:IsMonsterEffect() and re:GetHandler():IsDefenseBelow(1000) end)
	c:RegisterEffect(e3)
end
function s.defval(e,c)
	local val=math.max(c:GetBaseAttack(),0)
	return val*-1
end