RED 		= \\e[1m\\e[31m
DARKRED 	= \\e[31m
GREEN 		= \\e[1m\\e[32m
DARKGREEN 	= \\e[32m
YELLOW 		= \\e[1m\\e[33m
DARKYELLOW 	= \\e[33m
BLUE 		= \\e[1m\\e[34m
DARKBLUE 	= \\e[34m
MAGENTA 	= \\e[1m\\e[35m
DARKMAGENTA = \\e[35m
CYAN 		= \\e[1m\\e[36m
DARKCYAN 	= \\e[36m
RESET  		= \\e[m

CWD = $(shell pwd)
CWD_DIR_NAME = $(notdir $(CWD))

OBJECT_EXT = o
DEPEND_EXT = d
CPPSRC_EXT = cpp
CSRC_EXT = c
HEADER_EXT = h
STATICLIB_EXT = a
DYNAMICLIB_EXT = so

ifndef INC_DIR
	INC_DIR = include
endif

ifndef LIB_PREFIX
	LIB_PREFIX = lib
endif

ifndef SRC_DIR
	SRC_DIR = src
endif

ifndef OBJ_DIR
	OBJ_DIR = obj
endif

ifndef LIB_DIR
	LIB_DIR = lib
endif

ifndef TARGET
	TARGET = $(LIB_DIR)/$(LIB_PREFIX)$(CWD_DIR_NAME).$(STATICLIB_EXT)
endif

ifndef DYNAMIC_SO
	DYNAMIC_SO = $(patsubst %.$(STATICLIB_EXT),%.$(DYNAMICLIB_EXT),$(TARGET))
endif

ifndef ARFLAGS
	ARFLAGS = rc
endif

ifndef CC
	CC = gcc
endif

ifndef CXX
	CXX = g++
endif

ifndef SED
	SED = sed
endif

ifndef CFLAGS
	CFLAGS = -g -O2 -pipe -D_GNU_SOURCE -fPIC -Wall -Werror -m64
endif

ifndef CPPFLAGS
	CPPFLAGS = -g -O2 -pipe -D_GNU_SOURCE -fPIC -Wall -Werror -m64
endif

ifndef CPPCHECK
	CPPCHECK = cppcheck
endif


C_SRCS = $(wildcard $(SRC_DIR)/*.$(CSRC_EXT))
C_OBJECTS = $(patsubst $(SRC_DIR)/%.$(CSRC_EXT),$(OBJ_DIR)/%.$(OBJECT_EXT),$(C_SRCS))
C_DEPENDS = $(patsubst $(SRC_DIR)/%.$(CSRC_EXT),$(OBJ_DIR)/%.$(DEPEND_EXT),$(C_SRCS))
CPP_SRCS = $(wildcard $(SRC_DIR)/*.$(CPPSRC_EXT))
CPP_OBJECTS = $(patsubst $(SRC_DIR)/%.$(CPPSRC_EXT),$(OBJ_DIR)/%.$(OBJECT_EXT),$(CPP_SRCS))
CPP_DEPENDS = $(patsubst $(SRC_DIR)/%.$(CPPSRC_EXT),$(OBJ_DIR)/%.$(DEPEND_EXT),$(CPP_SRCS))

INC += -I$(INC_DIR)

.PHONY: all clean check

ifeq "$(NEED_DYNAMIC)" "1"
all: $(DYNAMIC_SO)
else
all: $(TARGET)
endif

clean:
	$(RM) $(OBJ_DIR)/*.$(OBJECT_EXT) $(OBJ_DIR)/*.$(DEPEND_EXT) $(LIB_DIR)/*.$(STATICLIB_EXT) $(LIB_DIR)/*.$(DYNAMICLIB_EXT) $(TARGET) $(DYNAMIC_SO)

$(DYNAMIC_SO): LIB := $(TARGET) $(LIB)
$(DYNAMIC_SO): CPPFLAGS += -shared

$(DYNAMIC_SO): $(TARGET)
	@echo -e "$(DARKBLUE)Generating $@ ... $(RESET)"
	$(CXX) $(CPPFLAGS) $(LIB) -o $@
	@echo ""

$(TARGET): $(C_OBJECTS) $(C_DEPENDS) $(CPP_OBJECTS) $(CPP_DEPENDS)
	@echo -e "$(BLUE)Packaging $@ ... $(RESET)"
	$(AR) $(ARFLAGS) $@ $(C_OBJECTS) $(CPP_OBJECTS)
	@echo ""

$(C_OBJECTS): $(OBJ_DIR)/%.$(OBJECT_EXT): $(SRC_DIR)/%.$(CSRC_EXT)
	@echo -e "$(GREEN)Compiling $< ==> $@ ... $(RESET)"
	$(CC) $(INC) $(CFLAGS) -c $< -o $@
	@echo ""

$(CPP_OBJECTS): $(OBJ_DIR)/%.$(OBJECT_EXT): $(SRC_DIR)/%.$(CPPSRC_EXT)
	@echo -e "$(GREEN)Compiling $< ==> $@ ... $(RESET)"
	$(CXX) $(INC) $(CPPFLAGS) -c $< -o $@
	@echo ""

$(C_DEPENDS): $(OBJ_DIR)/%.$(DEPEND_EXT): $(SRC_DIR)/%.$(CSRC_EXT)
	@echo -e "$(GREEN)Generating $< ==> $@ ... $(RESET)"
	@echo -e "$(CC) -MM $(INC) $(CPPFLAGS) $< > $@"
	@$(CC) -MM $(INC) $(CFLAGS) $< > $@.$$$$; \
		$(SED) 's,\($*\)\.o[ :]*,$(OBJ_DIR)\1.o $@ : ,g' < $@.$$$$ > $@; \
		$(RM) $@.$$$$
	@echo ""

$(CPP_DEPENDS): $(OBJ_DIR)/%.$(DEPEND_EXT): $(SRC_DIR)/%.$(CPPSRC_EXT)
	@echo -e "$(GREEN)Generating $< ==> $@ ... $(RESET)"
	@echo -e "$(CXX) -MM $(INC) $(CPPFLAGS) $< > $@"
	@$(CXX) -MM $(INC) $(CPPFLAGS) $< > $@.$$$$; \
		$(SED) 's,\($*\)\.o[ :]*,$(OBJ_DIR)\1.o $@ : ,g' < $@.$$$$ > $@; \
		$(RM) $@.$$$$
	@echo ""

ifneq "$(MAKECMDGOALS)" "clean"
sinclude $(C_DEPENDS) $(CPP_DEPENDS)
endif

