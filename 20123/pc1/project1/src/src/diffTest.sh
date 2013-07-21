java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4500 159314 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 4500 159314 > diff2 && diff diffSeq diff2 > out1 

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4500 159314 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 4500 159314 > diff2 && diff diffSeq diff2 > out2

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 4500 159314 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=8 JacobiClu 4500 159314 > diff2 && diff diffSeq diff2 > out3 

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 3000 123 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=5 JacobiClu 3000 123 > diff2 && diff diffSeq diff2 > out4

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 3000 333 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 3000 333 > diff2 && diff diffSeq diff2 > out5 

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 6200 11111111 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=2 JacobiClu 6200 11111111 > diff2 && diff diffSeq diff2 > out6

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 6200 5555555511 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=7 JacobiClu 6200 5555555511 > diff2 && diff diffSeq diff2 > out7

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 5000 12345 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=6 JacobiClu 5000 12345 > diff2 && diff diffSeq diff2 > out8

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 5000 12345 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=3 JacobiClu 5000 12345 > diff2 && diff diffSeq diff2 > out9 

java -Dpj.jvmflags="-Xmx500m" JacobiSeq 6200 666 > diffSeq && java -Dpj.jvmflags="-Xmx500m" -Dpj.np=1 JacobiClu 6200 666 > diff2 && diff diffSeq diff2 > out10
