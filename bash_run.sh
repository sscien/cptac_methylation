# bash /diskmnt/Projects/Users/ysong/Projects/cptac_methylation/batch_run.sh /diskmnt/Projects/Users/ysong/project/methylation/batch0318_22 batch0318_22 /diskmnt/Projects/Users/ysong/project/methylation/batch0318_22/Methylation_Array.analysis_SN.dat

cd /diskmnt/Projects/Users/ysong/Projects/Datasets/CPTAC3.catalog/
rm CPTAC3.Catalog.dat
rm katmai.BamMap.dat

wget https://raw.githubusercontent.com/ding-lab/CPTAC3.catalog/master/CPTAC3.Catalog.dat
wget https://raw.githubusercontent.com/ding-lab/CPTAC3.catalog/master/BamMap/katmai.BamMap.dat

# Activate environment
source /diskmnt/Projects/Users/ysong/program/anaconda3/etc/profile.d/conda.sh

conda activate methyl-pipeline

# Read in arguments
Path=$1
Batch_name=$2
Sample=$3

cd $Path

## Make input
#python $cptac_methyl/make_pipeline_input.py ${Path} ${Batch_name} ${Sample}

#python $cptac_methyl/make_pipleline_input_v1.3.py /diskmnt/Projects/Users/ysong/project/methylation/batch0318_22 batch0318_22 /diskmnt/Projects/Users/ysong/project/methylation/batch0318_22/Methylation_Array.analysis_SN.dat

python /diskmnt/Projects/Users/ysong/Projects/cptac_methylation/make_pipeline_input_v1.3.py $Path $Batch_name $Sample

## Softlink IDAT files
## Softlink IDAT files
# for i in `cat /diskmnt/Projects/Users/ysong/Projects/Datasets/CPTAC3.catalog/katmai.BamMap.dat ${Sample}| grep Methylation | awk -F "\t" '{OFS="\t"; print $6}'`; do ln -s $i ${Path}; done
## Pipeline
Rscript $cptac_methyl/cptac_methylation_v1.1.R $Path |& tee tmux.methylation.log

Rscript $cptac_methyl/cptac_methylation_liftover.R $Path/Processed |& tee tmux.mapping.log
