// let's now track the total amount of entries
// an event that a new number was stored
// a constructor function

#[starknet::interface]
trait ISimpleStorage<TContractState> {
    fn set_number(ref self: TContractState, number: u64);
    fn get_number(self: @TContractState) -> u64;
}

#[starknet::contract]
mod SimpleStorage {
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        numbers: LegacyMap<ContractAddress, u64>,
        owner: person
    }

    #[derive(Copy, Drop, Serde, starknet::Store)] // we added a person struct that specifies the owner of the addrss. The owner has a name to input
    struct person {
        name: felt252,
        address: ContractAddress
    }

    #[constructor] // we're adding a constructor function, the contract will be deployd and initiate the first number at 0
    fn constructor(ref self: ContractState) {
        self.numbers.write(0);
    }

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn set_number(ref self: ContractState, number: u64) {
            let caller = get_caller_address();
            self.numbers.write(caller, number);
        }
        fn get_number(self: @ContractState) -> u64 {
            let caller = get_caller_address();
            return self.numbers.read(caller);
        }
    }
}

