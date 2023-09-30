#####
#该makefile为单main入口的版本，后续可直接把命名改为Makefile后可食用
#####

#编译器
CC := g++

#编译选项
CFLAGS := -g -O2 -Wall -Werror -Wno-unused -ldl -std=c++14
$(warning CFLAGS is $(CFLAGS))

#静态库链接的参数
LDFLAGS := -L./lib -lmul

#头文件的搜索路径
INCLUDE := -I. -I./include
$(warning INCLUDE is $(INCLUDE))

#main函数所在的文件
MAIN_SRC := main.cpp
MAIN_OBJ := $(MAIN_SRC:%.cpp=%.o)
MAIN_EXE := main

#，-not -path "./lib/*" 表示排除路径中包含"lib"目录的文件。
#EXECLUTE_PATH := -not -path './$(MAIN_SRC)'  -not -path './test.cpp'
EXECLUTE_PATH := -not -path './lib/*' -not -path './$(MAIN_SRC)'  -not -path './test.cpp'

#找到当前目录下，所有的.cpp文件
#SRCS :=$(shell find ./ -type f -not -path './lib/*' |grep '\.cpp' |grep -v '$(MAIN_SRC)')
SRCS :=$(shell find ./ -type f $(EXECLUTE_PATH) |grep '\.cpp')
$(warning SRCS is $(SRCS))

#根据.cpp文件确定对应的.o目标文件的名字
OBJS:=$(patsubst %.cpp, %.o, $(filter %.cpp, $(SRCS)))
$(warning OBJS is $(OBJS))

target: $(MAIN_EXE)

#$^和$<是两个特殊的变量，分别表示所有的依赖文件列表和第一个依赖文件。
$(MAIN_EXE) : $(OBJS) $(MAIN_OBJ)
	$(CC) $(CFLAGS) $(INCLUDE)  $^ -o $@ $(LDFLAGS)

#静态库
MUL_SRC := ./lib/mul.cpp
MUL_OBJ := $(MUL_SRC:%.cpp=%.o)
MUL_LIB := ./lib/libmul.a
MUL_DLL := ./lib/libmul.so
#static为库名称
static: $(MUL_LIB)
# r：替换或插入目标文件到静态库中。如果库中不存在同名的目标文件，则插入；如果存在同名的目标文件，则替换。
# c：创建静态库文件。如果静态库文件不存在，则创建；如果已存在，则覆盖。
# s：创建索引表。这允许链接器更快地查找静态库中的符号。
$(MUL_LIB): $(MUL_OBJ)
	ar rcs $@ $^
#r rs $@ $^
	

shared:$(MUL_DLL)
$(MUL_DLL):$(MUL_OBJ)
	$(CC) $(CFLAGS) $(INCLUDE) $^ -o $@ -fPIC -shared 

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@
	
clean:
	rm -rf $(OBJS) $(MAIN_OBJ) $(MAIN_EXE)

clean_lib:
	rm -rf ./lib/*.so ./lib/*.a
