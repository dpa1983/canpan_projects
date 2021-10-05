# 1st argument: name of case dir, e.g. case1

case_dir=$1
mkdir $case_dir
mv x-time.dat *DAT $case_dir
mv *png  $case_dir
cp isotopedatabase.txt networksetup.txt $case_dir
cp iniab.dat trajectory.input $case_dir
