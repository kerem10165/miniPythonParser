
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

file(GLOB HH_FILES *.hh)
file(GLOB SRC_FILES *.cc *.cpp)
file(GLOB HXX_FILES *.hxx *.hpp *.h)


find_package(BISON)
find_package(FLEX)

set(BISON_FLAGS "-v")

bison_target(Parser parse.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp COMPILE_FLAGS ${BISON_FLAGS})
flex_target(Scanner scan.l ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp)


add_flex_bison_dependency(Scanner Parser)

add_library(parse
            STATIC
            ${FLEX_Scanner_OUTPUTS}
            ${BISON_Parser_OUTPUTS}
            ${HH_FILES}
            ${SRC_FILES}
            ${HXX_FILES}
)
