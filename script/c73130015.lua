--Maybell the True Adjucator
--Keddy was here~
local id,cod=73130015,c73130015
function cod.initial_effect(c)
	--Xyz Summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	--Treat as Tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(cod.tncost)
	e1:SetTarget(cod.tntg)
	e1:SetOperation(cod.tnop)
	c:RegisterEffect(e1)
	--Increase/Decrease Rank
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id+1)
    e2:SetTarget(cod.rktg)
    e2:SetOperation(cod.rkop)
    c:RegisterEffect(e2)
end
function cod.tncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cod.tfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRankAbove(1)
end
function cod.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chck)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cod.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cod.tfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cod.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cod.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_RANK_LEVEL_S)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function cod.cfilter(c)
    return c:IsFaceup() and c:IsRankAbove(1)
end
function cod.rktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cod.cfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cod.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,cod.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    local op=0
    if tc:GetRank()==1 then op=Duel.SelectOption(tp,aux.Stringid(id,2))
    else op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) end
    e:SetLabel(op)
end
function cod.rkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_UPDATE_RANK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        if e:GetLabel()==0 then
            e1:SetValue(1)
        else e1:SetValue(-1) end
        tc:RegisterEffect(e1)
    end
end
