function Assert-Type {
    param (
        [Parameter(Position=1, ValueFromPipeline=$true)]
        $Actual, 
        [Parameter(Position=0)]
        [Type]$Expected,
        [String]$Message
    )

    $Actual = Collect-Input -ParameterInput $Actual -PipelineInput $local:Input
    if ($Actual -isnot $Expected) 
    { 
        $type = [string]$Expected
        $Message = Get-AssertionMessage -Expected $Expected -Actual $Actual -Message $Message -DefaultMessage "Expected value to be of type '$type', but got '<actual>' of type '<actualType>'."
        throw [Assertions.AssertionException]$Message
    }

    $Actual
}
