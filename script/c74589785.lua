--Neo Galaxy
--Keddy was here~
local id,cod=74589785,c74589785
function cod.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
	--Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(cod.spcost)
	e2:SetTarget(cod.sptg)
	e2:SetOperation(cod.spop)
	c:RegisterEffect(e2)
end
function cod.gfilter(c)
	return c:IsSetCard(0x1f) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cod.gfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cod.fusfilter(c)
	return c:IsCanBeFusionMaterial() and (c:IsCode(89943723) or c:IsSetCard(0x1f))
end
function cod.cfilter(c,tp)
	local g=Duel.GetMatchingGroup(cod.fusfilter,tp,LOCATION_DECK,0,nil)
	return (c:IsCode(89943723) or c:IsSetCard(0x1f)) 
		and Duel.IsExistingMatchingCard(cod.spfilter,tp,LOCATION_EXTRA,0,1,nil,g,c)
end
function cod.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cod.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,cod.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function cod.spfilter(c,m,gc)
	return c:IsSetCard(0x9) and c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(m,gc) and not c:IsCode(31111109)
end
function cod.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cod.nfilter(c)
	return not c:IsCode(89943723)
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cod.fusfilter,tp,LOCATION_DECK,0,nil)
	local oc=e:GetLabelObject()
	if not oc then return end
	if oc:GetPreviousCodeOnField()==89943723 then
		g=g:Filter(cod.nfilter,nil)
	end
	local fg=Duel.GetMatchingGroup(cod.spfilter,tp,LOCATION_EXTRA,0,nil,g,oc)
	if fg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=fg:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,true,false)
	if sg:GetCount()==0 then return end
	local tc=sg:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local mg=Duel.SelectFusionMaterial(tp,tc,g)
	if mg:GetCount()>0 then
		mg:AddCard(oc)
		tc:SetMaterial(mg)
		Duel.SendtoGrave(mg,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCategory(CATEGORY_TODECK)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCondition(cod.retcon)
		e1:SetTarget(cod.rettg)
		e1:SetOperation(cod.retop)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cod.rfilter(c,e)
	return c==e:GetLabelObject() and c:IsLocation(LOCATION_EXTRA)
end
function cod.retcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cod.rfilter,1,nil,e)
end
function cod.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if not tc then return end
	local g=tc:GetMaterial()
	if chk==0 then return g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) end
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,sg:GetCount(),0,0)
end
function cod.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end