for file in ./*.stl
do
  admesh $file -b $file
done
