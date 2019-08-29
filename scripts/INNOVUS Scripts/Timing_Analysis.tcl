 
setAnalysisMode -checkType setup -asyncChecks async -skew true  -clockPropagation forcedIdeal -moduleIOCstr true -timeBorrowing false
setDelayCalMode -ignoreNetLoad true
buildTimingGraph


report_timing -max_path 100 > TIMING_ANALYSIS/report_timing.txt

############################### useful paramaters
# -from
#-to
# -through
#-rise
#-fall
#-nworst
#-format

reportCapViolation -all > TIMING_ANALYSIS/reportCapViolation.txt
reportTranViolation -all > TIMING_ANALYSIS/reportTranViolation.txt
reportFanoutViolation -all > TIMING_ANALYSIS/reportFanoutViolation.txt
