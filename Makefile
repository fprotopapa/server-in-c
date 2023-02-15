TARGET_NAME ?= main
CC ?= gcc
BUILD ?= build
DEBUG ?= 1
TEST_FRAMEWORK ?= criterion

ifeq ($(DEBUG), 1)
    BUILD_DIR = $(BUILD)/dbg
else
    BUILD_DIR = $(BUILD)/rel
endif

SRC_DIR = src
INC_DIR = include
TEST_DIR = tests
BUILD_OBJ = $(BUILD_DIR)/obj
BUILD_BIN = $(BUILD_DIR)/bin
BUILD_TEST = $(BUILD_DIR)/test
BUILD_SUBDIR = $(BUILD_OBJ) $(BUILD_BIN) $(BUILD_TEST)

TARGET = $(BUILD_BIN)/$(TARGET_NAME) 

$(shell mkdir -p $(BUILD_SUBDIR))

SRC_FILES = $(shell find $(SRC_DIR)/ -type f -name '*.c') 
TEST_FILES = $(shell find $(TEST_DIR)/ -type f -name '*.c') 

SRC_SUBDIR = $(shell find $(SRC_DIR)/ -type d)

SRC_OBJ = $(patsubst %.c,$(BUILD_OBJ)/%.o,$(notdir $(SRC_FILES)))
SRC_OBJ_UT = $(filter-out $(BUILD_OBJ)/main.o,$(SRC_OBJ))
TEST_OBJ = $(patsubst %.c,$(BUILD_TEST)/%,$(notdir $(TEST_FILES)))

INCLUDES = -I$(INC_DIR) 
TEST_LIB = $(TEST_FRAMEWORK)
LIBS =  
DEBUG_FLAGS = -g -O0 -Wextra -Warray-bounds 

ifeq ($(DEBUG), 1)
    CFLAGS += $(INCLUDES) $(DEBUG_FLAGS) -Wall -fcommon -fdata-sections -ffunction-sections 
else
    CFLAGS += $(INCLUDES) -Wall -O2 -DNDEBUG
endif

LDFLAGS +=  $(LIBS) 

.PHONY: all clean test

vpath %.c $(SRC_SUBDIR)

all: $(TARGET)

$(TARGET): $(SRC_OBJ) 
	@echo '----------------------------------' 
	@echo 'CFLAGS: $(CFLAGS)'
	@echo 'LDFLAGS: $(LDFLAGS)'
	@echo ' '
	@echo '[LD] $(SRC_OBJ) -o $@'
	@$(CC) $(CFLAGS) $(LDFLAGS) $(SRC_OBJ) -o $@
	@echo '----------------------------------' 
	@size $<
	@echo ' '

$(BUILD_OBJ)/%.o: %.c 
	@echo '[CC] -c $< -o $@'
	@$(CC) -c $(CFLAGS) $< -o $@

test: $(TARGET) $(TEST_OBJ)
	@echo '-------------TESTING---------------' 
	@for test in $(TEST_OBJ) ; do ./$$test --verbose ; done
	@echo ' '

$(BUILD_TEST)/%: $(TEST_DIR)/%.c 
	@echo '[CC] -c $< -o $@'
	@$(CC) $(CFLAGS) $< $(SRC_OBJ_UT) -o $@ -l$(TEST_LIB)

clean: 
	rm -rf $(BUILD_DIR)

clean_all: 
	rm -rf $(BUILD)
