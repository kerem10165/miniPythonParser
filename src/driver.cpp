/*
MIT License

Copyright (c) 2017 Rémi Berson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
*/



#include "driver.h"
#include "parser.hpp"
#include "scanner.h"

namespace parse
{
    Driver::Driver()
        : scanner_(new Scanner()),
          parser_(new Parser(*this)),
          error_(0)
    {
    }

    Driver::~Driver()
    {
        delete parser_;
        delete scanner_;
    }

    void Driver::reset()
    {
        error_ = 0;
    }

    int Driver::parse()
    {
        scanner_->switch_streams(&std::cin, &std::cerr);
        parser_->parse();
        return error_;
    }

    int Driver::parse_file(const std::string &path)
    {
        std::ifstream s(path.c_str(), std::ifstream::in);

        if(!s.is_open())
            return -55;

        scanner_->switch_streams(&s, &std::cerr);

        parser_->parse();

        s.close();

        return error_;
    }
}
