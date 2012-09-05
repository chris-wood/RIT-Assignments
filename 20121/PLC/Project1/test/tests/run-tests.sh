#!/bin/bash

BIRCH="$@"

testScript=`basename "$0"`
testDir=`dirname "$0"`

#BIRCH="./birch"
#BIRCH="java Birch"
#BIRCH="java -jar Birch.jar"
#BIRCH="python Birch.py"
#BIRCH="mono Birch.exe"
#BIRCH="ruby Birch.rb"
#BIRCH="../solns/sml/birch"
#BIRCH="java -jar ../solns/java/Birch.jar"

if [ -z "$BIRCH" ]; then
    printf "usage: $testScript <executeCmd>\n"
    printf "\t<executeCmd>: the command to execute the Birch interpreter.\n"
    printf "\tExample <executeCmd>s\n"
    printf "\t\tjava Birch\t\t\t# for Java\n"
    printf "\t\tjava -jar Birch.jar\t\t# for Java\n"
    printf "\t\tpython Birch.py\t\t\t# for Python\n"
    printf "\t\t./birch\t\t\t\t# for compiled executable (e.g., C, C++)\n"
    exit;
fi

pass=0
fail=0
for testBir in `cd $testDir ; ls *.bir`; do
    test=$(basename $testBir .bir) ;
    if [ "$test" = "99_loop" ] ; then
        printf "Skipping $test.\n" ;
        break ;
    fi ;
    printf "Testing $test..." ;
    $BIRCH $testDir/$test.bir > $test.tst 2>&1 ;
    diff -b $test.tst $testDir/$test.out > $test.diff 2>&1 ;
    if [ -s $test.diff ]; then
        printf "failed!\n" ;
        cat $test.diff ;
        fail=$(( $fail+1 ));
    else
        printf "passed!\n" ;
        pass=$(( $pass+1 ));
    fi
    rm $test.tst $test.diff ;
done
total=$(( $pass+$fail ));
passPct=$(( $pass * 100 / $total ));
failPct=$(( $fail * 100 / $total ));
printf "Tests passed: $pass  ($passPct%%)\n" ;
printf "Tests failed: $fail  ($failPct%%)\n" ;
