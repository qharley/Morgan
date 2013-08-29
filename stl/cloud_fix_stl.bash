for file in *.stl
do
  echo $file	
  ~/netfabbcloud/netfabbcloud.py $file

done
