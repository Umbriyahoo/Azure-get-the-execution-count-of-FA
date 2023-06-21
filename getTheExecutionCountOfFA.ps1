#To get the execution count of FA

connect-azaccount

$subscriptionList = Get-AzSubscription -ErrorAction silentlyContinue

$select = $subscriptionList | Select SubscriptionId, Name, State, TenantId | Out-GridView -OutputMode Multiple -Title "Please select a subscription"

$subscriptionId = $select.SubscriptionId


# Set the subscription context
Set-AzContext -SubscriptionId $subscriptionId

# Provide the resource group and Function App name
$resourceGroupName = "your_RG_name"
$functionAppName = "your_function_app_name"

# Set the time range for the last 24 hours
$startTime = (Get-Date).AddDays(-1)
$endTime = Get-Date

# Get the execution count metric
$metric = Get-AzMetric -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/$functionAppName" -MetricName "FunctionExecutionCount" -StartTime $startTime -EndTime $endTime -TimeGrain 01:00:00 -Aggregation Total

# Extract the execution count
$executionCount = $metric.Data | Measure-Object -Property Total -Sum | Select-Object -ExpandProperty Sum

# Print the execution count
Write-Host "Function App Execution Count (Last 24 hours): $executionCount"
