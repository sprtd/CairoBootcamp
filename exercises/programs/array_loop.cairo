func loop(array_len: felt, array: felt*, needle: felt) -> (result: felt){
    if(array_len == 0) {
        return (result = 0);
    }
    // increment index by 1
    if(array[0] == needle) {
        return (result = 1);
    }
    %{print(f"array_len: {ids.array}")%}
    return loop(array_len - 1, array + 1, needle);

}
