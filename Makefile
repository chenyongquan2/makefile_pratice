#####
#该makefile为单main入口的版本，后续可直接把命名改为Makefile后可食用
#####

#编译器
CC := g++

#编译选项
CFLAGS := -g -O2 -Wall -Werror -Wno-unused -ldl -std=c++14
$(warning CFLAGS is $(CFLAGS))

#头文件的搜索路径
INCLUDE := -I. -I./include
$(warning INCLUDE is $(INCLUDE))

#main函数所在的文件
MAIN_SRC := main.cpp
MAIN_OBJ := $(MAIN_SRC:%.cpp=%.o)
MAIN_EXE := main

#找到当前目录下，所有的.cpp文件
SRCS :=$(shell find ./ -type f |grep '\.cpp' |grep -v '$(MAIN_SRC)')
$(warning SRCS is $(SRCS))

#根据.cpp文件确定对应的.o目标文件的名字
OBJS:=$(patsubst %.cpp, %.o, $(filter %.cpp, $(SRCS)))
$(warning OBJS is $(OBJS))

target: $(MAIN_EXE)

#$^和$<是两个特殊的变量，分别表示所有的依赖文件列表和第一个依赖文件。
$(MAIN_EXE) : $(OBJS) $(MAIN_OBJ)
	$(CC) $(CFLAGS) $(INCLUDE)  $^ -o $@

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

# main:
# 	$(CC) $(CFLAGS) $(INCLUDE) $(OBJS) -o main

# %.o: %.cpp
# 	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

# sub.o:
# 	clang++ -I . -c sub.cpp -o sub.o
# add.o:
# 	clang++ -I . -c add.cpp -o add.o
# main.o:
# 	clang++ -I . -c main.cpp -o main.o


clean:
	rm -rf $(OBJS) $(MAIN_OBJ) $(MAIN_EXE)
