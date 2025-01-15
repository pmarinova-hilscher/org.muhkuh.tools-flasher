# -*- coding: utf-8 -*- 1111
#-------------------------------------------------------------------------#
#   Copyright (C) 2011 by Christoph Thelen                                #
#   doc_bacardi@users.sourceforge.net                                     #
#                                                                         #
#   This program is free software; you can redistribute it and/or modify  #
#   it under the terms of the GNU General Public License as published by  #
#   the Free Software Foundation; either version 2 of the License, or     #
#   (at your option) any later version.                                   #
#                                                                         #
#   This program is distributed in the hope that it will be useful,       #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#   GNU General Public License for more details.                          #
#                                                                         #
#   You should have received a copy of the GNU General Public License     #
#   along with this program; if not, write to the                         #
#   Free Software Foundation, Inc.,                                       #
#   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #
#-------------------------------------------------------------------------#


import os.path
import struct
from gitVersionManager import gitVersionManager

#----------------------------------------------------------------------------
#
# Select the platforms to build
#
atPickNetxForBuild_All = ['NETX4000', 'NETX500', 'NETX90_MPW', 'NETX90', 'NETX56', 'NETX50', 'NETX10', 'NETIOL']
AddOption('--netx',
          dest='atPickNetxForBuild',
          type='choice',
          choices=atPickNetxForBuild_All,
          action='append',
          metavar='NETX',
          help='Select the platforms to build the flasher for.')
atPickNetxForBuild = GetOption('atPickNetxForBuild')
if atPickNetxForBuild is None:
    atPickNetxForBuild = atPickNetxForBuild_All
fBuildIsFull = True
for strNetx in atPickNetxForBuild_All:
    if strNetx not in atPickNetxForBuild:
        fBuildIsFull = False
        break


#----------------------------------------------------------------------------
#
# Set up the Muhkuh Build System.
#
SConscript('mbs/SConscript')
Import('atEnv')

import spi_flashes
spi_flashes.ApplyToEnv(atEnv.DEFAULT)

# Create a build environment for the ARM9 based netX chips.
env_arm9 = atEnv.DEFAULT.CreateEnvironment(['gcc-arm-none-eabi-4.7', 'asciidoc', 'exoraw-2.0.7_2'])
if 'NETX500' in atPickNetxForBuild:
    env_arm9.CreateCompilerEnv('NETX500', ['arch=armv5te'])
    spi_flashes.ApplyToEnv(atEnv.NETX500)
if 'NETX56' in atPickNetxForBuild:
    env_arm9.CreateCompilerEnv('NETX56', ['arch=armv5te'])
    spi_flashes.ApplyToEnv(atEnv.NETX56)
if 'NETX50' in atPickNetxForBuild:
    env_arm9.CreateCompilerEnv('NETX50', ['arch=armv5te'])
    spi_flashes.ApplyToEnv(atEnv.NETX50)
if 'NETX10' in atPickNetxForBuild:
    env_arm9.CreateCompilerEnv('NETX10', ['arch=armv5te'])
    spi_flashes.ApplyToEnv(atEnv.NETX10)

# Create a build environment for the Cortex-R7 and Cortex-A9 based netX chips.
env_cortexR7 = atEnv.DEFAULT.CreateEnvironment(['gcc-arm-none-eabi-4.9', 'asciidoc', 'exoraw-2.0.7_2'])
if 'NETX4000' in atPickNetxForBuild:
    env_cortexR7.CreateCompilerEnv('NETX4000', ['arch=armv7', 'thumb'], ['arch=armv7-r', 'thumb'])
    spi_flashes.ApplyToEnv(atEnv.NETX4000)

# Create a build environment for the Cortex-M4 based netX chips.
env_cortexM4 = atEnv.DEFAULT.CreateEnvironment(['gcc-arm-none-eabi-4.9', 'asciidoc', 'exoraw-2.0.7_2'])
if 'NETX90_MPW' in atPickNetxForBuild:
    env_cortexM4.CreateCompilerEnv('NETX90_MPW', ['arch=armv7', 'thumb'], ['arch=armv7e-m', 'thumb'])
    spi_flashes.ApplyToEnv(atEnv.NETX90_MPW)
if 'NETX90' in atPickNetxForBuild:
    env_cortexM4.CreateCompilerEnv('NETX90', ['arch=armv7', 'thumb'], ['arch=armv7e-m', 'thumb'])
    spi_flashes.ApplyToEnv(atEnv.NETX90)

# Create a build environment for the RISCV based netIOL.
env_riscv = atEnv.DEFAULT.CreateEnvironment(['gcc-riscv-none-embed-7.2', 'asciidoc', 'exoraw-2.0.7_2'])
if 'NETIOL' in atPickNetxForBuild:
    env_riscv.CreateCompilerEnv('NETIOL', ['arch=rv32im', 'abi=ilp32'], ['arch=rv32imc', 'abi=ilp32'])
    spi_flashes.ApplyToEnv(atEnv.NETIOL)

# Build the platform libraries.
SConscript('platform/SConscript')


#----------------------------------------------------------------------------
# This is the list of sources. The elements must be separated with whitespace
# (i.e. spaces, tabs, newlines). The amount of whitespace does not matter.
flasher_sources_main = """
	src/main.c
	src/init_netx_test.S
	src/progress_bar.c
"""

flasher_sources_lib = """
	src/internal_flash/flasher_internal_flash.c
	src/internal_flash/internal_flash_maz_v0.c
	src/cfi_flash.c
	src/delay.c
	src/spi_flash.c
	src/exodecr.c
	src/flasher_parflash.c
	src/flasher_spi.c
	src/sfdp.c
	src/spansion.c
	src/spi_macro_player.c
	src/strata.c
	src/units.c
	src/reset.c
"""


flasher_sources_main_netx4000 = """
	src/netx4000/flasher_header.c
"""

flasher_sources_lib_netx4000 = """
	src/netx4000/board.c
	src/netx4000/cr7_global_timer.c
	src/netx4000/portcontrol.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v2.c
	src/drv_sqi.c
	src/mmio.c
	src/pl353_nor.c
	src/netx4000/netx4000_sdio.c
	src/flasher_sdio.c
"""

flasher_sources_main_netx90 = """
	src/netx90/flasher_header.c
"""

flasher_sources_lib_netx90 = """
	src/netx90/board.c
	src/netx90/cortexm_systick.c
	src/netx90/sha384.c
	src/drv_spi_hsoc_v2.c
	src/drv_sqi.c
	src/mmio.c
	src/sha1_netx/sha1.c
"""


flasher_sources_main_netx500 = """
	src/netx500/flasher_header.c
"""

flasher_sources_lib_netx500 = """
	src/netx500/board.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v1.c
"""


flasher_sources_main_netx56 = """
	src/netx56/flasher_header.c
"""

flasher_sources_lib_netx56 = """
	src/netx56/board.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v2.c
	src/drv_sqi.c
	src/mmio.c
"""


flasher_sources_main_netx50 = """
	src/netx50/flasher_header.c
"""

flasher_sources_lib_netx50 = """
	src/netx50/board.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v2.c
	src/mmio.c
"""


flasher_sources_main_netx10 = """
	src/netx10/flasher_header.c
"""

flasher_sources_lib_netx10 = """
	src/netx10/board.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v2.c
	src/drv_sqi.c
	src/mmio.c
"""


flasher_sources_main_netiol = """
	src/netiol/flasher_header.c
"""

flasher_sources_lib_netiol = """
	src/delay.c
	src/spi_flash.c
	src/exodecr.c
	src/flasher_spi.c
	src/sfdp.c
	src/spi_macro_player.c
	src/units.c
	src/netiol/board.c
	src/drv_spi_hsoc_v2.c
	src/reset.c
"""


src_lib_netx4000 = flasher_sources_lib + flasher_sources_lib_netx4000
src_lib_netx500  = flasher_sources_lib + flasher_sources_lib_netx500
src_lib_netx90   = flasher_sources_lib + flasher_sources_lib_netx90
src_lib_netx56   = flasher_sources_lib + flasher_sources_lib_netx56
src_lib_netx50   = flasher_sources_lib + flasher_sources_lib_netx50
src_lib_netx10   = flasher_sources_lib + flasher_sources_lib_netx10
src_lib_netiol   = flasher_sources_lib_netiol

src_main_netx4000 = flasher_sources_main + flasher_sources_main_netx4000
src_main_netx500  = flasher_sources_main + flasher_sources_main_netx500
src_main_netx90   = flasher_sources_main + flasher_sources_main_netx90
src_main_netx56   = flasher_sources_main + flasher_sources_main_netx56
src_main_netx50   = flasher_sources_main + flasher_sources_main_netx50
src_main_netx10   = flasher_sources_main + flasher_sources_main_netx10
src_main_netiol   = flasher_sources_main + flasher_sources_main_netiol


#----------------------------------------------------------------------------
#
# Get the source code version from the VCS.
#
atEnv.DEFAULT.Version('targets/version/flasher_version.h', 'templates/flasher_version.h')
atEnv.DEFAULT.Version('targets/version/flasher_version.xsl', 'templates/flasher_version.xsl')

from datetime import datetime
tBuildTime = datetime.now()
strBuildTime = tBuildTime.strftime("%Y-%B-%d-T%H:%M")
tDict = {'BUILD_TIME': strBuildTime} 

# Set the dev ending
# dev-branch:      "devX"
# release-branch:  ""
# everything else: branch name
repoManager = gitVersionManager(".")
if repoManager.onDevBranch() or repoManager.onReleaseBranch():
    tDict['BUILD_TYPE'] = repoManager.getDevEnding()
else:
    tDict['BUILD_TYPE'] = "-" + repoManager.getCurrentBranchName()

#----------------------------------------------------------------------------
#
# Create the compiler environments.
#
astrCommonIncludePaths = ['src', '#platform/src', '#platform/src/lib', 'targets/spi_flash_types', 'targets/version']

# Note: CFG_INCLUDE_PARFLASH, CFG_INCLUDE_INTFLASH are checked using ifdef. The value is irrelevant.
if 'NETX4000' in atPickNetxForBuild:
    env_netx4000_default = atEnv.NETX4000.Clone()
    env_netx4000_default.Replace(LDFILE = File('src/netx4000/netx4000.ld'))
    env_netx4000_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx4000','src/sha1_arm'])
    env_netx4000_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1'], ['CFG_INCLUDE_PARFLASH', '1'], ['CFG_INCLUDE_SMART_ERASE', '1'], ['CFG_INCLUDE_SDIO', '1']])

if 'NETX500' in atPickNetxForBuild:
    env_netx500_default = atEnv.NETX500.Clone()
    env_netx500_default.Replace(LDFILE = File('src/netx500/netx500.ld'))
    env_netx500_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx500','src/sha1_arm'])
    env_netx500_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1'], ['CFG_INCLUDE_PARFLASH', '1'], ['CFG_INCLUDE_SMART_ERASE', '1']])

if 'NETX90_MPW' in atPickNetxForBuild:
    env_netx90_mpw_default  = atEnv.NETX90_MPW.Clone()
    env_netx90_mpw_default.Replace(LDFILE = File('src/netx90/netx90.ld'))
    env_netx90_mpw_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx90','src/sha1_netx'])
    env_netx90_mpw_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1'], ['CFG_INCLUDE_PARFLASH', '1'], ['CFG_INCLUDE_INTFLASH', '1'], ['CFG_INCLUDE_SMART_ERASE', '1']])

if 'NETX90' in atPickNetxForBuild:
    env_netx90_default  = atEnv.NETX90.Clone()
    env_netx90_default.Replace(LDFILE = File('src/netx90/netx90.ld'))
    env_netx90_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx90','src/sha1_netx'])
    env_netx90_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1'], ['CFG_INCLUDE_PARFLASH', '1'], ['CFG_INCLUDE_INTFLASH', '1'], ['CFG_INCLUDE_SMART_ERASE', '1']])

if 'NETX56' in atPickNetxForBuild:
    env_netx56_default  = atEnv.NETX56.Clone()
    env_netx56_default.Replace(LDFILE = File('src/netx56/netx56.ld'))
    env_netx56_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx56','src/sha1_arm'])
    env_netx56_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1'], ['CFG_INCLUDE_PARFLASH', '1'], ['CFG_INCLUDE_SMART_ERASE', '1']])

if 'NETX50' in atPickNetxForBuild:
    env_netx50_default  = atEnv.NETX50.Clone()
    env_netx50_default.Replace(LDFILE = File('src/netx50/netx50.ld'))
    env_netx50_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx50','src/sha1_arm'])
    env_netx50_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1'], ['CFG_INCLUDE_PARFLASH', '1'], ['CFG_INCLUDE_SMART_ERASE', '1']])

if 'NETX10' in atPickNetxForBuild:
    env_netx10_default  = atEnv.NETX10.Clone()
    env_netx10_default.Replace(LDFILE = File('src/netx10/netx10.ld'))
    env_netx10_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx10','src/sha1_arm'])
    env_netx10_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1'], ['CFG_INCLUDE_PARFLASH', '1'], ['CFG_INCLUDE_SMART_ERASE', '1']])

if 'NETIOL' in atPickNetxForBuild:
    env_netiol_default  = atEnv.NETIOL.Clone()
    env_netiol_default.Replace(LDFILE = File('src/netiol/netiol.ld'))
    env_netiol_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netiol','src/sha1_arm'])
    env_netiol_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '0'], ['CFG_INCLUDE_SMART_ERASE', '0']])

#----------------------------------------------------------------------------
#
# Provide a function to build a flasher binary.
#
def flasher_build(strFlasherName, tEnv, strBuildPath, astrSourcesLib, astrSourcesMain):
	# Get the platform library.
	tLibPlatform = tEnv['PLATFORM_LIBRARY']

	# Create the list of known SPI flashes.
	srcSpiFlashes = tEnv.SPIFlashes(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types.c'), 'src/spi_flash_types.xml')
	objSpiFlashes = tEnv.Object(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types.o'), srcSpiFlashes[0])
	# Extract the binary.
	binSpiFlashes = tEnv.ObjCopy(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types.bin'), objSpiFlashes)
	# Pack the binary with exomizer.
	exoSpiFlashes = tEnv.Exoraw(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types.exo'), binSpiFlashes)
	# Convert the packed binary to an object.
	objExoSpiFlashes = tEnv.ObjImport(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types_exo.o'), exoSpiFlashes)

	# Append the path to the SPI flash list.
	tEnv.Append(CPPPATH = [os.path.join(strBuildPath, 'spi_flash_types')])

	# Build the library.
	tSrcFlasherLib = tEnv.SetBuildPath(os.path.join(strBuildPath, 'lib'), 'src', astrSourcesLib)
	tLibFlasher = tEnv.StaticLibrary(os.path.join(strBuildPath, strFlasherName), tSrcFlasherLib + objExoSpiFlashes)

	tSrcFlasher = tEnv.SetBuildPath(strBuildPath, 'src', astrSourcesMain)
	tElfFlasher = tEnv.Elf(os.path.join(strBuildPath, strFlasherName+'.elf'), tSrcFlasher + tLibFlasher + [tLibPlatform])
	tBinFlasher = tEnv.ObjCopy(os.path.join(strBuildPath, strFlasherName+'.bin'), tElfFlasher)
	tTxtFlasher = tEnv.ObjDump(os.path.join(strBuildPath, strFlasherName+'.txt'), tElfFlasher, OBJDUMP_FLAGS=['--disassemble', '--source', '--all-headers', '--wide'])

	return tElfFlasher,tBinFlasher,tLibFlasher


#----------------------------------------------------------------------------
#
# Build the netX10 flasher with the old netX50 console io interface.
#
if 'NETX10' in atPickNetxForBuild:
    env_netx10_oldio_nodbg = env_netx10_default.Clone()
    env_netx10_oldio_nodbg.Replace(LDFILE = File('src/netx10/netx10_oldio.ld'))
    env_netx10_oldio_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netx10_oldio_nodbg, bin_netx10_oldio_nodbg, lib_netx10_oldio_nodbg = flasher_build('flasher_netx10', env_netx10_oldio_nodbg, 'targets/netx10_oldio_nodbg', src_lib_netx10, src_main_netx10)

    env_netx10_oldio_dbg = env_netx10_default.Clone()
    env_netx10_oldio_dbg.Replace(LDFILE = File('src/netx10/netx10_oldio.ld'))
    env_netx10_oldio_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netx10_oldio_dbg, bin_netx10_oldio_dbg, lib_netx10_oldio_dbg = flasher_build('flasher_netx10_debug', env_netx10_oldio_dbg, 'targets/netx10_oldio_dbg', src_lib_netx10, src_main_netx10)


#----------------------------------------------------------------------------
#
# Build the flasher without debug messages.
#
if 'NETX4000' in atPickNetxForBuild:
    env_netx4000_nodbg = env_netx4000_default.Clone()
    env_netx4000_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netx4000_nodbg, bin_netx4000_nodbg, lib_netx4000_nodbg = flasher_build('flasher_netx4000', env_netx4000_nodbg, 'targets/netx4000_nodbg', src_lib_netx4000, src_main_netx4000)

if 'NETX500' in atPickNetxForBuild:
    env_netx500_nodbg = env_netx500_default.Clone()
    env_netx500_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netx500_nodbg, bin_netx500_nodbg, lib_netx500_nodbg = flasher_build('flasher_netx500', env_netx500_nodbg, 'targets/netx500_nodbg', src_lib_netx500, src_main_netx500)

if 'NETX90_MPW' in atPickNetxForBuild:
    env_netx90_mpw_nodbg = env_netx90_mpw_default.Clone()
    env_netx90_mpw_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netx90_mpw_nodbg,bin_netx90_mpw_nodbg, lib_netx90_mpw_nodbg = flasher_build('flasher_netx90_mpw', env_netx90_mpw_nodbg, 'targets/netx90_mpw_nodbg', src_lib_netx90, src_main_netx90)

if 'NETX90' in atPickNetxForBuild:
    env_netx90_nodbg = env_netx90_default.Clone()
    env_netx90_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netx90_nodbg,bin_netx90_nodbg, lib_netx90_nodbg = flasher_build('flasher_netx90', env_netx90_nodbg, 'targets/netx90_nodbg', src_lib_netx90, src_main_netx90)
 

if 'NETX56' in atPickNetxForBuild:
    env_netx56_nodbg = env_netx56_default.Clone()
    env_netx56_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netx56_nodbg, bin_netx56_nodbg, lib_netx56_nodbg = flasher_build('flasher_netx56', env_netx56_nodbg, 'targets/netx56_nodbg', src_lib_netx56, src_main_netx56)

if 'NETX50' in atPickNetxForBuild:
    env_netx50_nodbg = env_netx50_default.Clone()
    env_netx50_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netx50_nodbg, bin_netx50_nodbg, lib_netx50_nodbg = flasher_build('flasher_netx50', env_netx50_nodbg, 'targets/netx50_nodbg', src_lib_netx50, src_main_netx50)

if 'NETX10' in atPickNetxForBuild:
    env_netx10_nodbg = env_netx10_default.Clone()
    env_netx10_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netx10_nodbg, bin_netx10_nodbg, lib_netx10_nodbg = flasher_build('flasher_netx10', env_netx10_nodbg, 'targets/netx10_nodbg', src_lib_netx10, src_main_netx10)

if 'NETIOL' in atPickNetxForBuild:
    env_netiol_nodbg = env_netiol_default.Clone()
    env_netiol_nodbg.Replace(LIBS = ['c'])
    env_netiol_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    elf_netiol_nodbg, bin_netiol_nodbg, lib_netiol_nodbg = flasher_build('flasher_netiol', env_netiol_nodbg, 'targets/netiol_nodbg', src_lib_netiol, src_main_netiol)


#----------------------------------------------------------------------------
#
# Build the flasher with debug messages.
#
if 'NETX4000' in atPickNetxForBuild:
    env_netx4000_dbg = env_netx4000_default.Clone()
    env_netx4000_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netx4000_dbg, bin_netx4000_dbg, lib_netx4000_dbg = flasher_build('flasher_netx4000_debug', env_netx4000_dbg, 'targets/netx4000_dbg', src_lib_netx4000, src_main_netx4000)

if 'NETX500' in atPickNetxForBuild:
    env_netx500_dbg = env_netx500_default.Clone()
    env_netx500_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netx500_dbg, bin_netx500_dbg, lib_netx500_dbg = flasher_build('flasher_netx500_debug', env_netx500_dbg, 'targets/netx500_dbg', src_lib_netx500, src_main_netx500)

if 'NETX90_MPW' in atPickNetxForBuild:
    env_netx90_mpw_dbg = env_netx90_mpw_default.Clone()
    env_netx90_mpw_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netx90_mpw_dbg, bin_netx90_mpw_dbg, lib_netx90_mpw_dbg = flasher_build('flasher_netx90_mpw_debug', env_netx90_mpw_dbg, 'targets/netx90_mpw_dbg', src_lib_netx90, src_main_netx90)

if 'NETX90' in atPickNetxForBuild:
    env_netx90_dbg = env_netx90_default.Clone()
    env_netx90_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netx90_dbg, bin_netx90_dbg, lib_netx90_dbg = flasher_build('flasher_netx90_debug', env_netx90_dbg, 'targets/netx90_dbg', src_lib_netx90, src_main_netx90)

if 'NETX56' in atPickNetxForBuild:
    env_netx56_dbg = env_netx56_default.Clone()
    env_netx56_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netx56_dbg, bin_netx56_dbg, lib_netx56_dbg = flasher_build('flasher_netx56_debug', env_netx56_dbg, 'targets/netx56_dbg', src_lib_netx56, src_main_netx56)

if 'NETX50' in atPickNetxForBuild:
    env_netx50_dbg = env_netx50_default.Clone()
    env_netx50_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netx50_dbg, bin_netx50_dbg, lib_netx50_dbg = flasher_build('flasher_netx50_debug', env_netx50_dbg, 'targets/netx50_dbg', src_lib_netx50, src_main_netx50)

if 'NETX10' in atPickNetxForBuild:
    env_netx10_dbg = env_netx10_default.Clone()
    env_netx10_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netx10_dbg, bin_netx10_dbg, lib_netx10_dbg = flasher_build('flasher_netx10_debug', env_netx10_dbg, 'targets/netx10_dbg', src_lib_netx10, src_main_netx10)

if 'NETIOL' in atPickNetxForBuild:
    env_netiol_dbg = env_netiol_default.Clone()
    env_netiol_dbg.Replace(LIBS = ['c'])
    env_netiol_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
    elf_netiol_dbg, bin_netiol_dbg, lib_netiol_dbg = flasher_build('flasher_netiol_debug', env_netiol_dbg, 'targets/netiol_dbg', src_lib_netiol, src_main_netiol)


#----------------------------------------------------------------------------
#
# Build the BOB flasher without debug messages.
# This version runs from SDRAM starting at 0x8002000 to save the INTRAM for
# the 2ndStageLoader.
#
if 'NETX500' in atPickNetxForBuild:
    env_netx500_bob = env_netx500_default.Clone()
    env_netx500_bob.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
    env_netx500_bob.Replace(LDFILE = File('src/netx500/netx500_bob.ld'))
    elf_netx500_bob, bin_netx500_bob, lib_netx500_bob = flasher_build('flasher_netx500_bob', env_netx500_bob, 'targets/netx500_bob', src_lib_netx500, src_main_netx500)