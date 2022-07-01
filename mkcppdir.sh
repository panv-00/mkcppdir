#!/bin/bash

if [ "$#" -eq 1 ]
then
  if [ -d "$PWD/$1" ]
  then
    echo "Directory $1 exists. Cannot continue."
    exit 1
  fi
  mkdir "$PWD/$1"
  mkdir "$PWD/$1/build"
  mkdir "$PWD/$1/src"

  touch "$PWD/$1/Makefile"
  echo "default:" >> "$PWD/$1/Makefile"
  echo $'\t'"@+make -C build" >> "$PWD/$1/Makefile"
  echo "" >> "$PWD/$1/Makefile"
  echo "clean:" >> "$PWD/$1/Makefile"
  echo $'\t'"@rm -f build/*.o" >> "$PWD/$1/Makefile"
  echo $'\t'"@rm -f $1" >> "$PWD/$1/Makefile"
  echo $'\t'"@echo \"Clean!\"" >> "$PWD/$1/Makefile"

  touch "$PWD/$1/build/Makefile"
  echo "CPP=g++" >> "$PWD/$1/build/Makefile"
  echo "CFLAGS=-Wall -O3 -g" >> "$PWD/$1/build/Makefile"
  echo "VPATH=../src" >> "$PWD/$1/build/Makefile"
  echo "" >> "$PWD/$1/build/Makefile"
  echo "OBJECTS= \\" >> "$PWD/$1/build/Makefile"
  echo $'\t'"$1_functions.o \\" >> "$PWD/$1/build/Makefile"
  echo "" >> "$PWD/$1/build/Makefile"
  echo "default: \$(OBJECTS)" >> "$PWD/$1/build/Makefile"
  echo $'\t'"\$(CPP) -o ../$1 ../src/$1.cpp \\" >> "$PWD/$1/build/Makefile"
  echo $'\t'$'\t'"\$(OBJECTS) \\" >> "$PWD/$1/build/Makefile"
  echo $'\t'$'\t'"\$(CFLAGS)" >> "$PWD/$1/build/Makefile"
  echo "" >> "$PWD/$1/build/Makefile"
  echo "%.o: %.cpp %.h" >> "$PWD/$1/build/Makefile"
  echo $'\t'"\$(CPP) -c \$< -o \$*.o \$(CFLAGS)" >> "$PWD/$1/build/Makefile"

  touch "$PWD/$1/src/$1_functions.h"
  tmph="$1_functions_h"
  tu_h=$(echo $tmph | tr '[:lower:]' '[:upper:]')
  echo "#ifndef $tu_h" >> "$PWD/$1/src/$1_functions.h"
  echo "#define $tu_h" >> "$PWD/$1/src/$1_functions.h"
  echo "" >> "$PWD/$1/src/$1_functions.h"
  echo "#endif" >> "$PWD/$1/src/$1_functions.h"

  touch "$PWD/$1/src/$1_functions.cpp"
  echo "#include <stdio.h>" >> "$PWD/$1/src/$1_functions.cpp"
  echo "#include \"$1_functions.h\"" >> "$PWD/$1/src/$1_functions.cpp"
  echo "" >> "$PWD/$1/src/$1_functions.cpp"

  touch "$PWD/$1/src/$1.cpp"
  echo "#include <stdio.h>" >> "$PWD/$1/src/$1.cpp"
  echo "#include \"$1_functions.h\"" >> "$PWD/$1/src/$1.cpp"
  echo "" >> "$PWD/$1/src/$1.cpp"
  echo "int main(int argc, char *argv[])" >> "$PWD/$1/src/$1.cpp"
  echo "{" >> "$PWD/$1/src/$1.cpp"
  echo "" >> "$PWD/$1/src/$1.cpp"
  echo "  return 0;" >> "$PWD/$1/src/$1.cpp"
  echo "}" >> "$PWD/$1/src/$1.cpp"

else
  echo "  Usage: mkcppdir.sh [project_name]"
  echo "Script ended with errors!"
fi
