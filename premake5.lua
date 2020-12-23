workspace "ZeXo"
    architecture "x64"
    configurations { "Debug", "Release" }

    outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"
    
project "ZeXo"
    location "ZeXo"
    kind "SharedLib"
    language "C++"

    targetdir ("bin/".. outputdir .. "/%{prj.name}")
    objdir    ("bin/intermediates/" .. outputdir .. "/%{prj.name}")

    files { "%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp" }
    includedirs { "%{prj.name}/src", "%{prj.name}/ThirdParty/spdlog/include" }
     
    pchheader "zxpch.h"
    pchsource "ZeXo/src/zxpch.cpp" 

    filter { "system:windows" }
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"

        defines { "ZX_BUILD_DLL", "ZX_PLAT_WIN" }

        postbuildcommands
        {
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/SandboxApp")
        }

    filter { "configurations:Debug" }
        defines { "DEBUG", "ZX_USE_LOGGER", "ZX_DEBUG" }
        symbols "On"

    filter { "configurations:Release" }
        defines { "NDEBUG", "ZX_RELEASE" }
        optimize "On"

project "SandboxApp"
    location "SandboxApp"
    kind "ConsoleApp"
    language "C++"

    targetdir ("bin/".. outputdir .. "/%{prj.name}")
    objdir    ("bin/intermediates/" .. outputdir .. "/%{prj.name}")

    files { "%{prj.name}/src/**.h", "%{prj.name}/src/**.cpp" }
    includedirs { "ZeXo/src", "ZeXo/ThirdParty/spdlog/include" }
    links { "ZeXo" }

    filter { "system:windows" }
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"

        defines { "ZX_PLAT_WIN" }

    filter { "configurations:Debug" }
        defines { "DEBUG", "ZX_USE_LOGGER", "ZX_DEBUG" }
        symbols "On"

    filter { "configurations:Release" }
        defines { "NDEBUG", "ZX_RELEASE" }
        optimize "On"