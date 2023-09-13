-- Can create multiple policy profiles - these are attached to
-- different groups of policies etc.

-- Each row represents a group of policies.    
-- Note: Limit, SIR, TotalValue and MaxLoss are all applied before 
-- application of the participation percentage.
data PolicyLimitProfile = PolicyLimitProfile
    {
      minLimit      :: Maybe Double -- Minimum limit for the group - if omitted equal to MaxLimit
    , maxLimit      :: Double       -- Maximum limit for the group - can be omitted
    , risks         :: Int          -- Count of policies represented by the group. Used for sample weights.
    , cessionRate   :: Maybe Double -- Only used by variable quotashare. Can have multiple.
    , sir           :: Maybe Double -- Self-Insured Retention. If omitted - zero.
    , maxLoss       :: Maybe Double -- When randomly sampling - rows with MaxLoss less than the loss generated are excluded from sample. If all omitted, select the largest row.
    , totalValue    :: Maybe Double -- Total Insured Value - 
    , participation :: Maybe Double -- Percentage share of the policy written by the company. If omitted - assumed 100%.
    , premium       :: Maybe Double -- Premium associated with policies in the row.
    }


data SubjectPremium = SubjectPremium Double

data ContractPremium = ContractPremium Double

data SubjectLoss = SubjectLoss Double

data ContractLoss = ContractLoss Double

type Commission = Double

data ContractBrokerage = ContractBrokerage Double

data ContractReinsurerExpense = ContractReinsurerExpense Double

type ParticipationPercentage = Double

type PlacementPercentage = Double

type PremiumRate = Double

-- Clause Calculation Definitions 

participationClause :: Losses -> ParticipationPercentage -> Losses
participationClause losses participationPercentage = 
    map (*participationPercentage) losses


data PlacementRecord = PlacementRecord
    {
      cededLoss        :: [ContractLoss]
    , cededPremium     :: ContractPremium
    , cedingCommission :: Commission
    , brokerage        :: Brokerage
    , reinsurerExpense :: ReinsurerExpense    
    }

-- General percentage placement used across all values
placementClause :: PlacementRecord -> PlacementPercentage -> PlacementRecord
placementClause 
    placementRecord@(P { cededLoss = cededLoss
                       , cededPremium = cededPremium
                       , cedingCommission = cedingCommission
                       , brokerage = brokerage
                       , reinsurerExpense = reinsurerExpense
                       }) 
    placementPercentage = 
    placementRecord 
        { cededLoss = map (*placementPercentage) cededLoss
        , cededPremium = placementPercentage * cededPremium
        , cedingCommission = placementPercentage * cedingCommission
        , brokerage = placementPercentage * brokerage
        , reinsurerExpense = placementPercentage * reinsurerExpense
        }

-- Converts between subject premium (that paid to the insurer) to
-- contract premium paid from the insurer to the reinsurer.
rateOnPremium :: SubjectPremium -> PremiumRate -> ContractPremium
rateOnPremium (SubjectPremium premium) rate = 
    ContractPremium (premium * rate)


data ReinsurerExpenseRecord = ReinsurerExpenseRecord
    {
      reinsurerExpenseRate :: ReinsurerExpenseRate
    , brokerageRate :: BrokerageRate
    , additionalPremiumReinsurerExpenseRate :: ReinsurerExpenseRate
    , additionalPremiumBrokerageRate :: BrokerageRate
    }


reinsurerExpense :: ReinsurerExpenseRecord -> SubjectPremium -> SubjectPremium -> (ContractBrokerage, ContractReinsurerExpense)
reinsurerExpense reinsurerExpenseRecord additionalPremium subjectPremium =
    let 
        premium = subjectPremium + additionlPremium
        brokerage = reinsurerExpenseRecord.brokerageRate + reinsurerExpenseRecord.additionalPremiumBrokerageRate
        expense = reinsurerExpenseRecord.expenseRate + reinsurerExpenseRecord.additionalPremiumExpenseRate
    in
        (ContractBrokerage (premium * brokerage), ContractReinsurerExpense (premium * expense))


-- Requires a "policy profile" - look this up.
surplusShare Maybe Double -> Maybe Double -> Double -> Double
surplusShare numberOfLines maxLineSize retainedLine =
    let cededLimit = policyLimit * participation
        maxLine = 
            case numberOfLines, maxLineSize of
                (Just n, Nothing) -> n * retainedLine
                (Nothing, Just m) -> m
        percentCeded = min(maxLine, max(cededLimit - RetainedLine, 0)) / cededLimit
        weightedAveragePercent =
            -- to be calculated.
    in
        -- Random limits -> random ceded loss amounts
        -- Constant percentage for ceded premium


variableQuotaShareClause = undefined

tabularQuotaShareClause = undefined

cedingCommissionClause = undefined

profitCommissionClause = undefined

swingRatePremiumClause = undefined

lossCorridorClause = undefined

perOccurrenceExcessClause = undefined

perRiskExcessClause = undefined

aggregateExcessClause = undefined

proportionalALAEExcessClause = undefined

indexedOccurrenceExcessClause = undefined

excessWithHoursClause = undefined

reinstatementsClauses = undefined

-- Something to deal with the case of "largest losses" = undefined

-- General framework to do arbitrary calculations with the values.


