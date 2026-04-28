--Sanae the Shrine Maiden of Moriya Shrine
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon self from hand and negate Spell/Trap Card activation
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spnegcon)
    e1:SetTarget(s.spnegtg)
    e1:SetOperation(s.spnegop)
    c:RegisterEffect(e1)
    aux.DoubleSnareValidity(c,LOCATION_HAND)
    --Change opponent's activated monster effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.chcon)
	e2:SetCost(s.chcost)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end
function s.negcfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x382) or c:IsSetCard(0x31e))
end
function s.spnegcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==1-tp and re:IsSpellTrapEffect() and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(s.negcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spnegtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.spnegop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.NegateEffect(ev)
    end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp and re:IsMonsterEffect()
end
function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST|REASON_DISCARD)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,1000,REASON_EFFECT)
    Duel.Recover(1-tp,1000,REASON_EFFECT)
end