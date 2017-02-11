--Elemental HERO Galactic Neos
--Keddy was here~
local id,cod=24561879,c24561879
function cod.initial_effect(c)
	--Name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(89943723)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cod.cost)
	e2:SetTarget(cod.sptg)
	e2:SetOperation(cod.spop)
	c:RegisterEffect(e2)
	--Effect Gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(cod.efcon)
	e3:SetOperation(cod.efop)
	c:RegisterEffect(e3)
end
function cod.cfilter(c)
	return c:IsSetCard(0x1f) and c:IsDiscardable()
end
function cod.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cod.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cod.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cod.efcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return r==REASON_COST and rc:IsSetCard(0x9) and rc:IsType(TYPE_FUSION)
end
function cod.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(42015635)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetLabelObject(rc)
	e1:SetTarget(cod.nev)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	Duel.RegisterEffect(e1,tp)
end
function cod.nev(e,c)
	return c==e:GetLabelObject()
end