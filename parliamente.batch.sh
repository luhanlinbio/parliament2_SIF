#!/usr/bin/env bash

# must include hg38.fa hg38.fa.fai and all splited chr*.fa 
refdir=/yourpath/hg38  

# batch
## your bamlist files 
list=$1 
cat $list | while IFS=$'\t' read -r -a col
do
    samid=${col[0]}
    inputdir=${col[1]}
    wdir=/yourpath/s06_parliament2/$samid
    name=$samid
    mkdir -pv $wdir 
    mkdir -pv $wdir/outputs

    echo -ne "#!/usr/bin/env bash
#SBATCH --job-name=sv_$samid
#SBATCH -p kshcnormal

# load env
module load apps/apptainer/1.3.4

# prepare
rsync -avLK --checksum $inputdir/*.bam $wdir
rsync -avLK --checksum $inputdir/*.bai $wdir
rsync -avLK --checksum $refdir/*       $wdir

# run parliament2
apptainer exec --no-home \
  -B $wdir:/home/dnanexus/in \
  -B $wdir/outputs:/home/dnanexus/out \
  /yourpath/parliament2.sif /home/dnanexus/parliament2.py \
  --bam $name.marked.BQSR.bam \
  --bai $name.marked.BQSR.bam.bai \
  -r hg38.fasta --fai hg38.fasta.fai \
  --prefix $name \
  --filter_short_contigs --breakdancer --manta --cnvnator --lumpy \
  --delly_deletion --delly_insertion --delly_inversion --delly_duplication \
  --genotype 

# clean temp files
rm -Rvf *.delly.*.vcf delly* breakdancer* chr* cnvnator* svtype* output.* lumpy* manta* survivor* *.fa *.fai *.fasta *.bam *.bai input* *.vcf *.cmds *.svp contigs

#END
\n" > $wdir/$samid.slurm
    cd $wdir && sbatch -p kshcnormal -N 1 -n 16 --mem=32g -o $samid.slurm.o -e $samid.slurm.e $samid.slurm
done