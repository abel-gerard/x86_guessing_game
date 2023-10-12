#bin
# build set of assembly files together

# MODIFY BEGIN - /!\ filenames without extensions
main="main"                 # entry-point
out="out"                   # output executable
dependencies=("guess" "random")     # dependencies of the project
# MODIFY STOP

as --32 $main.s -o $main.o

obj_files="$main.o"
for dep in ${dependencies[@]}; do
    as --32 $dep.s -o $dep.o
    obj_files+=" $dep.o"
done

ld -m elf_i386 $obj_files -o $out

rm $main.o
for dep in ${dependencies[@]}; do
    rm $dep.o
done 
