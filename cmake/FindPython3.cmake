# - Find the python 3 libraries
#   This module defines
#   PYTHONLIBS_FOUND           - have the Python libs been found
#   PYTHON_EXECUTABLE          - path to python executable
#   PYTHON_LIBRARIES           - path to the python library
#   PYTHON_INCLUDE_PATH        - path to where Python.h is found (deprecated)
#   PYTHON_INCLUDE_DIRS        - path to where Python.h is found
#   PYTHON_DEBUG_LIBRARIES     - path to the debug library (deprecated)
#   PYTHONLIBS_VERSION_STRING  - version of the Python libs found (since CMake 2.8.8)

message("Find python 3")

if ( WIN32 )
    if(NOT DEFINED ENV{PATHON3_PATH})
        set(PATHON3_PATH "C:/Python36" CACHE PATH "Where the python 3 are stored")
    else()
        message("PATHON3_PATH is set as the corresponding environmental variable ... ")
        set(PATHON3_PATH $ENV{PATHON3_PATH} CACHE PATH "Where the python 3 are stored")
    endif() 

    find_file(PYTHON_EXECUTABLE NAMES python.exe HINTS "#{PATHON3_PATH}")
    if (PYTHON_EXECUTABLE)
        set(PYTHON_EXECUTABLE ${PYTHON_EXECUTABLE} CACHE FILEPATH "Where the python3 exe are stored")
        set(PYTHONLIBS_FOUND 1)
        set(PYTHON_EXECUTABLE ${PYTHON_EXECUTABLE} CACHE FILEPATH "Where the python3 exe are stored")
        set(PYTHON_INCLUDE_DIRS ${PATHON3_PATH}/include CACHE FILEPATH "Path to python.h")

        FILE(GLOB var "${PATHON3_PATH}/libs/python*.lib")
        foreach(file ${var})
            message(${file})
        endforeach()

        set(PYTHON_INCLUDE_PATH "${PYTHON_INCLUDE_DIR}")
        if(PYTHON_INCLUDE_DIR AND EXISTS "${PYTHON_INCLUDE_DIR}/patchlevel.h")
            file(STRINGS "${PYTHON_INCLUDE_DIR}/patchlevel.h" python_version_str
                REGEX "^#define[ \t]+PY_VERSION[ \t]+\"[^\"]+\"")
            string(REGEX REPLACE "^#define[ \t]+PY_VERSION[ \t]+\"([^\"]+)\".*" "\\1"
                                PYTHONLIBS_VERSION_STRING "${python_version_str}")
            unset(python_version_str)
            message("Found python ${PYTHONLIBS_VERSION_STRING}")
        endif()

        string(FIND ${PYTHONLIBS_VERSION_STRING} "3.6" pos)
        if ( ${pos} GREATER -1)
            set(PYTHON_LIBRARIES ${PATHON3_PATH}/libs/python36.lib CACHE FILEPATH "Python3 lib")
            set(PYTHON_DEBUG_LIBRARIES ${PATHON3_PATH}/libs/python36_d.lib CACHE FILEPATH "Python3 lib for debug")
            message("Found python lib ${PYTHON_LIBRARIES}")
        else ()
            string(FIND ${PYTHONLIBS_VERSION_STRING} "3.5" pos)
            if (${pos} GREATER -1)
                set(PYTHON_LIBRARIES ${PATHON3_PATH}/libs/python35.lib CACHE FILEPATH "Python3 lib")
                set(PYTHON_DEBUG_LIBRARIES ${PATHON3_PATH}/libs/python35_d.lib CACHE FILEPATH "Python3 lib for debug")
                message("Found python lib ${PYTHON_LIBRARIES}")
            else ()
                string(FIND ${PYTHONLIBS_VERSION_STRING} "3.4" pos)
                if (${pos} GREATER -1)
                    set(PYTHON_LIBRARIES ${PATHON3_PATH}/libs/python34.lib CACHE FILEPATH "Python3 lib")
                    set(PYTHON_DEBUG_LIBRARIES ${PATHON3_PATH}/libs/python34_d.lib CACHE FILEPATH "Python3 lib for debug")
                    message("Found python lib ${PYTHON_LIBRARIES}")
                else()
                    message("Cannot find python lib")
                endif ()
            endif ()
        endif ()
    else()
        message("Python3 is not found")
        set(PYTHONLIBS_FOUND 0)
    endif()
else ()
    if(NOT DEFINED ENV{PATHON3_PATH})
        set(PATHON3_PATH "/usr" CACHE PATH "Where the python 3 are stored")
    else()
        message("PATHON3_PATH is set as the corresponding environmental variable ... ")
        set(PATHON3_PATH $ENV{PATHON3_PATH} CACHE PATH "Where the python 3 are stored")
    endif()
    if(NOT DEFINED ENV{PATHON3_LIB_PATH})
        set(PATHON3_LIB_PATH "/usr/lib/x86_64-linux-gnu" CACHE PATH "Where the python 3 are stored")
    else()
        message("PATHON3_LIB_PATH is set as the corresponding environmental variable ... ")
        set(PATHON3_LIB_PATH $ENV{PATHON3_LIB_PATH} CACHE PATH "Where the python 3 are stored")
    endif()

    FILE(GLOB var "${PATHON3_PATH}/include/python*")
    foreach(file ${var})
        string(FIND ${file} "python3.6" pos)
        if ( ${pos} GREATER -1)
            set(PYTHON_INCLUDE_DIRS ${PATHON3_PATH}/include/${file} CACHE FILEPATH "Path to python.h")
            set(PYTHON_LIBRARIES ${PATHON3_LIB_PATH}/libpython3.6m.so CACHE FILEPATH "Python3 lib")
            set(PYTHON_DEBUG_LIBRARIES ${PATHON3_LIB_PATH}/libpython3.6m.so CACHE FILEPATH "Python3 lib for debug")
            set(PYTHON_EXECUTABLE ${PATHON3_PATH}/bin/python3 CACHE FILEPATH "Where the python3 executable are stored")
            set(PYTHONLIBS_FOUND 1)
            message("Found python lib ${PYTHON_LIBRARIES}")
        endif ()
    endforeach()

    if (Not PYTHONLIBS_FOUND)
        foreach(file ${var})
            string(FIND ${file} "python3.5" pos)
            if ( ${pos} GREATER -1)
                set(PYTHON_INCLUDE_DIRS ${PATHON3_PATH}/include/${file} CACHE FILEPATH "Path to python.h")
                set(PYTHON_LIBRARIES ${PATHON3_LIB_PATH}/libpython3.5m.so CACHE FILEPATH "Python3 lib")
                set(PYTHON_DEBUG_LIBRARIES ${PATHON3_LIB_PATH}/libpython3.5m.so CACHE FILEPATH "Python3 lib for debug")
                set(PYTHON_EXECUTABLE ${PATHON3_PATH}/bin/python3 CACHE FILEPATH "Where the python3 executable are stored")
                set(PYTHONLIBS_FOUND 1)
                message("Found python lib ${PYTHON_LIBRARIES}")
            endif ()
        endforeach()
    endif()

    # find the python version
    if(EXISTS "${PYTHON_INCLUDE_DIR}/patchlevel.h")
            file(STRINGS "${PYTHON_INCLUDE_DIR}/patchlevel.h" python_version_str
                REGEX "^#define[ \t]+PY_VERSION[ \t]+\"[^\"]+\"")
            string(REGEX REPLACE "^#define[ \t]+PY_VERSION[ \t]+\"([^\"]+)\".*" "\\1"
                                PYTHONLIBS_VERSION_STRING "${python_version_str}")
            unset(python_version_str)
            message("Found python ${PYTHONLIBS_VERSION_STRING}")
    endif()
endif ()

