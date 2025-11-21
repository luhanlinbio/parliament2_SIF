# parliament2_SIF
The apptainer SIF of parliament2 tools.  

## download link

```
parliament2.sif 链接: https://pan.baidu.com/s/1sk94LKCZhSUbE6ozvkyEWg?pwd=tx6n 提取码: tx6n

```

## usage
```
apptainer exec --no-home \
  -B $wdir:/home/dnanexus/in \
  -B $wdir/outputs:/home/dnanexus/out \
  parliament2.sif /home/dnanexus/parliament2.py \
  --bam input.bam \
  --bai input.bam.bai \
  -r hg38.fasta --fai hg38.fasta.fai \
  --prefix input \
  --filter_short_contigs --breakdancer --manta --cnvnator --lumpy \
  --delly_deletion --delly_insertion --delly_inversion --delly_duplication \
  --genotype
```
