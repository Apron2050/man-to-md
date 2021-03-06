#!/bin/sh
. $(dirname "$0")/init.sh

# Mixing \[NNNN] unicode codepoint literals
# and some sequences like \(dq on the same line
# may lead to incorrectly-encoded output.


outputErrors="$(conv unicode.roff 2>&1 >/dev/null)"
assertEmpty "$outputErrors" \
	"Input lines with UTF-8 character sequences caused some error output!"
outputErrors="$(conv unicode2.roff 2>&1 >/dev/null)"
assertEmpty "$outputErrors" \
	"Input lines with literal UTF-8 characters caused some error output!"


output="$(conv unicode.roff | grep "default is")"

expectedFragment="default is (?:“|\")(?:\\*\\*|<b>)⁻(?:\\*\\*|<\\/b>)(?:”|\") if missing"

assertRegex "$output" "/$expectedFragment/"


unicodeLine="$(tail -n1 -- "$HERE/samples/unicode2.roff")"
output="$(conv unicode2.roff)"
assertRegex "$output" "/$unicodeLine/"


success
