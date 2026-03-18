--Reimu the Eternal Shrine Maiden
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsRace,RACE_SPELLCASTER),1,99)
    --Battle indestructible
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --Swap ATK and DEF of opponent's monsters while in DEF pos
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SWAP_BASE_AD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.con)
	c:RegisterEffect(e2)
    --Defense attack (ATK applied)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e3)
end
function s.con(e)
	return e:GetHandler():IsDefensePos()
end