#!/bin/sh

test_description='"stg refresh" with removed files'

. ./test-lib.sh

# Ignore our own temp files.
cat >> .git/info/exclude <<EOF
expected*.txt
files*.txt
status*.txt
EOF

test_expect_success 'Initialize StGit stack' '
    stg init &&
    echo x > x.txt &&
    echo y > y.txt &&
    stg add x.txt y.txt &&
    git commit -m "Add some files"
'

cat > expected0.txt <<EOF
D  y.txt
EOF
printf '' > expected1.txt
cat > expected2.txt <<EOF
D y.txt
EOF
test_expect_success 'stg rm a file' '
    test_when_finished "stg pop -a; git reset --hard"
    stg new -m p0 &&
    stg rm y.txt &&
    stg status > status0.txt &&
    test_cmp expected0.txt status0.txt &&
    stg refresh &&
    stg status > status1.txt &&
    test_cmp expected1.txt status1.txt &&
    stg files > files.txt &&
    test_cmp expected2.txt files.txt
'

cat > expected0.txt <<EOF
 M x.txt
D  y.txt
EOF
printf '' > expected1.txt
cat > expected2.txt <<EOF
M x.txt
D y.txt
EOF
test_expect_success 'stg rm a file together with other changes' '
    test_when_finished "stg pop -a; git reset --hard"
    stg new -m p1 &&
    echo x2 >> x.txt &&
    stg rm y.txt &&
    stg status > status0.txt &&
    test_cmp expected0.txt status0.txt &&
    stg refresh --force &&
    stg status > status1.txt &&
    test_cmp expected1.txt status1.txt &&
    stg files > files.txt &&
    test_cmp expected2.txt files.txt
'

cat > expected0.txt <<EOF
 D y.txt
EOF
printf '' > expected1.txt
cat > expected2.txt <<EOF
D y.txt
EOF
test_expect_success 'rm a file' '
    test_when_finished "stg pop -a; git reset --hard"
    stg new -m p2 &&
    rm y.txt &&
    stg status > status0.txt &&
    test_cmp expected0.txt status0.txt &&
    stg refresh &&
    stg status > status1.txt &&
    test_cmp expected1.txt status1.txt &&
    stg files > files.txt &&
    test_cmp expected2.txt files.txt
'

cat > expected0.txt <<EOF
 M x.txt
 D y.txt
EOF
printf '' > expected1.txt
cat > expected2.txt <<EOF
M x.txt
D y.txt
EOF
test_expect_success 'rm a file together with other changes' '
    test_when_finished "stg pop -a; git reset --hard"
    stg new -m p3 &&
    echo x2 >> x.txt &&
    rm y.txt &&
    stg status > status0.txt &&
    test_cmp expected0.txt status0.txt &&
    stg refresh &&
    stg status > status1.txt &&
    test_cmp expected1.txt status1.txt &&
    stg files > files.txt &&
    test_cmp expected2.txt files.txt
'

test_done
