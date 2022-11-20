%lang starknet
from exercises.programs.ex3 import simple_math
from starkware.cairo.common.alloc import alloc
from exercises.programs.array_loop import loop

@external
func test_loop{syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let (array: felt*) = alloc();


    assert [array] = 1;
    assert [array + 1] = 2;
    assert [array + 2] = 3;
    assert [array + 3] = 4;
    assert [array + 4] = 5; 
    
    assert array[2] = 3;
    assert array[5] = 4;

    let value = array[2];
    assert value = 3;
    let (result) = loop(5, array, 5);
    assert result = 1;

    let (result) = loop(5, array, 7);
    assert result = 0;

    let (result) = loop(5, array, 4);
    assert result = 1;

    return ();
}
