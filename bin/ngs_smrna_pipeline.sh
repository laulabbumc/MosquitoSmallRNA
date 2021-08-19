INSTALLATION_PATH=$bindir


bash $INSTALLATION_PATH/ngs_align_to_mirna.sh $1.clipped $2
bash $INSTALLATION_PATH/ngs_align_to_mirna.sh $1.noclipped $2
grep '^@' $1.noclipped.hairpin.sam > $1.hairpin.sam
grep -v '^@' $1.clipped.hairpin.sam >> $1.hairpin.sam
grep -v '^@' $1.noclipped.hairpin.sam >> $1.hairpin.sam
