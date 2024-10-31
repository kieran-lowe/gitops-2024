package infracost # You must specify infracost as the Rego package name

# Each file can have a number of "deny" rules that must return an "out" object
# with keys "msg" & "failed". You can write as many "deny[out]" rule sets as you wish. 
# You can read more about rule definitions in Rego here: https://www.openpolicyagent.org/docs/latest/policy-language/#rules
deny[out] {
  # maxDiff defines the threshold that you require the cost estimate to be below
  maxDiff = 10.0

  # msg defines the output that will be shown in PR comments under the Policy Checks/Failures section
  msg := sprintf(
    "Total monthly cost diff must be less than $%.2f (actual diff is $%.2f)",
    [maxDiff, to_number(input.diffTotalMonthlyCost)],
  )

  # out defines the output for this policy. This output must be formatted with a `msg` and `failed` property.
  out := {
    # the msg you want to display in your PR comment, must be a string
    "msg": msg,
    # a boolean value that determines if this policy has failed.
    # In this case if the Infracost breakdown output diffTotalMonthlyCost is greater that $5000
    "failed": to_number(input.diffTotalMonthlyCost) >= maxDiff
  }
}
