add_library(libutils STATIC utils.c utils-prng.c)

macro(add_test _target)
    add_executable(${_target} ${_target}.c)
    target_link_libraries(${_target} pixman-1 libutils)
endmacro()

# Tests (sorted by expected completion time)
set(TESTPROGRAMS
    oob-test
    infinite-loop
    trap-crasher
    fence-image-self-test
    region-translate-test
    fetch-test
    a1-trap-test
    prng-test
    radial-invalid
    pdf-op-test
    region-test
    combiner-test
    scaling-crash-test
    alpha-loop
    scaling-helpers-test
    thread-test
    rotate-test
    alphamap
    gradient-crash-test
    pixel-test
    matrix-test
    composite-traps-test
    region-contains-test
    glyph-test
    solid-test
    stress-test
    cover-test
    blitters-test
    affine-test
    scaling-test
    composite
    tolerance-test
)

# Other programs
set(OTHERPROGRAMS
    lowlevel-blt-bench
    radial-perf-test
    check-formats
    scaling-bench
    affine-bench
)

foreach(program IN LISTS TESTPROGRAMS)
    add_test(${program})
endforeach()

foreach(program IN LISTS OTHERPROGRAMS)
    add_test(${program})
endforeach()
