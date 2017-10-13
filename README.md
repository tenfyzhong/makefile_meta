# makefile_meta
makefile metadata

# usage  
You only need to include the \*.mk file in you makefile.  
If you want to overwrite the default variables, you should  
define them before include statment.  

## dir.mk variable
### `DIRS`
the dirs you want to compile.  
default all. 

## src.mk variable
### `INC_DIR`
the include files directory. 
default: include

### `LIB_PREFIX`
the lib prefix. 
default: lib

### `SRC_DIR`
the source files directory.
default: src

### `OBJ_DIR`
the object files directory. 
default: obj

### `LIB_DIR`
the library files directory. 
default: lib

### `TARGET`
target name. 
default: lib{directory}.a

### `DYNAMIC_SO`
so name. 
default: lib{directory}.so

### `ARFLAGS`
ar flags
default: rc

### `CC`
the c complier.
default: gcc

### `CXX`
the c++ compiler.
default: g++

### `SED`
the sed program.
default: sed

### `CFLAGS`
c compiler flags
default: `-g -O2 -pipe -D_GNU_SOURCE -fPIC -Wall -Werror -m64`

### `CPPFLAGS`
c++ compiler flags
default: `-g -O2 -pipe -D_GNU_SOURCE -fPIC -Wall -Werror -m64`

### `CPPCHECK`
default: cppcheck
