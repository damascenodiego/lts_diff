#!/bin/bash
#SBATCH --partition=csedu
#SBATCH --output="logs_mqtt-%j.out"
#SBATCH --cpus-per-task=20
#SBATCH --time=10:00:00

MAX_PROCS=20
subjects_dir=../subjects/mqtt/
out_dir=../results/mqtt
END=10
TIMEOUT=20m


declare -a sat_solvers=("msat" "cvc4" "z3" "yices")
# "btor" "picosat" "bdd" do not suppport logic
mkdir -p $out_dir

# asuffix="*.dot"
declare -a file_suffix=("_invalid.dot" "_non_clean.dot" "_simple.dot" "_single_client.dot" "_two_client.dot" "_two_client_same_id.dot" "_two_client_will_retain.dot") #todo
for asuffix in ${file_suffix[@]}; do
    files=$(md5sum `find ../subjects/mqtt/ -name "*${asuffix}"` | sort | uniq -w 33 | cut -c35-)
    for i in $(seq 1 $END)
    do
        for file1 in $files
        do
            for file2 in $files
            do
                for solver in ${sat_solvers[@]};
                do
                    f1=${file1#${subjects_dir}}
                    f2=${file2#${subjects_dir}}
                    f1=${f1///}
                    f2=${f2///}
                    name="${out_dir}/${f1%.*}-${f2%.*}-${solver}-${i}.dot"
                    echo python3 ../algorithm/main.py --ref=$file1 --upd=$file2 -o $name -t 0.8 -s $solver -l

                    #echo ${name}
                done
                name="${out_dir}/${f1%.*}-${f2%.*}-umfpack-${i}.dot"
                echo python3 ../algorithm/main.py --ref=$file1 --upd=$file2 -o $name -t 0.8 -l
            done #| xargs -I CMD --max-procs=$MAX_PROCS timeout $TIMEOUT bash -c "CMD"
        done 
    done
done