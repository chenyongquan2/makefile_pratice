#include <iostream>
#include <add.h>
#include <sub.h>

//todo:当要测试多main入口，把此名改为main
int mainMulti()
{
    int res = add(2, 3);
    std::cout << "2 + 3 = " << res << std::endl;

    res = sub(8, 2);
    std::cout << "8 - 2 = " << res << std::endl;
    return 0;
}