cmake_minimum_required(VERSION 2.6)
project(shellback)

add_executable(shellback shellback.c)

INSTALL(TARGETS shellback RUNTIME DESTINATION /usr/bin/)
