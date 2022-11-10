#! /bin/bash

rm -f ./_slurm_aline.sh

mkdir -p ../results/dtls
mkdir -p ../results/mqtt
mkdir -p ../results/openssl
mkdir -p ../results/ssh
mkdir -p ../results/tcp
mkdir -p ../results/tcp_preset_50_rerun

count=0
while read LINE; do

echo '#! /bin/bash'              >  ./_slurm_aline.sh
echo '#SBATCH --partition=csedu' >> ./_slurm_aline.sh
echo '#SBATCH --time=20'         >> ./_slurm_aline.sh
echo ' '                         >> ./_slurm_aline.sh
echo '#SBATCH --output="all_line'(( ++count ))'-%j.out"' >> ./_slurm_aline.sh  

echo $LINE >> ./_slurm_aline.sh
sbatch ./_slurm_aline.sh
rm ./_slurm_aline.sh  
done < _slurm_all.txt
