REC2="tarameccaluna@gmail.com"
REC1="operatingsystems@vlsm.org"
FILES="my*.asc my*.txt my*.sh"
SHA="SHA256SUM"

# If the folder $HOME/RESULT doesn't exist, make it. -p is to create its parents if doesnt exist
[ -d $HOME/RESULT ] || mkdir -p $HOME/RESULT
# Go to this dir
pushd $HOME/RESULT
for II in W?? ; do
    # Compute all files matching W?? -Question mark is a single char wildcard-
    [ -d $II ] || continue
    # Skip if doesnt exist
    TARFILE=my$II.tar.bz2
    TARFASC=$TARFILE.asc
    # Remove any existing same file
    rm -f $TARFILE $TARFASC
    # Create tarball
    echo "tar cfj $TARFILE $II/"
    tar cfj $TARFILE $II/
	# Encryt tarball, multiple recipient, can be decrypted by Mr. Rahmat and Us
    echo "gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE"
    gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE
done
# Back to initial dir
popd

# Remove this fakeDODOL mysterious file
rm -f $HOME/RESULT/fakeDODOL
for II in $HOME/RESULT/myW*.tar.bz2.asc $HOME/RESULT/fakeDODOL ; do
   echo "Check and move $II..."
   # if this file exist, move it to ., this means TXT/
   [ -f $II ] && mv -f $II .
done

# Remove formerly made files
echo "rm -f $SHA $SHA.asc"
rm -f $SHA $SHA.asc

# Get all sha256 sum of all files
echo "sha256sum $FILES > $SHA"
sha256sum $FILES > $SHA

# Checksum of the sha
echo "sha256sum -c $SHA"
sha256sum -c $SHA

# Sign the sha
echo "gpg -o $SHA.asc -a -sb $SHA"
gpg -o $SHA.asc -a -sb $SHA

# Verify the sign
echo "gpg --verify $SHA.asc $SHA"
gpg --verify $SHA.asc $SHA

exit 0