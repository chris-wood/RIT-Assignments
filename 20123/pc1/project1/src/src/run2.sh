echo "Running test data"
echo "java -Dpj.jvmflags='-Xmx500m' JacobiSeq 4500 159314"
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4500 159314 > testSeq-1
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4500 159314 > testSeq-2
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4500 159314 > testSeq-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=1 JacobiClu 4500 159314"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 4500 159314 > test1-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 4500 159314 > test1-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 4500 159314 > test1-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=2 JacobiClu 4500 159314"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 4500 159314 > test2-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 4500 159314 > test2-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 4500 159314 > test2-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=3 JacobiClu 4500 159314"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 4500 159314 > test3-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 4500 159314 > test3-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 4500 159314 > test3-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=4 JacobiClu 4500 159314"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 4500 159314 > test4-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 4500 159314 > test4-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 4500 159314 > test4-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=8 JacobiClu 4500 159314"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 4500 159314 > test8-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 4500 159314 > test8-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 4500 159314 > test8-3

echo "java -Dpj.jvmflags='-Xmx500m' JacobiSeq 4000 314159"
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4000 314159 > d1-Seq-1
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4000 314159 > d1-Seq-2
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4000 314159 > d1-Seq-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=1 JacobiClu 4000 314159"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 4000 314159 > d1-1-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 4000 314159 > d1-1-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 4000 314159 > d1-1-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=2 JacobiClu 4000 314159"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 4000 314159 > d1-2-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 4000 314159 > d1-2-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 4000 314159 > d1-2-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=3 JacobiClu 4000 314159"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 4000 314159 > d1-3-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 4000 314159 > d1-3-2 
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 4000 314159 > d1-3-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=4 JacobiClu 4000 314159"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 4000 314159 > d1-4-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 4000 314159 > d1-4-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 4000 314159 > d1-4-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=8 JacobiClu 4000 314159"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 4000 314159 > d1-8-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 4000 314159 > d1-8-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 4000 314159 > d1-8-3

echo "java -Dpj.jvmflags='-Xmx500m' JacobiSeq 5000 141593"
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 5000 141593 > d2-Seq-1
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 5000 141593 > d2-Seq-2
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 5000 141593 > d2-Seq-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=1 JacobiClu 5000 141593"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 5000 141593 > d2-1-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 5000 141593 > d2-1-2 
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 5000 141593 > d2-1-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=2 JacobiClu 5000 141593"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 5000 141593 > d2-2-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 5000 141593 > d2-2-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 5000 141593 > d2-2-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=3 JacobiClu 5000 141593"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 5000 141593 > d2-3-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 5000 141593 > d2-3-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 5000 141593 > d2-3-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=4 JacobiClu 5000 141593"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 5000 141593 > d2-4-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 5000 141593 > d2-4-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 5000 141593 > d2-4-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=8 JacobiClu 5000 141593"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 5000 141593 > d2-8-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 5000 141593 > d2-8-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 5000 141593 > d2-8-3

echo "java -Dpj.jvmflags='-Xmx500m' JacobiSeq 6000 415931"
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 6000 415931 > d3-Seq-1
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 6000 415931 > d3-Seq-2
java -Dpj.jvmflags="-Xmx500m" JacobiSeq 6000 415931 > d3-Seq-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=1 JacobiClu 6000 415931"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 6000 415931 > d3-1-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 6000 415931 > d3-1-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 6000 415931 > d3-1-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=2 JacobiClu 6000 415931"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 6000 415931 > d3-2-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 6000 415931 > d3-2-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 6000 415931 > d3-2-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=3 JacobiClu 6000 415931"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 6000 415931 > d3-3-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 6000 415931 > d3-3-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 6000 415931 > d3-3-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=4 JacobiClu 6000 415931"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 6000 415931 > d3-4-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 6000 415931 > d3-4-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=4 JacobiClu 6000 415931 > d3-4-3

echo "java -Dpj.jvmflags='-Xmx500m' -Dpj.np=8 JacobiClu 6000 415931"
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 6000 415931 > d3-8-1
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 6000 415931 > d3-8-2
java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 6000 415931 > d3-8-3

echo "woot woot!"
echo "Done."

