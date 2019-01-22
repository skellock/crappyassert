import os, strutils, terminal

type
    Pos = tuple [filename: string, line: int, column: int]

# printing helpers

proc dimRed(value: string)  = stderr.styledWrite(styleDim, fgRed, value)
proc dim(value: string)     = stderr.styledWrite(styleDim, value)
proc boldRed(value: string) = stderr.styledWrite(styleBright, fgRed, value)
proc normal(value: string)  = stderr.write(value)

template errLine(body: untyped) =
    dimRed "|>  "
    body
    stderr.writeLine ""

proc section(value: string) =
    errLine: dim "$1:" % value
    errLine: discard

# main output

proc printTestFailure(actualValue, expected: any, actualCode: string, pos: Pos) =
    ## Prints a nice looking error message.
    let
        filename       = os.getAppDir() / pos.filename
        content        = readFile(filename)
        lines          = content.splitLines()
        line           = lines[pos.line - 1]
        linePrefix     = line[0..(pos.column-1)]
        lineNumberSize = (pos.line).intToStr.len
        lineBadCode    = line[(pos.column)..(actualCode.len - 1 + pos.column)]
        lineSuffix     = line[(actualCode.len + pos.column)..high(line)]

    stderr.writeLine ""

    errLine:
        boldRed pos.filename
        dimRed ":"
        boldRed $pos.line
    errLine: dim "-".repeat(pos.filename.len + lineNumberSize + 1)
    errLine: discard

    section "Code"
    errLine:
        dim "  $1 |   " % $pos.line
        normal "$1 " % linePrefix.strip
        boldRed lineBadCode
        normal lineSuffix
    errLine: discard

    section "Actual"
    errLine: normal "    $1" % $actualValue
    errLine: discard

    section "Expected"
    errLine: normal "    $1" % $expected
    errLine: discard

    stderr.writeLine ""

# the operator

template `===`*(actual, expected: untyped): untyped =
    ## A fancy wrapper around doAssert which simply prints the error in a
    ## nice format.
    ## 
    ## Example:
    ##
    ##   "this" === "that"
    try:
        # perform the assertion
        doAssert actual == expected
    except AssertionError:
        # if there was an assertion error, capture the position
        let pos = instantiationInfo()
        # and pass it to a pretty print function
        printTestFailure actual, expected, actual.astToStr, pos
        raise newException(AssertionError, "test failed")
