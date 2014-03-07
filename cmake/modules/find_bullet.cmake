SET(BULLET_INCLUDE_SEARCH_DIRS
	${GLOBAL_EXT_DIR}/inc/bullet
    /opt/bullet/current
)

SET(BULLET_LIBRARY_SEARCH_DIRS
	${GLOBAL_EXT_DIR}/lib
    /opt/bullet/current/bullet-build
)

message(STATUS "-- checking for BULLET")

IF (NOT BULLET_INCLUDE_DIRS)

    SET(_BULLET_FOUND_INC_DIRS "")

    FOREACH(_SEARCH_DIR ${BULLET_INCLUDE_SEARCH_DIRS})
        FIND_PATH(_CUR_SEARCH
            NAMES src/btBulletDynamicsCommon.h
                PATHS ${_SEARCH_DIR}
                NO_DEFAULT_PATH)
        IF (_CUR_SEARCH)
            LIST(APPEND _BULLET_FOUND_INC_DIRS ${_CUR_SEARCH})
        ENDIF(_CUR_SEARCH)
        SET(_CUR_SEARCH _CUR_SEARCH-NOTFOUND CACHE INTERNAL "internal use")
    ENDFOREACH(_SEARCH_DIR ${BULLET_INCLUDE_SEARCH_DIRS})

    IF (NOT _BULLET_FOUND_INC_DIRS)
        MESSAGE(FATAL_ERROR "find_bullet.cmake: unable to find bullet headers")
    ENDIF (NOT _BULLET_FOUND_INC_DIRS)
    
    FOREACH(_INC_DIR ${_BULLET_FOUND_INC_DIRS})
        LIST(APPEND BULLET_INCLUDE_DIRS ${_INC_DIR}/src)
        LIST(APPEND BULLET_INCLUDE_DIRS ${_INC_DIR}/Extras/HACD)
    ENDFOREACH(_INC_DIR ${_BOOST_FOUND_INC_DIRS})

ENDIF(NOT BULLET_INCLUDE_DIRS)


IF(UNIX)
	SET(BULLET_DYNAMICS_LIB_SUFFIX 		"src/BulletDynamics/")
	SET(BULLET_COLLISION_LIB_SUFFIX 		"src/BulletCollision/")
	SET(BULLET_LINEAR_MATH_LIB_SUFFIX "src/LinearMath/")
	SET(BULLET_HACD_LIB_SUFFIX 				"Extras/HACD/")
	SET(BULLET_DYNAMICS_LIB 					"libBulletDynamics.so")
	SET(BULLET_COLLISION_LIB 					"libBulletCollision.so")
	SET(BULLET_LINEAR_MATH_LIB 				"libLinearMath.so")
	SET(BULLET_HACD_LIB 							"libHACD.so")
ELSEIF(WIN32)
	SET(BULLET_DYNAMICS_LIB_SUFFIX 		"")
	SET(BULLET_COLLISION_LIB_SUFFIX 		"")
	SET(BULLET_LINEAR_MATH_LIB_SUFFIX "")
	SET(BULLET_HACD_LIB_SUFFIX 				"")
	SET(BULLET_DYNAMICS_LIB 					"BulletDynamics.lib")
	SET(BULLET_COLLISION_LIB 					"BulletCollision.lib")
	SET(BULLET_LINEAR_MATH_LIB 				"LinearMath.lib")
	SET(BULLET_HACD_LIB 							"HACD.lib")
ENDIF(UNIX)


IF (        BULLET_INCLUDE_DIRS
    AND NOT BULLET_LIBRARIES)

    SET(_BULLET_FOUND_LIB_DIR "")
    SET(_BULLET_POSTFIX "")

    FOREACH(_SEARCH_DIR ${BULLET_LIBRARY_SEARCH_DIRS})
        FIND_PATH(_CUR_SEARCH
				NAMES ${BULLET_DYNAMICS_LIB}
                PATHS ${_SEARCH_DIR}
                PATH_SUFFIXES debug release ${BULLET_DYNAMICS_LIB_SUFFIX}
                NO_DEFAULT_PATH)
        IF (_CUR_SEARCH)
            LIST(APPEND _BULLET_FOUND_LIB_DIR ${_SEARCH_DIR})
        ENDIF(_CUR_SEARCH)
        SET(_CUR_SEARCH _CUR_SEARCH-NOTFOUND CACHE INTERNAL "internal use")
    ENDFOREACH(_SEARCH_DIR ${BULLET_LIBRARY_SEARCH_DIRS})

    IF (NOT _BULLET_FOUND_LIB_DIR)
        MESSAGE(FATAL_ERROR "find_bullet.cmake: unable to find bullet libraries")
    ELSE (NOT _BULLET_FOUND_LIB_DIR)
		SET(BULLET_LIBRARY_DIRS ${_BULLET_FOUND_LIB_DIR} CACHE STRING "The bullet library directory")
        message(STATUS "--  found matching version")
    ENDIF (NOT _BULLET_FOUND_LIB_DIR)
    
    FOREACH(_LIB_DIR ${_BULLET_FOUND_LIB_DIR})
        LIST(APPEND BULLET_LIBRARY_DIRS ${_LIB_DIR}/${BULLET_DYNAMICS_LIB_SUFFIX})
        LIST(APPEND BULLET_LIBRARY_DIRS ${_LIB_DIR}/${BULLET_COLLISION_LIB_SUFFIX})
        LIST(APPEND BULLET_LIBRARY_DIRS ${_LIB_DIR}/${BULLET_LINEAR_MATH_LIB_SUFFIX})
        LIST(APPEND BULLET_LIBRARY_DIRS ${_LIB_DIR}/${BULLET_HACD_LIB_SUFFIX})
    ENDFOREACH(_LIB_DIR ${_BULLET_FOUND_INC_DIRS})

	LIST(APPEND BULLET_LIBRARIES ${BULLET_DYNAMICS_LIB})
	LIST(APPEND BULLET_LIBRARIES ${BULLET_COLLISION_LIB})
	LIST(APPEND BULLET_LIBRARIES ${BULLET_LINEAR_MATH_LIB})
	LIST(APPEND BULLET_LIBRARIES ${BULLET_HACD_LIB})
	
ENDIF(        BULLET_INCLUDE_DIRS
      AND NOT BULLET_LIBRARIES)



