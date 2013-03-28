echo "Running test data"
echo "java -Xmx2000m JacobiSeq 5000 142857 > testSeq-1"
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-1
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-2
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-3
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-4
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-5
java -Xmx2000m JacobiSeq 5000 142857 > testSeq-6

echo "java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-1"
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-1
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-2
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-3
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-4
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-5
java -Xmx2000m -Dpj.nt=1 JacobiSmp 5000 142857 > test1-6

echo "java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-1"
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-1
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-2
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-3
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-4
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-5
java -Xmx2000m -Dpj.nt=2 JacobiSmp 5000 142857 > test2-6

echo "java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-1"
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-1
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-2
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-3
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-4
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-5
java -Xmx2000m -Dpj.nt=3 JacobiSmp 5000 142857 > test3-6

echo "java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-1"
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-1
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-2
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-3
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-4
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-5
java -Xmx2000m -Dpj.nt=4 JacobiSmp 5000 142857 > test4-6

echo "java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-1"
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-1
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-2
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-3
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-4
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-5
java -Xmx2000m -Dpj.nt=8 JacobiSmp 5000 142857 > test8-6

echo "Running data set 1"
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-1
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-2
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-3
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-4
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-5
java -Xmx2000m JacobiSeq 4500 285714 > d1_Seq-6

java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-1
java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-2
java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-3
java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-4
java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-5
java -Xmx2000m -Dpj.nt=1 JacobiSmp 4500 285714 > d1_1-6

java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-1
java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-2
java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-3
java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-4
java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-5
java -Xmx2000m -Dpj.nt=2 JacobiSmp 4500 285714 > d1_2-6

java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-1
java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-2
java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-3
java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-4
java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-5
java -Xmx2000m -Dpj.nt=3 JacobiSmp 4500 285714 > d1_3-6

java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-1
java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-2
java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-3
java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-4
java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-5
java -Xmx2000m -Dpj.nt=4 JacobiSmp 4500 285714 > d1_4-6

java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-1
java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-2
java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-3
java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-4
java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-5
java -Xmx2000m -Dpj.nt=8 JacobiSmp 4500 285714 > d1_8-6

echo "Running data set 2"
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-1
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-2
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-3
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-4
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-5
java -Xmx2000m JacobiSeq 6000 428571 > d2_Seq-6

java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-1
java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-2
java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-3
java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-4
java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-5
java -Xmx2000m -Dpj.nt=1 JacobiSmp 6000 428571 > d2_1-6

java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-1
java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-2
java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-3
java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-4
java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-5
java -Xmx2000m -Dpj.nt=2 JacobiSmp 6000 428571 > d2_2-6

java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-1
java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-2
java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-3
java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-4
java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-5
java -Xmx2000m -Dpj.nt=3 JacobiSmp 6000 428571 > d2_3-6

java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-1
java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-2
java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-3
java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-4
java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-5
java -Xmx2000m -Dpj.nt=4 JacobiSmp 6000 428571 > d2_4-6

java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-1
java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-2
java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-3
java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-4
java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-5
java -Xmx2000m -Dpj.nt=8 JacobiSmp 6000 428571 > d2_8-6

echo "Running data set 3"
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-1
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-2
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-3
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-4
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-5
java -Xmx2000m JacobiSeq 7500 714285 > d3_Seq-6

java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-1
java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-2
java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-3
java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-4
java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-5
java -Xmx2000m -Dpj.nt=1 JacobiSmp 7500 714285 > d3_1-6

java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-1
java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-2
java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-3
java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-4
java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-5
java -Xmx2000m -Dpj.nt=2 JacobiSmp 7500 714285 > d3_2-6

java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-1
java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-2
java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-3
java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-4
java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-5
java -Xmx2000m -Dpj.nt=3 JacobiSmp 7500 714285 > d3_3-6

java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-1
java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-2
java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-3
java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-4
java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-5
java -Xmx2000m -Dpj.nt=4 JacobiSmp 7500 714285 > d3_4-6

java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-1
java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-2
java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-3
java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-4
java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-5
java -Xmx2000m -Dpj.nt=8 JacobiSmp 7500 714285 > d3_8-6


