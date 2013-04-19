echo "Running test data"
echo "java -Xmx2000m JacobiSeq 5000 142857 > testSeq-1"
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-1
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-2
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-3

echo "java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-1"
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-1
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-2
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-3

echo "java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-1"
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-1
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-2
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-3

echo "java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-1"
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-1
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-2
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-3

echo "java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-1"
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-1
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-2
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-3

echo "java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-1"
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-1
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-2
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-3

echo "Running data set 1"
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-1
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-2
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-3

java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-1
java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-2
java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-3

java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-1
java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-2
java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-3

java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-1
java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-2
java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-3

java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-1
java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-2
java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-3

java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-1
java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-2
java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-3

echo "Running data set 2"
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-1
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-2
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-3

java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-1
java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-2
java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-3

java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-1
java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-2
java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-3

java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-1
java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-2
java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-3

java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-1
java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-2
java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-3

java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-1
java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-2
java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-3

echo "Running data set 3"
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-1
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-2
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-3

java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-1
java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-2
java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-3

java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-1
java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-2
java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-3

java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-1
java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-2
java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-3

java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-1
java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-2
java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-3

java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-1
java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-2
java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-3


