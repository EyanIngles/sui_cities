/// Module: suicities
module suicities::cities {


    const UNABLE_TO_UPGRADE:u64 = 1; // unable to upgrade due to being already at high upgrade evolution.

    public struct CityNft has key {
        id: UID,
        rarity: u64,
        evolveStage: u8,
        mint_epoch: u64, 
        level_epoch: u64,
    }

    public fun mint(ctx: &mut TxContext) {
        let rarityNumber = generate_random_number(ctx);
        let epoch = ctx.epoch(); // attaches the epoch value to the structure of the nft
        let sender = ctx.sender();
        let city = CityNft {
            id: object::new(ctx),
            rarity: rarityNumber,
            evolveStage: 1, // evolution always starts at one.
            mint_epoch: epoch,
            level_epoch: 0,
        };
        transfer::transfer(city, sender); // Transfer the NFT to the caller
    }
     
    fun generate_random_number(ctx: &TxContext): u64 {
        let epoch = ctx.epoch();
        epoch * epoch % 100 // Generates a pseudo-random number between 1 and 100
    }
    public fun update_epoch_value(city: &mut CityNft, ctx: &mut TxContext) {
        let currentEpoch = ctx.epoch();
        city.level_epoch = city.level_epoch + currentEpoch;
    }
    public fun upgrade_city(city: &mut CityNft) {
        let epoch = city.level_epoch;
        let current_evolution = city.evolveStage;
        let upgrade_value_lvl1 = 100;
        let upgrade_value_lvl2 = 200;
        let upgrade_value_lvl3 = 300;


        if (epoch >= upgrade_value_lvl1 && current_evolution <= 1) { // this check will check to see if the current nft is of certain values before upgrading.
            city.evolveStage = city.evolveStage + 1
        };
        if (epoch >= upgrade_value_lvl2 && current_evolution == 2) { // this check will check to see if the current nft is of certain values before upgrading.
            city.evolveStage = city.evolveStage + 1
        };
        if (epoch >= upgrade_value_lvl3 && current_evolution == 3) { // this check will check to see if the current nft is of certain values before upgrading.
            city.evolveStage = city.evolveStage + 1
        } else {
            abort(UNABLE_TO_UPGRADE)
        }
    }
}
