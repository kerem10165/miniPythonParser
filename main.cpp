#include <iostream>
#include <memory>
#include <string>
#include "src/driver.h"

std::unique_ptr<std::string> identiferVal;

int main(int argc , char** argv)
{
    parse::Driver driver;

    for(int i = 1 ; i < argc ; i++)
    {
        std::cout << argv[i] << " named file is reading\n";
        auto resultOfParse = driver.parse_file(std::string{"test/"} + argv[i]);

        if(resultOfParse == 0)
        {
            std::cout << "Parse is succesfull. There isn't any error\n\n";
        }

        else if(resultOfParse == -55)
        {
            std::cout << "File doesn't found\n\n";
        }
    }

}