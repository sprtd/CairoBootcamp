%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp
from starkware.cairo.common.math import unsigned_div_rem, assert_le_felt, assert_le, assert_nn, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.pow import pow
from starkware.cairo.common.hash_state import hash_init, hash_update
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor, bitwise_or
from lib.constants import TRUE, FALSE

// Structs
//#########################################################################################

struct Consortium {
    chairperson: felt,
    proposal_count: felt,
}

struct Member {
    votes: felt,
    prop: felt,
    ans: felt,
}

struct Answer {
    text: felt,
    votes: felt,
}

struct Proposal {
    type: felt,  // whether new answers can be added
    win_idx: felt,  // index of preffered option
    ans_idx: felt,
    deadline: felt,
    over: felt,
}

// remove in the final asnwerless
struct Winner {
    highest: felt,
    idx: felt,
}

// Storage
//#########################################################################################

@storage_var
func consortium_idx() -> (idx: felt) {
}

@storage_var
func consortiums(consortium_idx: felt) -> (consortium: Consortium) {
}

@storage_var
func members(consortium_idx: felt, member_addr: felt) -> (memb: Member) {
}

@storage_var
func proposals(consortium_idx: felt, proposal_idx: felt) -> (win_idx: Proposal) {
}

@storage_var
func proposals_idx(consortium_idx: felt) -> (idx: felt) {
}

@storage_var
func proposals_title(consortium_idx: felt, proposal_idx: felt, string_idx: felt) -> (
    substring: felt
) {
}

@storage_var
func proposals_link(consortium_idx: felt, proposal_idx: felt, string_idx: felt) -> (
    substring: felt
) {
}

@storage_var
func proposals_answers(consortium_idx: felt, proposal_idx: felt, answer_idx: felt) -> (
    answers: Answer
) {
}

@storage_var
func voted(consortium_idx: felt, proposal_idx: felt, member_addr: felt) -> (true: felt) {
}

@storage_var
func answered(consortium_idx: felt, proposal_idx: felt, member_addr: felt) -> (true: felt) {
}

// External functions
//#########################################################################################

@external
func create_consortium{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // get caller
    let (caller) = get_caller_address();
    with_attr error_message("{caller} cannot be zero address") {
        assert_not_zero(caller);
    }

    // get index
    let (c_idx) = consortium_idx.read(); 
    with_attr error_message("{c_idx} must be 0") {
        assert 0 = c_idx;
    }

    // create new consortium_struct
    let consortium_struct = Consortium(chairperson=caller, proposal_count=0);

    // add consortium_struct to consortiums storage map
    consortiums.write(c_idx, consortium_struct);

    // create new members_struct
    let members_struct = Member(votes=0, prop=TRUE, ans=0);

    // create a members mapping of mapping 
    // that maps a consortium index and caller to members_struct
    // c_idx -> caller -> members_struct
    members.write(c_idx, caller, members_struct);

    // increase consortium counter by 1
    consortium_idx.write(c_idx + 1);
    return ();
}

@external
func add_proposal{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    consortium_idx: felt,
    title_len: felt,
    title: felt*,
    link_len: felt,
    link: felt*,
    ans_len: felt,
    ans: felt*,
    type: felt,
    deadline: felt,
) {
    let (caller) = get_caller_address(); 



    proposals(consortium_idx: felt, proposal_idx: felt) -> (win_idx: Proposal)
    // members(consortium_idx: felt, member_addr: felt) 

    let (members_struct) = members(consortium_idx, caller);

    
    with_attr error_message("{members_struct.prop} cannot be false" ) {
        assert members_struct.prop = TRUE;
    }
    // proposals_idx(consortium_idx: felt) -> (idx: felt)
    let (proposal_idx) = proposals_idx.read(consortium_idx);
    // proposals(consortium_idx: felt, proposal_idx: felt) -> (win_idx: Proposal)
    proposals.write(consortium_idx, proposal_idx);




    let (proposal_struct) = Proposal(type=type, win_idx= consortium_idx, ans_idx= ans_len, deadline=deadline, over=);
    // proposals_idx(consortium_idx: felt) -> (idx: felt)
    // proposals.write(consortium_idx, )
    // let (consortium_idx) = proposals.read(proposal_idx);

    return ();
}

@external
func add_member{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    consortium_idx: felt, member_addr: felt, prop: felt, ans: felt, votes: felt
) {
    let (caller) = get_caller_address();
    with_attr error_message("{caller} cannot be zero address") {
        assert_not_zero(caller);
    }
    with_attr error_message("{member_addr} cannot be zero address") {
        assert_not_zero(member_addr);
    }
    // read consortiums struct
    let (c_struct) = consortiums.read(consortium_idx);

    with_attr error_message("{caller} not authorized to add member") {
        assert caller = c_struct.chairperson;
    }
     // create new members_struct
    let members_struct = Member(votes=votes, prop=prop, ans=ans);

    // create a members mapping of mapping 
    // that maps a consortium_idx and member_addr as keys to store members_struct
    // consortium_idx -> member_addr -> members_struct
    members.write(consortium_idx, member_addr, members_struct);
    return ();
}

// @external
// func add_answer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     consortium_idx: felt, proposal_idx: felt, string_len: felt, string: felt*
// ) {

//     return ();
// }

// @external
// func vote_answer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     consortium_idx: felt, proposal_idx: felt, answer_idx: felt
// ) {

//     return ();
// }

// @external
// func tally{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     consortium_idx: felt, proposal_idx: felt
// ) -> (win_idx: felt) {

//     return (winner_idx,);
// }



// // Internal functions
// //#########################################################################################


// func find_highest{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     consortium_idx: felt, proposal_idx: felt, highest: felt, idx: felt, countdown: felt
// ) -> (idx: felt) {

//     return (idx,);    
// }

// // Loads it based on length, internall calls only
// func load_selector{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     string_len: felt,
//     string: felt*,
//     slot_idx: felt,
//     proposal_idx: felt,
//     consortium_idx: felt,
//     selector: felt,
//     offset: felt,
// ) {

//     return ();
// }



