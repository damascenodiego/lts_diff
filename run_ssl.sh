#!/bin/bash

openssl_dir=../openssl_test



declare -a sat_solvers=("msat" "cvc4" "z3" "yices")
# "btor" "picosat" "bdd" do not suppport logic

for file1 in "$openssl_dir"/*/*/*
do
  for file2 in "$openssl_dir"/*/*/*
  do
    for solver in ${sat_solvers[@]};
    do
        f1=${file1#${openssl_dir}}
        f2=${file2#${openssl_dir}}
        f1=${f1///}
        f2=${f2///}
        name="../out/${f1%lea*}-${f2%lea*}-${solver}.dot"
        python3 main.py --ref=$file1 --upd=$file2 -o $name -t 0.5 -s $solver
        
        echo $name
    done
  done
done

python3 add_date.py "../out/"

