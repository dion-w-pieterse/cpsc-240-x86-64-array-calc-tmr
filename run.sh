echo "Assemble the x86-64 NASM file"
nasm -f elf64 -l control.lis -o control.o control.asm

echo "Assemble the x86-64 NASM file"
nasm -f elf64 -l input_array_func.lis -o input_array_func.o input_array_func.asm

echo "Assemble the x86-64 NASM file"
nasm -f elf64 -l output_original_array.lis -o output_original_array.o output_original_array.asm

echo "Assemble the x86-64 NASM file"
nasm -f elf64 -l compute_dot.lis -o compute_dot.o compute_dot.asm

echo "Compile the .cpp file"
g++ -c -m64 -Wall -l prac2cpp.lis -o driver.o driver.cpp

echo "Link the object files"
g++ -m64 -o Exec driver.o control.o input_array_func.o output_original_array.o compute_dot.o

echo "Run the program"
./Exec
