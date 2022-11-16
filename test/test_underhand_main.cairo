%lang starknet

from starkware.cairo.common.uint256 import Uint256, uint256_sub
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

const MINTER = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91;
const BURNER = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04e95;
const TREASURY_ADDR = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;


// from exercises.contracts.erc20.IERC20 import IErc20 as Erc20
from exercises.contracts.underhand.main import mint
from tkn import (
    Token,
    token_info,
    token_init,
    token_total,
    token_owns,
    token_mint,
    token_burn,
    token_allowance,
    token_approve,
    token_transfer,
)


@external
func __setup__() {
    // Deploy contract main
    // name
    // symbol
    // decimals
    // minter
    // burner
    // treasury admin
    %{
        context.contract_address  = deploy_contract("./exercises/contracts/erc721/erc721.cairo", [
               479180725013462735611246,
               76245607140174, 
               43256319147690229400997140624606456196985002583002772481989492744049475773690, 
               ids.MINTER, 
                ids.BURNER, 
                ids.TREASURY_ADDR 
          
               ]).contract_address
    %}

    return ();
}

