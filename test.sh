echo $@
echo $#
echo $1
echo $2
echo $(($1+$2))
args=()
some=$@
for i in $@
do 
	args+=("$i")
done
echo "alle argumetne: $args"
i=0
for arg in $args
do
	echo ${args[$i]}
	i=$((i+1))
done 
for i in "${args[@]}"; do echo "$i"; done
echo $i
echo "alle args: " $args
startdir=0
expression=1

echo ${some[$startdir]}
