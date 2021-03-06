# (c) 1997-2010 Netflix, Inc.  All content herein is protected by
# U.S. copyright and other applicable intellectual property laws and
# may not be copied without the express permission of Netflix, Inc.,
# which reserves all rights.  Reuse of any of this content for any
# purpose without the permission of Netflix, Inc. is strictly
# prohibited.

cmake_minimum_required( VERSION 2.8 )
	
option( PLAYREADY_SECURE_CLOCK "PlayReady secure clock" OFF)
option( PLAYREADY_LICENSE_SYNC "PlayReady license synchronization" OFF)
option( PLAYREADY_METERING "PlayReady metering support" OFF)
	
# set( DRM_BUILD_ARCH X86 )	
set( DRM_BUILD_PLATFORM ANSI )	
set( DRM_BUILD_PROFILE OEM )	
set( DRM_BUILD_TYPE CHECKED )	

add_definitions(
	-DDRM_SUPPORT_CONTENTREVOCATION=0
	-DDRM_SUPPORT_SECUREOEMHAL=1
	-DDRM_SUPPORT_ECCPROFILING=0
	-DDRM_SUPPORT_INLINEDWORDCPY=0
	-DDRM_SUPPORT_DATASTORE_PREALLOC=1
	-DDRM_SUPPORT_DELETEDSTORE=0
	-DDRM_SUPPORT_EST=1
	-DDRM_SUPPORT_HDS=1
	-DDRM_SUPPORT_NATIVE_64BIT_TYPES=1
	-DDRM_SUPPORT_TRACING=0
	-D_DATASTORE_WRITE_THRU=1
	-DDRM_HDS_COPY_BUFFER_SIZE=32768
	-DDRM_BUILD_PROFILE=10
	-DDRM_SUPPORT_ACTIVATION=0
	-DDRM_TEST_SUPPORT_ACTIVATION=0
	-DDRM_SUPPORT_REACTIVATION=0
	-DDRM_SUPPORT_APP_POLICY=0
	-DDRM_SUPPORT_APPREVOCATION=0
	-DDRM_SUPPORT_ASSEMBLY=0
	-DDRM_SUPPORT_COPYOPL=0
	-DDRM_SUPPORT_CRT=1
	-DDRM_SUPPORT_DEVCERTKEYGEN=1
	-DDRM_SUPPORT_DEVICE_SIGNING_KEY=0
	-DDRM_SUPPORT_DEVICEREVOCATION=1
	-DDRM_SUPPORT_DEVICESTORE=1
	-DDRM_SUPPORT_DLA=1
	-DDRM_SUPPORT_DOMAIN=1
	-DDRM_SUPPORT_EMBEDDED_CERTS=0
	-DDRM_SUPPORT_FORCE_ALIGN=0
	-DDRM_SUPPORT_HDSBLOCKHEADERCACHE=0
	-DDRM_SUPPORT_LOCKING=0
	-DDRM_SUPPORT_MODELREVOCATION=0
	-DDRM_SUPPORT_MOVE=0
	-DDRM_SUPPORT_MULTI_THREADING=0
	-DDRM_SUPPORT_NONVAULTSIGNING=1
	-DDRM_SUPPORT_PERFORMANCE=1
	-DDRM_SUPPORT_PRECOMPUTE_GTABLE=0
	-DDRM_SUPPORT_PRIVATE_KEY_CACHE=0
	-DDRM_SUPPORT_SYMOPT=1
	-DDRM_SUPPORT_THUMBNAIL=0
	-DDRM_SUPPORT_XMLHASH=1
	-DDRM_USE_IOCTL_HAL_GET_DEVICE_INFO=0
	-DDRM_SUPPORT_TEST_SETTINGS=0
	-DDRM_TEST_SUPPORT_NET_IO=0
	-DUSE_PK_NAMESPACES=0
	-DDRM_INCLUDE_PK_NAMESPACE_USING_STATEMENT=0
	-D_ADDLICENSE_WRITE_THRU=0
	-DDRM_KEYFILE_VERSION=3
	-DDRM_SUPPORT_SECUREOEMHAL_PLAY_ONLY=1
    -DNETFLIX_EXT=1
    -DARCLOCK=1
)

if(BUILD_PS3 OR BUILD_PS4 OR BUILD_XB1)
# In 2.0-tee, do we need these? probably not -- jb 11/20/14
	add_definitions(
		-DDRM_SUPPORT_CERTCACHE=1
		-DDRM_SUPPORT_CERTPARSERCACHE=1
		-DDRM_SUPPORT_CLEANSTORE=1
		-DDRM_SUPPORT_VIEWRIGHTS=1
		-DDRM_SUPPORT_WMDRM=1
		-DDRM_SUPPORT_WMDRMNET=1
		-DXC_RESTRICTED_ISO
	)
endif()

if(NRDP_PLATFORM_NOVA)
# Cut down on the amount of blackbox contexts we need, should save ~120k per blackbox
	add_definitions(
		-DOEM_HAL_MAX_NUM_BLACKBOXES=2
	)
endif()

if(BUILD_PS3)
	add_definitions(-DTARGET_LITTLE_ENDIAN=0 -DTARGET_SUPPORTS_UNALIGNED_DWORD_POINTERS=0)
	string(REPLACE "-Wall" "" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${POSIX_WRAP_COMPILER_FLAGS} -w")
elseif(BUILD_PS4)
	add_definitions(-DTARGET_LITTLE_ENDIAN=1 -DTARGET_SUPPORTS_UNALIGNED_DWORD_POINTERS=0 -DDRM_64BIT_TARGET)
	string(REPLACE "-Wall" "" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${POSIX_WRAP_COMPILER_FLAGS} -w")
elseif(BUILD_XB1)
	add_definitions(-DTARGET_LITTLE_ENDIAN=1 -DTARGET_SUPPORTS_UNALIGNED_DWORD_POINTERS=0 -DDRM_64BIT_TARGET)
	string(REPLACE "/W4" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${POSIX_WRAP_COMPILER_FLAGS} /W0")
else()
	add_definitions(
		-DTARGET_LITTLE_ENDIAN=1
		-DTARGET_SUPPORTS_UNALIGNED_DWORD_POINTERS=0
    )
endif()

if( PLAYREADY_SECURE_CLOCK )
    add_definitions( -DDRM_SUPPORT_SECURE_CLOCK=1 -DDRM_SUPPORT_ANTIROLLBACK_CLOCK=0 )
else()
	add_definitions( -DDRM_SUPPORT_SECURE_CLOCK=0 -DDRM_SUPPORT_ANTIROLLBACK_CLOCK=1 )
endif()
	
if( PLAYREADY_LICENSE_SYNC )
	add_definitions( -DDRM_SUPPORT_LICENSE_SYNC=1 )
else()
	add_definitions( -DDRM_SUPPORT_LICENSE_SYNC=0 )
endif()
	
if( PLAYREADY_METERING )
	add_definitions( -DDRM_SUPPORT_METERING=1 )
else()
	add_definitions( -DDRM_SUPPORT_METERING=0 )
endif()
